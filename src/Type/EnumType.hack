namespace Graphpinator\Type;

abstract class EnumType extends \Graphpinator\Type\Contract\LeafDefinition {
    public function __construct(protected \Graphpinator\EnumItem\EnumItemSet $options) {}

    final public static function fromConstants(): \Graphpinator\EnumItem\EnumItemSet {
        $values = vec[];

        foreach ((new \ReflectionClass(static::class))->getConstants() as $name => $constant) {
            $value = $constant->getValue();
            $values[] = new \Graphpinator\EnumItem\EnumItem(
                $value,
                $constant->getDocComment() ? \trim($constant->getDocComment(), '/* ') : null,
            );
        }

        return new \Graphpinator\EnumItem\EnumItemSet($values);
    }

    final public function getItems(): \Graphpinator\EnumItem\EnumItemSet {
        return $this->options;
    }

    final public function accept(\Graphpinator\Typesystem\NamedTypeVisitor $visitor): mixed {
        return $visitor->visitEnum($this);
    }

    final public function validateNonNullValue(mixed $rawValue): bool {
        return \is_string($rawValue) && $this->options->offsetExists($rawValue as int);
    }
}
