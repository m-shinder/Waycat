using Python;
using Python381;
class Python381.BlockBuilder : GLib.Object {
    public delegate RoundBlock SepElem(Parser.Node node);
    private static BlockBuilder _instance = null;
    public static BlockBuilder instance {
        get {
            if ( _instance == null)
                _instance = new BlockBuilder();
            return _instance;
        }
        private set { _instance = value; }
    }

    private BlockBuilder() {

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
            var item = parse_token_stmt(file[i]);
            var wrapper = new Waycat.DragWrapper(item);
            item.on_workbench();
            place.item = item;
            i++;
            return anchor;
        }

        while( file[i].type != Python.Token.ENDMARKER && !file[i].indirect()) {
            var item = parse_token_stmt(file[i]);
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

    private StatementBase parse_token_stmt(Parser.Node stmt) requires (stmt.type == Token.STMT) {
        StatementBase result;
        if (stmt[0].type == Token.COMPOUND_STMT)
            result = parse_token_compound_stmt(stmt[0]);
        else // SIMPLE_STMT
            result = parse_token_simple_stmt(stmt[0]);
        return result;
    }

    // simple = small (';' small)* [';'] \n'
    private SimpleStmtBase parse_token_simple_stmt(Parser.Node stmt)
                                requires (stmt.type == Token.SIMPLE_STMT) {
        int i = 0;
        bool cont =  (stmt[i+1].type == Token.SEMI);
        //          && (stmt[i+2].type != Token.NEWLINE);
        SimpleStmtBase res = parse_token_small_stmt(stmt[i], cont);
        var place = res.stmt as StatementPlace;
        i += 2;
        while (cont) {
            cont =  (stmt[i+1].type == Token.SEMI);
            //   && (stmt[i+2].type != Token.NEWLINE);
            if (stmt[i].type != Token.SIMPLE_STMT) // new line heck
                break;
            var s = parse_token_small_stmt(stmt[i], cont);
            var w = new Waycat.DragWrapper(s);
            s.on_workbench();
            place.item = s;
            place = place.item.stmt;
            i+=2;
        }
        return res;
    }

    private SimpleStmtBase parse_token_small_stmt(Parser.Node stmt, bool cont) {
        SimpleStmtBase res = null;
        switch (stmt[0].type) {
            case Token.EXPR_STMT:
                res = parse_small_expr(stmt[0]);
            break;
            case Token.DEL_STMT:
                res = new DelStmt();
            break;
            case Token.PASS_STMT:
                res = new PassStmt();
            break;
            case Token.FLOW_STMT:
                res = parse_token_flow_stmt(stmt[0]);
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
            var item = parse_small_expr_tlse(stmtexpr[0]);
            var w = new Waycat.DragWrapper(item);
            item.on_workbench();
            block.exprPlace.item = item;
            return block;
        }
        var block = new AssignStmt();
        var lhs = parse_small_expr_assign_lhs(stmtexpr[0]);
        var item = parse_small_expr_tlse(stmtexpr[2]);
        var w = new Waycat.DragWrapper(lhs);
        var w2 = new Waycat.DragWrapper(item);
        lhs.on_workbench();
        item.on_workbench();
        block.leftPlace.item = lhs;
        block.rightPlace.item = item;
        return block;
    }

    private AngleBlock parse_small_expr_assign_lhs(Parser.Node tlse) {
        if (tlse.size == 1)
            return get_single_nameConst_from_tlse_child(tlse[0]) as AngleBlock;
        var self = new SeparatedNames(", ");
        var place = self.content.get_first_child() as AnglePlace;
        for (int i=0; i<tlse.size; i+=2) {
            var it = get_single_nameConst_from_tlse_child(tlse[i]);
            var w = new Waycat.DragWrapper(it);
            place.item = it;
            it.on_workbench();
            place = place.get_next_sibling().get_next_sibling() as AnglePlace;
        }
        return self;
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

    private RoundBlock parse_small_expr_tlse(Parser.Node tlse) {
        if (tlse.size == 1) {
            if (tlse[0].type == Token.TEST)
                return parse_token_test(tlse[0]);
            else
                return parse_token_test(tlse[0]);
        }
        RoundBlock self = null;
        return self;
    }

    private RoundBlock parse_token_test(Parser.Node test) {
        if (test[0].type == Token.LAMBDEF)
            return new NameAdapter();
        if (test.size > 1)
            return new NameAdapter();
        return parse_token_orTest(test[0]);
    }

    private RoundBlock parse_token_orTest(Parser.Node ortest) {
        if (ortest.size == 1)
            return parse_token_andTest(ortest[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_andTest(Parser.Node andtest) {
        if (andtest.size == 1)
            return parse_token_notTest(andtest[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_notTest(Parser.Node nottest) {
        if (nottest.size == 1)
            return parse_token_comparasion(nottest[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_comparasion(Parser.Node comp) {
        if (comp.size == 1)
            return parse_token_expr(comp[0]);
        var self = new SeparatedExpr(comp[1][0].n_str);
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i < comp.size; i+=2) {
            var item = parse_token_expr(comp[i]);
            var w = new Waycat.DragWrapper(item);
            place.item = item;
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

    private RoundBlock parse_token_expr(Parser.Node expr) {
        if (expr.size == 1)
            return parse_token_xorExpr(expr[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_xorExpr(Parser.Node xor) {
        if (xor.size == 1)
            return parse_token_andExpr(xor[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_andExpr(Parser.Node and) {
        if (and.size == 1)
            return parse_token_shiftExpr(and[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_shiftExpr(Parser.Node shift) {
        if (shift.size == 1)
            return parse_token_arithExpr(shift[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_arithExpr(Parser.Node arith) {
        if (arith.size == 1)
            return parse_token_term(arith[0]);
        return separated_from_gomogeneous(arith, parse_token_term);
    }

    private RoundBlock parse_token_term(Parser.Node term) {
        if (term.size == 1)
            return parse_token_factor(term[0]);
        return separated_from_gomogeneous(term, parse_token_factor);
    }

    private RoundBlock parse_token_factor(Parser.Node factor) {
        if (factor.size == 1)
            return parse_token_power(factor[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_power(Parser.Node power) {
        if (power.size == 1)
            return parse_token_atomExpr(power[0]);
        return new NameAdapter();
    }

    private RoundBlock parse_token_atomExpr(Parser.Node atomExpr) {
        if (atomExpr.size == 1)
            return parse_token_atom(atomExpr[0]);

        int i = atomExpr.size-1;
        bool await = (atomExpr[0].type != Token.ATOM);
        var self = parse_token_trailer(atomExpr[i], await);
        RoundPlace cur;
        if (self is AwaitCallExpr)
            cur = (self as AwaitCallExpr).function;
        else if (self is CallExpr)
            cur = (self as CallExpr).function;
        else
            cur = (self as DotName).expr;

        for (i = i-1; atomExpr[i].type != Token.ATOM; i--) {
            var t = parse_token_trailer(atomExpr[i], false);
            t.on_workbench();
            var w = new Waycat.DragWrapper(t);
            cur.item = t;
            switch (atomExpr[i][0].n_str) {
                case "(":
                    cur = (self as CallExpr).function;
                break;
                case "[":
                break;
                case ".":
                    cur = (t as DotName).expr;
                break;
            }
        }
        var fun = parse_token_atom(atomExpr[i]);
        var w = new Waycat.DragWrapper(fun);
        fun.on_workbench();
        cur.item = fun;
        return self;
    }

    private RoundBlock parse_token_trailer(Parser.Node trail, bool await) {
        RoundBlock self = null;
        RoundBlock[] intr = null;
        Waycat.DragWrapper[] wraps = null;
        RoundPlace argplace = null;
        switch (trail[0].n_str) {
            case "(":
                if (trail.size > 2) {
                    unowned Parser.Node arglist = trail[1];
                    int len = arglist.size;
                    if (len % 2 == 0) // ended with ',' so even
                        len--;
                    len = (len+1)/2;
                    intr = new RoundBlock[len];
                    wraps = new Waycat.DragWrapper[len];
                    for (int i=0; i < len; i++) {
                        intr[i] = parse_token_argument(arglist[i*2]);
                        intr[i].on_workbench();
                        wraps[i] = new Waycat.DragWrapper(intr[i]);
                    }
                }
                if (await) {
                    var s = new AwaitCallExpr();
                    argplace = (RoundPlace)s.function.get_next_sibling().get_next_sibling();
                    self = s;
                } else {
                    var s = new CallExpr();
                    argplace = (RoundPlace)s.function.get_next_sibling().get_next_sibling();
                    self = s;
                }
                for (int i=0; i < intr.length; i++) {
                    argplace.item = intr[i];
                    argplace = (RoundPlace)argplace.get_next_sibling().get_next_sibling();
                }
            break;
            case "[":
            break;
            case ".":
                var n = new NameConst.with_name(trail[1].n_str);
                n.on_workbench();
                self = new DotName.with_nonwrapped_name(n);
            break;
        }
        return self;
    }

    private RoundBlock parse_token_argument(Parser.Node arg) {
        if (arg[0].type == Token.TEST)
            return parse_token_test(arg[0]);
        return parse_token_test(arg[1]);
    }
    private RoundBlock parse_token_atom(Parser.Node atom) {
        switch (atom[0].type) {
            case Token.LPAR:
                if (atom[1].type == Token.RPAR) return null;
                if (atom[1][0].type == Token.YIELD_EXPR)
                    return new NameAdapter();
                else
                    return parse_token_testlist_comp(atom[1]);
            break;
            case Token.LBRACE:
                if (atom[1].type == Token.RBRACE) return null;
                return parse_token_testlist_comp(atom[1][0]);
            case Token.NAME:
                var a = new NameAdapter();
                var n = new NameConst.with_name(atom[0].n_str);
                n.on_workbench();
                var w = new Waycat.DragWrapper(n);
                a.name.item = n;
                return a;
            case Token.NUMBER:
            case Token.STRING:
                return new ExprConst.with_name(atom[0].n_str);
        }
        return new NameAdapter();
    }

    private RoundBlock parse_token_testlist_comp(Parser.Node tlc) {
        if (tlc.size == 1)
            return parse_token_testlist_comp_single(tlc[0]);
        if (tlc[1].type == Token.COMP_FOR)
            return null;
        var self = new SeparatedExpr(", ");
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i < tlc.size; i+=2) {
            var t = parse_token_testlist_comp_single(tlc[i]);
            var w = new Waycat.DragWrapper(t);
            t.on_workbench();
            place.item = t;
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

    private RoundBlock parse_token_testlist_comp_single(Parser.Node tlcs) {
        if (tlcs.type == Token.NAMEDEXPR_TEST)
            return parse_token_namedexpr_test(tlcs);
        else
            return new NameAdapter();
    }

    private RoundBlock parse_token_namedexpr_test(Parser.Node walrus) {
        if (walrus.size == 1)
            return parse_token_test(walrus[0]);
        return parse_token_test(walrus[0]);
    }

    private RoundBlock parse_token_testlist(Parser.Node list) {
        if (list.size == 1)
            return parse_token_test(list[0]);
        var self = new SeparatedExpr(",");
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i < list.size; i+=2) {
            place.item = parse_token_test(list[i]);
            var w = new Waycat.DragWrapper(place.item);
            place.item.on_workbench();
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

    private RoundBlock parse_token_exprlist(Parser.Node list) {
        if (list.size == 1)
            return parse_token_expr(list[0]);
        var self = new SeparatedExpr(",");
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i < list.size; i+=2) {
            place.item = parse_token_expr(list[i]);
            var w = new Waycat.DragWrapper(place.item);
            place.item.on_workbench();
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

    private SimpleStmtBase parse_token_flow_stmt(Parser.Node flow) {
        switch (flow[0].type) {
            case Token.BREAK_STMT:
                return new BreakStmt();
            case Token.CONTINUE_STMT:
                return new BreakStmt();
            case Token.RETURN_STMT:
                var self = new ReturnStmt();
                if (flow[0].size > 1) {
                    var it = parse_token_test(flow[0][1][0]);
                    var w = new Waycat.DragWrapper(it);
                    self.expression.item = it;
                }
                return self;
            case Token.RAISE_STMT:
            case Token.YIELD_STMT:
                return null;
        }
        return null;
    }

    private SimpleStmtBase parse_small_import(Parser.Node import) {
        if (import[0].type == Token.IMPORT_NAME) {
            var block = new ImportNameStmt();
            var w = new Waycat.DragWrapper(parse_token_dotted_as_names(import[0][1]));
            block.dotNamesPlace.item = w.get_child() as AngleBlock;
            block.dotNamesPlace.item.on_workbench();
            return block;
        } else {
            var self = parse_token_import_from(import[0]);
            return self;
        }
    }

    private AngleBlock parse_token_dotted_as_names(Parser.Node names) {
        var self = new NameConst();
        self.lbl.text = names[0][0][0].n_str;
        return self;
    }

    private SimpleStmtBase parse_token_import_from(Parser.Node from) {
        var self = new ImportFromStmt();
        NameConst dname = null;
        int i;
        for (i=1; i<from.size; i++) {
            if (from[i].n_str == "import")
                break;
            if (from[i].type == Token.DOTTED_NAME) {
                dname = new NameConst.with_name(from[i][0].n_str);
                dname.on_workbench();
                break;
            }
        }
        if (dname == null)
            dname = new NameConst.with_name(".");
        var w = new Waycat.DragWrapper(dname);
        self.sourcePlace.item = dname;
        var names = new NameConst.with_name(from[i+2][0][0].n_str);
        w = new Waycat.DragWrapper(names);
        self.dotNamesPlace.item = names;
        return self;
    }

    private StatementBase parse_token_compound_stmt(Parser.Node stmt) {
        if (stmt[0].type == Token.DECORATED)
            return parse_token_compound_stmt_direct(stmt[0]);
        if (stmt[0].type == Token.ASYNC_STMT)
            return parse_token_compound_stmt_direct(stmt[0]);
        if (stmt[0].type == Token.FUNCDEF)
            return parse_token_funcdef(stmt[0]);
        return parse_token_compound_stmt_direct(stmt[0]);
    }

    private FuncDef parse_token_funcdef(Parser.Node func) {
        var self = new FuncDef();
        var name = new NameConst.with_name(func[1].n_str);
        var args = parse_token_parameters(func[2]);
        var suite = parse_token_suite(func[4]);
        var w = new Waycat.DragWrapper(name);
        self.name.item = name;
        w = new Waycat.DragWrapper(suite);
        self.stanzas[0].stmt.item = suite;
        w = new Waycat.DragWrapper(args);
        suite.on_workbench();
        self.args.item = args;
        return self;
    }

    private SeparatedExpr parse_token_parameters(Parser.Node prms) {
        var self = new SeparatedExpr(", ");
        if (prms.size == 2)
            return self;
        unowned var tal = prms[1];
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i<tal.size; i+=2) {
            var n = new NameConst.with_name(tal[i][0].n_str);
            var a = new NameAdapter.with_nonwrapped_name(n);
            var w = new Waycat.DragWrapper(a);
            place.item = a;
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

    private MultiContainerBase parse_token_compound_stmt_direct(Parser.Node comp) {
        switch (comp.type) {
            case Token.IF_STMT:
                return parse_token_if_stmt(comp);
            case Token.WHILE_STMT:
                return parse_token_while_stmt(comp);
            case Token.FOR_STMT:
                return parse_token_for_stmt(comp);
            case Token.TRY_STMT:
                return parse_token_try_stmt(comp);
            case Token.WITH_STMT:
                return parse_token_while_stmt(comp);
        }
        return new WhileLoop();
    }

    private MultiContainerBase parse_token_if_stmt(Parser.Node ifstmt) {
        var self = new IfStmt();
        var cond = parse_token_namedexpr_test(ifstmt[1]);
        var suite = parse_token_suite(ifstmt[3]);
        var place = self.stanzas[0].content.get_first_child().get_next_sibling() as RoundPlace;
        var w = new Waycat.DragWrapper(suite);
        self.stanzas[0].stmt.item = suite;
        w = new Waycat.DragWrapper(cond);
        place.item = cond;
        self.on_workbench();
        cond.on_workbench();
        return self;
    }
    // while_stmt: 'while' expr ':' suite ['else' ':' suite]
    private MultiContainerBase parse_token_while_stmt(Parser.Node whilestmt) {
        MultiContainerBase self = null;
        var cond = parse_token_namedexpr_test(whilestmt[1]);
        var suite = parse_token_suite(whilestmt[3]);
        if (whilestmt.size > 4) {
            var elsuite = parse_token_suite(whilestmt[6]);
            var w = new Waycat.DragWrapper(elsuite);
            elsuite.on_workbench();
            self = new WhileLoop.with_else(elsuite);
        } else {
            self = new WhileLoop();
        }
        var w = new Waycat.DragWrapper(suite);
        self.stanzas[0].stmt.item = suite;
        var w2 = new Waycat.DragWrapper(cond);
        var place = self.stanzas[0].content.get_first_child().get_next_sibling() as RoundPlace;
        place.item = cond;
        return self;
    }

    private MultiContainerBase parse_token_for_stmt(Parser.Node forstmt) {
        var iter = parse_token_exprlist(forstmt[1]);
        var values = parse_token_testlist(forstmt[3]);
        var suite = parse_token_suite(forstmt[5]);
        var self = new ForLoop();
        var w = new Waycat.DragWrapper(suite);
        self.stanzas[0].stmt.item = suite;
        w = new Waycat.DragWrapper(iter);
        var place = self.stanzas[0].content
                    .get_first_child().get_next_sibling() as RoundPlace;
        place.item = iter;
        place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        w = new Waycat.DragWrapper(values);
        place.item = values;
        self.on_workbench();
        return self;
    }

    private MultiContainerBase parse_token_try_stmt(Parser.Node trystmt) {
        return new TryStmt();
    }
    private MultiContainerBase parse_token_with_stmt(Parser.Node with) {
        return new WithStmt();
    }
    private StatementBase parse_token_suite(Parser.Node suite) {
        if (suite.size == 1)
            return parse_token_simple_stmt(suite[0]);
        StatementBase self = parse_token_stmt(suite[2]);
        StatementPlace place = self.stmt;
        for(int i = 3; i < suite.size - 1; i++) {
            var item = parse_token_stmt(suite[i]);
            var wrapper = new Waycat.DragWrapper(item);
            item.on_workbench();
            place.item = item;
            while (place.item != null)
                place = place.item.stmt;
            while(suite[i].type == Python.Token.NEWLINE)
                i++;
        }
        return self;
    }

    private SeparatedExpr separated_from_gomogeneous(Parser.Node math, SepElem func) {
        var self = new SeparatedExpr(" "+math[1].n_str+" ");
        var place = self.content.get_first_child() as RoundPlace;
        for (int i=0; i < math.size; i+=2) {
            var item = func(math[i]);
            var w = new Waycat.DragWrapper(item);
            place.item = item;
            place = place.get_next_sibling().get_next_sibling() as RoundPlace;
        }
        return self;
    }

}
