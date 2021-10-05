class Waycat.WaycatApp : Gtk.Application {
    public WaycatApp () {
        Object(
            application_id: "com.example.dnd",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate() {
        Gtk.Builder builder = new Gtk.Builder();

        try {
            builder.add_from_resource("/com/example/ui/window.ui");
        } catch (Error e) {
            print("failed to open ui resource: %s", e.message);
        }

        var win = (Gtk.Window)builder.get_object("window");
        Language lang = new ExampleLanguage();
        var workbench = (Gtk.Fixed)builder.get_object("workbench");
        workbench_setup(workbench, lang);
        leftSidemenu_setup((Gtk.ScrolledWindow)builder.get_object("blocks-scroll"), lang);
        setup_rightStack((Gtk.Stack)builder.get_object("right-stack"), lang.buffer);
        setup_middle_top_buttons((Gtk.Box)builder.get_object("middle-top-buttons"), workbench, lang);
        win.set_application(this);
        win.present();
    }
}
