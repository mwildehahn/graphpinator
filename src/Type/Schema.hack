namespace Graphpinator\Type;

final class Schema implements \Graphpinator\Typesystem\Entity {
    use \Graphpinator\Utils\TOptionalDescription;

    public function __construct(
        private \Graphpinator\Container\Container $container,
        private \Graphpinator\Type\Type $query,
        private ?\Graphpinator\Type\Type $mutation = null,
        private ?\Graphpinator\Type\Type $subscription = null,
    ) {
        $this->query->addMetaField(new \Graphpinator\Field\ResolvableField(
            '__schema',
            $this->container->getType('__Schema')?->notNull() as nonnull,
            function($_, $_): this {
                return $this;
            },
        ));
        $this->query->addMetaField(
            \Graphpinator\Field\ResolvableField::create(
                '__type',
                $this->container->getType('__Type')?->getName() as nonnull,
                function(mixed $parent, mixed $name): ?\Graphpinator\Type\Contract\Definition {
                    return $this->container->getType($name as string);
                },
            )->setArguments(new \Graphpinator\Argument\ArgumentSet(dict[
                'name' =>
                    new \Graphpinator\Argument\Argument('name', \Graphpinator\Container\Container::String()->notNull()),
            ])),
        );
    }

    public function getContainer(): \Graphpinator\Container\Container {
        return $this->container;
    }

    public function getQuery(): \Graphpinator\Type\Type {
        return $this->query;
    }

    public function getMutation(): ?\Graphpinator\Type\Type {
        return $this->mutation;
    }

    public function getSubscription(): ?\Graphpinator\Type\Type {
        return $this->subscription;
    }

    public function accept(\Graphpinator\Typesystem\EntityVisitor $visitor): mixed {
        return $visitor->visitSchema($this);
    }
}
