package extools;

import haxe.Exception;
import haxe.ds.Option;

using extools.OptionTools;

class OptionToolsSuite extends BuddySuite {
    public function new() {
        timeoutMs = 50;

        describe("OptionTools.toMaybe()", {
            it("should return value", {
                final x = Some(1).toMaybe();
                x.nonEmpty().should.be(true);
                x.getOrThrow().should.be(1);
            });
            it("should return empty", {
                final x = None.toMaybe();
                x.isEmpty().should.be(true);
            });
        });

        describe("OptionTools.get()", {
            it("should return value", {
                Some(1).get().should.be(1);
            });
            it("should return null", {
                final x:Null<Any> = None.get();
                x.should.be(null);
            });
        });

        #if !target.static
        describe("OptionTools.getUnsafe()", {
            it("should return value", {
                Some(1).getUnsafe().should.be(1);
            });
            it("should return null", {
                final x:Null<Any> = None.getUnsafe();
                x.should.be(null);
            });
        });
        #end

        describe("OptionTools.getOrThrow()", {
            it("should be success", {
                Some(1).getOrThrow().should.be(1);
                Some(2).getOrThrow(() -> new MyError()).should.be(2);
            });
            it("should be failure", {
                try {
                    None.getOrThrow();
                    fail();
                } catch (e) {
                }

                try {
                    None.getOrThrow(() -> new MyError());
                    fail();
                } catch (e) {
                }
            });
        });

        describe("OptionTools.getOrElse()", {
            it("should return value", {
                Some(1).getOrElse(-5).should.be(1);
            });
            it("should return alt value", {
                None.getOrElse(-5).should.be(-5);
            });
        });

        describe("OptionTools.orElse()", {
            it("should return value", {
                Some(1).orElse(Some(-5)).should.equal(Some(1));
            });
            it("should return alt value", {
                None.orElse(Some(-5)).should.equal(Some(-5));
            });
        });

        describe("OptionTools.isEmpty()", {
            it("should be false", {
                Some(1).isEmpty().should.be(false);
            });

            it("should be true", {
                None.isEmpty().should.be(true);
            });
        });

        describe("OptionTools.nonEmpty()", {
            it("should be true", {
                Some(1).nonEmpty().should.be(true);
            });

            it("should be false", {
                None.nonEmpty().should.be(false);
            });
        });

        describe("OptionTools.iter()", {
            it("should call fn", done -> {
                Some(1).iter(x -> {
                    x.should.be(1);
                    done();
                });
            });

            it("should not call fn", {
                None.iter(x -> {
                    fail();
                });
            });
        });

        describe("OptionTools.map()", {
            it("should call fn", {
                Some(1).map(x -> x * 2).should.equal(Some(2));
            });

            it("should not call fn", {
                None.map(x -> {
                    fail();
                    x * 2;
                }).should.equal(None);
            });
        });

        describe("OptionTools.flatMap()", {
            it("should call fn", {
                Some(1).flatMap(x -> Some(x * 2)).should.equal(Some(2));

                Some(1).flatMap(x -> None).should.equal(None);
            });

            it("should not call fn", {
                var ret = None.map(x -> {
                    fail();
                    x * 2;
                });
                ret.should.equal(None);
            });
        });

        describe("OptionTools.flatten()", {
            it("should flatten", {
                Some(Some(1)).flatten().should.equal(Some(1));
            });

            it("should be None", {
                Some(None).flatten().should.equal(None);
                None.flatten().should.equal(None);
            });
        });

        describe("OptionTools.exists()", {
            it("should be true", {
                Some(1).exists(1).should.be(true);
            });

            it("should be false", {
                Some(1).exists(0).should.be(false);
                None.exists(1).should.be(false);
            });
        });

        describe("OptionTools.notExists()", {
            it("should be false", {
                Some(1).notExists(1).should.be(false);
            });

            it("should be true", {
                Some(1).notExists(0).should.be(true);
                None.notExists(1).should.be(true);
            });
        });

        describe("OptionTools.find()", {
            it("should be true", {
                Some(1).find(x -> x == 1).should.be(true);
            });

            it("should be false", {
                Some(1).find(x -> false).should.be(false);
                None.find(x -> true).should.be(false);
                None.find(x -> false).should.be(false);
            });
        });

        describe("OptionTools.filter()", {
            it("should be Some", {
                Some(1).filter(x -> true).should.equal(Some(1));
            });

            it("should be None", {
                Some(1).filter(x -> false).should.equal(None);
                None.filter(x -> true).should.equal(None);
                None.filter(x -> false).should.equal(None);
            });
        });

        describe("OptionTools.fold()", {
            it("should pass", {
                Some(1).fold(() -> { fail(); -1; }, x -> x + 100).should.be(101);
                None.fold(() -> 10, x -> { fail(); -1; }).should.be(10);
            });
        });
    }
}

private class MyError extends extype.Exception {
    public function new() {
        super("myerror");
    }
}
