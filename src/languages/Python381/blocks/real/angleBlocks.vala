using Python;
namespace Python381 {
    class NameConst : AngleBlock {
        public EditableLabel lbl = new EditableLabel("name");
        public NameConst () {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(lbl);
        }
        public NameConst.with_name(string s) {
            this();
            lbl.text = s;
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
        public override string serialize() {
            return lbl.serialize();
        }
    }

    class SeparatedNames : AngleBlock {
        public string separator;
        public SeparatedNames (string s) {
            base("green", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            separator = s;
            var f = new AnglePlace();
            f.item_changed.connect(changed_cb);
            content.append(f);
            //content.append(new Gtk.Label(separator));

        }
        public override string serialize() {
            var list = content.observe_children();
            var strings = new string[(int)(list.get_n_items())/2];
            for (int i=0; i < strings.length; i++) {
                var place = list.get_item(i*2) as AnglePlace;
                if (place.item != null)
                    strings[i] = place.serialize();
            }
            return string.joinv(separator, strings);
        }
        public void changed_cb(AngleBlock? item) {
            if (item != null) {
                var p = new AnglePlace();
                p.on_workbench();
                p.item_changed.connect(changed_cb);
                content.append(new Gtk.Label(separator));
                content.append(p);
            } else {
                AnglePlace place = content.get_first_child() as AnglePlace;
                while (place.item != null) {
                    place = place.get_next_sibling().get_next_sibling() as AnglePlace;
                }
                content.remove(place.get_next_sibling());
                content.remove(place);
            }
        }
        public override Parser.Node get_node() {
            return null;
        }
    }

    class ExprAdapter : AngleBlock {
        public RoundPlace expr = new RoundPlace();
        public ExprAdapter () {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(expr);
        }
        public override string serialize() {
            return expr.serialize();
        }
        public override Parser.Node get_node() {
            return null;
        }
    }
}
