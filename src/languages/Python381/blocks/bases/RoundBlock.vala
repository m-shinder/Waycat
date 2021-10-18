class Python381.RoundBlock : Block {
    protected Gdk.RGBA color;
    protected Gtk.Box content = null;
    public const int HEIGHT_STEP = 4;


    public RoundBlock(string color, Gtk.Box content) {
        base();
        this.color.parse(color);
        this.content = content;
        this.content.set_parent(this);
    }

    public override bool on_workbench() {
        var list = content.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as BlockComponent;
            if (comp != null)
                comp.on_workbench();
        }
        return true;
    }

    public override bool break_free() {
        var place = get_parent().get_parent() as RoundPlace;
        if (place != null)
            place.item = null;
        return true;
    }

    public override void measure (Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition req;
        content.get_preferred_size(out req, null);
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = req.width + req.height + HEIGHT_STEP;
        } else {
            minimum = natural = req.height + HEIGHT_STEP;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.arc(h/2, h/2, h/2-1, Math.PI/2, -Math.PI/2);
        cr.line_to(w-h/2, 1);
        cr.arc(w-h/2, h/2, h/2-1, -Math.PI/2, Math.PI/2);
        cr.close_path();

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.fill();

        Gtk.Requisition req;
        content.get_preferred_size(out req, null);
        content.allocate_size({h/2, HEIGHT_STEP/2, req.width, req.height }, -1);

        base.snapshot(snapshot);
    }

    public override Python.Parser.Node get_node() { return null; }
}
