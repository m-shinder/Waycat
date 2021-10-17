class Example.DoubleContainerBlock : StatementBase {
    public StatementPlace fbody = new StatementPlace(32);
    public StatementPlace sbody = new StatementPlace(32);
    public Gtk.Label slabel;

    public DoubleContainerBlock(string color, Gtk.Box content, Gtk.Label lbl) {
        base(color, content);
        slabel = lbl;
        this.slabel.set_parent(this);
        this.fbody.set_parent(this);
        this.sbody.set_parent(this);
    }

    public override void dispose() {
        fbody.unparent();
        sbody.unparent();
        content.unparent();
        stmt.unparent();
        slabel.unparent();
        base.dispose();
    }
    public override bool on_workbench() {
        fbody.on_workbench();
        sbody.on_workbench();
        base.on_workbench();
        return true;
    }
    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition creq, sreq, fbreq, sbreq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        fbody.get_preferred_size(out fbreq, null);
        sbody.get_preferred_size(out sbreq, null);

        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = (int)Math.fmax(creq.width + 24,
                                     Math.fmax(sreq.width,
                                     Math.fmax(fbreq.width, sbreq.width)));
        } else {
            minimum = natural = creq.height + sreq.height
                    + fbreq.height + sbreq.height + HEIGHT_STEP*3;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition creq, sreq, fbreq, sbreq, lreq;
        content.get_preferred_size(out creq, null);
        slabel.get_preferred_size(out lreq, null);
        stmt.get_preferred_size(out sreq, null);
        fbody.get_preferred_size(out fbreq, null);
        sbody.get_preferred_size(out sbreq, null);

        var header = creq.height + HEIGHT_STEP;
        var h = header + fbreq.height + sbreq.height + HEIGHT_STEP, w = creq.width + 24;
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});

        cr.move_to(1, 1);
        cr.line_to(16, 1);
        cr.arc_negative(24, 1, 8, Math.PI, 0);
        cr.line_to(w-1, 1);

        cr.line_to(w-1, header);
        cr.line_to(48,  header);
        cr.arc(40, header, 8, 0, Math.PI);
        cr.line_to(16,  header);

        cr.line_to(16, header + fbreq.height - HEIGHT_STEP/2);
        cr.line_to(w-1,header + fbreq.height - HEIGHT_STEP/2);

        cr.line_to(w-1,header + fbreq.height + HEIGHT_STEP/2);
        cr.line_to(48, header + fbreq.height + HEIGHT_STEP/2);
        cr.arc(40, header + fbreq.height + HEIGHT_STEP/2, 8, 0, Math.PI);
        cr.line_to(16,  header + fbreq.height + HEIGHT_STEP/2);

        cr.line_to(16, header + fbreq.height + sbreq.height );
        cr.line_to(w-1,header + fbreq.height + sbreq.height );

        cr.line_to(w-1, header + fbreq.height + sbreq.height + HEIGHT_STEP);
        cr.line_to(32, header + fbreq.height + sbreq.height + HEIGHT_STEP);
        cr.arc(24, h, 8, 0, Math.PI);
        cr.line_to(1, h);
        cr.close_path();

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.fill();

        fbody.allocate_size({16, header, (fbreq.width>0)?fbreq.width:(w-16), fbreq.height }, -1);
        slabel.allocate_size({64, header + fbreq.height -HEIGHT_STEP/2, lreq.width, lreq.height}, -1);
        sbody.allocate_size({16, header + fbreq.height + HEIGHT_STEP/2, (sbreq.width>0)?sbreq.width:(w-16), sbreq.height }, -1);
        content.allocate_size({12, HEIGHT_STEP/2, creq.width, creq.height }, -1);
        stmt.allocate_size({0, h-1, (sreq.width>0)?sreq.width:w, sreq.height }, -1);

        base.snapshot(snapshot);
    }

    public override string serialize() {
        return "STATEMENT";
    }
}
