namespace Graphpinator\Value;

final class ConvertRawValueVisitor implements \Graphpinator\Typesystem\TypeVisitor {
    use \Nette\SmartObject;

    public function __construct(private mixed $rawValue, private \Graphpinator\Common\Path $path) {}

    public function visitType(\Graphpinator\Type\Type $type): mixed {
        // nothing here
    }

    public function visitInterface(\Graphpinator\Type\InterfaceType $interface): mixed {
        // nothing here
    }

    public function visitUnion(\Graphpinator\Type\UnionType $union): mixed {
        // nothing here
    }

    public function visitInput(\Graphpinator\Type\InputType $input): InputedValue {
        if ($this->rawValue === null) {
            return new \Graphpinator\Value\NullInputedValue($input);
        }

        if (!$this->rawValue is KeyedContainer<_, _>) {
            throw new \Graphpinator\Exception\Value\InvalidValue($input->getName(), $this->rawValue, true);
        }

        return new InputValue($input, self::convertArgumentSet($input->getArguments(), $this->rawValue, $this->path));
    }

    public function visitScalar(\Graphpinator\Type\ScalarType $scalar): InputedValue {
        if ($this->rawValue === null) {
            return new \Graphpinator\Value\NullInputedValue($scalar);
        }

        $this->rawValue = $scalar->coerceValue($this->rawValue);

        return new \Graphpinator\Value\ScalarValue($scalar, $this->rawValue, true);
    }

    public function visitEnum(\Graphpinator\Type\EnumType $enum): InputedValue {
        if ($this->rawValue === null) {
            return new \Graphpinator\Value\NullInputedValue($enum);
        }

        return new \Graphpinator\Value\EnumValue($enum, $this->rawValue, true);
    }

    public function visitNotNull(\Graphpinator\Type\NotNullType $notNull): InputedValue {
        $value = $notNull->getInnerType()->accept($this);

        if ($value is \Graphpinator\Value\NullValue) {
            throw new \Graphpinator\Exception\Value\ValueCannotBeNull(true);
        }

        return $value;
    }

    public function visitList(\Graphpinator\Type\ListType $list): InputedValue {
        if ($this->rawValue === null) {
            return new \Graphpinator\Value\NullInputedValue($list);
        }

        if (!\is_array($this->rawValue)) {
            throw new \Graphpinator\Exception\Value\InvalidValue($list->printName(), $this->rawValue, true);
        }

        $innerType = $list->getInnerType();
        \assert($innerType is \Graphpinator\Type\Contract\Inputable);

        $inner = vec[];
        $listValue = $this->rawValue;

        foreach ($listValue as $index => $rawValue) {
            $this->path->add($index.' <list index>');
            $this->rawValue = $rawValue;
            $inner[] = $innerType->accept($this);
            $this->path->pop();
        }

        $this->rawValue = $listValue;

        return new ListInputedValue($list, $inner);
    }

    public static function convertArgumentSet(
        \Graphpinator\Argument\ArgumentSet $arguments,
        \stdClass $rawValue,
        \Graphpinator\Common\Path $path,
    ): \stdClass {
        $rawValue = self::mergeRaw($rawValue, (object)$arguments->getRawDefaults());

        foreach ((array)$rawValue as $name => $temp) {
            if ($arguments->offsetExists($name)) {
                continue;
            }

            throw new \Graphpinator\Normalizer\Exception\UnknownArgument($name);
        }

        $inner = new \stdClass();

        foreach ($arguments as $argument) {
            $path->add($argument->getName().' <argument>');
            $inner->{
                $argument->getName()
            } = self::convertArgument($argument, $rawValue->{$argument->getName()} ?? null, $path);
            $path->pop();
        }

        return $inner;
    }

    public static function convertArgument(
        \Graphpinator\Argument\Argument $argument,
        mixed $rawValue,
        \Graphpinator\Common\Path $path,
    ): ArgumentValue {
        $default = $argument->getDefaultValue();

        if ($rawValue === null && $default is \Graphpinator\Value\ArgumentValue) {
            return $default;
        }

        return new ArgumentValue(
            $argument,
            $argument->getType()->accept(new ConvertRawValueVisitor($rawValue, $path)),
            false,
        );
    }

    private static function mergeRaw(dict<string, mixed> $core, dict<string, mixed> $supplement): dict<string, mixed> {
        foreach ($supplement as $key => $value) {
            if (\property_exists($core, $key)) {
                if ($core[$key] is KeyedContainer<_, _> && $supplement[$key] is KeyedContainer<_, _>) {
                    /* HH_FIXME[4110] */
                    $core[$key] = self::mergeRaw($core[$key], $supplement[$key]);
                }

                continue;
            }

            $core[$key] = $value;
        }

        return $core;
    }
}
