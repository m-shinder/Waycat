using Python;
using Python381;
class Python381.NodeBuilder : GLib.Object {
    private static NodeBuilder _instance = null;
    public static NodeBuilder  instance {
        get {
            if ( _instance == null)
                _instance = new NodeBuilder();
            return instance;
        }
        private set { _instance = value; }
    }
    private NodeBuilder() {

    }

    public string serialize(AnchorHeader[] anchors) {
        return "";
    }
}
