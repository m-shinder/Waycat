abstract class Boilerplate.ValueBlock : Waycat.Block {
    protected Gtk.Label label { get; private set; default = new Gtk.Label(" "); }
    protected Gdk.RGBA color;
    protected string text {
        get {
            return label.label;
        }
        set {
            label.label = value;
        }
    }

    protected ValueBlock(uint cat, uint blk, string color) {
        base(cat, blk);
        this.color.parse(color);
        label.set_parent(this);
    }

    public override void dispose() {
        label.unparent();
    }

    public override Gtk.SizeRequestMode get_request_mode() {
        return label.get_request_mode();
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int minimum_baseline,
                                 out int natural_baseline) {
        Gtk.Requisition req;
        label.get_preferred_size(out req, null);
        if (orientation == Gtk.Orientation.HORIZONTAL)
        {
            minimum = natural = (int)Math.fmax(30, req.width + req.height);
            minimum_baseline = natural_baseline = -1;

        } else {
            minimum = natural = req.height;
            minimum_baseline = natural_baseline = -1;
        }
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        base.snapshot(snapshot);
    }
    
    public override string serialize() {
        return text;
    }
}
