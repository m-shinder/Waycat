class Boilerplate.AngleBlock : ValueBlock {
    public AngleBlock (uint cat, uint blk, string text) {
        base(cat, blk, "blue");
        this.text = text;
    }

    public override void snapshot (Gtk.Snapshot snapshot) {
        Gtk.Requisition req;
        var h = get_height(), w = get_width();
        label.get_preferred_size(out req, null);
        var hoffset = (get_width() - req.width) / 2;

        //var hoffset = (w - req.width) / 2;
        //var voffset = (h - req.height) / 2;
        var cr = snapshot.append_cairo({{0,0}, {w, h}});

        cr.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        cr.move_to(0, h/2);
        cr.line_to(7, 0);
        cr.line_to(w - 7, 0);
        cr.line_to(w, h/2);

        cr.line_to(w - 7, h);
        cr.line_to(7, h);
        cr.close_path();
        cr.fill();

        label.allocate_size({hoffset, 0, req.width, req.height }, -1);

        base.snapshot(snapshot);
    }
    
    public override bool break_free() {
        var parent = (AnglePlace)this.get_parent().get_parent();
        parent.set_item(null);
        return true;
    }
}
