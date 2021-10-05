class Boilerplate.DeclarationStmtBlock : StatementBlock {
    public DeclarationStmtBlock(uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        
        content.append(new Gtk.Label("Variable"));
        content.append(new RoundPlace());
        content.append(new Gtk.Label("of type"));
        content.append(new AnglePlace());
    }
    
    public override string serialize() {
        string next = "";
        string name = "";
        string type = "";
        var typeC = content.get_last_child() as AnglePlace;
        var nameC = typeC.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (typeC.item != null)
            type = typeC.item.serialize();
        if (nameC.item != null)
            name = nameC.item.serialize();
        if (this.stmt != null)
            next = this.stmt.serialize();
        if (next != "")
            return @"declare $name: $type;\n$next";
        return @"declare $name: $type;";
    }
}
