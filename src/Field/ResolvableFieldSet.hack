namespace Graphpinator\Field;

/**
 * @method \Graphpinator\Field\ResolvableField current() : object
 * @method \Graphpinator\Field\ResolvableField offsetGet($offset) : object
 */
final class ResolvableFieldSet extends \Infinityloop\Utils\ObjectMap<string, ResolvableField> {
    protected function getKey(ResolvableField $object): string {
        return $object->getName();
    }
}
