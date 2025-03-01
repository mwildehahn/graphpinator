namespace Graphpinator\Type\Spec;

final class IdType extends \Graphpinator\Type\ScalarType
{
    protected const NAME = 'ID';
    protected const DESCRIPTION = 'ID built-in type';

    public function validateNonNullValue(mixed $rawValue) : bool
    {
        return \is_string($rawValue);
    }

    public function coerceValue(mixed $rawValue) : mixed
    {
        return \is_int($rawValue)
            ? (string) $rawValue
            : $rawValue;
    }
}
