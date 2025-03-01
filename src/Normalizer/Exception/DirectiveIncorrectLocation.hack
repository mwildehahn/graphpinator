namespace Graphpinator\Normalizer\Exception;

final class DirectiveIncorrectLocation extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Directive "%s" cannot be used on this DirectiveLocation.';

    public function __construct(string $name)
    {
        $this->messageArgs = [$name];

        parent::__construct();
    }
}
