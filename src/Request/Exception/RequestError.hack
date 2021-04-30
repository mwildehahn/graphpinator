namespace Graphpinator\Request\Exception;

abstract class RequestError extends \Graphpinator\Exception\GraphpinatorBase
{
    public function isOutputable() : bool
    {
        return true;
    }
}
