namespace Graphpinator;

final class Graphpinator implements \Psr\Log\LoggerAwareInterface {
    use \Nette\SmartObject;

    public static bool $validateSchema = true;
    private bool $catchExceptions;
    private \Graphpinator\Module\ModuleSet $modules;
    private \Psr\Log\LoggerInterface $logger;
    private \Graphpinator\Parser\Parser $parser;
    private \Graphpinator\Normalizer\Normalizer $normalizer;
    private \Graphpinator\Normalizer\Finalizer $finalizer;
    private \Graphpinator\Resolver\Resolver $resolver;

    public function __construct(
        \Graphpinator\Type\Schema $schema,
        bool $catchExceptions = false,
        ?\Graphpinator\Module\ModuleSet $modules = null,
        ?\Psr\Log\LoggerInterface $logger = null,
    ) {
        $this->catchExceptions = $catchExceptions;
        $this->modules = $modules is \Graphpinator\Module\ModuleSet ? $modules : new \Graphpinator\Module\ModuleSet();
        $this->logger = $logger is \Psr\Log\LoggerInterface ? $logger : new \Psr\Log\NullLogger();
        $this->parser = new \Graphpinator\Parser\Parser();
        $this->normalizer = new \Graphpinator\Normalizer\Normalizer($schema);
        $this->finalizer = new \Graphpinator\Normalizer\Finalizer();
        $this->resolver = new \Graphpinator\Resolver\Resolver();
    }

    public function run(\Graphpinator\Request\RequestFactory $requestFactory): \Graphpinator\Result {
        try {
            $request = $requestFactory->create();
            $result = $request;

            $this->logger->debug($request->getQuery());

            foreach ($this->modules as $module) {
                $result = $module->processRequest($request);

                if (!$result is \Graphpinator\Request\Request) {
                    break;
                }
            }

            if ($result is \Graphpinator\Request\Request) {
                $result = $this->parser->parse(new \Graphpinator\Source\StringSource($request->getQuery()));

                foreach ($this->modules as $module) {
                    $result = $module->processParsed($result);

                    if (!$result is \Graphpinator\Parser\ParsedRequest) {
                        break;
                    }
                }
            }

            if ($result is \Graphpinator\Parser\ParsedRequest) {
                $result = $this->normalizer->normalize($result);

                foreach ($this->modules as $module) {
                    $result = $module->processNormalized($result);

                    if (!$result is \Graphpinator\Normalizer\NormalizedRequest) {
                        break;
                    }
                }
            }

            if ($result is \Graphpinator\Normalizer\NormalizedRequest) {
                $result = $this->finalizer->finalize($result, $request->getVariables(), $request->getOperationName());

                foreach ($this->modules as $module) {
                    $result = $module->processFinalized($result);
                }
            }

            return $this->resolver->resolve($result);
        } catch (\Throwable $exception) {
            if (!$this->catchExceptions) {
                throw $exception;
            }

            $this->logger->log(self::getLogLevel($exception), self::getLogMessage($exception));

            return new \Graphpinator\Result(null, vec[
                $exception is \Graphpinator\Exception\GraphpinatorBase
                    ? $exception
                    : \Graphpinator\Exception\GraphpinatorBase::notOutputableResponse(),
            ]);
        }
    }

    public function setLogger(\Psr\Log\LoggerInterface $logger): void {
        $this->logger = $logger;
    }

    private static function getLogMessage(\Throwable $exception): string {
        return $exception->getMessage().' in '.$exception->getFile().':'.$exception->getLine();
    }

    private static function getLogLevel(\Throwable $exception): string {
        if ($exception is \Graphpinator\Exception\GraphpinatorBase) {
            return $exception->isOutputable() ? \Psr\Log\LogLevel::INFO : \Psr\Log\LogLevel::ERROR;

        }

        return \Psr\Log\LogLevel::EMERGENCY;
    }
}
