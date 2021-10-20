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
}
