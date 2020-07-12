package extools;

import extype.Maybe;
import haxe.ds.Option;
#if js
import js.Syntax;
#end

class NullTools {
	extern public static inline function eq<T>(a:Null<T>, b:Null<T>):Bool {
		#if js
		return Syntax.strictEq(a, b);
		#else
		return a == b;
		#end
	}

	extern public static inline function neq<T>(a:Null<T>, b:Null<T>):Bool {
		#if js
		return Syntax.strictNeq(a, b);
		#else
		return a != b;
		#end
	}

	extern public static inline function isNull<T>(a:Null<T>):Bool {
		return a == null;
	}

	extern public static inline function nonNull<T>(a:Null<T>):Bool {
		return a != null;
	}

	#if js
	extern public static inline function isUndefined<T>(a:Null<T>):Bool {
		return Syntax.strictEq(a, js.Lib.undefined);
	}
	#end

	extern public static inline function getOrElse<T>(a:Null<T>, b:T):T {
		return nonNull(a) ? a : b;
	}

	extern public static inline function toMaybe<T>(a:Null<T>):Maybe<T> {
		return (a : Maybe<T>);
	}

	extern public static inline function toOptions<T>(a:Null<T>):Option<T> {
		return if (a != null) {
			Some(a);
		} else {
			None;
		}
	}
}
