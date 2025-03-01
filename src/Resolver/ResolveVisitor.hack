namespace Graphpinator\Resolver;

final class ResolveVisitor implements \Graphpinator\Typesystem\TypeVisitor
{
    public function __construct(
        private ?\Graphpinator\Normalizer\Field\FieldSet $requestedFields,
        private \Graphpinator\Value\ResolvedValue $parentResult,
    ) {}

    public function visitType(\Graphpinator\Type\Type $type) : \Graphpinator\Value\TypeValue
    {
        \assert($this->requestedFields instanceof \Graphpinator\Normalizer\Field\FieldSet);
        $resolved = new \stdClass();

        foreach ($this->requestedFields as $field) {
            if ($field->getTypeCondition() instanceof \Graphpinator\Type\Contract\NamedDefinition &&
                !$this->parentResult->getType()->isInstanceOf($field->getTypeCondition())) {
                continue;
            }

            foreach ($field->getDirectives() as $directive) {
                $directiveDef = $directive->getDirective();
                $directiveResult = $directiveDef->resolveFieldBefore($directive->getArguments());

                if (!\array_key_exists($directiveResult, \Graphpinator\Directive\FieldDirectiveResult::ENUM)) {
                    throw new \Graphpinator\Resolver\Exception\InvalidDirectiveResult();
                }

                if ($directiveResult === \Graphpinator\Directive\FieldDirectiveResult::SKIP) {
                    continue 2;
                }
            }

            $fieldDef = $type->getMetaFields()[$field->getName()]
                ?? $type->getFields()[$field->getName()];
            $fieldResult = $this->resolveField($fieldDef, $field);

            foreach ($field->getDirectives() as $directive) {
                $directiveDef = $directive->getDirective();
                $directiveResult = $directiveDef->resolveFieldAfter($directive->getArguments(), $fieldResult);

                if (!\array_key_exists($directiveResult, \Graphpinator\Directive\FieldDirectiveResult::ENUM)) {
                    throw new \Graphpinator\Resolver\Exception\InvalidDirectiveResult();
                }

                if ($directiveResult === \Graphpinator\Directive\FieldDirectiveResult::SKIP) {
                    continue 2;
                }
            }

            $resolved->{$field->getAlias()} = $fieldResult;
        }

        return new \Graphpinator\Value\TypeValue($type, $resolved);
    }

    public function visitInterface(\Graphpinator\Type\InterfaceType $interface) : mixed
    {
        // nothing here
    }

    public function visitUnion(\Graphpinator\Type\UnionType $union) : mixed
    {
        // nothing here
    }

    public function visitInput(\Graphpinator\Type\InputType $input) : mixed
    {
        // nothing here
    }

    public function visitScalar(\Graphpinator\Type\ScalarType $scalar) : \Graphpinator\Value\ResolvedValue
    {
        return $this->parentResult;
    }

    public function visitEnum(\Graphpinator\Type\EnumType $enum) : \Graphpinator\Value\ResolvedValue
    {
        return $this->parentResult;
    }

    public function visitNotNull(\Graphpinator\Type\NotNullType $notNull) : \Graphpinator\Value\ResolvedValue
    {
        return $notNull->getInnerType()->accept($this);
    }

    public function visitList(\Graphpinator\Type\ListType $list) : \Graphpinator\Value\ListResolvedValue
    {
        \assert($this->parentResult instanceof \Graphpinator\Value\ListIntermediateValue);

        $return = [];

        foreach ($this->parentResult->getRawValue() as $rawValue) {
            $value = $this->getResolvedValue($rawValue, $list->getInnerType());

            if ($value instanceof \Graphpinator\Value\NullValue) {
                $return[] = $value;
            } else {
                $resolver = new self(
                    $this->requestedFields,
                    $value,
                );

                $return[] = $value->getType()->accept($resolver);
            }
        }

        return new \Graphpinator\Value\ListResolvedValue($list, $return);
    }

    private function resolveField(
        \Graphpinator\Field\ResolvableField $field,
        \Graphpinator\Normalizer\Field\Field $requestedField,
    ) : \Graphpinator\Value\FieldValue
    {
        foreach ($field->getDirectiveUsages() as $directive) {
            $directive->getDirective()->resolveFieldDefinitionStart($directive->getArgumentValues(), $this->parentResult);
        }

        $arguments = $requestedField->getArguments();

        foreach ($arguments as $argumentValue) {
            $argumentValue->resolveNonPureDirectives();
        }

        foreach ($field->getDirectiveUsages() as $directive) {
            $directive->getDirective()->resolveFieldDefinitionBefore($directive->getArgumentValues(), $this->parentResult, $arguments);
        }

        $rawArguments = $arguments->getValuesForResolver();
        \array_unshift($rawArguments, $this->parentResult->getRawValue());
        $rawValue = \call_user_func_array($field->getResolveFunction(), $rawArguments);
        $resolvedValue = $this->getResolvedValue($rawValue, $field->getType());

        if (!$resolvedValue->getType()->isInstanceOf($field->getType())) {
            throw new \Graphpinator\Resolver\Exception\FieldResultTypeMismatch();
        }

        foreach ($field->getDirectiveUsages() as $directive) {
            $directive->getDirective()->resolveFieldDefinitionAfter($directive->getArgumentValues(), $resolvedValue, $arguments);
        }

        if ($resolvedValue instanceof \Graphpinator\Value\NullValue) {
            $fieldValue = $resolvedValue;
        } else {
            $resolver = new self(
                $requestedField->getFields(),
                $resolvedValue,
            );

            $fieldValue = $resolvedValue->getType()->accept($resolver);
        }

        return new \Graphpinator\Value\FieldValue($field, $fieldValue);
    }

    private function getResolvedValue(mixed $rawValue, \Graphpinator\Type\Contract\Definition $type) : \Graphpinator\Value\ResolvedValue
    {
        $visitor = new CreateResolvedValueVisitor($rawValue);

        return $type->accept($visitor);
    }
}
