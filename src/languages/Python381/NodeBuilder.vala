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
            result = parse_compound(stmt[0]);
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
            case Token.EXPR_STMT:
                res = parse_small_expr(stmt[0]);
            break;
            case Token.DEL_STMT:
                res = new DelStmt();
            break;
            case Token.PASS_STMT:
                res = new DelStmt();
            break;
            case Token.FLOW_STMT:
                res = new ExprStmt(); // TODO
            break;
            case Token.IMPORT_STMT:
                res = parse_small_import(stmt[0]);
            break;
            case Token.GLOBAL_STMT:
                res = new GlobalStmt();
            break;
            case Token.NONLOCAL_STMT:
                res = new NonlocalStmt();
            break;
            case Token.ASSERT_STMT:
                res = new AssertStmt();
            break;
            default:
                res = new ExprStmt();
            break;
        }
        return res;
    }

    private SimpleStmtBase parse_small_expr(Parser.Node stmtexpr) {
        if (stmtexpr.size == 1) {
            var block = new ExprStmt();
            return block;
        }
        var block = new AssignStmt();
        var lhs = parse_small_expr_assign_lhs(stmtexpr[0]);
        var w = new Waycat.DragWrapper(lhs);
        lhs.on_workbench();
        block.leftPlace.item = lhs;
        return block;
    }

    private AngleBlock parse_small_expr_assign_lhs(Parser.Node tlse) {
        if (tlse.size == 1)
            return get_single_nameConst_from_tlse_child(tlse[0]) as AngleBlock;
        return get_single_nameConst_from_tlse_child(tlse[0]) as AngleBlock;
        return null;
    }
    private NameConst get_single_nameConst_from_tlse_child(Parser.Node n) {
        unowned Parser.Node expr;
        if (n.type == Token.TEST)
            expr = n[0][0][0][0][0];
        else
            expr = n[1];
        unowned Parser.Node name = get_name_from_expr(expr);
        var self = new NameConst();
        self.lbl.text = name.n_str;
        return self;
    }
    private unowned Parser.Node get_name_from_expr(Parser.Node expr) {
        return expr[0][0][0][0][0][0][0][0][0][0];
    }

    private RoundBlock parse_small_expr_single(Parser.Node tlse) {
        return null;
    }

    private SimpleStmtBase parse_small_import(Parser.Node import) {
        if (import[0].type == Token.IMPORT_NAME) {
            var block = new ImportNameStmt();
            var w = new Waycat.DragWrapper(parse_small_import_dotNames(import[0][1]));
            block.dotNamesPlace.item = w.get_child() as AngleBlock;
            block.dotNamesPlace.item.on_workbench();
            return block;
        } else {
            return new ImportFromStmt();
        }
    }

    private AngleBlock parse_small_import_dotNames(Parser.Node names) {
        var self = new NameConst();
        self.lbl.text = names[0][0][0].n_str;
        return self;
    }

    private StatementBase parse_compound(Parser.Node stmt) {
        if (stmt[0].type == Token.DECORATED)
            return parse_plain_compound(stmt[0]);
        if (stmt[0].type == Token.ASYNC_STMT)
            return parse_plain_compound(stmt[0]);
        return parse_plain_compound(stmt[0]);
    }

    private MultiContainerBase parse_plain_compound(Parser.Node comp) {
        return new WhileLoop();
    }
}
