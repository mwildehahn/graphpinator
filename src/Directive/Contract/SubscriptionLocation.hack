namespace Graphpinator\Directive\Contract;

interface SubscriptionLocation extends ExecutableDefinition
{
    public function resolveSubscriptionBefore(
        \Graphpinator\Value\ArgumentValueSet $arguments,
    ) : string;

    public function resolveSubscriptionAfter(
        \Graphpinator\Value\ArgumentValueSet $arguments,
        \Graphpinator\Value\TypeValue $typeValue,
    ) : string;
}
