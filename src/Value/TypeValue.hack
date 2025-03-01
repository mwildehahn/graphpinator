namespace Graphpinator\Value;

final class TypeValue implements \Graphpinator\Value\OutputValue
{
    use \Nette\SmartObject;

    private \Graphpinator\Type\Type $type;
    private \stdClass $value;

    public function __construct(\Graphpinator\Type\Type $type, \stdClass $rawValue)
    {
        $this->type = $type;
        $this->value = $rawValue;

        foreach ($type->getDirectiveUsages() as $directive) {
            $directive->getDirective()->resolveObject($directive->getArgumentValues(), $this);
        }
    }

    public function getRawValue() : \stdClass
    {
        return $this->value;
    }

    public function getType() : \Graphpinator\Type\Type
    {
        return $this->type;
    }

    public function jsonSerialize() : \stdClass
    {
        return $this->value;
    }

    public function __get(string $name) : \Graphpinator\Value\FieldValue
    {
        return $this->value->{$name};
    }

    public function __isset(string $name) : bool
    {
        return \property_exists($this->value, $name);
    }
}
