using Python;
namespace Python381 {
    class BreakStmt : SimpleStmtBase {
        public BreakStmt () {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("break"));
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            return self;
        }
        public override string serialize() {
            return "break\n" + stmt.serialize();
        }
    }
    class ContinueStmt : SimpleStmtBase {
        public ContinueStmt () {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("continue"));
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            return self;
        }
        public override string serialize() {
            return "continue\n" + stmt.serialize();
        }
    }
    class ReturnStmt : SimpleStmtBase {
        public RoundPlace expression = new RoundPlace();
        public ReturnStmt () {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("return"));
            content.append(expression);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            return self;
        }
        public override string serialize() {
            return "return" + expression.serialize() + "\n" + stmt.serialize();
        }
    }
    class RaiseStmt : SimpleStmtBase {
        public RoundPlace expression = new RoundPlace();
        public RaiseStmt () {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("raise"));
            content.append(expression);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            return self;
        }
        public override string serialize() {
            return "raise" + expression.serialize() + "\n" + stmt.serialize();
        }
    }
    class YieldStmt : SimpleStmtBase {
        public RoundPlace expression = new RoundPlace();
        public YieldStmt () {
            base("darkOrange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("yield"));
            content.append(expression);
        }
        public override Parser.Node get_small_node() {
            var self = new Parser.Node(Token.SMALL_STMT);
            return self;
        }
        public override string serialize() {
            return "yield" + expression.serialize() + "\n" + stmt.serialize();
        }
    }
}
