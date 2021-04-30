namespace Graphpinator\Resolver\Exception;

final class FieldResultTypeMismatch extends \Graphpinator\Resolver\Exception\ResolverError
{
    public const MESSAGE = 'FieldResult does not match field type.';
}
