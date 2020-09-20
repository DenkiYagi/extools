package extools;

import haxe.io.Bytes;
import haxe.Constraints.IMap;
import extype.Tuple;
#if js
import js.Syntax;
#end

class EqualsTools {
    public extern static inline function strictEqual<T>(a:T, b:T):Bool {
        #if js
        return Syntax.strictEq(a, b);
        #elseif cpp
        return a == b && Type.typeof(a) == Type.typeof(b);
        #else
        return a == b;
        #end
    }

    public extern static inline function notStrictEqual<T>(a:T, b:T):Bool {
        #if js
        return Syntax.strictNeq(a, b);
        #else
        return !strictEqual(a, b);
        #end
    }

    inline extern static final MAX_DEPTH = 20;

    public static function deepEqual(value1:Dynamic, value2:Dynamic):Bool {
        #if js
        if (strictEqual(value1, value2) || value1 == null && value2 == null) return true;
        #else
        if (strictEqual(value1, value2)) return true;
        #end

        final stack = [new Tuple2(value1, value2)];
        var loop = 0;
        while (stack.length > 0 && loop++ < MAX_DEPTH) {
            final tuple = stack.pop();
            final a = tuple.value1;
            final b = tuple.value2;

            #if js
            if (strictEqual(a, b) || a == null && b == null) continue;
            if (nonJsObject(a) || nonJsObject(b)) return false;
            #else
            if (strictEqual(a, b)) continue;
            if (Std.is(a, String) || Std.is(b, String)) return false;
            #end

            switch (Type.typeof(a)) {
                case TEnum(aEnum):
                    switch (Type.typeof(b)) {
                        case TEnum(bEnum) if (strictEqual(aEnum, bEnum)):
                            if (notStrictEqual(Type.enumIndex(cast a), Type.enumIndex(cast b))) return false;
                            final aParams = Type.enumParameters(cast a);
                            final bParams = Type.enumParameters(cast b);
                            final len = aParams.length;
                            if (notStrictEqual(len, bParams.length)) return false;
                            for (i in 0...len) {
                                stack.push(new Tuple2(aParams[i], bParams[i]));
                            }
                            continue;
                        case _:
                            return false;
                    }
                case TObject:
                    switch (Type.typeof(b)) {
                        case TObject:
                            final aKeys = Reflect.fields(a);
                            final bKeys = Reflect.fields(b);
                            switch ([aKeys.length, bKeys.length]) {
                                case [0, 0]:
                                    continue;
                                case [x, y] if (x == y):
                                    for (key in aKeys) {
                                        if (!Reflect.hasField(b, key)) return false;
                                        stack.push(new Tuple2(Reflect.field(a, key), Reflect.field(b, key)));
                                    }
                                case _:
                                    return false;
                            }
                        case _: return false;
                    }
                case TClass(aCls):
                    switch (Type.typeof(b)) {
                        case TClass(bCls) if (strictEqual(aCls, bCls)):
                            if (Std.is(a, Array)) {
                                final aArray:Array<Dynamic> = cast a;
                                final bArray:Array<Dynamic> = cast b;
                                final len = aArray.length;
                                if (notStrictEqual(len, bArray.length)) return false;
                                for (i in 0...len) {
                                    stack.push(new Tuple2(aArray[i], bArray[i]));
                                }
                                continue;
                            } else if (Std.is(a, Date)) {
                                final aDate:Date = cast a;
                                final bDate:Date = cast b;
                                if (notStrictEqual(aDate.getTime(), bDate.getTime())) return false;
                                continue;
                            } else if (Std.is(a, Bytes)) {
                                final aBytes:Bytes = cast a;
                                final bBytes:Bytes = cast b;
                                if (notStrictEqual(aBytes.length, bBytes.length)) return false;
                                for (i in 0...aBytes.length) {
                                    if (notStrictEqual(aBytes.get(i), bBytes.get(i))) return false;
                                }
                                continue;
                            } else if (Std.is(a, IMap)) {
                                final aMap:IMap<Dynamic, Dynamic> = cast a;
                                final bMap:IMap<Dynamic, Dynamic> = cast b;
                                final keys = [for (k in aMap.keys()) k];
                                if (notStrictEqual(keys.length, [for (k in bMap.keys()) k].length)) return false;
                                for (key in keys) {
                                    stack.push(new Tuple2(aMap.get(key), bMap.get(key)));
                                }
                                continue;
                            } else if (Std.is(a, IntIterator)) {
                                if (Reflect.field(a, "min") != Reflect.field(b, "min") || Reflect.field(a, "max") != Reflect.field(b, "max")) return false;
                                continue;
                            }
                            // TODO custom class comparator
                        case _:
                            return false;
                    }
                case _:
                    return false;
            }
        }

        return (loop <= MAX_DEPTH);
    }

    public extern static inline function notDeepEqual(value1:Dynamic, value2:Dynamic):Bool {
        return !deepEqual(value1, value2);
    }

    #if js
    extern static inline function nonJsObject(x:Dynamic):Bool {
        return Syntax.strictEq(x, null) || Syntax.strictNeq(Syntax.typeof(x), "object");
    }
    #end
}
