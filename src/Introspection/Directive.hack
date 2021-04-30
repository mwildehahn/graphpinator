namespace Graphpinator\Introspection;

final class Directive extends \Graphpinator\Type\Type {
    const NAME = '__Directive';
    const DESCRIPTION = 'Built-in introspection type.';

    public function __construct(private \Graphpinator\Container\Container $container) {
        parent::__construct();
    }

    public function validateNonNullValue(mixed $rawValue): bool {
        return $rawValue is \Graphpinator\Directive\Directive;
    }

    protected function getFieldDefinition(): \Graphpinator\Field\ResolvableFieldSet {
        return new \Graphpinator\Field\ResolvableFieldSet(dict[
            'name' => new \Graphpinator\Field\ResolvableField(
                'name',
                \Graphpinator\Container\Container::String()->notNull(),
                static function(shape(?'directive' => \Graphpinator\Directive\Directive, ...) $args): string {
                    return $args['directive']->getName();
                },
            ),
            'description' => new \Graphpinator\Field\ResolvableField(
                'description',
                \Graphpinator\Container\Container::String(),
                static function(shape(?'directive' => \Graphpinator\Directive\Directive, ...) $args): ?string {
                    return $args['directive']->getDescription();
                },
            ),
            'locations' => new \Graphpinator\Field\ResolvableField(
                'locations',
                $this->container->getType('__DirectiveLocation')->notNullList(),
                static function(shape(?'directive' => \Graphpinator\Directive\Directive, ...) $args): array {
                    return $args['directive']->getLocations();
                },
            ),
            'args' => new \Graphpinator\Field\ResolvableField(
                'args',
                $this->container->getType('__InputValue')->notNullList(),
                static function(
                    shape(?'directive' => \Graphpinator\Directive\Directive, ...) $args,
                ): \Graphpinator\Argument\ArgumentSet {
                    return $directive->getArguments();
                },
            ),
            'isRepeatable' => new \Graphpinator\Field\ResolvableField(
                'isRepeatable',
                \Graphpinator\Container\Container::Boolean()->notNull(),
                static function(shape(?'directive' => \Graphpinator\Directive\Directive, ...) $args): bool {
                    return $directive->isRepeatable();
                },
            ),
        ]);
    }
}
