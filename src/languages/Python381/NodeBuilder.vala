using Python;
using Python381;
class Python381.NodeBuilder : GLib.Object {
    public static string[] operators = {
        ", ", " := ", " or ", " and ", " not ",
        " < ", " > ", " == ", " >= ", " <= ",
        " <> ", " != ", " in ", "not in", " is ", "is not",
        " | ", " ^ ", " & ", " >> ", " << ", " + ", " - ",
        " * ", " / ", " % "," ** ",
    };
    private static NodeBuilder _instance = null;
    public static NodeBuilder  instance {
        get {
            if ( _instance == null)
                _instance = new NodeBuilder();
            return _instance;
        }
        private set { _instance = value; }
    }
    private NodeBuilder() {

    }

    public string serialize(AnchorHeader[] anchors) {
        return "";
    }

    public string wrap_for_operator(RoundBlock blk, string op) {
        var block = blk as SeparatedExpr;
        if (block == null)
            return blk.serialize();

        bool needpar = false;
        string inside = block.separator;
        for (int i=0; i < operators.length; i++) {
            if (operators[i] == inside)
                needpar = true;
            if (operators[i] == op)
                break;
        }
        if (needpar)
            return "(" + block.serialize() + ")" ;
        return blk.serialize();
    }
}
