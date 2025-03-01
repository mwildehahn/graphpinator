namespace Graphpinator\Value;

final class NullResolvedValue implements \Graphpinator\Value\OutputValue, \Graphpinator\Value\NullValue
{
    use \Nette\SmartObject;

    public function __construct(
        private \Graphpinator\Type\Contract\Outputable $type,
    ) {}

    public function getRawValue() : ?bool
    {
        return null;
    }

    public function getType() : \Graphpinator\Type\Contract\Outputable
    {
        return $this->type;
    }

    public function jsonSerialize() : ?bool
    {
        return null;
    }
}
