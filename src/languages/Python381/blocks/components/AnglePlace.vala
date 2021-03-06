class Python381.AnglePlace : BlockComponent {
    private AngleBlock _item = null;
    public signal void item_changed(AngleBlock item);
    public AngleBlock item {
        get { return _item; }
        set {
            if (_item != null)
                _item.get_parent().unparent();
            _item = value;
            item_changed(_item);
            if (_item == null)
                return;
            _item.get_parent().unparent();
            _item.get_parent().set_parent(this);
        }
    }

    public AnglePlace() {
        this.valign = Gtk.Align.CENTER;
    }

    public override bool on_workbench() {
        var target = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);
        target.on_drop.connect(dropTarget_on_drop_cb);
        this.add_controller(target);
        return true;
    }

    public override string serialize() {
        if (item == null)
            return "";
        return item.serialize();
    }

    public override Python.Parser.Node get_node() {
        if (item==null)
            return null;
        return item.get_node();
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        if (item != null) {
            item.measure(orientation, for_size,
                out minimum, out natural, out min_baseline, out nat_baseline);
            return;
        }
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = 32;
        } else {
            minimum = natural = 16;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.move_to(0, h/2);
        cr.line_to(h/2, 0);
        cr.line_to(w-h/2, 0);
        cr.line_to(w, h/2);
        cr.line_to(w-h/2, h);
        cr.line_to(h/2, h);
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

    private bool dropTarget_on_drop_cb(Value val, double x, double y) {
        var wrapper = val.get_object() as Waycat.DragWrapper;
        var block = wrapper.get_child() as AngleBlock;
        if (block != null) {
            item = block;
        }
        return true;
    }
}
