public abstract class Waycat.Block : Gtk.Widget {
    public uint cat_id { get; set;}
    public uint block_id { get; set;}
/// you should use Gtk.Widget.name instead
//    public string name { get; set; default = "";}
    protected Block(uint cat, uint blk) {
        cat_id = cat;
        block_id = blk;
    }
    
    // language only?
    public abstract bool break_free();

    public abstract bool on_workbench();
    
    public override void dispose() {
        var list = this.observe_children();
        while (list.get_n_items() > 0) {
            var comp = list.get_item(0) as Gtk.Widget;
            if (comp != null)
                comp.unparent();
        }
        base.dispose();
    }
}
