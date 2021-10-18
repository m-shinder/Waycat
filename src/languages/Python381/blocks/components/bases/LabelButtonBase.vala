abstract class Python381.LabelButtonBase : BlockComponent {
    public const int SIZE_STEP = 8;
    public signal void released();
    private Gtk.Label label = new Gtk.Label("");
    public string text {
        get { return label.label; }
        set { label.label = value; }
    }
    private bool _active;
    public bool active {
        get {return _active;}
        set {
            if (_active != value) {
                _active = value;
                this.queue_draw();
            }
        }
    }

    protected LabelButtonBase(string text, bool active) {
        this.active = active;
        this.text = text;
        label.set_parent(this);
    }

    public override void dispose() {
        label.unparent();
    }

    public override bool on_workbench() {
        var click = new Gtk.GestureClick();
        click.released.connect((gest, n_press, x, y) => {
            if ( this.contains(x, y) == false )
                return;
            if (active)
                released();
       });

        this.add_controller(click);
        return true;
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
            label.measure(orientation, for_size,
                    out minimum, out natural, out min_baseline, out nat_baseline);
            minimum = natural = natural + SIZE_STEP;
            min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.move_to(4, 1);
        cr.line_to(w-4, 1);
        cr.line_to(w-1, 4);
        cr.line_to(w-1, h-4);
        cr.line_to(w-4, h-1);
        cr.line_to(4, h-1);
        cr.line_to(1, h-4);
        cr.line_to(1, 4);
        cr.close_path();

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        if (active)
            cr.set_source_rgba (0.5, 0.5, 0.5, 1);
        else
            cr.set_source_rgba (0.1, 0.1, 0.1, 1);
        cr.fill();

        Gtk.Requisition lreq;
        label.get_preferred_size(out lreq, null);
        label.allocate_size({
            (w - lreq.width)/2, (h - lreq.height)/2,
            lreq.width, lreq.height
        }, -1);
        base.snapshot(snapshot);
    }
}
