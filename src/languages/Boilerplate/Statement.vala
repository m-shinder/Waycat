abstract class Boilerplate.Statement : Waycat.Block, IStatementPlace {
    public Statement stmt {get; set; default = null;}
    protected Gtk.Box content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
    protected Gtk.DropTarget dropTarget = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);
    
    protected Statement(uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        
        content.set_parent(this);
        content.set_margin_end(5);
    }
    
    public override void dispose() {
        content.unparent();
        if(stmt != null)
            stmt.get_parent().unparent();
    }
        
    public bool set_next(Statement? stmt) {
        var p = stmt.get_parent(); // otherwise set_parent() not working...
        p.unparent();
        p.set_parent(this);
        this.stmt = stmt;
        return true;
    }
    
    public override bool break_free() {
        var prev = this.get_parent().get_parent() as IStatementPlace;
        if (prev == null)
            return true;
        prev.stmt = null;
        return true;
    } 

    public override bool on_workbench() {
        var item = content.get_first_child();
        while (item != null) {
            var witem = (item as IWorkbenchItem);
            if (witem != null)
                witem.on_workbench();
            item = item.get_next_sibling();
        }
        dropTarget.on_drop.connect(this.dropTarget_on_drop_cb);
        this.add_controller(dropTarget);
        return true;
    }
    
    public override Gtk.SizeRequestMode get_request_mode() {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        Gtk.Requisition req;
        Gtk.Requisition nreq = Gtk.Requisition();
        content.get_preferred_size(out req, null);
        if (stmt != null) {
            stmt.get_preferred_size(out nreq, null);
        }
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = (int)Math.fmax(15 + req.width, nreq.width);
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = 30 + nreq.height + ((stmt == null)?7:0);
            minimum_baseline = natural_baseline = -1;
        }
    }
}
