namespace Waycat {
    public void workbench_setup(Gtk.Fixed workbench, Language lang) {
        double last_x = 20, last_y = 20;
        var source = new Gtk.DragSource ();
        var target = new Gtk.DropTarget(typeof(DragWrapper), Gdk.DragAction.COPY);
        DragWrapper wrapper = null;

        source.prepare.connect((source_origin, x, y) => {
            var val = Value(typeof(DragWrapper));
            var picked = workbench.pick(x, y, Gtk.PickFlags.DEFAULT);
            Graphene.Point p;
            wrapper = (DragWrapper)picked.get_ancestor(typeof(DragWrapper));

            if (wrapper == null)
                wrapper = picked as DragWrapper;
            if (wrapper == null)
                return null;

            
            workbench.compute_point(wrapper, {(float)x, (float)y}, out p);
            wrapper.mousex = p.x;
            wrapper.mousey = p.y;
            val.set_object(wrapper);
            return new Gdk.ContentProvider.for_value(val);
        });
        
        source.drag_begin.connect((source_origin, drag) => {
            var paintable = new Gtk.WidgetPaintable(wrapper);
            var width = wrapper.get_width();
            var height = wrapper.get_height();

            if (wrapper.get_ancestor(typeof(Gtk.Fixed)) == workbench) {
                if (wrapper.get_parent() != workbench) {
                    lang.update_remove((Block)wrapper.get_child());
                    wrapper.unparent();
                    workbench.put(wrapper, -width, -height);
                } else {
                    lang.update_remove((Block)wrapper.get_child());
                }
                workbench.get_child_position(wrapper, out last_x, out last_y);
                workbench.move(wrapper, -width, -height); //TODO: that's not good
            }
            source_origin.set_icon(paintable, (int)wrapper.mousex, (int)wrapper.mousey);
        });
        
        source.drag_end.connect((source_origin, drag, delete_data) => {
            if (wrapper.get_ancestor(typeof(Gtk.Fixed)) == workbench)
                lang.update_insert((Block)wrapper.get_child());
            wrapper = null;
        });
        source.drag_cancel.connect((source_origin, drag, reason) => {
            if (wrapper.get_parent() == workbench)
                workbench.move(wrapper, last_x, last_y);
            wrapper = null;
            return false;
        });
        
        target.on_drop.connect((target, val, x, y) => {
            var draggable_widget = (DragWrapper)val.get_object();
            var last_item = (DragWrapper)workbench.get_last_child();

            // Bring the moved item in front if it was droped on another item
            if (draggable_widget.get_parent() == workbench)
                if (draggable_widget != last_item) {
                    draggable_widget.insert_after(workbench, last_item);
                }

            if (draggable_widget.get_ancestor(typeof(Gtk.Fixed)) == workbench) {
                if (draggable_widget.get_parent() == workbench)
                    workbench.move(draggable_widget,
                            x - draggable_widget.mousex,
                            y - draggable_widget.mousey
                        );
                else {
                    print("TSNH: workbench.drop_end() get widget that is not child of workbench\n");
                    draggable_widget.unparent();
                    workbench.put(draggable_widget, x - draggable_widget.mousex, y - draggable_widget.mousey);
                }
            } else {
                workbench.put(draggable_widget, x - draggable_widget.mousex, y - draggable_widget.mousey);
            }
            return true;
        });
        
        workbench.add_controller(source);
        workbench.add_controller(target);
    }
}
