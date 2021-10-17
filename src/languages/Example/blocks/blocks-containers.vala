namespace Example {
    class For : ContainerBlock {
        RoundPlace iterPlace = new RoundPlace();
        RoundPlace fromPlace = new RoundPlace();
        RoundPlace toPlace = new RoundPlace();
        RoundPlace byPlace = new RoundPlace();

        public For() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("for"));
            content.append(iterPlace);
            content.append(new Gtk.Label("from"));
            content.append(fromPlace);
            content.append(new Gtk.Label("to"));
            content.append(toPlace);
            content.append(new Gtk.Label("by"));
            content.append(byPlace);
        }

        public override string serialize() {
            string iter = iterPlace.serialize();
            string from = fromPlace.serialize();
            string to = toPlace.serialize();
            string by = byPlace.serialize();
            string body = this.body.serialize().replace("\n", "\n\t");
            string next = stmt.serialize();
            return @"for $iter from $from to $to by $by do$body\nend$next";
        }
    }

    class While : ContainerBlock {
        RoundPlace condition = new RoundPlace();

        public While() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("while"));
            content.append(condition);
        }

        public override string serialize() {
            string cond = condition.serialize();
            string body = this.body.serialize().replace("\n", "\n\t");
            string next = stmt.serialize();
            return @"while $cond do$body\nend$next";
        }
    }

    class Repeat : ReverseContainerBlock {
        RoundPlace condition = new RoundPlace();

        public Repeat() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("while"));
            content.append(condition);
        }

        public override string serialize() {
            string cond = condition.serialize();
            string body = this.body.serialize().replace("\n", "\n\t");
            string next = stmt.serialize();
            return @"repeat$body\nwhile $cond;$next";
        }
    }

    class If : ContainerBlock {
        RoundPlace condition = new RoundPlace();

        public If() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("if"));
            content.append(condition);
            content.append(new Gtk.Label("then"));
        }

        public override string serialize() {
            string cond = condition.serialize();
            string body = this.body.serialize().replace("\n", "\n\t");
            string next = stmt.serialize();
            return @"if $cond then$body\nend$next";
        }
    }

    class IfElse : DoubleContainerBlock {
        RoundPlace condition = new RoundPlace();

        public IfElse() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4), new Gtk.Label("else"));
            content.append(new Gtk.Label("if"));
            content.append(condition);
            content.append(new Gtk.Label("then"));
        }

        public override string serialize() {
            string cond = condition.serialize();
            string fbody = this.fbody.serialize().replace("\n", "\n\t");
            string sbody = this.sbody.serialize().replace("\n", "\n\t");
            string next = stmt.serialize();
            return @"if $cond then$fbody\nelse$sbody\nend$next";
        }
    }
}
