namespace Boilerplate {
    public BoilerplateLanguage lang;
}
public class BoilerplateLanguage : Waycat.Language {
    public BoilerplateLanguage() {
        buffer = new Gtk.SourceBuffer(tag_table);
        Boilerplate.lang = this;
    }
    
    public override Waycat.Category[] get_categories() {
        return {
            new Waycat.Category("blue", "blue", 0),
            new Waycat.Category("green", "green", 1),
            new Waycat.Category("red", "red", 2)
        };
    }
    
    public override Waycat.Block[] get_blocks() {
        return {
            new Boilerplate.EntrypointBlock(0, 0, "Program"),
            new Boilerplate.EntrypointBlock(0, 1, "Function"),
            new Boilerplate.AssignStmtBlock(0, 2),
            new Boilerplate.DeclarationStmtBlock(0, 3),
            new Boilerplate.ExpressionStmtBlock(0, 4),
            new Boilerplate.ContainerBlock(0, 5),
            new Boilerplate.ReverseContainerBlock(0, 6),
            new Boilerplate.DoubleContainerBlock(0, 7),
            new Boilerplate.ForLoopBlock(0, 8),
            new Boilerplate.EditableRoundBlock(0, 9),
            new Boilerplate.CallRoundBlock(0, 10),
            new Boilerplate.DoubleRoundBlock(0, 11, ","),
            new Boilerplate.DoubleRoundBlock(0, 12, ">"),
            new Boilerplate.DoubleRoundBlock(0, 13, "<"),
            new Boilerplate.DoubleRoundBlock(0, 14, "=="),
            new Boilerplate.DoubleRoundBlock(0, 15, ">="),
            new Boilerplate.DoubleRoundBlock(0, 16, "=<"),
            new Boilerplate.AngleBlock(0, 17, "void"),
            new Boilerplate.AngleBlock(0, 18, "integer"),
            new Boilerplate.AngleBlock(0, 19, "float"),
            new Boilerplate.AngleBlock(0, 20, "char"),
        };
    }
    
    public override bool update_insert(Waycat.Block block) {
        var entry = block as Boilerplate.EntrypointBlock;
        if (entry == null) {
            entry = (Boilerplate.EntrypointBlock)
                        block.get_ancestor(typeof(Boilerplate.EntrypointBlock));
            if (entry != null)
                update_remove(entry);
        }
        
        if (entry != null) {
            Gtk.TextIter end;
            buffer.get_end_iter(out end);
            if (entry.start == null) {
                entry.start = new Gtk.TextMark(null, true);
                buffer.add_mark(entry.start, end);
            }
            if (entry.end == null) {
                entry.end = new Gtk.TextMark(null, false);
                buffer.add_mark(entry.end, end);
            }
            buffer.insert(ref end, entry.serialize(), entry.serialize().length);
            return true;
        }
        return false;
    }
    
    public override bool update_remove(Waycat.Block block) {
        var entry = block as Boilerplate.EntrypointBlock;
        if (entry == null) {
            entry = (Boilerplate.EntrypointBlock)
                        block.get_ancestor(typeof(Boilerplate.EntrypointBlock));
            if (entry != null) {
                update_remove(entry);
                block.break_free();
                update_insert(entry);
            } else {
                block.break_free();
            }
        } else {
            Gtk.TextIter start, end;
            buffer.get_iter_at_mark(out start, entry.start);
            buffer.get_iter_at_mark(out end, entry.end);
            buffer.@delete(ref start, ref end);
            buffer.move_mark(entry.end, start);
            return true;
        }
        return false;
    }
    
    public override bool save_buffer_to_oStream(FileOutputStream fileo) {
        Gtk.TextIter start, end;
        buffer.get_start_iter(out start);
        buffer.get_end_iter(out end);
        return fileo.write_all(buffer.get_text(start, end, true).data, null, null);
    }
}
