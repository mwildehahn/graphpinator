<?php

declare(strict_types = 1);

namespace Graphpinator\Type\Scalar;

abstract class ScalarType extends \Graphpinator\Type\Contract\LeafDefinition implements
    \Graphpinator\Typesystem\Entity
{
    final public function getTypeKind() : string
    {
        return \Graphpinator\Type\Introspection\TypeKind::SCALAR;
    }

    final public function accept(\Graphpinator\Typesystem\EntityVisitor $visitor) : mixed
    {
        return $visitor->visitScalar($this);
    }
}
