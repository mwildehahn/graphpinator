namespace Graphpinator\Normalizer;

final class FinalizedRequest
{
    use \Nette\SmartObject;

    public function __construct(
        private \Graphpinator\Normalizer\Operation\Operation $operation,
    ) {}

    public function getOperation() : \Graphpinator\Normalizer\Operation\Operation
    {
        return $this->operation;
    }
}
