abstract class Python381.StatementBase : Block {
    [CCode (cname = "next_stmt")]
    public StatementPlace stmt = new StatementPlace(8);
    protected StatementBase() {

    }

    public override bool break_free() {
        var place = get_parent().get_parent() as StatementPlace;
        if (place != null)
            place.item = null;
        return true;
    }

}
