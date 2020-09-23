package extools;

import haxe.ds.Option;

class OptionTools {
    public static inline function isEmpty<A>(option:Option<A>):Bool {
        return switch (option) {
            case Some(_): false;
            case None: true;
        }
    }

    public static inline function nonEmpty<A>(option:Option<A>):Bool {
        return switch (option) {
            case Some(_): true;
            case None: false;
        }
    }

    public static inline function iter<A>(option:Option<A>, fn:A->Void):Void {
        switch (option) {
            case Some(x):
                fn(x);
            case None:
        }
    }

    public static inline function map<A, B>(option:Option<A>, fn:A->B):Option<B> {
        return switch (option) {
            case Some(a): Some(fn(a));
            case None: None;
        }
    }

    public static inline function flatMap<A, B>(option:Option<A>, fn:A->Option<B>):Option<B> {
        return switch (option) {
            case Some(a): fn(a);
            case None: None;
        }
    }

    public static inline function flatten<A>(option:Option<Option<A>>):Option<A> {
        return switch (option) {
            case Some(Some(a)): Some(a);
            case _: None;
        }
    }

    public static inline function exists<A>(option:Option<A>, value:A):Bool {
        return switch (option) {
            case Some(a) if (a == value): true;
            case _: false;
        }
    }

    public static inline function notExists<A>(option:Option<A>, value:A):Bool {
        return switch (option) {
            case Some(a) if (a == value): false;
            case _: true;
        }
    }

    public static inline function find<A>(option:Option<A>, fn:A->Bool):Bool {
        return switch (option) {
            case Some(a) if (fn(a)): true;
            case _: false;
        }
    }

    public static inline function fold<A, B>(option:Option<A>, ifEmpty:()->B, fn:A->B):B {
        return switch (option) {
            case Some(v): fn(v);
            case None: ifEmpty();
        }
    }
}
