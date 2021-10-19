using Python;
namespace Python381 {
    class FuncDef : MultiContainerBase {
        public FuncDef () {
            base("orange", {
                Stanza(new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5), new StatementPlace(32)),
            });
            stanzas[0].content.append(new Gtk.Label("function"));
            stanzas[0].content.append(new AnglePlace());
            stanzas[0].content.append(new RoundPlace());

            footer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 1);
            //footer.append(new ToggleButton("+", "+"));
            footer.set_parent(this);
        }
        public override Parser.Node get_node() {
            return null;
        }
    }
}
