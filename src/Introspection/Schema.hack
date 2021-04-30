namespace Graphpinator\Introspection;

final class Schema extends \Graphpinator\Type\Type {
    protected const NAME = '__Schema';
    protected const DESCRIPTION = 'Built-in introspection type.';

    public function __construct(private \Graphpinator\Container\Container $container) {
        parent::__construct();
    }

    public function validateNonNullValue(mixed $rawValue): bool {
        return $rawValue is \Graphpinator\Type\Schema;
    }

    protected function getFieldDefinition(): \Graphpinator\Field\ResolvableFieldSet {
        return new \Graphpinator\Field\ResolvableFieldSet(dict[
            'description' => new \Graphpinator\Field\ResolvableField(
                'description',
                \Graphpinator\Container\Container::String(),
                static function(\Graphpinator\Type\Schema $schema): ?string {
                    return $schema->getDescription();
                },
            ),
            'types' => new \Graphpinator\Field\ResolvableField(
                'types',
                $this->container->getType('__Type')?->notNullList() as nonnull,
                static function(\Graphpinator\Type\Schema $schema): array {
                    return $schema->getContainer()->getTypes(true);
                },
            ),
            'queryType' => new \Graphpinator\Field\ResolvableField(
                'queryType',
                $this->container->getType('__Type')?->notNull() as nonnull,
                static function(\Graphpinator\Type\Schema $schema): \Graphpinator\Type\Contract\Definition {
                    return $schema->getQuery();
                },
            ),
            'mutationType' => new \Graphpinator\Field\ResolvableField(
                'mutationType',
                $this->container->getType('__Type'),
                static function(\Graphpinator\Type\Schema $schema): ?\Graphpinator\Type\Contract\Definition {
                    return $schema->getMutation();
                },
            ),
            'subscriptionType' => new \Graphpinator\Field\ResolvableField(
                'subscriptionType',
                $this->container->getType('__Type'),
                static function(\Graphpinator\Type\Schema $schema): ?\Graphpinator\Type\Contract\Definition {
                    return $schema->getMutation();
                },
            ),
            'directives' => new \Graphpinator\Field\ResolvableField(
                'directives',
                $this->container->getType('__Directive')->notNullList(),
                static function(\Graphpinator\Type\Schema $schema): array {
                    return $schema->getContainer()->getDirectives(true);
                },
            ),
        ]);
    }
}
