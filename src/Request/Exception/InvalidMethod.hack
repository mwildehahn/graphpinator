namespace Graphpinator\Request\Exception;

final class InvalidMethod extends \Graphpinator\Request\Exception\RequestError
{
    public const MESSAGE = 'Invalid request - only GET and POST methods are supported.';
}
