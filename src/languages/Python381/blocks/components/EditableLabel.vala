class Python381.EditableLabel : BlockComponent {
    public const int WIDTH_STEP = 8;
    private Gtk.Label label = new Gtk.Label("");
    private Gtk.Entry entry = new Gtk.Entry();
    private string text {
        get {
            return label.label;
        }
        set {
            label.label = value;
        }
    }

    public EditableLabel(string text) {
        this.text = text;
        label.set_parent(this);
        entry.set_parent(this);
        entry.set_opacity(0);
        entry.visible = false;
    }

    public override void dispose() {
        entry.unparent();
        base.dispose();
    }

    public override bool on_workbench() {
        var click = new Gtk.GestureClick();
        entry.text = text;
        entry.changed.connect((e) => {
            text = entry.get_text();
        });

        click.released.connect((gest, n_press, x, y) => {
            if ( this.contains(x, y) == false )
                return;

            if (entry.visible == true) {
                entry.visible = false;
            } else {
                entry.visible = true;
                entry.grab_focus();
            }
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
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum += WIDTH_STEP;
            natural += WIDTH_STEP;
        }
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        if (entry.visible) {
            cr.move_to(0, h);
            cr.line_to(w - WIDTH_STEP/2, h);
            cr.close_path();

            cr.set_source_rgba (1, 0, 0, 1);
            cr.set_line_width(3);
            cr.stroke();
            entry.get_preferred_size(null, null);
            entry.allocate_size({0,0, 56,34}, -1);
        }

        label.allocate_size({WIDTH_STEP/2,0, w-WIDTH_STEP,h}, -1);

        base.snapshot(snapshot);
    }

    public override string serialize() {
        return text;
    }
}
