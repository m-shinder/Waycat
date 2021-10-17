abstract class Example.Block : Waycat.Block {
    private static uint id = 0;
    
    public static void reset_count() {
        id = 0;
    }
    protected Block() {
        base(0, id++);
    }
    
    public virtual string serialize() {
        return "UEO";
    }
    
    public override Gtk.SizeRequestMode get_request_mode() {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }
}
