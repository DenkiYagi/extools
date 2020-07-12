package extools;

import buddy.BuddySuite;
import haxe.ds.Option;
import extype.Result;
import haxe.io.Bytes;
import haxe.ds.StringMap;

using buddy.Should;
using extools.LangTools;

class LangToolsTest extends BuddySuite {
	public function new() {
		describe("LangTools.some()", {
			it("can compare null", {
				LangTools.same(null, null).should.be(true);
				LangTools.same(null, true).should.be(false);
				LangTools.same(null, 1).should.be(false);
				LangTools.same(null, "hello").should.be(false);
				LangTools.same(null, []).should.be(false);
				LangTools.same(null, {}).should.be(false);
				LangTools.same(null, Some(1)).should.be(false);
				LangTools.same(null, function() {}).should.be(false);
			});
			#if js
			it("can compare undefined", {
				LangTools.same(js.Lib.undefined, js.Lib.undefined).should.be(true);
				LangTools.same(js.Lib.undefined, null).should.be(true);
			});
			#end

			it("can compare Bool", {
				true
				.same(true).should.be(true);
				true
				.same(false).should.be(false);
				true
				.same(null).should.be(false);
				true
				.same(1).should.be(false);
				true
				.same(0.1).should.be(false);
				true
				.same("hello").should.be(false);
				true
				.same([]).should.be(false);
				true
				.same({}).should.be(false);
				true
				.same(Some(1)).should.be(false);
				true
				.same(function() {}).should.be(false);
			});

			it("can compare Int", {
				1.same(1).should.be(true);
				1.same(0).should.be(false);
				1.same(1.0).should.be(true);
				1.same(null).should.be(false);
				1.same(true).should.be(false);
				1.same("hello").should.be(false);
				1.same([]).should.be(false);
				1.same({}).should.be(false);
				1.same(Some(1)).should.be(false);
				1.same(function() {}).should.be(false);
			});

			it("can compare Float", {
				(1.1).same(1.1).should.be(true);
				(1.1).same(0).should.be(false);
				(1.1).same(0.9).should.be(false);
				(1.1).same(null).should.be(false);
				(1.1).same(true).should.be(false);
				(1.1).same("hello").should.be(false);
				(1.1).same([]).should.be(false);
				(1.1).same({}).should.be(false);
				(1.1).same(Some(1.1)).should.be(false);
				(1.1).same(function() {}).should.be(false);
			});

			it("can compare Simple Enum", {
				True.same(True).should.be(true);
				True.same(False).should.be(false);
				True.same(null).should.be(false);
				True.same(true).should.be(false);
				True.same(0).should.be(false);
				True.same(0.1).should.be(false);
				True.same("").should.be(false);
				True.same([]).should.be(false);
				True.same({}).should.be(false);
				True.same(Some(True)).should.be(false);
				True.same(function() {}).should.be(false);
			});
			it("can compare Paramed Enum", {
				Success(1).same(Success(1)).should.be(true);
				Failure("error").same(Failure("error")).should.be(true);
				Some(1).same(Some(1)).should.be(true);
				Some(1).same(Some(2)).should.be(false);
				Some(1).same(null).should.be(false);
				Some(1).same(true).should.be(false);
				Some(1).same(0).should.be(false);
				Some(1).same(0.1).should.be(false);
				Some(1).same("").should.be(false);
				Some(1).same([]).should.be(false);
				Some(1).same({}).should.be(false);
				Some(1).same(None).should.be(false);
				Some(1).same(function() {}).should.be(false);
			});
			it("can compare Nested Enum", {
				Some(Some(1)).same(Some(Some(1))).should.be(true);
				Some(Some(1)).same(Some(Some(0))).should.be(false);
				Some(Some(1)).same(None).should.be(false);
				Some(1).same(Some(Some(1))).should.be(false);
			});

			// object
			it("can compare Simple Object", {
				({}).same({}).should.be(true);
				({}).same({id: 1}).should.be(false);
				{id: 1}.same({id: 1}).should.be(true);
				{id: 1}.same({id: 0}).should.be(false);
				{id: 1, name: "test"}.same({id: 1, name: "test"}).should.be(true);
				{id: 1, name: "hello"}.same({id: 1, name: "world"}).should.be(false);
				Some(1).same(null).should.be(false);
				Some(1).same(true).should.be(false);
				Some(1).same(0).should.be(false);
				Some(1).same(0.1).should.be(false);
				Some(1).same("").should.be(false);
				Some(1).same([]).should.be(false);
				Some(1).same({}).should.be(false);
				Some(1).same(None).should.be(false);
				Some(1).same(function() {}).should.be(false);
			});
			it("can compare Nested Object", {
				{id: 1, sub: {key1: "aaa", key2: "bbb"}}.same({id: 1, sub: {key1: "aaa", key2: "bbb"}}).should.be(true);
				{id: 1, sub: {key1: "aaa", key2: "bbb"}}.same({id: 1, sub: {key1: "aaa", key2: "invalid"}}).should.be(false);
				{id: 1, sub: {key1: "aaa", key2: "bbb"}}.same({id: 1, sub: {key1: "aaa", key2: "bbb", key3: "rest"}}).should.be(false);
			});
			it("can compare Iterable Object", {
				{id: 1, iterator: function() return 0...5}.same({id: 1, iterator: function() return 0...5}).should.be(true);
				{id: 1, iterator: function() return 0...5}.same({id: 1, iterator: function() return 0...0}).should.be(false);
				{id: 1, iterator: function() return 0...5}.same({id: 1, iterator: function() return null}).should.be(false);
			});
			it("can compare Iterator Object", {
				{id: 2, hasNext: function() return false, next: function() {}}.same({id: 2, hasNext: function() return false, next: function() {}})
					.should.be(true);

				var a = 0;
				var b = 0;
				{id: 2, hasNext: function() return a < 5, next: function() return a++}.same({id: 2, hasNext: function() return b < 5, next: function() return
					b++})
					.should.be(true);

				var x = 0;
				var y = 0;
				{id: 2, hasNext: function() return x < 5, next: function() return x++}.same({id: 2, hasNext: function() return y < 1, next: function() return
					y++})
					.should.be(false);

				{id: 2, hasNext: function() return false, next: function() {}}.same({id: 2}).should.be(false);
			});

			it("can compare String", {
				"".same("").should.be(true);
				"hello".same("hello").should.be(true);
				"hello".same("").should.be(false);
				"".same(null).should.be(false);
				"".same(true).should.be(false);
				"".same(0).should.be(false);
				"".same(0.1).should.be(false);
				"".same([]).should.be(false);
				"".same({}).should.be(false);
				"".same(Some("")).should.be(false);
				"".same(function() {}).should.be(false);
			});

			it("can compare Date", {
				new Date(2000, 1, 1, 0, 0, 0).same(new Date(2000, 1, 1, 0, 0, 0)).should.be(true);
				new Date(2000, 1, 1, 0, 0, 0).same(new Date(2000, 1, 1, 0, 0, 1)).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(null).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(true).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(0).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(0.1).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same("").should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same([]).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same({}).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(Some("")).should.be(false);
				new Date(2000, 1, 1, 0, 0, 0).same(function() {}).should.be(false);
			});

			it("can compare Bytes", {
				Bytes.alloc(0).same(Bytes.alloc(0)).should.be(true);
				Bytes.alloc(1).same(Bytes.alloc(0)).should.be(false);
				Bytes.ofString("haxe").same(Bytes.ofString("haxe")).should.be(true);
				Bytes.ofString("hello").same(Bytes.ofString("world")).should.be(false);
				Bytes.alloc(0).same(null).should.be(false);
				Bytes.alloc(0).same(true).should.be(false);
				Bytes.alloc(0).same(0).should.be(false);
				Bytes.alloc(0).same(0.1).should.be(false);
				Bytes.alloc(0).same("").should.be(false);
				Bytes.alloc(0).same([]).should.be(false);
				Bytes.alloc(0).same({}).should.be(false);
				Bytes.alloc(0).same(Some("")).should.be(false);
				Bytes.alloc(0).same(function() {}).should.be(false);
			});

			it("can compare Simple Map", {
				new StringMap().same(new StringMap()).should.be(true);
				["1" => "v1"]
				.same(["1" => "v1"]).should.be(true);
				["1" => "v1"]
				.same(["1" => "invalid"]).should.be(false);
				["1" => "v1"]
				.same(new StringMap()).should.be(false);
				[1 => "v1"]
				.same(["1" => "v1"]).should.be(false);
				["1" => "v1"]
				.same([1 => "v1"]).should.be(false);
				new StringMap().same(null).should.be(false);
				new StringMap().same(true).should.be(false);
				new StringMap().same(0).should.be(false);
				new StringMap().same(0.1).should.be(false);
				new StringMap().same("").should.be(false);
				new StringMap().same([]).should.be(false);
				new StringMap().same({}).should.be(false);
				new StringMap().same(Some("")).should.be(false);
				new StringMap().same(function() {}).should.be(false);
			});
			it("can compare Nested Map", {
				["1" => [11 => "v1", 12 => "v2"]]
				.same(["1" => [11 => "v1", 12 => "v2"]]).should.be(true);
				["1" => [11 => "v1", 12 => "v2"]]
				.same(["1" => [11 => "v1", 12 => "invalid"]]).should.be(false);
				["1" => [11 => "v1", 12 => "v2"]]
				.same(["1" => new StringMap()]).should.be(false);
				["1" => [11 => "v1", 12 => "v2"]]
				.same(["1" => ["11" => "v1", "12" => "v2"]]).should.be(false);
			});

			it("can compare IntIterator", {
				(0...0).same(0...0).should.be(true);
				(0...0).same(0...5).should.be(false);
				(0...5).same(0...5).should.be(true);
			});

			it("can compare Valid IterableClass", {
				new ValidIterable(0, "name", 0, 0).same(new ValidIterable(0, "name", 0, 0)).should.be(true);
				new ValidIterable(0, "name", 0, 5).same(new ValidIterable(0, "name", 0, 5)).should.be(true);

				new ValidIterable(0, "name", 0, 5).same(new ValidIterable(0, "name", 0, 0)).should.be(false);
				new ValidIterable(0, "name", 0, 5).same(new ValidIterable(0, "name", 0, 4)).should.be(false);
				new ValidIterable(1, "name", 0, 5).same(new ValidIterable(0, "name", 0, 5)).should.be(false);
				new ValidIterable(0, "hello", 0, 5).same(new ValidIterable(0, "name", 0, 5)).should.be(false);
			});
			it("can compare Invalid IterableClass", {
				new InvalidIterable(0, "name", 0, 0).same(new InvalidIterable(0, "name", 0, 0)).should.be(true);
				new ValidIterable(0, "name", 0, 0).same(new InvalidIterable(0, "name", 0, 0)).should.be(false);
			});

			it("can compare Valid IteratorClass", {
				new ValidIterator(0, "name", 0, 0).same(new ValidIterator(0, "name", 0, 0)).should.be(true);
				new ValidIterator(0, "name", 0, 5).same(new ValidIterator(0, "name", 0, 5)).should.be(true);

				new ValidIterator(0, "name", 0, 5).same(new ValidIterator(0, "name", 0, 0)).should.be(false);
				new ValidIterator(0, "name", 0, 5).same(new ValidIterator(0, "name", 0, 4)).should.be(false);
				new ValidIterator(1, "name", 0, 5).same(new ValidIterator(0, "name", 0, 5)).should.be(false);
				new ValidIterator(0, "hello", 0, 5).same(new ValidIterator(0, "name", 0, 5)).should.be(false);
			});

			it("can compare Empty Array", {
				[]
				.same([]).should.be(true);
				[]
				.same([1]).should.be(false);
				[]
				.same(null).should.be(false);
				[]
				.same(true).should.be(false);
				[]
				.same(0).should.be(false);
				[]
				.same(0.1).should.be(false);
				[]
				.same("").should.be(false);
				[]
				.same({}).should.be(false);
				[]
				.same(Some(True)).should.be(false);
				[]
				.same(function() {}).should.be(false);
			});
			it("can compare Simple Array", {
				[1]
				.same([1]).should.be(true);
				[1]
				.same([0]).should.be(false);
				[1]
				.same([1, 2]).should.be(false);
				[1]
				.same([null]).should.be(false);
				["a"]
				.same(["a"]).should.be(true);
				["a"]
				.same(["b"]).should.be(false);
			});
			it("can compare Nested Array", {
				[[]]
				.same([[]]).should.be(true);
				[[]]
				.same([1]).should.be(false);
				[[], []]
				.same([[], []]).should.be(true);
				([[1, 2, 3], ["a", "b"]] : Array<Dynamic>).same([[1, 2, 3], ["a", "b"]]).should.be(true);
				([[1, 2, 3], ["a", "b"]] : Array<Dynamic>).same([[1, 2, 3], ["a"]]).should.be(false);
				[[[]]]
				.same([[[]]]).should.be(true);
			});

			it("can compare mixed object", {
				{
					id: 1,
					msg: "hello",
					sub: {
						iters: [new ValidIterator(2, "iter", 0, 5)],
						enums: ([Some(1), None, Some(new ValidIterator(3, "enum", 2, 3))] : Array<Dynamic>),
						array: [1, 2, 3]
					},
					nullValue: null
				}.same({
						id: 1,
						msg: "hello",
						sub: {
							iters: [new ValidIterator(2, "iter", 0, 5)],
							enums: ([Some(1), None, Some(new ValidIterator(3, "enum", 2, 3))] : Array<Dynamic>),
							array: [1, 2, 3]
						},
						nullValue: null
					}).should.be(true);
			});
		});

		describe("LangTools.notSome()", {
			it("should pass", {
				1.notSame(2).should.be(true);
				1.notSame(1).should.be(false);
				"1".notSame("1").should.be(false);
				({}).notSame({}).should.be(false);
			});
		});

		describe("LangTools.combine()", {
			it("can combine null", {
				({}).combine().same({}).should.be(true);
				{name: "test"}.combine().same({name: "test"}).should.be(true);
			});
			it("can combine empty object", {
				({}).combine({}).same({}).should.be(true);
				({}).combine({}, {}).same({}).should.be(true);
				{name: "test"}.combine({}).same({name: "test"}).should.be(true);
				{name: "test"}.combine({}, {}).same({name: "test"}).should.be(true);
			});
			it("can combine some objects", {
				{id: 1}.combine({name: "test"}).same({id: 1, name: "test"}).should.be(true);
				{id: 1}.combine({name: "test", age: 20}).same({id: 1, name: "test", age: 20}).should.be(true);
				{id: 1}.combine({name: "test", age: 20}, {key: "value"}).same({
					id: 1,
					name: "test",
					age: 20,
					key: "value"
				}).should.be(true);
			});
			it("can combine same name field", {
				{name: "test"}.combine({name: "hello"}).same({name: "hello"}).should.be(true);
			});
			it("can combine nested object", {
				LangTools.combine({
					id: 1,
					sub: {
						key1: "v1",
						key2: "v2",
						key3: "v3"
					}
				}, {
					sub: {
						key2: "v2 override",
						key3: {
							values: [1, 2, 3]
						},
						key4: "v4"
					}
				}).same({
					id: 1,
					sub: {
						key1: "v1",
						key2: "v2 override",
						key3: {
							values: [1, 2, 3],
						},
						key4: "v4"
					}
				}).should.be(true);
			});
		});

		describe("LangTools.callIfNotNull()", {
			describe("Void -> Void", {
				it("should pass", {
					var fn:Void->Void = null;
					fn.callIfNotNull();
				});

				it("should pass", function(done) {
					var fn = function() {
						done();
					};
					fn.callIfNotNull();
				});
			});

			describe("return value", {
				it("should pass", {
					var fn:Void->Int = null;
					var ret = fn.callIfNotNull();
					ret.should.be(null);
				});

				it("should pass", {
					var fn:Void->Int = function() return 1;
					var ret = fn.callIfNotNull();
					ret.should.be(1);
				});
			});

			describe("multiple arguments", {
				it("should pass", {
					var fn:Int->Int->Int = null;
					var ret = fn.callIfNotNull(1, 2);
					ret.should.be(null);
				});

				it("should pass", {
					var fn:Int->Int->Int = function(a, b) return a + b;
					var ret = fn.callIfNotNull(1, 2);
					ret.should.be(3);
				});
			});
		});
	}
}

enum Boolean {
	True;
	False;
}

class ValidIterable {
	public var id:Int;
	public var name:String;

	var start:Int;
	var end:Int;

	public function new(id:Int, name:String, start:Int, end:Int) {
		this.id = id;
		this.name = name;
		this.start = start;
		this.end = end;
	}

	public function iterator():Iterator<Int> {
		return start...end;
	}
}

class InvalidIterable {
	public var id:Int;
	public var name:String;

	var start:Int;
	var end:Int;

	public function new(id:Int, name:String, start:Int, end:Int) {
		this.id = id;
		this.name = name;
		this.start = start;
		this.end = end;
	}

	public function iterator():Void {}
}

class ValidIterator {
	public var id:Int;
	public var name:String;

	var start:Int;
	var end:Int;
	var offset:Int;

	public function new(id:Int, name:String, start:Int, end:Int) {
		this.id = id;
		this.name = name;
		this.start = start;
		this.end = end;
		this.offset = start;
	}

	public function hasNext():Bool {
		return offset < end;
	}

	public function next():Int {
		return if (hasNext()) offset++ else throw "no data";
	}
}
