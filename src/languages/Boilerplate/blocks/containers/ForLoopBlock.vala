class Boilerplate.ForLoopBlock : ContainerBlock {
    public ForLoopBlock (uint cat_id, uint blk_id) {
        base(cat_id, blk_id);
        ((Gtk.Label)content.get_first_child()).label = "For";
        content.append(new Gtk.Label("from"));
        content.append(new RoundPlace());
        content.append(new Gtk.Label("to"));
        content.append(new RoundPlace());
        content.append(new Gtk.Label("by"));
        content.append(new RoundPlace());
    }
    
    public override string serialize() {
        string next = "";
        string iter = "";
        string from = "";
        string to = "";
        string by = "";
        string body = "";
        var round = content.get_last_child() as RoundPlace;
        if (round.item != null)
            by = round.item.serialize();
        
        round = round.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (round.item != null)
            to = round.item.serialize();
        round = round.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (round.item != null)
            from = round.item.serialize();
        round = round.get_prev_sibling().get_prev_sibling() as RoundPlace;
        if (round.item != null)
            iter = round.item.serialize();
        
        if (this.body.stmt != null)
            body = this.body.stmt.serialize().replace("\n", "\n\t");
        if (stmt != null)
            next = stmt.serialize();
        var ret = @"for $iter from $from to $to by $by do\n\t$body\nend";
        if (next != "")
            return ret + "\n" + next;
        return ret;
    }
}
