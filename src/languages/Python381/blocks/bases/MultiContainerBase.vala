abstract class Python381.MultiContainerBase : StatementBase {
    public const int CONTENT_OFFSET = 24;
    public const int HEADER_ADDITION = 8; // HEADER_STEP - SEPARATOR_STEP
    public const int SEPARATOR_STEP = 8;
    public const int FOOTER_STEP = 8;
    public Gtk.Box footer;
    public Gee.ArrayList<Stanza?> stanzas;

    protected MultiContainerBase () {
        stanzas = new Gee.ArrayList<Stanza?>();
    }

    public override void measure(Gtk.Orientation orientation,
                                 int for_size,
                                 out int minimum,
                                 out int natural,
                                 out int min_baseline,
                                 out int nat_baseline) {
        min_baseline = nat_baseline = -1;
        minimum = natural = 0;
        if (orientation == Gtk.Orientation.HORIZONTAL) {
            foreach (var stanza in stanzas) {
                Gtk.Requisition creq, sreq;
                stanza.content.get_preferred_size(out creq, null);
                stanza.stmt.get_preferred_size(out sreq, null);
                minimum = (int)Math.fmax(creq.width + CONTENT_OFFSET, sreq.width);
                natural = (int)Math.fmax(natural, minimum);
            }
            Gtk.Requisition req;
            stmt.get_preferred_size(out req, null);
            natural = (int)Math.fmax(natural, req.width);
            footer.get_preferred_size(out req, null);
            natural = (int)Math.fmax(natural, req.width + CONTENT_OFFSET);
        } else {
            foreach (var stanza in stanzas) {
                Gtk.Requisition creq, sreq;
                stanza.content.get_preferred_size(out creq, null);
                stanza.stmt.get_preferred_size(out sreq, null);
                natural += sreq.height + creq.height + SEPARATOR_STEP;
            }
            Gtk.Requisition req;
            stmt.get_preferred_size(out req, null);
            natural += req.height;
            footer.get_preferred_size(out req, null);
            natural += HEADER_ADDITION + req.height + FOOTER_STEP;
        }
        minimum = natural;
    }

    public override void snapshot(Gtk.Snapshot snapshot) {
        Gtk.Requisition creq, sreq;
        measure_stanza(0, out creq, out sreq);
        var h = get_height(), w = get_width();
        var cr = snapshot.append_cairo({{0,0}, {w, h+9}});
        var voffset = 0;

        cr.move_to(1, 1);
        cr.line_to(16, 1);
        cr.arc_negative(24, 1, 8, Math.PI, 0);
        cr.line_to(w-1, 1);

        cr.line_to(w-1, creq.height + HEADER_ADDITION);
        cr.line_to(48, creq.height + HEADER_ADDITION);
        cr.arc(40, creq.height + HEADER_ADDITION, 8, 0, Math.PI);
        cr.line_to(16, creq.height + HEADER_ADDITION);
        stanzas[0].content.allocate_size({
            CONTENT_OFFSET, (int) (SEPARATOR_STEP+HEADER_ADDITION)/2 ,
            creq.width, creq.height - SEPARATOR_STEP
        }, -1);
        stanzas[0].stmt.allocate_size({
            CONTENT_OFFSET, HEADER_ADDITION + creq.height,
            sreq.width, sreq.height
        }, -1);

        voffset += HEADER_ADDITION + creq.height + sreq.height;
        for (int i = 1; i < stanzas.size; i++) {
            measure_stanza(i, out creq, out sreq);
            cr.line_to(16, voffset);
            cr.line_to(w-1,voffset);

            cr.line_to(w-1, voffset + creq.height);
            cr.line_to(48,  voffset + creq.height);
            cr.arc(40, voffset + creq.height, 8, 0, Math.PI);
            cr.line_to(16, voffset + creq.height);

            stanzas[i].content.allocate_size({
                CONTENT_OFFSET, voffset + (int) (SEPARATOR_STEP)/2 ,
                creq.width, creq.height - SEPARATOR_STEP
            }, -1);
            stanzas[i].stmt.allocate_size({
                CONTENT_OFFSET, voffset + creq.height,
                sreq.width, sreq.height
            }, -1);
            voffset += creq.height + sreq.height;
        }
        footer.get_preferred_size(out creq, null);
        cr.line_to(16, voffset);
        cr.line_to(w-1,voffset);

        cr.line_to(w-1, voffset + creq.height);
        cr.line_to(32,  voffset + creq.height);
        cr.arc(24, voffset + creq.height, 8, 0, Math.PI);
        cr.line_to(1, voffset + creq.height);
        cr.close_path();

        footer.allocate_size({
            CONTENT_OFFSET, voffset + (int)FOOTER_STEP/2,
            creq.width, creq.height
        }, -1);

        base.snapshot(snapshot);
    }

    private void measure_stanza(int id, out Gtk.Requisition creq, out Gtk.Requisition sreq) {
        if (stanzas.size < id) {
            sreq = {0,0};
            creq = {0,0};
        } else {
            stanzas[id].content.get_preferred_size(out creq, null);
            stanzas[id].content.get_preferred_size(out sreq, null);
        }
        creq.height += SEPARATOR_STEP;
        if (id == 0)
            creq.height += HEADER_ADDITION;
    }
}
