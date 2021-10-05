class Boilerplate.StatementPlace : Gtk.Widget, IWorkbenchItem, IStatementPlace {
    public Statement stmt {get; set; default = null;}
    public Gtk.DropTarget dropTarget = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);
    public StatementPlace () {
    }
        
    public override bool on_workbench() {
        dropTarget.on_drop.connect(this.dropTarget_on_drop_cb);
        this.add_controller(dropTarget);
        return true;
    }

    public override void dispose() {
        if (stmt != null)
            stmt.get_parent().unparent();
    }

    public override Gtk.SizeRequestMode get_request_mode() {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }

    public override void measure (Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        Gtk.Requisition req = Gtk.Requisition();
        if (stmt != null)
            stmt.get_preferred_size(out req, null);
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = (int)Math.fmax(90, req.width);
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = (int)Math.fmax(30, req.height);
            minimum_baseline = natural_baseline = -1;
        }
    }
    
    public override void snapshot(Gtk.Snapshot snapshot) {
        if (stmt != null) {
            Gtk.Requisition req = Gtk.Requisition();
            var w = (stmt as Gtk.Widget).get_parent();
            w.get_preferred_size(out req, null);
            w.allocate_size({0, 0, req.width, req.height }, -1);
        }
        base.snapshot(snapshot);
    }
}
