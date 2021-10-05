class Boilerplate.ExpressionStmtBlock : StatementBlock {
    public ExpressionStmtBlock(uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        
        content.append(new Gtk.Label("execute"));
        content.append(new RoundPlace());
    }
    
    public override string serialize() {
        string next = "";
        string expr = "";
        var exprC = content.get_last_child() as RoundPlace;
        if (exprC.item != null)
            expr = exprC.item.serialize();
        if (this.stmt != null)
            next = this.stmt.serialize();
        if (next != "")
            return @"$expr;\n$next";
        return @"$expr;";
    }
}
