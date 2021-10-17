abstract class Python381.BlockComponent : Gtk.Widget {
    public abstract bool on_workbench();
    public abstract Python.Parser.Node get_node();

    public override void dispose() {
        var list = this.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as Gtk.Widget;
            if (comp != null)
                comp.unparent();
        }
        base.dispose();
    }
}
