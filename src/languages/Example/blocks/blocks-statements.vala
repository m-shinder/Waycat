namespace Example {
    class Program : EntrypointBlock {
        public RoundPlace namePlace = new RoundPlace();
        public AnglePlace typePlace = new AnglePlace();

        public Program() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("Program"));
            content.append(namePlace);
            content.append(typePlace);
        }

        public override string serialize() {
            string name = namePlace.serialize();
            string type = typePlace.serialize();
            string body = stmt.serialize().replace("\n", "\n\t");
            return @"program $name() : $type\ndo$body\nend";
        }
    }

    class Function : EntrypointBlock {
        public RoundPlace namePlace = new RoundPlace();
        public AnglePlace typePlace = new AnglePlace();

        public Function() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("Function"));
            content.append(namePlace);
            content.append(typePlace);
        }

        public override string serialize() {
            string name = namePlace.serialize();
            string type = typePlace.serialize();
            string body = stmt.serialize().replace("\n", "\n\t");
            return @"function $name() : $type\ndo$body\nend";
        }
    }

    class Declare : StatementBlock {
        public RoundPlace namePlace = new RoundPlace();
        public AnglePlace typePlace = new AnglePlace();

        public Declare() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("variable"));
            content.append(namePlace);
            content.append(typePlace);
        }

        public override string serialize() {
            string name = namePlace.serialize();
            string type = typePlace.serialize();
            string next = stmt.serialize();
            return @"declare $name: $type;$next";
        }
    }

    class Assign : StatementBlock {
        public RoundPlace namePlace = new RoundPlace();
        public RoundPlace valuePlace = new RoundPlace();

        public Assign() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("set"));
            content.append(namePlace);
            content.append(new Gtk.Label("to"));
            content.append(valuePlace);
        }

        public override string serialize() {
            string name = namePlace.serialize();
            string val = valuePlace.serialize();
            string next = stmt.serialize();
            return @"$name := $val;$next";
        }
    }

    class Exec : StatementBlock {
        public RoundPlace namePlace = new RoundPlace();

        public Exec() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("exec"));
            content.append(namePlace);
        }

        public override string serialize() {
            string name = namePlace.serialize();
            string next = stmt.serialize();
            return @"$name;$next";
        }
    }

    class SmartPrintf : StatementBlock {
        public AnglePlace typePlace = new AnglePlace();
        public RoundPlace namePlace = new RoundPlace();

        public SmartPrintf() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("print"));
            content.append(typePlace);
            content.append(namePlace);
        }

        public override string serialize() {
            string type = Angle2printf(typePlace.item);
            string name = namePlace.serialize();
            string next = stmt.serialize();
            return @"printf(\"$type\\n\", $name);$next";
        }
    }

    class SmartScanf : StatementBlock {
        public AnglePlace typePlace = new AnglePlace();
        public RoundPlace namePlace = new RoundPlace();

        public SmartScanf() {
            base("orange", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5));
            content.append(new Gtk.Label("read"));
            content.append(typePlace);
            content.append(namePlace);
        }

        public override string serialize() {
            string type = Angle2printf(typePlace.item);
            string name = namePlace.serialize();
            string next = stmt.serialize();
            return @"scanf(\"$type\", @$name);$next";
        }
    }
}
