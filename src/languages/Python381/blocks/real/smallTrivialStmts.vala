using Python;
namespace Python381 {
    class ExprStmt : SimpleStmtBase {
        public RoundPlace exprPlace = new RoundPlace();
        public ExprStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(exprPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.EXPR_STMT, null,0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(TEST_LIST_STAR_EXPR);
            return self;
        }
        public override string serialize() {
            return exprPlace.serialize() + "\n" + stmt.serialize();
        }
    }

    class AssignStmt : SimpleStmtBase {
        public AnglePlace leftPlace = new AnglePlace();
        public RoundPlace rightPlace = new RoundPlace();
        public AssignStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(leftPlace);
            content.append(new Gtk.Label("="));
            content.append(rightPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.EXPR_STMT, null,0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(TEST_LIST_STAR_EXPR);
            return self;
        }
        public override string serialize() {
            string rhs = NodeBuilder.instance.wrap_for_operator(rightPlace.item, " := ");
            return leftPlace.serialize() + " = " + rhs + "\n"
                    + stmt.serialize() ;
        }
    }
    class DelStmt : SimpleStmtBase {
        public RoundPlace exprPlace = new RoundPlace();
        public DelStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("delete"));
            content.append(exprPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.DEL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "del",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
        public override string serialize() {
            return "delete " + exprPlace.serialize() + "\n" + stmt.serialize();
        }
    }

    class PassStmt : SimpleStmtBase {
        public PassStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("pass"));
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.PASS_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "pass",0,0,0,0);
            return self;
        }
        public override string serialize() {
            return "pass\n" + stmt.serialize();
        }
    }

    class ImportNameStmt : SimpleStmtBase {
        public AnglePlace dotNamesPlace = new AnglePlace();
        public ImportNameStmt() {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("import"));
            content.append(dotNamesPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.IMPORT_STMT, null,0,0,0,0);
            self[0].add_child(Token.IMPORT_NAME, null,0,0,0,0);
            return self;
        }
        public override string serialize() {
            return "import " + dotNamesPlace.serialize() + "\n" + stmt.serialize();
        }
    }

    class ImportFromStmt : SimpleStmtBase {
        public AnglePlace sourcePlace = new AnglePlace();
        public AnglePlace dotNamesPlace = new AnglePlace();
        public ImportFromStmt() {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("from"));
            content.append(sourcePlace);
            content.append(new Gtk.Label("import"));
            content.append(dotNamesPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.IMPORT_STMT, null,0,0,0,0);
            self[0].add_child(Token.IMPORT_FROM, null,0,0,0,0);
            return self;
        }
        public override string serialize() {
            return "from " + sourcePlace.serialize() + " import " +
                dotNamesPlace.serialize() + stmt.serialize() + "\n";
        }
    }
    // TODO: flow and import statements
    class GlobalStmt : SimpleStmtBase {
        public RoundPlace exprPlace = new RoundPlace();
        public GlobalStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("global"));
            content.append(exprPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.GLOBAL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "global",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
        public override string serialize() {
            return "global " + exprPlace.serialize() + "\n" + stmt.serialize();
        }
    }

    class NonlocalStmt : SimpleStmtBase {
        public RoundPlace exprPlace = new RoundPlace();
        public NonlocalStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("nonlocal"));
            content.append(exprPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.NONLOCAL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "nonlocal",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
        public override string serialize() {
            return "nonlocal " + exprPlace.serialize() + "\n" + stmt.serialize();
        }
    }

    class AssertStmt : SimpleStmtBase {
        public RoundPlace exprPlace = new RoundPlace();
        public AssertStmt() {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("assert"));
            content.append(exprPlace);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.DEL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "assert",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
        public override string serialize() {
            return "assert " + exprPlace.serialize() + "\n" + stmt.serialize();
        }
    }
}
