namespace Graphpinator\Request\Exception;

final class UnknownKey extends \Graphpinator\Request\Exception\RequestError
{
    public const MESSAGE = 'Invalid request - unknown key in request JSON (only "query", "variables" and "operationName" are allowed).';
}
