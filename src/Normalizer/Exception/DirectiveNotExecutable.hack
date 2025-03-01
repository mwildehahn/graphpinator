namespace Graphpinator\Normalizer\Exception;

final class DirectiveNotExecutable extends \Graphpinator\Normalizer\Exception\NormalizerError
{
    public const MESSAGE = 'Directive "%s" is not executable directive.';

    public function __construct(string $name)
    {
        $this->messageArgs = [$name];

        parent::__construct();
    }
}
