using Python;
namespace Python381 {
    class FuncDef : MultiContainerBase {
        public FuncDef () {
            base("orange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(32)),
            });
            stanzas[0].content.append(new Gtk.Label("function"));
            stanzas[0].content.append(new AnglePlace());
            stanzas[0].content.append(new RoundPlace());

            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            //footer.append(new ToggleButton("+", "+"));
            footer.set_parent(this);
        }
        public override Parser.Node get_node() {
            return null;
        }
    }
    class WhileLoop : MultiContainerBase {
        private Stanza else_stnz = Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40));
        private ToggleButton else_btn = new ToggleButton("else", "else");
        private ToggleButton remove_b = new ToggleButton("remove", "remove");
        private int else_id = -1;
        public WhileLoop () {
            base("orange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40)),
            });
            stanzas[0].content.append(new Gtk.Label("while"));
            stanzas[0].content.append(new RoundPlace());
            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);

            else_stnz.content.append(new Gtk.Label("else"));
            else_stnz.content.append(remove_b);

            else_btn.released.connect(else_cb);
            remove_b.released.connect(remove_cb);
            remove_b.on_workbench();
            else_stnz.stmt.on_workbench();

            footer.append(else_btn);
            footer.set_parent(this);
        }

        public override Parser.Node get_node() {
            return null;
        }

        private void else_cb() {
            else_id = add_stanza(else_id, else_stnz);
            else_btn.active = false;
            else_stnz.set_parent(this);
            queue_resize();
        }

        private void remove_cb() {
            stanzas.remove_at(else_id);
            else_btn.active = true;
            else_stnz.set_parent(null);
            queue_resize();
            else_id = -1;
        }
    }
}
