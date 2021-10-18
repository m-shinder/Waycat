abstract class Python381.CheckBase : BlockComponent {
    public bool checked { get; protected set; }
    public const int SIZE = 16;

    protected CheckBase(bool init) {
        checked = init;
        this.valign = Gtk.Align.CENTER;
    }

    public override bool on_workbench() {
        var click = new Gtk.GestureClick();
        click.released.connect((gest, n_press, x, y) => {
            if ( this.contains(x, y) == false )
                return;
            checked = !checked;
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
            minimum = natural = SIZE;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.arc(w/2, h/2, SIZE/2-1, 0, 2*Math.PI);

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        if (checked)
            cr.set_source_rgba (1, 0, 0, 1);
        else
            cr.set_source_rgba (0, 1, 0, 1);
        cr.fill();
        base.snapshot(snapshot);
    }
}
