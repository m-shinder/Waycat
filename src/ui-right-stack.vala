namespace Waycat {
    public void setup_rightStack(Gtk.Stack stack, Gtk.TextBuffer code_buffer) 
            requires ( (code_buffer as Gtk.TextBuffer) != null ) {
        var buttonsBox = ((Gtk.Box)stack.get_parent()).get_first_child();
        var button = (Gtk.ToggleButton)buttonsBox.get_first_child();
        var group_holder = new Gtk.ToggleButton();
        var last_toggled = group_holder;
        
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
        stack.set_visible_child_name("source");
        ((GtkSource.View)stack.get_child_by_name("source")).set_buffer(code_buffer);
    }
}
