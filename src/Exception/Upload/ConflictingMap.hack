namespace Graphpinator\Exception\Upload;

final class ConflictingMap extends \Graphpinator\Exception\Upload\UploadError
{
    public const MESSAGE = 'Upload map is in conflict with other value.';
}
