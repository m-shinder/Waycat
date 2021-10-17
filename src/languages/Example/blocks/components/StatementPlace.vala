class Example.StatementPlace : BlockComponent {
    private int height;
    private StatementBase _item = null;
    public StatementBase item {
        get { return _item; }
        set {
            StatementBase current = null;
            StatementBase last = null;
            if (_item != null) {
                current = _item;
                _item.get_parent().unparent();
            }
            _item = value;
            if (_item == null)
                return;
            _item.get_parent().unparent();
            _item.get_parent().set_parent(this);
            last = _item;
            if (current != null) {
                while (last.stmt.item != null)
                    last = last.stmt.item;
                last.stmt.item = current;
            }

        }
    }

    public StatementPlace(int h) {
        height = h;
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
        return "\n"+item.serialize();
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
            minimum = natural = -1;
        } else {
            minimum = natural = height;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.arc(w/2,h/2, 5, 0, 0);
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
        var block = wrapper.get_child() as StatementBase;
        if (block != null) {
            item = block;
        }
        return true;
    }
}
