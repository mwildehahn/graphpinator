namespace Graphpinator\Value;

interface Value
{
    public function getRawValue() : mixed;

    public function getType() : \Graphpinator\Type\Contract\Definition;
}
