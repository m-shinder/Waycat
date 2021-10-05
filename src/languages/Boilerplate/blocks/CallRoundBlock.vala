class Boilerplate.CallRoundBlock : EditableRoundBlock {
    protected RoundPlace args = new RoundPlace();
    public CallRoundBlock(uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        args.set_parent(this);
    }
    
    public override void dispose() {
        args.unparent();
        base.dispose();
    } 
    
    public override bool on_workbench() {
        args.on_workbench();
        return base.on_workbench();
    }
    
    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        Gtk.Requisition req, areq;
        label.get_preferred_size(out req, null);
        args.get_preferred_size(out areq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = req.width + areq.width + 15;
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = (int)(Math.fmax(req.height, areq.height)+6);
            minimum_baseline = natural_baseline = -1;
        }
    }
    
    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        Gtk.Requisition req;
        
        args.get_preferred_size(out req, null);
        args.allocate_size({w - h/4 - req.width, h/2 - req.height/2, req.width, req.height}, -1);
        label.get_preferred_size(out req, null);
        label.allocate_size({
            get_height()/4, get_height()/2 - req.height/2,
            req.width, req.height
        }, -1);
        base.noalloc_snapshot(snapshot);
    }
    
    public override string serialize() {
        string left = "";
        if (args.item != null)
            left = args.item.serialize();
        return @"$text($left)";
    }
}
