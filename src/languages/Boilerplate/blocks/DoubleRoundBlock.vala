class Boilerplate.DoubleRoundBlock : RoundBlock {
    protected RoundPlace left = new RoundPlace();
    protected RoundPlace right = new RoundPlace();
    
    public DoubleRoundBlock(uint cat_id, uint blk_id, string mid) {
        base(cat_id, blk_id, "green");
        text = mid;
        left.set_parent(this);
        right.set_parent(this);
    }
    
    public override bool on_workbench() {
        left.on_workbench();
        right.on_workbench();
        return true;
    }
    
    public override void dispose() {
        left.unparent();
        right.unparent();
        base.dispose();
    }
    
    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        Gtk.Requisition req, lreq, rreq;
        label.get_preferred_size(out req, null);
        left.get_preferred_size(out lreq, null);
        right.get_preferred_size(out rreq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = req.width + lreq.width + rreq.width + 15;
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = (int)(Math.fmax(req.height, 
                        Math.fmax(lreq.height, rreq.height))+6);
            minimum_baseline = natural_baseline = -1;
        }
    }
    
    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        Gtk.Requisition req, lreq, rreq;
        label.get_preferred_size(out req, null);
        left.get_preferred_size(out lreq, null);
        right.get_preferred_size(out rreq, null);
        
        left.allocate_size({h/4, h/2-lreq.height/2, lreq.width, lreq.height }, -1);
        label.allocate_size({h/4+lreq.width, h/2-req.height/2, req.width, req.height }, -1);
        right.allocate_size({w - h/4 - rreq.width, h/2-rreq.height/2, rreq.width, rreq.height }, -1);
        
        base.snapshot(snapshot);
    }
    
    public override string serialize() {
        string left = "";
        string right = "";
        if (this.left.item != null)
            left = this.left.item.serialize();
        if (this.right.item != null)
            right = this.right.item.serialize();
        return left + text + right;
    }
}
