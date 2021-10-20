using Python;
namespace Python381 {
    class NameAdapter : RoundBlock {
        public AnglePlace name = new AnglePlace();
        public NameAdapter () {
            base("red", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0));
            content.append(name);
        }
        public override Parser.Node get_node() {
            return null;
        }
    }

    class SeparatedExpr : RoundBlock {
        public string separator;
        public SeparatedExpr (string s) {
            base("green", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            separator = s;
            var f = new RoundPlace();
            f.item_changed.connect(changed_cb);
            content.append(f);
            //content.append(new Gtk.Label(separator));

        }
        public void changed_cb(RoundBlock? item) {
            if (item != null) {
                var p = new RoundPlace();
                p.on_workbench();
                p.item_changed.connect(changed_cb);
                content.append(new Gtk.Label(separator));
                content.append(p);
            } else {
                RoundPlace place = content.get_first_child() as RoundPlace;
                while (place.item != null) {
                    place = place.get_next_sibling().get_next_sibling() as RoundPlace;
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
