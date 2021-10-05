class Boilerplate.StatementBlock : Statement, IStatementPlace {

    public StatementBlock(uint cat, uint blk) {
        base(cat, blk);
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req =  Gtk.Requisition();
        Gtk.Requisition nreq = Gtk.Requisition();
        content.get_preferred_size(out req, null);
        if (stmt != null)
            stmt.get_preferred_size(out nreq, null);
        
        var h = get_height() - nreq.height + ((stmt == null)?0:7), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});
        //content.get_preferred_size(out req, null);
        //stmt.get_preferred_size(out req, null);

        cr.move_to(0, 0);
        cr.line_to(15, 0);
        cr.arc_negative(22, 0, 7, Math.PI, 0);
        cr.line_to(w, 0);
        cr.line_to(w, h-7);

        cr.line_to(29, h-7);
        cr.arc(22, h-7, 7, 0, Math.PI);
        //cr.line_to(45, h-7);
        //cr.arc(38, h-7, 7, 0, Math.PI);
        cr.line_to(0, h-7);

        cr.close_path();
        cr.set_source_rgba (1,0,1,1);
        cr.fill_preserve();
        cr.set_source_rgba (1,1,1,1);
        cr.set_line_width(1);
        cr.stroke();

        content.allocate_size({15, 7, req.width, req.height }, -1);
        if (stmt != null) {
            stmt.get_parent().get_preferred_size(out req, null);
            stmt.get_parent().allocate_size({0, 30, req.width, req.height }, -1);
        }
        base.snapshot(snapshot);
    }
}
