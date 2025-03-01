namespace Graphpinator\Normalizer\Operation;

final class Operation
{
    use \Nette\SmartObject;

    public function __construct(
        protected string $type,
        protected ?string $name,
        protected \Graphpinator\Type\Type $rootObject,
        protected \Graphpinator\Normalizer\Field\FieldSet $children,
        protected \Graphpinator\Normalizer\Variable\VariableSet $variables,
        protected \Graphpinator\Normalizer\Directive\DirectiveSet $directives,
    ) {}

    public function getType() : string
    {
        return $this->type;
    }

    public function getRootObject() : \Graphpinator\Type\Type
    {
        return $this->rootObject;
    }

    public function getFields() : \Graphpinator\Normalizer\Field\FieldSet
    {
        return $this->children;
    }

    public function getVariables() : \Graphpinator\Normalizer\Variable\VariableSet
    {
        return $this->variables;
    }

    public function getDirectives() : \Graphpinator\Normalizer\Directive\DirectiveSet
    {
        return $this->directives;
    }

    public function getName() : ?string
    {
        return $this->name;
    }
}
