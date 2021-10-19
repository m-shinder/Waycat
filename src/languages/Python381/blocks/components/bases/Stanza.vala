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
}
