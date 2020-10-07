<?php

declare(strict_types = 1);

namespace Graphpinator\Resolver;

final class ArgumentValueSet extends \Infinityloop\Utils\ObjectSet
{
    public function __construct(
        \Graphpinator\Parser\Value\NamedValueSet $namedValueSet,
        \Graphpinator\Argument\ArgumentSet $argumentSet
    )
    {
        foreach ($namedValueSet as $namedValue) {
            if (!$argumentSet->offsetExists($namedValue->getName())) {
                throw new \Graphpinator\Exception\Resolver\UnknownArgument();
            }
        }

        foreach ($argumentSet as $argument) {
            if ($namedValueSet->offsetExists($argument->getName())) {
                $value = $argument->getType()->createInputableValue($namedValueSet[$argument->getName()]->getRawValue());
            } elseif ($argument->getDefaultValue() instanceof \Graphpinator\Value\InputableValue) {
                $value = $argument->getDefaultValue();
            } else {
                $value = $argument->getType()->createInputableValue(null);
            }

            $this->appendUnique($argument, $value);
        }
    }

    public function current() : \Graphpinator\Value\InputableValue
    {
        return parent::current();
    }

    public function offsetGet($offset) : \Graphpinator\Value\InputableValue
    {
        return parent::offsetGet($offset);
    }

    public function getRawValues() : array
    {
        $return = [];

        foreach ($this as $argumentValue) {
            $return[] = $argumentValue->getRawValue();
        }

        return $return;
    }

    private function appendUnique(\Graphpinator\Argument\Argument $argument, \Graphpinator\Value\InputableValue $value) : void
    {
        $argument->validateConstraints($value);

        if ($this->offsetExists($argument->getName())) {
            throw new \Exception('Duplicated item.');
        }

        $this->array[$argument->getName()] = $value;
    }
}
