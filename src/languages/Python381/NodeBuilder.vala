using Python;
using Python381;
class Python381.NodeBuilder : GLib.Object{
    private static NodeBuilder _instance = null;
    public static NodeBuilder instance {
        get {
            if ( _instance == null)
                _instance = new NodeBuilder();
            return _instance;
        }
        private set { _instance = value; }
    }

    private NodeBuilder() {

    }

    public Waycat.Block[] parse_node(Python.Parser.Node file) {
        int size = 0;
        var list = new Gee.ArrayList<Waycat.Block>(null);
        AnchorHeader temp = null;
        while ((temp = next_AnchorHeader(file, ref size)) != null) {
            list.add(temp);
        }

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
        anchor.on_workbench();
        var place = anchor.stmt;
        bool parse_indirect = file[i].indirect();

        if (parse_indirect) { // class or func smth
            i++;
            return anchor;
        }
        while( file[i].type != Python.Token.ENDMARKER && !file[i].indirect()) {
            var item = parse_stmt(file[i]);
            var wrapper = new Waycat.DragWrapper(item);
            item.on_workbench();
            place.item = item;
            while (place.item != null)
                place = place.item.stmt;
            i++;
            while(file[i].type == Python.Token.NEWLINE)
                i++;
        }
        return anchor;
    }

    private StatementBase parse_stmt(Parser.Node stmt) requires (stmt.type == Token.STMT) {
        StatementBase result;
        if (stmt[0].type == Token.COMPOUND_STMT)
            result = new ExprStmt(); // XXX
        else // SIMPLE_STMT
            result = parse_simple(stmt[0]);
        return result;
    }

    // simple = small (';' small)* [';'] \n'
    private SimpleStmtBase parse_simple(Parser.Node stmt)
                                requires (stmt.type == Token.SIMPLE_STMT) {
        int i = 0;
        bool cont =  (stmt[i+1].type == Token.SEMI);
        //          && (stmt[i+2].type != Token.NEWLINE);
        SimpleStmtBase res = parse_small(stmt[i], cont);
        var place = res.stmt as StatementPlace;
        i += 2;
        while (cont) {
            cont =  (stmt[i+1].type == Token.SEMI);
            //   && (stmt[i+2].type != Token.NEWLINE);
            if (stmt[i].type != Token.SIMPLE_STMT) // new line heck
                break;
            var s = parse_small(stmt[i], cont);
            var w = new Waycat.DragWrapper(s);
            s.on_workbench();
            place.item = s;
            place = place.item.stmt;
            i+=2;
        }
        return res;
    }

    private SimpleStmtBase parse_small(Parser.Node stmt, bool cont) {
        SimpleStmtBase res = null;
        switch (stmt[0].type) {
            case 0:
            break;
            default:
                res = new ExprStmt();
            break;
        }
        return res;
    }
}
