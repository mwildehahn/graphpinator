namespace Graphpinator\DirectiveUsage;

final class DirectiveUsage implements \Graphpinator\Typesystem\Component {

    private \Graphpinator\Directive\Contract\TypeSystemDefinition $directive;
    private \Graphpinator\Value\ArgumentValueSet $argumentValues;

    public function __construct(
        \Graphpinator\Directive\Contract\TypeSystemDefinition $directive,
        \Graphpinator\Argument\ArgumentSet $arguments,
    ) {
        $this->directive = $directive;
        $this->argumentValues = new \Graphpinator\Value\ArgumentValueSet(
            (array)\Graphpinator\Value\ConvertRawValueVisitor::convertArgumentSet(
                $directive->getArguments(),
                $arguments,
                new \Graphpinator\Common\Path(),
            ),
        );
    }

    public function getDirective(): \Graphpinator\Directive\Contract\TypeSystemDefinition {
        return $this->directive;
    }

    public function getArgumentValues(): \Graphpinator\Value\ArgumentValueSet {
        return $this->argumentValues;
    }

    public function accept(\Graphpinator\Typesystem\ComponentVisitor $visitor): mixed {
        return $visitor->visitDirectiveUsage($this);
    }
}
