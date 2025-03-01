namespace Graphpinator\Normalizer\Exception;

final class UnknownType extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Unknown type "%s".';

    public function __construct(string $type)
    {
        $this->messageArgs = [$type];

        parent::__construct();
    }
}
