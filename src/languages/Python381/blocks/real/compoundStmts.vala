using Python;
namespace Python381 {
    class IfStmt : MultiContainerBase {
        private Stanza else_stnz = Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40));
        private ToggleButton else_btn = new ToggleButton("else", "else");
        private ToggleButton elif_btn = new ToggleButton("elif", "elif");
        private ToggleButton remove_b = new ToggleButton("remove", "remove");
        private int else_id = -1;
        public IfStmt () {
            base("darkOrange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40)),
            });
            stanzas[0].content.append(new Gtk.Label("if"));
            stanzas[0].content.append(new RoundPlace());
            stanzas[0].content.append(elif_btn);
            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);

            else_stnz.content.append(new Gtk.Label("else"));
            else_stnz.content.append(remove_b);

            elif_btn.released.connect(elif_cb);
            else_btn.released.connect(else_cb);
            remove_b.released.connect(remove_cb);
            remove_b.on_workbench();
            else_stnz.stmt.on_workbench();

            footer.append(else_btn);
            footer.set_parent(this);
        }

        public override string serialize() {
            return "IF";
        }
        public override Parser.Node get_node() {
            return null;
        }

        private void else_cb() {
            else_id = add_stanza(else_id, else_stnz);
            else_btn.visible = false;
            else_stnz.set_parent(this);
            queue_resize();
        }

        private void elif_cb() {
            var content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            var btn = new ToggleButton("remove", "remove");
            content.append(new Gtk.Label("elif"));
            content.append(new RoundPlace());
            content.append(btn);
            var elif_stnz = Stanza(content, new StatementPlace(40));
            add_stanza(1, elif_stnz);
            int elif_id = stanzas.size -1;
            btn.released.connect(() => {
                int real_id = stanzas.size - elif_id;
                if (else_id > 0)
                    real_id--;
                stanzas[real_id].set_parent(null);
                stanzas.remove_at(real_id);
                queue_resize();
            });
            elif_stnz.set_parent(this);
            btn.on_workbench();
            elif_stnz.on_workbench();
            queue_resize();
        }

        private void remove_cb() {
            stanzas.remove_at(else_id);
            else_btn.visible = true;
            else_stnz.set_parent(null);
            queue_resize();
            else_id = -1;
        }
    }

    class WhileLoop : MultiContainerBase {
        private Stanza else_stnz = Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40));
        private ToggleButton else_btn = new ToggleButton("else", "else");
        private ToggleButton remove_b = new ToggleButton("remove", "remove");
        private int else_id = -1;
        public WhileLoop () {
            base("darkOrange", {
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
        public WhileLoop.with_else(StatementBase els) {
            this();
            else_stnz.stmt.item = els;
            else_cb();
        }

        public override string serialize() {
            var condition = stanzas[0].content.get_first_child()
                                    .get_next_sibling() as RoundPlace;
            var cond = condition.serialize();
            var body = stanzas[0].stmt.serialize().replace("\n", "\n  ");
            return @"while $cond:\n  $body";
        }
        public override Parser.Node get_node() {
            return null;
        }

        private void else_cb() {
            else_id = add_stanza(else_id, else_stnz);
            else_btn.visible = false;
            else_stnz.set_parent(this);
            queue_resize();
        }

        private void remove_cb() {
            stanzas.remove_at(else_id);
            else_btn.visible = true;
            else_stnz.set_parent(null);
            queue_resize();
            else_id = -1;
        }
    }
    class ForLoop : MultiContainerBase {
        private Stanza else_stnz = Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40));
        private ToggleButton else_btn = new ToggleButton("else", "else");
        private ToggleButton remove_b = new ToggleButton("remove", "remove");
        private int else_id = -1;
        public ForLoop () {
            base("darkOrange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40)),
            });
            stanzas[0].content.append(new Gtk.Label("for"));
            stanzas[0].content.append(new RoundPlace());
            stanzas[0].content.append(new Gtk.Label("in"));
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

        public override string serialize() {
            return "IF";
        }
        public override Parser.Node get_node() {
            return null;
        }

        private void else_cb() {
            else_id = add_stanza(else_id, else_stnz);
            else_btn.visible = false;
            else_stnz.set_parent(this);
            queue_resize();
        }

        private void remove_cb() {
            stanzas.remove_at(else_id);
            else_btn.visible = true;
            else_stnz.set_parent(null);
            queue_resize();
            else_id = -1;
        }
    }

    // TODO: rename if* methods
    class TryStmt : MultiContainerBase {
        private Stanza else_stnz = Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40));
        private ToggleButton else_btn = new ToggleButton("finally", "finally");
        private ToggleButton elif_btn = new ToggleButton("except", "except");
        private ToggleButton remove_b = new ToggleButton("remove", "remove");
        private int else_id = -1;
        public TryStmt () {
            base("darkOrange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(40)),
            });
            stanzas[0].content.append(new Gtk.Label("try"));
            stanzas[0].content.append(new RoundPlace());
            stanzas[0].content.append(elif_btn);
            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);

            else_stnz.content.append(new Gtk.Label("finally"));
            else_stnz.content.append(remove_b);

            elif_btn.released.connect(elif_cb);
            else_btn.released.connect(else_cb);
            remove_b.released.connect(remove_cb);
            remove_b.on_workbench();
            else_stnz.stmt.on_workbench();

            footer.append(else_btn);
            footer.set_parent(this);
        }

        public override string serialize() {
            return "IF";
        }
        public override Parser.Node get_node() {
            return null;
        }

        private void else_cb() {
            else_id = add_stanza(else_id, else_stnz);
            else_btn.visible = false;
            else_stnz.set_parent(this);
            queue_resize();
        }

        private void elif_cb() {
            var content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            var btn = new ToggleButton("remove", "remove");
            content.append(new Gtk.Label("except"));
            content.append(new RoundPlace());
            content.append(btn);
            var elif_stnz = Stanza(content, new StatementPlace(40));
            add_stanza(1, elif_stnz);
            int elif_id = stanzas.size -1;
            btn.released.connect(() => {
                int real_id = stanzas.size - elif_id;
                if (else_id > 0)
                    real_id--;
                stanzas[real_id].set_parent(null);
                stanzas.remove_at(real_id);
                queue_resize();
            });
            elif_stnz.set_parent(this);
            btn.on_workbench();
            elif_stnz.on_workbench();
            queue_resize();
        }

        private void remove_cb() {
            stanzas.remove_at(else_id);
            else_btn.visible = true;
            else_stnz.set_parent(null);
            queue_resize();
            else_id = -1;
        }
    }

    class WithStmt : MultiContainerBase {
        public Gtk.Box vcontent = new Gtk.Box(Gtk.Orientation.VERTICAL, 3);
        public WithStmt () {
            base("darkOrange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(32)),
            });
            stanzas[0].content.append(new Gtk.Label("with"));
            stanzas[0].content.append(vcontent);
            var place = new RoundPlace();
            place.item_changed.connect(changed_cb);
            vcontent.append(place);

            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            footer.set_parent(this);
        }
        public override string serialize() {
            return "IF";
        }
        public override Parser.Node get_node() {
            return null;
        }
        public override bool on_workbench() {
            RoundPlace place = vcontent.get_first_child() as RoundPlace;
            while (place != null) {
                place.on_workbench();
                place = place.get_next_sibling() as RoundPlace;
            }
            return base.on_workbench();
        }
        public void changed_cb(RoundBlock? item) {
            if (item != null) {
                var p = new RoundPlace();
                p.on_workbench();
                p.item_changed.connect(changed_cb);
                vcontent.append(p);
            } else {
                RoundPlace place = vcontent.get_first_child() as RoundPlace;
                while (place.item != null) {
                    place = place.get_next_sibling() as RoundPlace;
                }
                vcontent.remove(place);
            }
        }
    }

    class FuncDef : MultiContainerBase {
        public FuncDef () {
            base("darkOrange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(32)),
            });
            stanzas[0].content.append(new Gtk.Label("function"));
            stanzas[0].content.append(new AnglePlace());
            stanzas[0].content.append(new RoundPlace());

            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            footer.set_parent(this);
        }
        public override string serialize() {
            return "IF";
        }
        public override Parser.Node get_node() {
            return null;
        }
    }
}
