namespace Graphpinator\Value;

final class TypeIntermediateValue implements \Graphpinator\Value\ResolvedValue
{
    use \Nette\SmartObject;

    private \Graphpinator\Type\Type $type;
    private mixed $rawValue;

    public function __construct(\Graphpinator\Type\Type $type, mixed $rawValue)
    {
        if (!$type->validateNonNullValue($rawValue)) {
            throw new \Graphpinator\Exception\Value\InvalidValue($type->getName(), $rawValue, false);
        }

        $this->type = $type;
        $this->rawValue = $rawValue;
    }

    public function getRawValue(bool $forResolvers = false) : mixed
    {
        return $this->rawValue;
    }

    public function getType() : \Graphpinator\Type\Type
    {
        return $this->type;
    }
}
