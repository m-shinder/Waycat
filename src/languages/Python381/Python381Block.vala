abstract class Python381.Block : Waycat.Block {
    private static uint id = 0;

    public static void reset_count() {
        id = 0;
    }

    protected Block() {
        base(0, id++);
    }

    public abstract Python.Parser.Node get_node();
    public abstract string serialize();

    public override Gtk.SizeRequestMode get_request_mode() {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }

    public override bool on_workbench() {
        var list = this.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as BlockComponent;
            if (comp != null)
                comp.on_workbench();
        }
        return true;
    }
}
