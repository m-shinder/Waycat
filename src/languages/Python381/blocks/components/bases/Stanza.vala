struct Python381.Stanza {
    public Gtk.Box content;
    public StatementPlace stmt;
    public Stanza(Gtk.Box c, StatementPlace s) {
        content = c;
        stmt = s;
    }
    public void set_parent(Gtk.Widget? w) {
        if (w == null) {
            content.unparent();
            stmt.unparent();
            return;
        }
        content.set_parent(w);
        stmt.set_parent(w);
    }
    public void on_workbench() {
        var list = content.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as BlockComponent;
            if (comp != null)
                comp.on_workbench();
        }
        stmt.on_workbench();
    }
}
