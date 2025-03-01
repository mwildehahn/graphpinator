namespace Graphpinator\Normalizer\Exception;

final class VariableTypeInputable extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Variable "%s" does not have inputable type.';

    public function __construct(string $name)
    {
        $this->messageArgs = [$name];

        parent::__construct();
    }
}
