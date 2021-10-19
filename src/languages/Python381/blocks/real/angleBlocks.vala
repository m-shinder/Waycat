using Python;
namespace Python381 {
    class NameConst : AngleBlock {
        public EditableLabel lbl = new EditableLabel("name");
        public NameConst () {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(lbl);
        }
        public override Parser.Node get_node() {
            string[] names = lbl.text.split_set(".");
            if (names.length < 2) {
                Parser.Node self = new Parser.Node(Token.NAME);
                self.n_str = lbl.text;
                return self;
            }
            Parser.Node self = new Parser.Node(Token.DOTTED_NAME);
            foreach (var name in names) {
                self.add_child(Token.NAME, name, 0,0,0,0);
                self.add_child(Token.NAME, ".", 0,0,0,0);
            }
            return null;
        }
    }
}
