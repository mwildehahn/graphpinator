namespace Graphpinator\Normalizer\Exception;

final class UnknownArgument extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Unknown argument "%s" provided.';

    public function __construct(string $argument)
    {
        $this->messageArgs = [$argument];

        parent::__construct();
    }
}
