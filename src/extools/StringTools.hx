package extools;

class StringTools {
    // It's compatible with .NET's String.isNullOrBlack().
    #if js
    static var BLANK = ~/^[\x09-\x0D\x85\x20\xA0\u1680\u2000-\u200A\u202F\u205F\u3000\u2028\u2029]*$/u;
    #else
    static var BLANK = ~/^[\x09-\x0D\x85\x20\xA0\x{1680}\x{2000}-\x{200A}\x{202F}\x{205F}\x{3000}\x{2028}\x{2029}]*$/u;
    #end

    @:extern public static inline function isBlank(x: Null<String>): Bool {
        return NullTools.isNull(x) || BLANK.match(x);
    }

    @:extern public static inline function nonBlank(x: Null<String>): Bool {
        return !isBlank(x);
    }


	extern public static inline function isEmpty(x:Null<String>):Bool {
		return NullTools.isNull(x) || NullTools.eq(x, "");
	}

	extern public static inline function nonEmpty(x:Null<String>):Bool {
		return NullTools.nonNull(x) && NullTools.neq(x, "");
    }

}