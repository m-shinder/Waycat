using Python;
namespace Python381 {
    class ExprConst : RoundBlock {
        public EditableLabel lbl = new EditableLabel("value");
        public ExprConst () {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(lbl);
        }
        public ExprConst.with_name(string s) {
            this();
            lbl.text = s;
        }
        public override Parser.Node get_node() {
            Parser.Node self;
            if (lbl.text[0] == '\'' || lbl.text[0] == '"')
                self = new Parser.Node(Token.STRING);
            else
                self = new Parser.Node(Token.NUMBER);
            self.n_str = lbl.text;
            return self;
        }
    }
    class NameAdapter : RoundBlock {
        public AnglePlace name = new AnglePlace();
        public NameAdapter () {
            base("red", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0));
            content.append(name);
        }
        public NameAdapter.with_nonwrapped_name (AngleBlock n) {
            this();
            var w = new Waycat.DragWrapper(n);
            name.item = n;
        }
        public override Parser.Node get_node() {
            return null;
        }
    }

    class DotName : RoundBlock {
        public RoundPlace expr = new RoundPlace();
        public AnglePlace name = new AnglePlace();
        public DotName () {
            base("green", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0));
            content.append(expr);
            content.append(new Gtk.Label("."));
            content.append(name);
        }
        public DotName.with_nonwrapped_name (AngleBlock n) {
            this();
            var w = new Waycat.DragWrapper(n);
            name.item = n;
        }
        public override Parser.Node get_node() {
            return null;
        }
    }

    class SeparatedExpr : RoundBlock {
        public static string[] seps = {",", "+"};
        public Gtk.Popover popover = new Gtk.Popover();
        public string separator;
        public SeparatedExpr (string s) {
            base("green", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            separator = s;
            var f = new RoundPlace();
            f.item_changed.connect(changed_cb);
            content.append(f);

            popover.set_parent(this);
            var popbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 3);
            foreach (string str in seps) {
                popbox.append(new ClickLabel(str, click_cb));
            }
            popover.set_child(popbox);
        }

        public override bool on_workbench() {
            var click = new Gtk.GestureClick();
            click.released.connect((gest, n_press, x, y) => {
                if ( this.contains(x, y) == false )
                    return;
                popover.popup();
            });
            this.add_controller(click);
            return base.on_workbench();
        }

        public void click_cb(string s) {
            var w = content.get_first_child();
            while ( (w = w.get_next_sibling() ) != null)
                if (w is Gtk.Label)
                    (w as Gtk.Label).label = s;
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

    class CallExpr : RoundBlock {
        public RoundPlace function = new RoundPlace();
        public CallExpr () {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            var a = new RoundPlace();
            a.item_changed.connect(changed_cb);
            content.append(function);
            content.append(new Gtk.Label("("));
            content.append(a);
            content.append(new Gtk.Label(")"));
        }

        public override bool on_workbench() {
            return base.on_workbench();
        }

        public void changed_cb(RoundBlock? item) {
            if (item != null) {
                var p = new RoundPlace();
                var l = content.get_last_child().get_prev_sibling() as RoundPlace;
                if (l.item == null)
                    return;
                p.on_workbench();
                p.item_changed.connect(changed_cb);
                content.insert_child_after(p, l);
                content.insert_child_after(new Gtk.Label(","), l);
            } else {
                RoundPlace place = content.get_first_child()
                        .get_next_sibling().get_next_sibling() as RoundPlace;
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

    class AwaitCallExpr : RoundBlock {
        public RoundPlace function = new RoundPlace();
        public AwaitCallExpr () {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            var a = new RoundPlace();
            a.item_changed.connect(changed_cb);
            content.append(new Gtk.Label("await"));
            content.append(function);
            content.append(new Gtk.Label("("));
            content.append(a);
            content.append(new Gtk.Label(")"));
        }

        public override bool on_workbench() {
            return base.on_workbench();
        }

        public void changed_cb(RoundBlock? item) {
            if (item != null) {
                var p = new RoundPlace();
                var l = content.get_last_child().get_prev_sibling() as RoundPlace;
                if (l.item == null)
                    return;
                p.on_workbench();
                p.item_changed.connect(changed_cb);
                content.insert_child_after(p, l);
                content.insert_child_after(new Gtk.Label(","), l);
            } else {
                RoundPlace place = function.get_next_sibling().get_next_sibling() as RoundPlace;
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
