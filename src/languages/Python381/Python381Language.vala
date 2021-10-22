using Python381;
class Python381Language : Waycat.Language {
    public Python381Language() {
        buffer = new Gtk.SourceBuffer(tag_table);
    }

    public override Waycat.Category[] get_categories() {
        return {
            new Waycat.Category("all", "blue", 0),
        };
    }

    public override Waycat.Block[] get_blocks() {
        Waycat.Block[] blocks = {
            new AnchorHeader(),
            new ImportNameStmt(),
            new ImportFromStmt(),
            //new FuncDef(),
            new IfStmt(),
            new WhileLoop(),
            new ForLoop(),
            new TryStmt(),
            new WithStmt(),
            new AssignStmt(),
            new ExprStmt(),
            new DelStmt(),
            new GlobalStmt(),
            new NonlocalStmt(),
            new AssertStmt(),
            new NameConst(),
            new CallExpr(),
            new AwaitCallExpr(),
            new SeparatedNames(","),
            new NameAdapter(),
            new SeparatedExpr(","),
        };
        Block.reset_count();
        return blocks;
//        Log.set_fatal_mask("", LogLevelFlags.LEVEL_CRITICAL);
    }

    public override bool update_remove(Waycat.Block block) {
        var anchor = block as AnchorHeader;
        if (anchor == null) {
            anchor = (AnchorHeader)block.get_ancestor(typeof(AnchorHeader));
            if (anchor != null) {
                delete_between_marks(anchor.start, anchor.end);

                buffer.delete_mark(anchor.end);
                anchor.end = null;
                block.break_free();
                print("requesting to refresh anchor\n");
                update_insert(anchor);
            } else {
                block.break_free();
            }
        } else {
            Gtk.TextIter start, end;
            buffer.get_iter_at_mark(out start, anchor.start);
            buffer.get_iter_at_mark(out end, anchor.end);
            buffer.@delete(ref start, ref end);
            buffer.delete_mark(anchor.start);
            buffer.delete_mark(anchor.end);
            anchor.start = anchor.end = null;
            return true;
        }
        return false;
    }

    public override bool update_insert(Waycat.Block block) {
        var anchor = block as AnchorHeader;
        if (anchor == null) {
            anchor = (AnchorHeader)block.get_ancestor(typeof(AnchorHeader));
            if (anchor == null)
                return false;
            delete_between_marks(anchor.start, anchor.end);
            buffer.delete_mark(anchor.end);
            anchor.end = null;
        }
        Gtk.TextIter end;
        if (anchor.start == null) {
            // if start == null, then anchor is "brand new"
            anchor.start = new Gtk.TextMark(null, true);
            anchor.end = new Gtk.TextMark(null, false);
            buffer.get_end_iter(out end);
            buffer.add_mark(anchor.start, end);
        } else {
            // refresh anchor, keeping it position
            if (anchor.end == null) {
                // polite request to refresh, anchor text shoul be removed
                anchor.end = new Gtk.TextMark(null, false);
                buffer.get_iter_at_mark(out end, anchor.start);
            } else {
                // invalid request for refresh
                print("TSNH: invalid request to refresh anchor, exiting\n");
                return false;
            }
        }
        buffer.add_mark(anchor.end, end);
        buffer.insert(ref end, anchor.serialize(), -1);
        set_mark_gravity(ref anchor.end, true);
        return true;
    }

    public override bool save_buffer_to_oStream(FileOutputStream fileo) {
        Gtk.TextIter start, end;
        buffer.get_start_iter(out start);
        buffer.get_end_iter(out end);
        try {
            return fileo.write_all(buffer.get_text(start, end, true).data, null, null);
        } catch (Error e) {
            return false;
        }
    }

    public override Waycat.Block[] open_iStream(FileInputStream filei) {
        buffer.set_text("");
        var input = new DataInputStream(filei);
        string line;
        while ( (line = input.read_line(null)) != null)
            buffer.insert_at_cursor(line + "\n", -1);
        return get_blocks_from_buffer();
    }

    public override void run() {
        print("running\n");
    }

    private Waycat.Block[] get_blocks_from_buffer() {
        Gtk.TextIter start, end;
        buffer.get_start_iter(out start);
        buffer.get_end_iter(out end);
        var fileNode = Python.Parser.SimpleParseString(
                buffer.get_text(start, end, true).data,
                Python.Token.FILE_INPUT
        );
        buffer.set_text("");
        Waycat.Block[] blocks = BlockBuilder.instance.parse_node(fileNode);
        for (int i =0; i < blocks.length; i++)
            update_insert(blocks[i]);
        return blocks;
    }

    private void set_mark_gravity(ref Gtk.TextMark mark, bool gravity) {
        Gtk.TextIter iter;
        string? name = mark.name;
        buffer.get_iter_at_mark(out iter, mark);
        buffer.delete_mark(mark);
        mark = new Gtk.TextMark(name, gravity);
        buffer.add_mark(mark, iter);
    }

    private void delete_between_marks(Gtk.TextMark start, Gtk.TextMark end) {
        Gtk.TextIter s, e;
        buffer.get_iter_at_mark(out s, start);
        buffer.get_iter_at_mark(out e, end);
        buffer.@delete(ref s, ref e);
    }
}
