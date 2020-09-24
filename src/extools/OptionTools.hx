package extools;

import extype.NoDataError;
import extype.Error;
import haxe.ds.Option;

class OptionTools {
    public static inline function get<T>(option:Option<T>):Null<T> {
        return switch (option) {
            case Some(v): v;
            case None: null;
        }
    }

    #if !target.static
    public static inline function getUnsafe<T>(option:Option<T>):T {
        return switch (option) {
            case Some(v): v;
            case None: null;
        }
    }
    #end

    public static inline function getOrThrow<T>(option:Option<T>, ?errorFn:() -> Error):T {
        switch (option) {
            case Some(v): return v;
            case None: throw (errorFn == null) ? new NoDataError() : errorFn();
        }
    }

    public static inline function getOrElse<T>(option:Option<T>, x:T):T {
        return switch (option) {
            case Some(v): v;
            case None: x;
        }
    }

    public static inline function orElse<T>(option:Option<T>, x:Option<T>):Option<T> {
        return switch (option) {
            case Some(v): option;
            case None: x;
        }
    }

    public static inline function isEmpty<T>(option:Option<T>):Bool {
        return switch (option) {
            case Some(_): false;
            case None: true;
        }
    }

    public static inline function nonEmpty<T>(option:Option<T>):Bool {
        return switch (option) {
            case Some(_): true;
            case None: false;
        }
    }

    public static inline function iter<T>(option:Option<T>, fn:T->Void):Void {
        switch (option) {
            case Some(x): fn(x);
            case None:
        }
    }

    public static inline function map<T, U>(option:Option<T>, fn:T->U):Option<U> {
        return switch (option) {
            case Some(a): Some(fn(a));
            case None: None;
        }
    }

    public static inline function flatMap<T, U>(option:Option<T>, fn:T->Option<U>):Option<U> {
        return switch (option) {
            case Some(a): fn(a);
            case None: None;
        }
    }

    public static inline function flatten<T>(option:Option<Option<T>>):Option<T> {
        return switch (option) {
            case Some(Some(a)): Some(a);
            case _: None;
        }
    }

    public static inline function exists<T>(option:Option<T>, value:T):Bool {
        return switch (option) {
            case Some(a) if (a == value): true;
            case _: false;
        }
    }

    public static inline function notExists<T>(option:Option<T>, value:T):Bool {
        return switch (option) {
            case Some(a) if (a == value): false;
            case _: true;
        }
    }

    public static inline function find<T>(option:Option<T>, fn:T->Bool):Bool {
        return switch (option) {
            case Some(a) if (fn(a)): true;
            case _: false;
        }
    }

    public static inline function filter<T>(option:Option<T>, fn:T->Bool):Option<T> {
        return switch (option) {
            case Some(a) if (fn(a)): option;
            case _: None;
        }
    }

    public static inline function fold<T, U>(option:Option<T>, ifEmpty:()->U, fn:T->U):U {
        return switch (option) {
            case Some(v): fn(v);
            case None: ifEmpty();
        }
    }
}
