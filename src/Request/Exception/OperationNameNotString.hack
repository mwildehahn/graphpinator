namespace Graphpinator\Request\Exception;

final class OperationNameNotString extends \Graphpinator\Request\Exception\RequestError
{
    public const MESSAGE = 'Invalid request - "operationName" key in request JSON is of invalid type (expected string).';
}
