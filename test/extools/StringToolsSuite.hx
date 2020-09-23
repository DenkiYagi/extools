package extools;

using extools.StringTools;

class StringToolsSuite extends BuddySuite {
    public function new() {
        describe("StringTools.isEmpty()", {
            it("should be true", {
                final x:String = null;
                x.isEmpty().should.be(true);
                "".isEmpty().should.be(true);
                #if js
                final y:String = js.Lib.undefined;
                y.isBlank().should.be(true);
                #end
            });

            it("should be false", {
                " ".isEmpty().should.be(false);
                "　".isEmpty().should.be(false);
                "a".isEmpty().should.be(false);
            });
        });

        describe("StringTools.nonEmpty()", {
            it("should be false", {
                final x:String = null;
                x.nonEmpty().should.be(false);
                "".nonEmpty().should.be(false);
                #if js
                final y:String = js.Lib.undefined;
                y.nonEmpty().should.be(false);
                #end
            });
            it("should be true", {
                " ".nonEmpty().should.be(true);
                "　".nonEmpty().should.be(true);
                "a".nonEmpty().should.be(true);
            });
        });

        describe("StringTools.isBlank()", {
            it("should be true", {
                final x:String = null;
                x.isBlank().should.be(true);

                "".isBlank().should.be(true);
                " ".isBlank().should.be(true);
                "　".isBlank().should.be(true);
                "\u3000".isBlank().should.be(true);
                #if js
                ("\u0009\u000A\u000B\u000C\u000D\u0085\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000"
                    + js.Syntax.code("'\\u2028'")
                    + js.Syntax.code("'\\u2029'")).isBlank().should.be(true);
                #else
                "\u0009\u000A\u000B\u000C\u000D\u0085\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029".isBlank()
                    .should.be(true);
                #end
                #if js
                final y:String = js.Lib.undefined;
                y.isBlank().should.be(true);
                #end
            });
            it("should be false", {
                " a".isBlank().should.be(false);
                " \u2030".isBlank().should.be(false);
            });
        });

        describe("StringTools.nonBlank()", {
            it("should be false", {
                final x:String = null;
                x.nonBlank().should.be(false);

                "".nonBlank().should.be(false);
                " ".nonBlank().should.be(false);
                "　".nonBlank().should.be(false);
                "\u3000".nonBlank().should.be(false);
                #if js
                ("\u0009\u000A\u000B\u000C\u000D\u0085\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000"
                    + js.Syntax.code("'\\u2028'")
                    + js.Syntax.code("'\\u2029'")).nonBlank().should.be(false);
                #else
                "\u0009\u000A\u000B\u000C\u000D\u0085\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029".nonBlank()
                    .should.be(false);
                #end
                #if js
                final y:String = js.Lib.undefined;
                y.nonBlank().should.be(false);
                #end
            });
            it("should be true", {
                " a".nonBlank().should.be(true);
                " \u2030".nonBlank().should.be(true);
            });
        });
    }
}
