interface Boilerplate.IStatementPlace : Gtk.Widget {
    public abstract Statement stmt {get; set; default = null;}
    
    public bool dropTarget_on_drop_cb(Value val, double x, double y) {
        if ( this.pick(x, y, Gtk.PickFlags.DEFAULT)
            .get_ancestor(typeof(IStatementPlace)) != this)
                return false;
        var wrapper = val.get_object() as Waycat.DragWrapper;
        var block = wrapper.get_child() as Statement;
        if (block != null) {
            wrapper.unparent();
            if (stmt != null) {
                var last = block;
                while (last.stmt != null)
                    last = last.stmt as Statement;
                last.set_next(stmt);
            }
            
            wrapper.set_parent(this);
            stmt = block;
        }
        return true;
    }
}
