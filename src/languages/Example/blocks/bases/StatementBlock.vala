class Example.StatementBlock : StatementBase {
    public StatementBlock(string color, Gtk.Box content) {
        base(color, content);
    }
    
    public override void measure (Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition creq, sreq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = (int)Math.fmax(creq.width + 24, sreq.width);
        } else {
            minimum = natural = creq.height + sreq.height + HEIGHT_STEP;
        }
        min_baseline = nat_baseline = -1;
    }
    
    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition creq, sreq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        
        var h = creq.height + HEIGHT_STEP, w = creq.width + 24;
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});

        cr.move_to(1, 1);
        cr.line_to(16, 1);
        cr.arc_negative(24, 1, 8, Math.PI, 0);
        cr.line_to(w-1, 1);
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
        
        content.allocate_size({12, HEIGHT_STEP/2+2, creq.width, creq.height }, -1);
        stmt.allocate_size({0, h, (sreq.width>0)?sreq.width:w, sreq.height }, -1);
        
        base.snapshot(snapshot);
    }
    
    public override string serialize() {
        return "STATEMENT";
    }
}
