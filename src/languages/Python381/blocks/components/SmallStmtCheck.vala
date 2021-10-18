class Python381.SmallStmtCheck : CheckBase {
    public SmallStmtCheck() {
        base(false);
    }

    public override Python.Parser.Node get_node() {
        if (checked)
            return new Python.Parser.Node(Python.Token.SEMI);
        return new Python.Parser.Node(Python.Token.NEWLINE);
    }
}
