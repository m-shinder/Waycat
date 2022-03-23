namespace Waycat {
    public void setup_rightStack(Gtk.Stack stack, GtkSource.Buffer code_buffer)
            requires ( (code_buffer as Gtk.TextBuffer) != null ) {
        var buttonsBox = ((Gtk.Box)stack.get_parent()).get_first_child();
        var button = (Gtk.ToggleButton)buttonsBox.get_first_child();
        var group_holder = new Gtk.ToggleButton();
        var last_toggled = group_holder;
        var sourceview = stack.get_child_by_name("source") as GtkSource.View;
        var scheme = GtkSource.StyleSchemeManager.get_default().get_scheme("Adwaita-dark");
        
        while (button != null) {
            button.set_group(group_holder);
            button.toggled.connect((toggled) => {
                if (toggled == last_toggled)
                    return;
                last_toggled = toggled;
                stack.set_visible_child_name(toggled.get_name());
            });
            button = (Gtk.ToggleButton)button.get_next_sibling();
        }
        code_buffer.style_scheme = scheme;
        sourceview.set_buffer(code_buffer);
        stack.set_visible_child_name("source");
    }
}
