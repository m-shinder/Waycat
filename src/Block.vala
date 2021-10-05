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

    public virtual bool on_workbench() {
        return false;
    }
    
    // language only?
    public virtual string serialize() {
        return "";
    }
}
