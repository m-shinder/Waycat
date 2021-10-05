class Boilerplate.EntrypointBlock : Waycat.Block, IStatementPlace {
    public Gtk.TextMark start = null;
    public Gtk.TextMark end = null;
    public Statement stmt {get;set; default=null;}
    protected Gtk.Box content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
    protected Gtk.DropTarget dropTarget = new Gtk.DropTarget(typeof(Waycat.DragWrapper), Gdk.DragAction.COPY);
    private Gtk.Requisition nreq = Gtk.Requisition();
    //private Gtk.TextMark content_start = null;
    //private Gtk.TextMark content_end = null;

    public EntrypointBlock(uint cat, uint blk, string type) {
        base(cat, blk);

        content.set_parent(this);
        content.set_margin_end(5);
        content.append(new Gtk.Label(type));
        content.append(new RoundPlace());
        content.append(new Gtk.Label("returns"));
        content.append(new AnglePlace());
    }
    
    public override void dispose() {
        content.unparent();
        if(stmt != null)
            stmt.get_parent().unparent();
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
        Gtk.Requisition req;
        nreq = Gtk.Requisition();
        content.get_preferred_size(out req, null);
        if (stmt != null) {
            stmt.get_preferred_size(out nreq, null);
        }
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = (int)Math.fmax(15 + req.width, nreq.width);
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = 30 + nreq.height + ((stmt == null)?7:0);
            minimum_baseline = natural_baseline = -1;
        }
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req;
        var h = get_height() - nreq.height + ((stmt == null)?0:7), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});
        //content.get_preferred_size(out req, null);
        //stmt.get_preferred_size(out req, null);

        cr.move_to(0, 0);
        cr.line_to(w, 0);
        cr.line_to(w, h-7);

        cr.line_to(29, h-7);
        cr.arc(22, h-7, 7, 0, Math.PI);
        //cr.line_to(45, h-7);
        //cr.arc(38, h-7, 7, 0, Math.PI);
        cr.line_to(0, h-7);

        cr.close_path();
        cr.set_source_rgba (0,0.8,0,1);
        cr.fill_preserve();
        cr.set_source_rgba (1,1,1,1);
        cr.set_line_width(1);
        cr.stroke();

        content.get_preferred_size(out req, null);
        content.allocate_size({15, 7, req.width, req.height }, -1);
        if (stmt != null) {
            stmt.get_parent().get_preferred_size(out req, null);
            stmt.get_parent().allocate_size({0, 30, req.width, req.height }, -1);
        }
        base.snapshot(snapshot);
    }

    public override bool break_free() {
        return true;
    }

    public override bool on_workbench() {
        var item = content.get_first_child();
        print("sup\n");
        while (item != null) {
            var witem = (item as IWorkbenchItem);
            if (witem != null)
                witem.on_workbench();
            item = item.get_next_sibling();
        }
        dropTarget.on_drop.connect(this.dropTarget_on_drop_cb);
        this.add_controller(dropTarget);
        print("sup\n");
        return true;
    }
    
    public override string serialize() {
        string type = ((Gtk.Label)content.get_first_child()).label.ascii_down();
        string name = "";
        string ret_type = "";
        string body = "";
        var angle = content.get_last_child() as AnglePlace;
        var round = angle.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (angle.item != null)
            ret_type = angle.item.serialize();
        if (round.item != null)
            name = round.item.serialize();
        if (stmt != null)
            body = stmt.serialize().replace("\n", "\n\t");
        
        return @"$type $name() : $ret_type\ndo\n\t$body\nend";
    }
}
