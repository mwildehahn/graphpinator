<?php

declare(strict_types=1);

namespace Graphpinator\Tests\Spec;

final class SimpleTest extends \PHPUnit\Framework\TestCase
{
    public function simpleDataProvider() : array
    {
        return [
            [
                'query queryName { field0 { field1 { name } } }',
                \Infinityloop\Utils\Json::fromArray([]),
                \Infinityloop\Utils\Json::fromArray(['data' => ['field0' => ['field1' => ['name' => 'Test 123']]]]),
            ],
            [
                'query queryName { aliasName: field0 { field1 { name } } }',
                \Infinityloop\Utils\Json::fromArray([]),
                \Infinityloop\Utils\Json::fromArray(['data' => ['aliasName' => ['field1' => ['name' => 'Test 123']]]]),
            ],
        ];
    }

    /**
     * @dataProvider simpleDataProvider
     */
    public function testSimple(string $request, \Infinityloop\Utils\Json $variables, \Infinityloop\Utils\Json $expected) : void
    {
        $graphpinator = new \Graphpinator\Graphpinator(TestSchema::getSchema());
        $result = $graphpinator->runQuery($request, $variables);

        self::assertSame($expected->toString(), \json_encode($result, JSON_THROW_ON_ERROR, 512),);
        self::assertSame($expected['data'], \json_decode(\json_encode($result->getData()), true));
        self::assertNull($result->getErrors());
    }

    public function invalidDataProvider() : array
    {
        return [
            [
                'query queryName { field0 { field1 } }',
                \Infinityloop\Utils\Json::fromArray([]),
            ],
            [
                'query queryName { field0 { field1 { nonExisting } } }',
                \Infinityloop\Utils\Json::fromArray([]),
            ],
            [
                'query queryName { field0 { field1 { name { nonExisting } } } }',
                \Infinityloop\Utils\Json::fromArray([]),
            ],
        ];
    }

    /**
     * @dataProvider invalidDataProvider
     */
    public function testInvalid(string $request, \Infinityloop\Utils\Json $variables) : void
    {
        $this->expectException(\Exception::class);

        $graphpinator = new \Graphpinator\Graphpinator(TestSchema::getSchema());
        $graphpinator->runQuery($request, $variables);
    }
}
