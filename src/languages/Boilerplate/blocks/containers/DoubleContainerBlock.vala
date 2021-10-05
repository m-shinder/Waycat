class Boilerplate.DoubleContainerBlock : Statement, IStatementPlace{
    private StatementPlace first_body = new StatementPlace();
    private StatementPlace second_body = new StatementPlace();
    private Gtk.Label else_lb = new Gtk.Label("else");
    
    public DoubleContainerBlock(uint cat, uint blk) {
        base(cat, blk);

        content.append(new Gtk.Label("if"));
        content.append(new RoundPlace());
        first_body.set_parent(this);
        second_body.set_parent(this);
        else_lb.set_parent(this);
    }
    
    public override void dispose() {
        first_body.unparent();
        second_body.unparent();
        else_lb.unparent();
        base.dispose();
    }

    public override Gtk.SizeRequestMode get_request_mode() {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        base.measure(orientation, for_size, out minimum, out natural, out minimum_baseline, out natural_baseline);
        if (orientation == Gtk.Orientation.VERTICAL) {
            Gtk.Requisition fbreq, sbreq;
            first_body.get_preferred_size(out fbreq, null);
            second_body.get_preferred_size(out sbreq, null);
            minimum = natural = natural + fbreq.height + sbreq.height + 30;
        }
    }
    
    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req, nreq, fbreq, sbreq;
        req = nreq = sbreq = sbreq = Gtk.Requisition();
        if (stmt != null)
            stmt.get_preferred_size(out nreq, null);
        first_body.get_preferred_size(out fbreq, null);
        second_body.get_preferred_size(out sbreq, null);
        
        var h = get_height() - nreq.height + ((stmt == null)?0:7), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});
        //content.get_preferred_size(out req, null);
        //stmt.get_preferred_size(out req, null);

        cr.move_to(0, 0);
        cr.line_to(15, 0);
        cr.arc_negative(22, 0, 7, Math.PI, 0);
        cr.line_to(w, 0);
        
        cr.line_to(w, 30);
        cr.line_to(45, 30);
        cr.arc(38, 30, 7, 0, Math.PI);
        cr.line_to(15, 30);
        
        cr.line_to(15, 30 + fbreq.height -7);
        cr.line_to(w, 30 + fbreq.height -7);
        
        cr.line_to(w, 60 + fbreq.height -7);
        cr.line_to(45, 60 + fbreq.height -7);
        cr.arc(38, 60 + fbreq.height -7, 7, 0, Math.PI);
        cr.line_to(15, 60 + fbreq.height -7);
        
        cr.line_to(15, 60 + fbreq.height + sbreq.height -7-7);
        cr.line_to(w, 60 + fbreq.height + sbreq.height -7-7);
        
        cr.line_to(w, 60 + fbreq.height + sbreq.height);
        cr.line_to(29, 60 + fbreq.height + sbreq.height);
        cr.arc(22, 60 + fbreq.height + sbreq.height, 7, 0, Math.PI);
        cr.line_to(0, 60 + fbreq.height + sbreq.height);

        cr.close_path();
        cr.set_source_rgba(1,0,1,1);
        cr.fill_preserve();
        cr.set_source_rgba (1,1,1,1);
        cr.set_line_width(1);
        cr.stroke();

        content.get_preferred_size(out req, null);
        content.allocate_size({15, 7, req.width, req.height }, -1);
        if (stmt != null) {
            stmt.get_parent().get_preferred_size(out req, null);
            stmt.get_parent().allocate_size({0, 45+fbreq.height, req.width, req.height }, -1);
        }
        else_lb.get_preferred_size(out req, null);
        first_body.allocate_size({15, 30, fbreq.width, fbreq.height }, -1);
        else_lb.allocate_size({15, 30 + fbreq.height, req.width, req.height }, -1);
        second_body.allocate_size({15, 60 -7 + fbreq.height, sbreq.width, sbreq.height }, -1);
        if (stmt != null) {
            stmt.get_parent().get_preferred_size(out req, null);
            stmt.get_parent().allocate_size({0, 60+fbreq.height + sbreq.height, req.width, req.height }, -1);
        }
        
        base.snapshot(snapshot);
    }
    
    public override bool on_workbench() {
        first_body.on_workbench();
        second_body.on_workbench();
        return base.on_workbench();
    }
    
    public override string serialize() {
        string next = "";
        string cond = "";
        string fbody = "";
        string sbody = "";
        var round = content.get_last_child() as RoundPlace;
        if (round.item != null)
            cond = round.item.serialize();
        if (first_body.stmt != null)
            fbody = first_body.stmt.serialize().replace("\n", "\n\t");
        if (second_body.stmt != null)
            fbody = second_body.stmt.serialize().replace("\n", "\n\t");
        if (stmt != null)
            next = stmt.serialize();
        if (next != "")
            return @"if $cond do\n\t$fbody\nelse\n$sbody\nend\n$next\n";
        return @"if $cond do\n\t$fbody\nelse\n$sbody\nend\n";
    }
}
