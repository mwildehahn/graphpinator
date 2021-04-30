namespace Graphpinator\Type;

abstract class Type
    extends \Graphpinator\Type\Contract\ConcreteDefinition
    implements
        \Graphpinator\Type\Contract\TypeConditionable,
        \Graphpinator\Type\Contract\InterfaceImplementor<\Graphpinator\Field\ResolvableFieldSet> {
    use \Graphpinator\Type\Contract\TInterfaceImplementor<
        \Graphpinator\Field\ResolvableField,
        \Graphpinator\Field\ResolvableFieldSet,
    >;
    use \Graphpinator\Type\Contract\TMetaFields;
    use \Graphpinator\Utils\THasDirectives;

    protected ?\Graphpinator\Field\ResolvableFieldSet $fields = null;

    public function __construct(?\Graphpinator\Type\InterfaceSet $implements = null) {
        $this->implements = $implements ?? new \Graphpinator\Type\InterfaceSet();
        $this->directiveUsages = new \Graphpinator\DirectiveUsage\DirectiveUsageSet();
    }

    abstract public function validateNonNullValue(mixed $rawValue): bool;

    final public function addMetaField(\Graphpinator\Field\ResolvableField $field): void {
        $this->getMetaFields()->offsetSet($field->getName(), $field);
    }

    final public function isInstanceOf(\Graphpinator\Type\Contract\Definition $type): bool {
        if ($type is \Graphpinator\Type\Contract\AbstractDefinition) {
            return $type->isImplementedBy($this);
        }

        return parent::isInstanceOf($type);
    }

    final public function getFields(): \Graphpinator\Field\ResolvableFieldSet {
        if ($this->fields is null) {
            $this->fields = $this->getFieldDefinition();

            if (\Graphpinator\Graphpinator::$validateSchema) {
                $this->validateInterfaceContract();
            }
        }

        return $this->fields as \Graphpinator\Field\ResolvableFieldSet;
    }

    final public function accept(\Graphpinator\Typesystem\NamedTypeVisitor $visitor): mixed {
        return $visitor->visitType($this);
    }

    final public function addDirective(
        \Graphpinator\Directive\Contract\ObjectLocation $directive,
        \Graphpinator\Argument\ArgumentSet $arguments = new \Graphpinator\Argument\ArgumentSet(),
    ): this {
        $usage = new \Graphpinator\DirectiveUsage\DirectiveUsage($directive, $arguments);

        if (!$directive->validateObjectUsage($this, $usage->getArgumentValues())) {
            throw new \Graphpinator\Exception\Type\DirectiveIncorrectType();
        }

        $this->directiveUsages->offsetSet(null, $usage);

        return $this;
    }

    abstract protected function getFieldDefinition(): \Graphpinator\Field\ResolvableFieldSet;
}
