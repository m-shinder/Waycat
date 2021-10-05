class Boilerplate.RoundBlock : ValueBlock {
    public RoundBlock (uint cat, uint blk, string color) {
        base(cat, blk, color);
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req;
        var h = get_height(), w = get_width();
        label.get_preferred_size(out req, null);

        var cr = snapshot.append_cairo({{0,0}, {w, h}});


        cr.arc(h/2, h/2, h/2, Math.PI/2, -Math.PI/2);
        cr.line_to(w - h/4, 0);
        cr.arc(w - h/2, h/2, h/2, -Math.PI/2, Math.PI/2);
        cr.close_path();

        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.fill();

        base.snapshot(snapshot);
    }

    public override bool break_free() {
        var parent = this.get_parent().get_parent() as RoundPlace;
        if (parent == null)
            return true;
        parent.set_item(null);
        return true;
    }
}
