namespace Graphpinator\Normalizer\Exception;

final class OperationNotSupported extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Operation "%s" is not supported by this service.';

    public function __construct(string $operation)
    {
        $this->messageArgs = [$operation];

        parent::__construct();
    }
}
