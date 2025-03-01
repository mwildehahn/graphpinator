namespace Graphpinator\Normalizer\Directive;

/**
 * @method \Graphpinator\Normalizer\Directive\Directive current() : object
 * @method \Graphpinator\Normalizer\Directive\Directive offsetGet($offset) : object
 */
final class DirectiveSet extends \Infinityloop\Utils\ObjectSet
{
    protected const INNER_CLASS = Directive::class;

    public function applyVariables(\Graphpinator\Normalizer\VariableValueSet $variables) : void
    {
        foreach ($this as $directive) {
            $directive->applyVariables($variables);
        }
    }
}
