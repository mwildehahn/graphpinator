namespace Graphpinator\Field;

class Field implements \Graphpinator\Typesystem\Component {
    use \Graphpinator\Utils\TOptionalDescription;
    use \Graphpinator\Utils\THasDirectives;
    use \Graphpinator\Utils\TDeprecatable<\Graphpinator\Directive\Contract\FieldDefinitionLocation>;

    protected string $name;
    protected \Graphpinator\Type\Contract\Outputable $type;
    protected \Graphpinator\Argument\ArgumentSet $arguments;

    public function __construct(string $name, \Graphpinator\Type\Contract\Outputable $type) {
        $this->name = $name;
        $this->type = $type;
        $this->arguments = new \Graphpinator\Argument\ArgumentSet();
        $this->directiveUsages = new \Graphpinator\DirectiveUsage\DirectiveUsageSet();
    }

    public static function create(string $name, \Graphpinator\Type\Contract\Outputable $type): Field {
        return new Field($name, $type);
    }

    final public function getName(): string {
        return $this->name;
    }

    final public function getType(): \Graphpinator\Type\Contract\Outputable {
        return $this->type;
    }

    final public function getArguments(): \Graphpinator\Argument\ArgumentSet {
        return $this->arguments;
    }

    final public function setArguments(\Graphpinator\Argument\ArgumentSet $arguments): this {
        $this->arguments = $arguments;

        return $this;
    }

    final public function accept(\Graphpinator\Typesystem\ComponentVisitor $visitor): mixed {
        return $visitor->visitField($this);
    }

    final public function addDirective(
        \Graphpinator\Directive\Contract\FieldDefinitionLocation $directive,
        \Graphpinator\Argument\ArgumentSet $arguments = new \Graphpinator\Argument\ArgumentSet(),
    ): this {
        $usage = new \Graphpinator\DirectiveUsage\DirectiveUsage($directive, $arguments);

        if (!$directive->validateFieldUsage($this, $usage->getArgumentValues())) {
            throw new \Graphpinator\Exception\Type\DirectiveIncorrectType();
        }

        $this->directiveUsages->offsetSet(null, $usage);

        return $this;
    }
}
