namespace Graphpinator\Tests\Feature;

final class InputObject
{
    public int $number;
    public ?InputObject2 $simpleInput2;
    public \stdClass $simpleInput3;
}
