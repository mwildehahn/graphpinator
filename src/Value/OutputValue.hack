namespace Graphpinator\Value;

interface OutputValue extends \Graphpinator\Value\ResolvedValue, \JsonSerializable
{
    public function jsonSerialize() : \stdClass|array|string|int|float|bool|null;
}
