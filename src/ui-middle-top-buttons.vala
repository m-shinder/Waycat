namespace Waycat {
    private File file = null;
    public void setup_middle_top_buttons(Gtk.Box toplevel, Gtk.Fixed workbench, Language lang) {
        var leftbox = toplevel.get_first_child() as Gtk.Box;
        var midbox = leftbox.get_next_sibling() as Gtk.Box;
        var rightbox = midbox.get_next_sibling() as Gtk.Box;
        
        setup_open_buttons(leftbox, workbench, lang);
        setup_workflow_buttons(midbox, workbench, lang);
    }

    public void setup_open_buttons(Gtk.Box _open, Gtk.Fixed workbench, Language lang) {
        var open = _open.get_first_child() as Gtk.Button;
        open.clicked.connect(() => {
            var dialog = new Gtk.FileChooserDialog(
                    "Open File", (Gtk.Window)workbench.get_root(), Gtk.FileChooserAction.OPEN,
                    "Cancel", -6, "Open", -3, null);
             dialog.response.connect((response) => {
                if (response == -3) {
                    file = dialog.get_file();
                    dialog.destroy();
                    place_blocks_on_workbench(workbench, lang.open_iStream(file.read()));
                } else {
                    dialog.destroy();
                }
            });
            dialog.show();
        });
    }

    public void setup_workflow_buttons(Gtk.Box save_sync_run, Gtk.Fixed workbench, Language lang) {
        var save = save_sync_run.get_first_child() as Gtk.Button;
        var sync = save.get_next_sibling() as Gtk.Button;
        var run  = sync.get_next_sibling() as Gtk.Button;
        
        save.clicked.connect(() => {
            if (file == null) {
                var dialog = new Gtk.FileChooserDialog(
                    "Save as", (Gtk.Window)workbench.get_root(), Gtk.FileChooserAction.SAVE,
                    "Cancel", -6, "Save", -3,
                null);
                dialog.response.connect((response) => {
                    if (response == -3) {
                        file = dialog.get_file();
                    }
                    dialog.destroy();
                    save_helper(lang, file);
                });
                dialog.show();
            } else {
                save_helper(lang, file);
            }
        });
        
        sync.clicked.connect(() => {
            var list = workbench.observe_children(); 
            for (uint i=0; i < list.get_n_items(); i++) {
                var wrapper = list.get_item(i) as DragWrapper;
                var block = wrapper.get_child() as Block;
                lang.update_remove(block);
                lang.update_insert(block);
            }
        });

        run.clicked.connect(() => {
            lang.run();
        });
    }

    private void save_helper(Language lang, File? file) {
        if (file == null )
            return;
        try {
            lang.save_buffer_to_oStream(file.replace(null, false, FileCreateFlags.NONE, null));
        }
        catch (Error e) {
            print("Error\n");
        }
    }

    private void place_blocks_on_workbench(Gtk.Fixed workbench, Block[] blocks) {
        int place_as_x = 20;
        int place_as_y = 20;
        var list = workbench.observe_children();
        while (list.get_n_items() != 0)
            workbench.remove(list.get_item(0) as Gtk.Widget);

        foreach (var block in blocks) {
            Gtk.Requisition req;
            workbench.put(new DragWrapper(block), place_as_x, place_as_y);
            block.get_preferred_size(out req, null);
            place_as_y += req.height + 20;
        }
    }
}
