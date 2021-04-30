namespace Graphpinator\Field;

final class ResolvableField<Ti, To> extends \Graphpinator\Field\Field {
    private ?(function(Ti): To) $resolveFn;

    public function __construct(
        string $name,
        \Graphpinator\Type\Contract\Outputable $type,
        ?(function(Ti): To) $resolveFn = null,
    ) {
        parent::__construct($name, $type);
        $this->resolveFn = $resolveFn;
    }

    public static function create(
        string $name,
        \Graphpinator\Type\Contract\Outputable $type,
        ?(function(Ti): To) $resolveFn = null,
    ): this {
        return new self($name, $type, $resolveFn);
    }

    public function getResolveFunction(): ?(function(Ti): To) {
        return $this->resolveFn;
    }
}
