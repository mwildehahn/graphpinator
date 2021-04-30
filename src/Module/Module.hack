namespace Graphpinator\Module;

interface Module {
    public function processRequest(\Graphpinator\Request\Request $request): mixed;

    public function processParsed(\Graphpinator\Parser\ParsedRequest $request): mixed;

    public function processNormalized(\Graphpinator\Normalizer\NormalizedRequest $request): mixed;

    public function processFinalized(
        \Graphpinator\Normalizer\FinalizedRequest $request,
    ): \Graphpinator\Normalizer\FinalizedRequest;
}
