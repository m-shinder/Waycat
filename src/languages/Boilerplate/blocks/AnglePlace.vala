
class Boilerplate.AnglePlace : Gtk.Widget, IWorkbenchItem {
    public AngleBlock item = null;
    protected Gtk.DropTarget dropTarget = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);

    public AnglePlace() {
    }
    
    public void set_item(AngleBlock? n) {
        item = n;
    }

    public override bool on_workbench() {
        dropTarget.on_drop.connect(dropTarget_on_drop_cb);
        this.add_controller(dropTarget);
        return true;
    }

    public override void dispose() {
        if (item != null)
            item.get_parent().unparent();
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
        if (item != null)
            item.get_preferred_size(out req, null);
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = (int)Math.fmax(30, req.width);
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = 15;
            minimum_baseline = natural_baseline = -1;
        }
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        var w = get_width(), h = get_height();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.move_to(0, h/2);
        cr.line_to(7, 0);
        cr.line_to(w - 7, 0);
        cr.line_to(w, h/2);
        cr.line_to(w - 7, h);
        cr.line_to(7, h);
        cr.close_path();
        
        cr.set_source_rgba (0.5, 0.5, 0.5, 1);
        cr.fill();

        if (item != null) {
            Gtk.Requisition req;
            item.get_parent().get_preferred_size(out req, null);
            item.get_parent().allocate_size({0, 0, req.width, req.height }, -1);
        }
        base.snapshot(snapshot);
    }

    protected bool dropTarget_on_drop_cb(Value val, double x, double y) {
        print("AnglePlace connect %p %p %p\n", this, val.get_object(), null);
        var wrapper = val.get_object() as Waycat.DragWrapper;
        var block = wrapper.get_child() as AngleBlock;
        if (block != null) {
            wrapper.unparent();
            if (item != null) {
                item.get_parent().unparent();
                item.get_parent().dispose();
            }
            wrapper.set_parent(this);
            item = block;
        }
        print("AnglePlace on_drop_cb\n");
        return true;
    }
}
