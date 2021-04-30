namespace Graphpinator\Exception\Type;

final class InputCycle extends \Graphpinator\Exception\Type\TypeError
{
    public const MESSAGE = 'Input cycle detected.';
}
