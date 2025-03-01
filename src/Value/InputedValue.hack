namespace Graphpinator\Value;

interface InputedValue extends \Graphpinator\Value\Value {
    public function getRawValue(bool $forResolvers = false): mixed;

    public function getType(): \Graphpinator\Type\Contract\Inputable;

    /**
     * Function used to replace variable references with concrete values before query execution.
     */
    public function applyVariables(\Graphpinator\Normalizer\VariableValueSet $variables): void;

    /**
     * Function used to compare argument values in field merging.
     */
    public function isSame(?InputedValue $compare): bool;

    /**
     * Function used to print value in introspection.
     */
    public function printValue(): string;
}
