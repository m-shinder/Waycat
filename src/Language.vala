public class Waycat.Category : Object {
    public string name;
    public string color;
    public int id;

    public Category(string name, string color, int id)
    {
        this.name = name;
        this.color = color;
        this.id = id;
    }
}

public abstract class Waycat.Language : Object {
    protected Gtk.TextTagTable tag_table = new Gtk.TextTagTable();
    public Gtk.SourceBuffer buffer {get; protected set;}
    
    public abstract Category[] get_categories();
    public abstract Block[] get_blocks();
    
    public abstract bool update_insert(Waycat.Block block);
    public abstract bool update_remove(Waycat.Block block);
    public abstract bool save_buffer_to_oStream(FileOutputStream fileo);
    public abstract Block[] open_iStream(FileInputStream fileo);
    public abstract void run();
}
