class Example.ReverseContainerBlock : StatementBase {
    public StatementPlace body = new StatementPlace(32);
    
    public ReverseContainerBlock(string color, Gtk.Box content) {
        base(color, content);
        this.body.set_parent(this);
    }
    
    public override void dispose() {
        body.unparent();
        content.unparent();
        stmt.unparent();
        base.dispose();
    }
    public override bool on_workbench() {
        body.on_workbench();
        base.on_workbench();
        return true;
    }
    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition creq, sreq, breq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        body.get_preferred_size(out breq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = (int)Math.fmax(creq.width + 24, 
                                     Math.fmax(breq.width, sreq.width));
        } else {
            minimum = natural = creq.height + sreq.height + breq.height + HEIGHT_STEP;
        }
        min_baseline = nat_baseline = -1;
    }
    
    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition creq, sreq, breq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        body.get_preferred_size(out breq, null);
        
        var header = breq.height + HEIGHT_STEP;
        var h = header + creq.height, w = creq.width + 24;
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});

        cr.move_to(1, 1);
        cr.line_to(16, 1);
        cr.arc_negative(24, 1, 8, Math.PI, 0);
        cr.line_to(w-1, 1);
        
        cr.line_to(w-1, HEIGHT_STEP);
        cr.line_to(48, HEIGHT_STEP);
        cr.arc(40, HEIGHT_STEP, 8, 0, Math.PI);
        cr.line_to(16, HEIGHT_STEP);
        
        cr.line_to(16, header-HEIGHT_STEP/2);
        cr.line_to(w-1, header-HEIGHT_STEP/2);
        
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
        
        body.allocate_size({16, HEIGHT_STEP, (breq.width>0)?breq.width:(w-16), breq.height }, -1);
        content.allocate_size({12, (int)(h - HEIGHT_STEP/4 - creq.height), creq.width, creq.height }, -1);
        stmt.allocate_size({0, h, (sreq.width>0)?sreq.width:w, sreq.height }, -1);
        
        base.snapshot(snapshot);
    }
    
    public override string serialize() {
        return "STATEMENT";
    }
}
