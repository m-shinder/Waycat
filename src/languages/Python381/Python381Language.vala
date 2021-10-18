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
            new ExprStmt(),
            new DelStmt(),
            new GlobalStmt(),
            new NonlocalStmt(),
            new AssertStmt(),
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
                update_remove(anchor);
                block.break_free();
                update_insert(anchor);
            } else {
                block.break_free();
            }
        } else {
            Gtk.TextIter start, end;
            buffer.get_iter_at_mark(out start, anchor.start);
            buffer.get_iter_at_mark(out end, anchor.end);
            buffer.@delete(ref start, ref end);
            buffer.move_mark(anchor.end, start);
            return true;
        }
        return false;
    }

    public override bool update_insert(Waycat.Block block) {
        var anchor = block as AnchorHeader;
        if (anchor == null) {
            anchor = (AnchorHeader)
                        block.get_ancestor(typeof(AnchorHeader));
            if (anchor != null)
                update_remove(anchor);
        }

        if (anchor != null) {
            Gtk.TextIter end;
            buffer.get_end_iter(out end);
            if (anchor.start == null) {
                anchor.start = new Gtk.TextMark(null, true);
                buffer.add_mark(anchor.start, end);
            }
            if (anchor.end == null) {
                anchor.end = new Gtk.TextMark(null, false);
                buffer.add_mark(anchor.end, end);
            }
            buffer.insert(ref end, "", 0);
            return true;
        }
        return false;
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

    private Waycat.Block[] get_blocks_from_buffer() {
        Gtk.TextIter start, end;
        buffer.get_start_iter(out start);
        buffer.get_end_iter(out end);
        var fileNode = Python.Parser.SimpleParseString(
                buffer.get_text(start, end, true).data,
                Python.Token.FILE_INPUT
        );
        int size = 0;
        var list = new Gee.ArrayList<Waycat.Block>(null);
        AnchorHeader temp = null;
        while ((temp = next_AnchorHeader(fileNode, ref size)) != null)
            list.add(temp);

       Waycat.Block[] blocks = new Waycat.Block[list.size];
       size = 0;
       foreach (Waycat.Block blk in list)
            blocks[size++] = blk;
        return blocks;
    }

    private AnchorHeader? next_AnchorHeader(Python.Parser.Node file, ref int i) {
        while(file[i].type == Python.Token.NEWLINE)
            i++;
        if (file[i].type == Python.Token.ENDMARKER)
            return null;

        var anchor = new AnchorHeader();
        bool parse_simple = (file[i][0].type == Python.Token.SIMPLE_STMT);

        if (!parse_simple) {
            i++;
            return anchor;
        }
        while( file[i].type != Python.Token.ENDMARKER && !file[i].indirect() ){
            i++;
            while(file[i].type == Python.Token.NEWLINE)
                i++;
        }
        return anchor;
    }
}
