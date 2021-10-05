class Boilerplate.AssignStmtBlock : StatementBlock {
    public AssignStmtBlock(uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        
        content.append(new Gtk.Label("Set"));
        content.append(new RoundPlace());
        content.append(new Gtk.Label("to"));
        content.append(new RoundPlace());
    }
    
    public override string serialize() {
        string next = "";
        string vari = "";
        string valu = "";
        var valuC = content.get_last_child() as RoundPlace;
        var variC = valuC.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (valuC.item != null)
            valu = valuC.item.serialize();
        if (variC.item != null)
            vari = variC.item.serialize();
        if (this.stmt != null)
            next = this.stmt.serialize();
        if (next != "")
            return @"$vari := $valu;\n$next";
        return @"$vari := $valu;";
    }
}
