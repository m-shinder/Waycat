class Boilerplate.EditableRoundBlock : RoundBlock {
    private Gtk.Entry entry = new Gtk.Entry();
    public Gtk.GestureClick click = new Gtk.GestureClick();
    public EditableRoundBlock(uint cat_id, uint blk_id) {
        base(cat_id, blk_id, "purple");
        entry.text = text;
        entry.visible = false;
        entry.changed.connect((e) => {
            text = entry.get_text();
        });
        
        click.released.connect((gest, n_press, x, y) => {
            if (this.pick(x, y, Gtk.PickFlags.DEFAULT)
                .get_ancestor(typeof(Waycat.DragWrapper)) != this.get_parent())
                    return ;
            if (entry.visible == true) {
                entry.visible = false;
            } else {
                entry.visible = true;
                entry.grab_focus ();
            }
        });
        
        entry.set_opacity(0);
        entry.set_parent(this);
    }
    
    public override void dispose() {
        entry.unparent();
        base.dispose();
    } 
    public override bool on_workbench() {
        this.add_controller(click);
        return true;
    }
    
    public override void snapshot(Gtk.Snapshot s) {
        Gtk.Requisition req;
        entry.get_preferred_size(out req, null);
        entry.allocate_size({
            get_width()/2 - req.width/2, get_height(),
            req.width, req.height
        }, -1);
        label.get_preferred_size(out req, null);
        label.allocate_size({
            get_width()/2 -req.width/2, get_height()/2 - req.height/2,
            req.width, req.height
        }, -1);
        if (entry.visible)
            color.parse("red");
        else
            color.parse("purple");
        base.snapshot(s);
    }
    
    // TODO: remove
    protected void noalloc_snapshot(Gtk.Snapshot s) {
        Gtk.Requisition req;
        entry.get_preferred_size(out req, null);
        entry.allocate_size({
            get_width()/2 - req.width/2, get_height(),
            req.width, req.height
        }, -1);
        if (entry.visible)
            color.parse("red");
        else
            color.parse("purple");
        base.snapshot(s);
    }
}
