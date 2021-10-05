class Boilerplate.RoundPlace : Gtk.Widget, IWorkbenchItem {
    public RoundBlock item = null;
    protected Gtk.DropTarget dropTarget = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);

    public RoundPlace() {
    }
    
    public void set_item(RoundBlock? n) {
        if (item != null) {
            item.get_parent().unparent();
        }
        item = n;
        if (item == null)
            return;
        item.get_parent().unparent();
        item.get_parent().set_parent(this);
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
            minimum = natural = (item!=null)?req.height:17;
            minimum_baseline = natural_baseline = -1;
        }
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        var w = get_width(), h = get_height();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.arc(h/2, h/2, h/2, Math.PI/2, -Math.PI/2);
        cr.line_to(w-15, 0);
        cr.arc(w-h/2, h/2, h/2, -Math.PI/2, Math.PI/2);
        cr.close_path();

        cr.set_source_rgba (0.5, 0.5, 0.5, 1);
        cr.fill();

        if (item != null) {
            Gtk.Requisition req;
            var wr = item.get_parent();
            wr.get_preferred_size(out req, null);
            wr.allocate_size({0, 0, req.width, req.height }, -1);
        }
        base.snapshot(snapshot);
    }

    protected bool dropTarget_on_drop_cb(Value val, double x, double y) {
        var wrapper = val.get_object() as Waycat.DragWrapper;
        var block = wrapper.get_child() as RoundBlock;
        if (block != null) {
            if (item != null) {
                set_item(block);
            }
            wrapper.unparent();
            wrapper.set_parent(this);
            item = block;
        }
        return true;
    }
}
