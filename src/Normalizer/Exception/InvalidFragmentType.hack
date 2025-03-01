namespace Graphpinator\Normalizer\Exception;

final class InvalidFragmentType extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Invalid fragment type condition. ("%s" is not instance of "%s").';

    public function __construct(string $childType, string $parentType)
    {
        $this->messageArgs = [$childType, $parentType];

        parent::__construct();
    }
}
