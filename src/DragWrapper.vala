namespace Waycat {
    class DragWrapper : Gtk.Widget {
        public double mousex;
        public double mousey;
        Gtk.Widget child;

        public DragWrapper (Gtk.Widget child) {
            this.child = child;
            child.set_parent(this);
            this.halign = Gtk.Align.START;
            this.valign = Gtk.Align.START;

            int m, n;
            measure(Gtk.Orientation.VERTICAL, -1, out m, out n, null, null);
        }
        
        public Gtk.Widget get_child()
        {
            return child;
        }

        public override void dispose()
        {
            child.unparent();
        }

        public override Gtk.SizeRequestMode get_request_mode()
        {
            return child.get_request_mode();
        }

        public override void measure (Gtk.Orientation orientation,
                                     int for_size,
                                     out int minimum,
                                     out int natural,
                                     out int minimum_baseline,
                                     out int natural_baseline) {

            child.measure(orientation, for_size,
                    out minimum, out natural,
                    out minimum_baseline, out natural_baseline);
        }

        public override void snapshot (Gtk.Snapshot snapshot) {
            child.allocate_size({0,0, get_width(), get_height()}, -1);

            base.snapshot(snapshot);
        }
    }
}
