class Boilerplate.ReverseContainerBlock : ContainerBlock {
    public ReverseContainerBlock (uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
    }
    
    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req, nreq, breq;
        req = nreq = breq = Gtk.Requisition();
        if (stmt != null)
            stmt.get_preferred_size(out nreq, null);
        if (body != null)
            body.get_preferred_size(out breq, null);
        var h = get_height() - nreq.height + ((stmt == null)?0:7), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});
        //content.get_preferred_size(out req, null);
        //stmt.get_preferred_size(out req, null);

        cr.move_to(0, 0);
        cr.line_to(15, 0);
        cr.arc_negative(22, 0, 7, Math.PI, 0);
        cr.line_to(w, 0);
        cr.line_to(w, 15);
        cr.line_to(45, 15);
        cr.arc(38, 15, 7, 0, Math.PI);
        cr.line_to(15, 15);
        
        cr.line_to(15, 15 + breq.height -7);
        cr.line_to(w, 15 + breq.height -7);
        cr.line_to(w, 45 + breq.height);
        cr.line_to(29, 45 + breq.height);
        cr.arc(22, 45+breq.height, 7, 0, Math.PI);
        cr.line_to(0, 45 + breq.height);

        cr.close_path();
        cr.set_source_rgba (1,0,1,1);
        cr.fill_preserve();
        cr.set_source_rgba (1,1,1,1);
        cr.set_line_width(1);
        cr.stroke();

        content.get_preferred_size(out req, null);
        content.allocate_size({15, h-15-req.height, req.width, req.height }, -1);
        if (stmt != null) {
            stmt.get_parent().get_preferred_size(out req, null);
            stmt.get_parent().allocate_size({0, 45+breq.height, req.width, req.height }, -1);
        }
        if (body != null) 
            body.allocate_size({15, 15, breq.width, breq.height }, -1);
        base.direct_snapshot(snapshot);
    }
    
    public override string serialize() {
        string next = "";
        string cond = "";
        string body = "";
        var round = content.get_last_child() as RoundPlace;
        if (round.item != null)
            cond = round.item.serialize();
        if (this.body.stmt != null)
            body = this.body.stmt.serialize().replace("\n", "\n\t");
        if (stmt != null)
            next = stmt.serialize();
        if (next != "")
            return @"repeat\n\t$body\nwhile $cond;\n$next";
        return @"repeat\n\t$body\nwhile $cond;";
    }
}
