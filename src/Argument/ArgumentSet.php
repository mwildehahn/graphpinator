<?php

declare(strict_types = 1);

namespace Graphpinator\Argument;

final class ArgumentSet extends \Infinityloop\Utils\ObjectSet
{
    protected const INNER_CLASS = Argument::class;

    private array $defaults = [];

    public function getDefaults() : array
    {
        return $this->defaults;
    }

    public function current() : Argument
    {
        return parent::current();
    }

    public function offsetGet($offset) : Argument
    {
        return parent::offsetGet($offset);
    }

    protected function getKey($object)
    {
        $defaultValue = $object->getDefaultValue();

        if ($defaultValue instanceof \Graphpinator\Value\ValidatedValue) {
            $this->defaults[$object->getName()] = $defaultValue;
        }

        return $object->getName();
    }
}
