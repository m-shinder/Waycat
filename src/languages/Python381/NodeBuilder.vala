using Python381;
class Python381.NodeBuilder : Object{
    private static NodeBuilder _instance = null;
    public static NodeBuilder instance {
        get {
            if ( _instance == null)
                _instance = new NodeBuilder();
            return _instance;
        }
        private set { _instance = value; }
    }

    private NodeBuilder() {

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
        bool parse_simple = (file[i][0].type == Python.Token.SIMPLE_STMT);

        if (!parse_simple) {
            i++;
            return anchor;
        }
        while( file[i].type != Python.Token.ENDMARKER && !file[i].indirect() ){
            i++;
            while(file[i].type == Python.Token.NEWLINE)
                i++;
        }
        return anchor;
    }
}
