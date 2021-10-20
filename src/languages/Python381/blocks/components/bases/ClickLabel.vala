class Python381.ClickLabel : Gtk.Widget {
    public Gtk.Label lbl = null;
    public delegate void Clicked(string s);
    public ClickLabel (string s, Clicked c) {
        lbl = new Gtk.Label(s);
        lbl.set_parent(this);
        var click = new Gtk.GestureClick();
        click.released.connect((gest, n_press, x, y) => {
            if (this.contains(x, y))
                c(lbl.label);
        });
        this.add_controller(click);
    }

    public override void measure(Gtk.Orientation o, int f,
                                 out int m, out int n,
                                 out int mb, out int nb) {
        lbl.measure(o,f, out m, out n, out mb, out nb);
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        lbl.allocate_size({0,0, get_width(), get_height()}, -1);
        base.snapshot(snapshot);
    }
}
