using Python;
namespace Python381 {
    class ExprStmt : SimpleStmtBase {
        private RoundPlace exprPlace = new RoundPlace();
        public ExprStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(exprPlace);
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.EXPR_STMT, null,0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(TEST_LIST_STAR_EXPR);
            return self;
        }
    }

    class DelStmt : SimpleStmtBase {
        private RoundPlace exprPlace = new RoundPlace();
        public DelStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("delete"));
            content.append(exprPlace);
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.DEL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "del",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
    }

    class PassStmt : SimpleStmtBase {
        public PassStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("pass"));
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.PASS_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "pass",0,0,0,0);
            return self;
        }
    }
    // TODO: flow and import statements
    class GlobalStmt : SimpleStmtBase {
        private RoundPlace exprPlace = new RoundPlace();
        public GlobalStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("global"));
            content.append(exprPlace);
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.GLOBAL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "global",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
    }

    class NonlocalStmt : SimpleStmtBase {
        private RoundPlace exprPlace = new RoundPlace();
        public NonlocalStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("nonlocal"));
            content.append(exprPlace);
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.NONLOCAL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "nonlocal",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
    }

    class AssertStmt : SimpleStmtBase {
        private RoundPlace exprPlace = new RoundPlace();
        public AssertStmt() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("assert"));
            content.append(exprPlace);
            content.append(small); // if do it in base() it will be at start
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            self.add_child(Token.DEL_STMT, null,0,0,0,0);
            self[0].add_child(Token.NAME, "assert",0,0,0,0);
            // TODO: actually call exprPlace
            //self[0].add_child(EXPR_LIST);
            return self;
        }
    }
}