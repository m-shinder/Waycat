class Python381.ToggleButton : LabelButtonBase {
    public ToggleButton (string s1, string s2) {
        base(s1, true);
        bool first = true;
        released.connect(() => {
            if (first)
                text = s2;
            else
                text = s1;
            first = !first;
        });
    }

    public override Python.Parser.Node get_node() {
        return null;
    }
}
