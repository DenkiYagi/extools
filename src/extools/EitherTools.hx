package extools;

import haxe.ds.Either;

class EitherTools {
    public static inline function isRight<A, B>(either:Either<A, B>):Bool {
        return switch (either) {
            case Right(_): true;
            case Left(_): false;
        }
    }

    public static inline function isLeft<A, B>(either:Either<A, B>):Bool {
        return switch (either) {
            case Right(_): false;
            case Left(_): true;
        }
    }

    public static inline function swap<A, B>(either:Either<A, B>):Either<B, A> {
        return switch (either) {
            case Right(v): Left(v);
            case Left(v): Right(v);
        }
    }

    public static inline function map<A, B, BB>(either:Either<A, B>, fn:B->BB):Either<A, BB> {
        return switch (either) {
            case Right(v): Right(fn(v));
            case Left(v): Left(v);
        }
    }

    public static inline function flatMap<A, B, BB>(either:Either<A, B>, fn:B->Either<A, BB>):Either<A, BB> {
        return switch (either) {
            case Right(v): fn(v);
            case Left(v): Left(v);
        }
    }

    public static inline function mapLeft<A, B, AA>(either:Either<A, B>, fn:A->AA):Either<AA, B> {
        return switch (either) {
            case Right(v): Right(v);
            case Left(v): Left(fn(v));
        }
    }

    public static inline function flatMapLeft<A, B, AA>(either:Either<A, B>, fn:A->Either<AA, B>):Either<AA, B> {
        return switch (either) {
            case Right(v): Right(v);
            case Left(v): fn(v);
        };
    }

    public static inline function fold<A, B, X>(either:Either<A, B>, fnA:A->X, fnB:B->X):X {
        return switch (either) {
            case Left(v): fnA(v);
            case Right(v): fnB(v);
        }
    }
}
