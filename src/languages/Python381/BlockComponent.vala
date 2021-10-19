abstract class Python381.BlockComponent : Gtk.Widget {
    public abstract bool on_workbench();
    public abstract Python.Parser.Node get_node();

    public override void dispose() {
        var list = this.observe_children();
        while (list.get_n_items() != 0) {
            var comp = list.get_item(0) as Gtk.Widget;
            if (comp != null)
                comp.unparent();
        }
        base.dispose();
    }
}
