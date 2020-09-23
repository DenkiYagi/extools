package extools;

import buddy.BuddySuite;
import haxe.ds.Option;
import extype.Result;
import haxe.io.Bytes;
import haxe.ds.StringMap;

using buddy.Should;
using extools.EqualsTools;

class EqualsToolsSuite extends BuddySuite {
    public function new() {
        describe("EqualsTools.strictEqual()", {
            it("should pass", {
                EqualsTools.strictEqual(1, 1).should.be(true);
                EqualsTools.strictEqual(1, 2).should.be(false);
                EqualsTools.strictEqual(null, null).should.be(true);
                EqualsTools.strictEqual(1, cast true).should.be(false);
                EqualsTools.strictEqual(0, cast false).should.be(false);
                #if js
                EqualsTools.strictEqual(null, js.Lib.undefined).should.be(false);
                #end
            });
        });

        describe("EqualsTools.notStrictEqual()", {
            it("should pass", {
                EqualsTools.notStrictEqual(1, 1).should.be(false);
                EqualsTools.notStrictEqual(1, 2).should.be(true);
                EqualsTools.notStrictEqual(null, null).should.be(false);
                EqualsTools.notStrictEqual(1, cast true).should.be(true);
                EqualsTools.notStrictEqual(0, cast false).should.be(true);
                #if js
                EqualsTools.notStrictEqual(null, js.Lib.undefined).should.be(true);
                #end
            });
        });

        describe("EqualsTools.deepEqual()", {
            it("can compare null", {
                EqualsTools.deepEqual(null, null).should.be(true);
                EqualsTools.deepEqual(null, true).should.be(false);
                EqualsTools.deepEqual(null, 1).should.be(false);
                EqualsTools.deepEqual(null, "hello").should.be(false);
                EqualsTools.deepEqual(null, []).should.be(false);
                EqualsTools.deepEqual(null, {}).should.be(false);
                EqualsTools.deepEqual(null, Some(1)).should.be(false);
                EqualsTools.deepEqual(null, function() {}).should.be(false);
            });
            #if js
            it("can compare undefined", {
                EqualsTools.deepEqual(js.Lib.undefined, js.Lib.undefined).should.be(true);
                EqualsTools.deepEqual(js.Lib.undefined, null).should.be(true);
            });
            #end

            it("can compare Bool", {
                true.deepEqual(true).should.be(true);
                true.deepEqual(false).should.be(false);
                true.deepEqual(null).should.be(false);
                true.deepEqual(1).should.be(false);
                true.deepEqual(0.1).should.be(false);
                true.deepEqual("hello").should.be(false);
                true.deepEqual([]).should.be(false);
                true.deepEqual({}).should.be(false);
                true.deepEqual(Some(1)).should.be(false);
                true.deepEqual(function() {}).should.be(false);
            });

            it("can compare Int", {
                1.deepEqual(1).should.be(true);
                1.deepEqual(0).should.be(false);
                1.deepEqual(1.0).should.be(true);
                1.deepEqual(null).should.be(false);
                1.deepEqual(true).should.be(false);
                1.deepEqual("hello").should.be(false);
                1.deepEqual([]).should.be(false);
                1.deepEqual({}).should.be(false);
                1.deepEqual(Some(1)).should.be(false);
                1.deepEqual(function() {}).should.be(false);
            });

            it("can compare Float", {
                (1.1).deepEqual(1.1).should.be(true);
                (1.1).deepEqual(0).should.be(false);
                (1.1).deepEqual(0.9).should.be(false);
                (1.1).deepEqual(null).should.be(false);
                (1.1).deepEqual(true).should.be(false);
                (1.1).deepEqual("hello").should.be(false);
                (1.1).deepEqual([]).should.be(false);
                (1.1).deepEqual({}).should.be(false);
                (1.1).deepEqual(Some(1.1)).should.be(false);
                (1.1).deepEqual(function() {}).should.be(false);
            });

            it("can compare Simple Enum", {
                True.deepEqual(True).should.be(true);
                True.deepEqual(False).should.be(false);
                True.deepEqual(null).should.be(false);
                True.deepEqual(true).should.be(false);
                True.deepEqual(0).should.be(false);
                True.deepEqual(0.1).should.be(false);
                True.deepEqual("").should.be(false);
                True.deepEqual([]).should.be(false);
                True.deepEqual({}).should.be(false);
                True.deepEqual(Some(True)).should.be(false);
                True.deepEqual(function() {}).should.be(false);
            });
            it("can compare Paramed Enum", {
                Success(1).deepEqual(Success(1)).should.be(true);
                Failure("error").deepEqual(Failure("error")).should.be(true);
                Some(1).deepEqual(Some(1)).should.be(true);
                Some(1).deepEqual(Some(2)).should.be(false);
                Some(1).deepEqual(null).should.be(false);
                Some(1).deepEqual(true).should.be(false);
                Some(1).deepEqual(0).should.be(false);
                Some(1).deepEqual(0.1).should.be(false);
                Some(1).deepEqual("").should.be(false);
                Some(1).deepEqual([]).should.be(false);
                Some(1).deepEqual({}).should.be(false);
                Some(1).deepEqual(None).should.be(false);
                Some(1).deepEqual(function() {}).should.be(false);
            });
            it("can compare Nested Enum", {
                Some(Some(1)).deepEqual(Some(Some(1))).should.be(true);
                Some(Some(1)).deepEqual(Some(Some(0))).should.be(false);
                Some(Some(1)).deepEqual(None).should.be(false);
                Some(1).deepEqual(Some(Some(1))).should.be(false);
            });

            // object
            it("can compare Simple Object", {
                ({}).deepEqual({}).should.be(true);
                ({}).deepEqual({id: 1}).should.be(false);
                {id: 1}.deepEqual({id: 1}).should.be(true);
                {id: 1}.deepEqual({id: 0}).should.be(false);
                {id: 1, name: "test"}.deepEqual({id: 1, name: "test"}).should.be(true);
                {id: 1, name: "hello"}.deepEqual({id: 1, name: "world"}).should.be(false);
                Some(1).deepEqual(null).should.be(false);
                Some(1).deepEqual(true).should.be(false);
                Some(1).deepEqual(0).should.be(false);
                Some(1).deepEqual(0.1).should.be(false);
                Some(1).deepEqual("").should.be(false);
                Some(1).deepEqual([]).should.be(false);
                Some(1).deepEqual({}).should.be(false);
                Some(1).deepEqual(None).should.be(false);
                Some(1).deepEqual(function() {}).should.be(false);
            });
            it("can compare Nested Object", {
                {id: 1, sub: {key1: "aaa", key2: "bbb"}}.deepEqual({id: 1, sub: {key1: "aaa", key2: "bbb"}}).should.be(true);
                {id: 1, sub: {key1: "aaa", key2: "bbb"}}.deepEqual({id: 1, sub: {key1: "aaa", key2: "invalid"}}).should.be(false);
                {id: 1, sub: {key1: "aaa", key2: "bbb"}}.deepEqual({id: 1, sub: {key1: "aaa", key2: "bbb", key3: "rest"}}).should.be(false);
            });

            it("can compare String", {
                "".deepEqual("").should.be(true);
                "hello".deepEqual("hello").should.be(true);
                "hello".deepEqual("").should.be(false);
                "".deepEqual(null).should.be(false);
                "".deepEqual(true).should.be(false);
                "".deepEqual(0).should.be(false);
                "".deepEqual(0.1).should.be(false);
                "".deepEqual([]).should.be(false);
                "".deepEqual({}).should.be(false);
                "".deepEqual(Some("")).should.be(false);
                "".deepEqual(function() {}).should.be(false);
            });

            it("can compare Date", {
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(new Date(2000, 1, 1, 0, 0, 0)).should.be(true);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(new Date(2000, 1, 1, 0, 0, 1)).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(null).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(true).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(0).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(0.1).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual("").should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual([]).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual({}).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(Some("")).should.be(false);
                new Date(2000, 1, 1, 0, 0, 0).deepEqual(function() {}).should.be(false);
            });

            it("can compare Bytes", {
                Bytes.alloc(0).deepEqual(Bytes.alloc(0)).should.be(true);
                Bytes.alloc(1).deepEqual(Bytes.alloc(0)).should.be(false);
                Bytes.ofString("haxe").deepEqual(Bytes.ofString("haxe")).should.be(true);
                Bytes.ofString("hello").deepEqual(Bytes.ofString("world")).should.be(false);
                Bytes.alloc(0).deepEqual(null).should.be(false);
                Bytes.alloc(0).deepEqual(true).should.be(false);
                Bytes.alloc(0).deepEqual(0).should.be(false);
                Bytes.alloc(0).deepEqual(0.1).should.be(false);
                Bytes.alloc(0).deepEqual("").should.be(false);
                Bytes.alloc(0).deepEqual([]).should.be(false);
                Bytes.alloc(0).deepEqual({}).should.be(false);
                Bytes.alloc(0).deepEqual(Some("")).should.be(false);
                Bytes.alloc(0).deepEqual(function() {}).should.be(false);
            });

            it("can compare Simple Map", {
                new StringMap().deepEqual(new StringMap()).should.be(true);
                ["1" => "v1"]
                .deepEqual(["1" => "v1"]).should.be(true);
                ["1" => "v1"]
                .deepEqual(["1" => "invalid"]).should.be(false);
                ["1" => "v1"]
                .deepEqual(new StringMap()).should.be(false);
                [1 => "v1"]
                .deepEqual(["1" => "v1"]).should.be(false);
                ["1" => "v1"]
                .deepEqual([1 => "v1"]).should.be(false);
                new StringMap().deepEqual(null).should.be(false);
                new StringMap().deepEqual(true).should.be(false);
                new StringMap().deepEqual(0).should.be(false);
                new StringMap().deepEqual(0.1).should.be(false);
                new StringMap().deepEqual("").should.be(false);
                new StringMap().deepEqual([]).should.be(false);
                new StringMap().deepEqual({}).should.be(false);
                new StringMap().deepEqual(Some("")).should.be(false);
                new StringMap().deepEqual(function() {}).should.be(false);
            });
            it("can compare Nested Map", {
                ["1" => [11 => "v1", 12 => "v2"]]
                .deepEqual(["1" => [11 => "v1", 12 => "v2"]]).should.be(true);
                ["1" => [11 => "v1", 12 => "v2"]]
                .deepEqual(["1" => [11 => "v1", 12 => "invalid"]]).should.be(false);
                ["1" => [11 => "v1", 12 => "v2"]]
                .deepEqual(["1" => new StringMap()]).should.be(false);
                ["1" => [11 => "v1", 12 => "v2"]]
                .deepEqual(["1" => ["11" => "v1", "12" => "v2"]]).should.be(false);
            });

            it("can compare IntIterator", {
                (0...0).deepEqual(0...0).should.be(true);
                (0...0).deepEqual(0...5).should.be(false);
                (0...5).deepEqual(0...5).should.be(true);
            });

            it("can compare Empty Array", {
                []
                .deepEqual([]).should.be(true);
                []
                .deepEqual([1]).should.be(false);
                []
                .deepEqual(null).should.be(false);
                []
                .deepEqual(true).should.be(false);
                []
                .deepEqual(0).should.be(false);
                []
                .deepEqual(0.1).should.be(false);
                []
                .deepEqual("").should.be(false);
                []
                .deepEqual({}).should.be(false);
                []
                .deepEqual(Some(True)).should.be(false);
                []
                .deepEqual(function() {}).should.be(false);
            });
            it("can compare Simple Array", {
                [1]
                .deepEqual([1]).should.be(true);
                [1]
                .deepEqual([0]).should.be(false);
                [1]
                .deepEqual([1, 2]).should.be(false);
                [1]
                .deepEqual([null]).should.be(false);
                ["a"]
                .deepEqual(["a"]).should.be(true);
                ["a"]
                .deepEqual(["b"]).should.be(false);
            });
            it("can compare Nested Array", {
                [[]]
                .deepEqual([[]]).should.be(true);
                [[]]
                .deepEqual([1]).should.be(false);
                [[], []]
                .deepEqual([[], []]).should.be(true);
                ([[1, 2, 3], ["a", "b"]] : Array<Dynamic>).deepEqual([[1, 2, 3], ["a", "b"]]).should.be(true);
                ([[1, 2, 3], ["a", "b"]] : Array<Dynamic>).deepEqual([[1, 2, 3], ["a"]]).should.be(false);
                [[[]]]
                .deepEqual([[[]]]).should.be(true);
            });

            it("can compare mixed object", {
                {
                    id: 1,
                    msg: "hello",
                    sub: {
                        enums: ([Some(cast 1), None, Some(cast {name: "taro", age: 15, flags: [Boolean.True, Boolean.False]})]),
                        array: [1, 2, 3]
                    },
                    nullValue: null
                }.deepEqual({
                    id: 1,
                    msg: "hello",
                    sub: {
                        enums: ([Some(cast 1), None, Some(cast {name: "taro", age: 15, flags: [Boolean.True, Boolean.False]})]),
                        array: [1, 2, 3]
                    },
                    nullValue: null
                }).should.be(true);
            });
        });

        describe("EqualsTools.notDeepEqual()", {
            it("should pass", {
                1.notDeepEqual(2).should.be(true);
                1.notDeepEqual(1).should.be(false);
                "1".notDeepEqual("1").should.be(false);
                ({}).notDeepEqual({}).should.be(false);
            });
        });
    }
}

enum Boolean {
    True;
    False;
}

