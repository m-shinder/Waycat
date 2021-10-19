abstract class Python381.SimpleStmtBase : StatementBase {
    protected Gdk.RGBA color;
    protected Gtk.Box content = null;
    public const int HEIGHT_STEP = 16;
    public SmallStmtCheck small = new SmallStmtCheck();
    public abstract Python.Parser.Node get_small_node();

    protected SimpleStmtBase(string color, Gtk.Box content) {
        base();
        this.color.parse(color);
        this.content = content;
        this.content.set_parent(this);

        stmt.set_parent(this);
    }

    public override void dispose() {
        content.unparent();
        stmt.unparent();
        base.dispose();
    }

    public override bool on_workbench() {
        var list = content.observe_children();
        for (uint i=0; i < list.get_n_items(); i++) {
            var comp = list.get_item(i) as BlockComponent;
            if (comp != null)
                comp.on_workbench();
        }
        stmt.on_workbench();
        return true;
    }

    public override Python.Parser.Node get_node() {
        var simple = new Python.Parser.Node(Python.Token.SIMPLE_STMT);
        SimpleStmtBase cont = this;
        while (cont.small.checked) {
            simple.add_child(Python.Token.SMALL_STMT, null, 0,0,0,0);
            simple.set_child(simple.size-1, cont.get_small_node());
            cont = cont.stmt.item as SimpleStmtBase;
            if (cont == null) // not simple, but may be compound
                break;
            simple.add_child(Python.Token.SEMI, ";", 0,0,0,0);

        }
        simple.add_child(Python.Token.NEWLINE, "\n", 0,0,0,0);
        return simple;
    }

    public override void measure (Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        Gtk.Requisition creq, sreq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            minimum = natural = (int)Math.fmax(creq.width + 24, sreq.width);
        } else {
            minimum = natural = creq.height + sreq.height + HEIGHT_STEP;
        }
        min_baseline = nat_baseline = -1;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition creq, sreq;
        content.get_preferred_size(out creq, null);
        stmt.get_preferred_size(out sreq, null);

        var h = creq.height + HEIGHT_STEP, w = creq.width + 24;
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});

        cr.move_to(1, 1);
        cr.line_to(16, 1);
        cr.arc_negative(24, 1, 8, Math.PI, 0);
        cr.line_to(w-1, 1);
        cr.line_to(w-1, h);
        cr.line_to(32, h);
        cr.arc(24, h, 8, 0, Math.PI);
        cr.line_to(1, h);
        cr.close_path();

        cr.set_source_rgba (1, 1, 1, 1);
        cr.set_line_width(1);
        cr.stroke_preserve();
        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.fill();

        content.allocate_size({12, HEIGHT_STEP/2+2, creq.width, creq.height }, -1);
        stmt.allocate_size({0, h, (sreq.width>0)?sreq.width:w, sreq.height }, -1);

        base.snapshot(snapshot);
    }
}
