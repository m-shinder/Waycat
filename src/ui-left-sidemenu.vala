namespace Waycat {
    private void leftSidemenu_setup(Gtk.ScrolledWindow scrolledWindow, Language lang) {
        var blocks = lang.get_blocks();
        var list = new ListStore(typeof(Block));
        var noselect = new Gtk.NoSelection(list);
        var source = new Gtk.DragSource();
        var target = new Gtk.DropTarget (typeof(DragWrapper), Gdk.DragAction.COPY);
        var factory = new Gtk.SignalListItemFactory();
        DragWrapper mock = null;
        DragWrapper wrapper = null;
        
        for (uint i=0; i < blocks.length; i++) {
            list.append(blocks[i]);
        }
        
        factory.setup.connect((factory, item) => { });
        
        factory.bind.connect((factory, item) => {
            item.child = new DragWrapper((Block)item.item);
        });

        factory.unbind.connect((factory, item) => { });
        
        factory.teardown.connect((factory, item) => {
            item.child = null;
        });
        
        var listview = new Gtk.ListView(noselect, factory);

        source.prepare.connect ((source_origin, x, y) => {
            var picked_widget = listview.pick(x, y, Gtk.PickFlags.DEFAULT);
            mock = (DragWrapper)picked_widget.get_ancestor(typeof(DragWrapper));

            if (mock == null)
                mock = picked_widget as DragWrapper;
            if (mock == null)
                return null;

            var val = Value(typeof(DragWrapper));
            var i = ((Block)mock.get_child()).block_id;
            Graphene.Point p;
            
            listview.compute_point(mock, {(float)x, (float)y}, out p);
            wrapper = new DragWrapper(lang.get_blocks()[i]);
            wrapper.mousex = p.x;
            wrapper.mousey = p.y;
            val.set_object(wrapper);
            var content = new Gdk.ContentProvider.for_value(val);
            return content;
        });
        
        source.drag_begin.connect ((source_origin, drag) => {
            var paintable = new Gtk.WidgetPaintable(mock);

            source_origin.set_icon(paintable, (int)wrapper.mousex, (int)wrapper.mousey);
            mock = null;
            wrapper = null;
        });
        
        source.drag_end.connect ((source_origin, drag, delete_data) => {
            var val = Value(typeof(DragWrapper));
            try {
                drag.get_content().get_value(ref val);
            } catch (Error err) {
                print("Error %s\n", err.message);
            }
            var wrap = (val.get_object() as DragWrapper);
            var block = wrap.get_child() as Block;
            block.on_workbench();
            lang.update_insert(block);
        });
        
        source.drag_cancel.connect ((source_origin, drag, reason) => {
            return false;
        });

        target.on_drop.connect((target, value, x, y) => {
            wrapper = (DragWrapper)value;
            if (wrapper.get_ancestor(typeof(Gtk.ListView)) != listview) {
                wrapper.unparent();
                wrapper.dispose();
            }
            return true;
        });
        
        listview.add_controller(source);
        listview.add_controller(target);
        scrolledWindow.set_child(listview); // TODO: css listview>row:hower { background: inherit; }
        int x;
        scrolledWindow.measure(Gtk.Orientation.HORIZONTAL, -1, null, out x, null, null);
        ((Gtk.Box)scrolledWindow.get_ancestor(typeof(Gtk.Box))).width_request = (x);
        //setup_categories((Gtk.Box)scrolledWindow.get_ancestor(typeof(Gtk.Box)), lang.get_categories());
    }
    
    private void setup_categories(Gtk.Box toplvl, Category[] cats) {
        var groupHolder = new Gtk.ToggleButton();
        var list = new ListStore(typeof(Category));
        var noselect = new Gtk.NoSelection(list);
        var factory = new Gtk.SignalListItemFactory();
        var grid = new Gtk.GridView(noselect, factory);
        
        for (uint i=0; i < cats.length; i++) {
            list.append(cats[i]);
        }
        
        factory.setup.connect((factory, item) => {
            var button = new Gtk.ToggleButton();
            button.set_group(groupHolder);
            button.add_css_class("circular");
            item.child = button;

        });
        
        factory.bind.connect((factory, item) => {
            ((Gtk.ToggleButton)item.child).label =
                    ((Category)item.item).name;
        });
        
        factory.unbind.connect((factory, item) => { });
        
        factory.teardown.connect((factory, item) => {
            item.child = null;
        });
        
        grid.set_min_columns(2);
        grid.set_max_columns(2);
        toplvl.prepend(grid);
    }
}
