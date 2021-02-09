<?php

declare(strict_types = 1);

namespace Graphpinator\Value;

/**
 * @method \Graphpinator\Value\ArgumentValue current() : object
 * @method \Graphpinator\Value\ArgumentValue offsetGet($offset) : object
 */
final class ArgumentValueSet extends \Infinityloop\Utils\ImplicitObjectMap
{
    protected const INNER_CLASS = \Graphpinator\Value\ArgumentValue::class;

    private function __construct(array $data)
    {
        parent::__construct($data);
    }

    public static function fromParsed(
        \Graphpinator\Parser\Value\ArgumentValueSet $parsed,
        \Graphpinator\Field\Field|\Graphpinator\Directive\Directive $element,
        \Graphpinator\Normalizer\Variable\VariableSet $variableSet,
    ) : self
    {
        $items = [];
        $argumentSet = $element->getArguments();

        foreach ($argumentSet as $argument) {
            if (!$parsed->offsetExists($argument->getName())) {
                $items[] = \Graphpinator\Value\ArgumentValue::fromRaw($argument, null);

                continue;
            }

            $parsedArg = $parsed->offsetGet($argument->getName());
            $items[] = \Graphpinator\Value\ArgumentValue::fromParsed($argument, $parsedArg->getValue(), $variableSet);
        }

        foreach ($parsed as $value) {
            if (!$argumentSet->offsetExists($value->getName())) {
                throw new \Graphpinator\Exception\Normalizer\UnknownArgument($value->getName(), $element->getName());
            }
        }

        return new self($items);
    }

    public static function fromRaw(
        array $rawValues,
        \Graphpinator\Field\Field|\Graphpinator\Directive\Contract\Definition $element,
    ) : self
    {
        $items = [];
        $argumentSet = $element->getArguments();

        foreach ($argumentSet as $argument) {
            if (!\array_key_exists($argument->getName(), $rawValues)) {
                $items[] = \Graphpinator\Value\ArgumentValue::fromRaw($argument, null);

                continue;
            }

            $items[] = \Graphpinator\Value\ArgumentValue::fromRaw($argument, $rawValues[$argument->getName()]);
        }

        foreach ($rawValues as $key => $value) {
            if (!$argumentSet->offsetExists($key)) {
                throw new \Graphpinator\Exception\Normalizer\UnknownArgument($key, $element->getName());
            }
        }

        return new self($items);
    }

    public function getRawValues() : \stdClass
    {
        $return = new \stdClass();

        foreach ($this as $name => $argumentValue) {
            $return->{$name} = $argumentValue->getValue()->getRawValue();
        }

        return $return;
    }

    public function getValuesForResolver() : array
    {
        $return = [];

        foreach ($this as $name => $argumentValue) {
            $return[$name] = $argumentValue->getValue()->getRawValue(true);
        }

        return $return;
    }

    public function applyVariables(\Graphpinator\Normalizer\VariableValueSet $variables) : void
    {
        foreach ($this as $value) {
            $value->applyVariables($variables);
        }
    }

    public function isSame(self $compare) : bool
    {
        foreach ($compare as $lhs) {
            if ($this->offsetExists($lhs->getArgument()->getName())) {
                if ($lhs->getValue()->isSame($this->offsetGet($lhs->getArgument()->getName())->getValue())) {
                    continue;
                }

                return false;
            }

            if ($lhs->getValue()->isSame($lhs->getArgument()->getDefaultValue())) {
                continue;
            }

            return false;
        }

        foreach ($this as $lhs) {
            if ($compare->offsetExists($lhs->getArgument()->getName())) {
                continue;
            }

            if ($lhs->getValue()->isSame($lhs->getArgument()->getDefaultValue())) {
                continue;
            }

            return false;
        }

        return true;
    }

    protected function getKey(object $object) : string
    {
        \assert($object instanceof ArgumentValue);

        return $object->getArgument()->getName();
    }
}
