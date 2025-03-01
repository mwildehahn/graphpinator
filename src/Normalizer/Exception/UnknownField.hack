namespace Graphpinator\Normalizer\Exception;

final class UnknownField extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Unknown field "%s" requested for type "%s".';

    public function __construct(string $field, string $type)
    {
        $this->messageArgs = [$field, $type];

        parent::__construct();
    }
}
