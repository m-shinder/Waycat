abstract class Example.StatementBase : Block {
    protected Gdk.RGBA color;
    protected Gtk.Box content = null;
    public StatementPlace stmt = new StatementPlace(8);
    public const int HEIGHT_STEP = 16;

    protected StatementBase(string color, Gtk.Box content) {
        base();
        this.color.parse(color);
        this.content = content;
        this.content.set_parent(this);

        stmt.set_parent(this);
    }

    public override void dispose() {
        content.unparent();
        stmt.unparent();
        base.dispose();
    }

    public override bool on_workbench() {
        var list = content.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as BlockComponent;
            if (comp != null)
                comp.on_workbench();
        }
        stmt.on_workbench();
        return true;
    }

    public override bool break_free() {
        var place = get_parent().get_parent() as StatementPlace;
        if (place != null)
            place.item = null;
        return true;
    }
}
