package extools;

import haxe.ds.Either;
using extools.EitherTools;

class EitherToolsSuite extends BuddySuite {
    public function new() {
        describe("EitherTools.isRight()", {
            it("should be false", {
                Left(1).isRight().should.be(false);
            });

            it("should be true", {
                Right(1).isRight().should.be(true);
            });
        });

        describe("EitherTools.isLeft()", {
            it("should be true", {
                Left(1).isLeft().should.be(true);
            });

            it("should be false", {
                Right(1).isLeft().should.be(false);
            });
        });

        describe("EitherTools.swap()", {
            it("should be Right", {
                Left(1).swap().should.equal(Right(1));
            });

            it("should be Left", {
                Right(1).swap().should.equal(Left(1));
            });
        });

        describe("EitherTools.map()", {
            it("should call fn", {
                Right(1).map(x -> x * 2).should.equal(Right(2));
            });

            it("should not call fn", {
                Left(1).map(x -> {
                    fail();
                    x * 2;
                }).should.equal(Left(1));
            });
        });

        describe("EitherTools.flatMap()", {
            it("should call fn", {
                Right(1).flatMap(x -> Right(x * 2)).should.equal(Right(2));
                Right(1).flatMap(x -> Left(x * 2)).should.equal(Left(2));
            });

            it("should not call fn", {
                Left(1).flatMap(x -> {
                    fail();
                    Right(x * 2);
                }).should.equal(Left(1));
            });
        });

        describe("EitherTools.mapLeft()", {
            it("should call fn", {
                Left(1).mapLeft(x -> x * 2).should.equal(Left(2));
            });

            it("should not call fn", {
                Right(1).mapLeft(x -> {
                    fail();
                    x * 2;
                }).should.equal(Right(1));
            });
        });

        describe("EitherTools.flatMapLeft()", {
            it("should call fn", {
                Left(1).flatMapLeft(x -> Left(x * 2)).should.equal(Left(2));
                Left(1).flatMapLeft(x -> Right(x * 2)).should.equal(Right(2));
            });

            it("should not call fn", {
                Right(1).flatMapLeft(x -> {
                    fail();
                    Left(x * 2);
                }).should.equal(Right(1));
            });
        });

        describe("EitherTools.fold()", {
            it("should pass", {
                Right(1).fold(x -> x + 100, x -> x + 200).should.be(201);
                Left(1).fold(x -> x + 100, x -> x + 200).should.be(101);
            });
        });
    }
}
