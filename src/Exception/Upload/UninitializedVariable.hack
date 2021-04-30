namespace Graphpinator\Exception\Upload;

final class UninitializedVariable extends \Graphpinator\Exception\Upload\UploadError
{
    public const MESSAGE = 'Variable for Upload must be initialized.';
}
