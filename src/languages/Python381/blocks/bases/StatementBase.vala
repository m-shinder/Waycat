abstract class Python381.StatementBase : Block {
    [CCode (cname = "next_stmt")]
    public StatementPlace stmt = new StatementPlace(8);
    protected StatementBase() {

    }

}
