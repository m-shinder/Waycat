using Python;
using Python381;
class Python381.NodeBuilder : GLib.Object {
    public static string[] operators = {
        ", ", " := ", " or ", " and ", " not ",
        " < ", " > ", " == ", " >= ", " <= ",
        " <> ", " != ", " in ", "not in", " is ", "is not",
        " | ", " ^ ", " & ", " >> ", " << ", " + ", " - ",
        " * ", " / ", " // ", " % "," ** ",
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

    public string wrap_for_operator(RoundBlock? blk, string op) {
        if (blk == null)
            return "";
        var block = blk as SeparatedExpr;
        if (block == null)
            return blk.serialize();

        string inside = block.separator;
        bool needpar = preced(inside, op);
        if (needpar)
            return "(" + block.serialize() + ")" ;
        return blk.serialize();
    }

    // is left need to be parentesized like (2 + 2) * 2 (L is + and * is right)
    private bool preced(string left, string right) {
        bool needpar = false;
        for (int i=0; i < operators.length; i++) {
            if (operators[i] == left)
                return true;
            if (operators[i] == right)
                break;
        }
        if (operator_level(left) <= operator_level(right))
            return true;
        return false;
        return needpar;
    }

    private int operator_level(string op) {
        switch (op) {
        case ", ":
            return 0;
        case " := ":
            return 1;
        case " or ":
        case " and ":
        case " not ":
            return 2;
        case " < ":
        case " > ":
        case " == ":
        case " >= ":
        case " <= ":
        case " <> ":
        case " != ":
        case " in ":
        case "not in":
        case " is ":
        case "is not":
            return 3;
        case " | ":
        case " ^ ":
        case " & ":
            return 4;
        case " >> ":
        case " << ":
            return 5;
        case " + ":
        case " - ":
        case " * ":
        case " / ":
        case " // ":
        case " % ":
            return 6;
        case " ** ":
            return 7;
        }
        return 999;
    }
}
