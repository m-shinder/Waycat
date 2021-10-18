class Python381.AnchorHeader : Block {
    protected Gdk.RGBA color;
    [CCode (cname = "next_stmt")]
    public StatementPlace stmt = new StatementPlace(8);
    public const int OWN_HEIGHT = 64;
    public Gtk.TextMark start = null;
    public Gtk.TextMark end = null;


    public AnchorHeader() {
        base();
        stmt.set_parent(this);
        this.color.parse("orange");
    }

    public override bool break_free() { return true; } // anchors always free

    public override Python.Parser.Node get_node() {
        if (stmt.item == null)
            return null;
        return stmt.item.get_node();
    }

    public override void dispose() {
        stmt.unparent();
        base.dispose();
    }

    public override void measure (Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition sreq;
        stmt.get_preferred_size(out sreq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = (int)Math.fmax(sreq.width, OWN_HEIGHT*2);
        } else {
            minimum = natural = sreq.height + OWN_HEIGHT;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition sreq;
        stmt.get_preferred_size(out sreq, null);

        var h = OWN_HEIGHT, w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});

        cr.move_to(1, h/2);
        cr.arc(h/2, h/2, h/2-1, Math.PI, 0);
        cr.line_to(w-1, h/2);
        cr.line_to(w-1, h);
        cr.line_to(32, h);
        cr.arc(24, h, 8, 0, Math.PI);
        cr.line_to(1, h);
        cr.close_path();

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.fill();

        stmt.allocate_size({0, h, (sreq.width>0)?sreq.width:w, sreq.height }, -1);

        base.snapshot(snapshot);
    }
}
