namespace Example {
    class TypeInteger : AngleBlock {
        public TypeInteger() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("integer"));
        }

        public override string serialize() {
            return "integer";
        }
    }

    class TypeChar : AngleBlock {
        public TypeChar() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("char"));
        }

        public override string serialize() {
            return "char";
        }
    }

    class TypeVoid : AngleBlock {
        public TypeVoid() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("void"));
        }

        public override string serialize() {
            return "void";
        }
    }

    class TypeFloat : AngleBlock {
        public TypeFloat() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("float"));
        }

        public override string serialize() {
            return "float";
        }
    }

    class TypeString : AngleBlock {
        public TypeString() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("string"));
        }

        public override string serialize() {
            return "%s";
        }
    }
    class TypePointer : AngleBlock {
        public AnglePlace type = new AnglePlace();

        public TypePointer() {
            base("blue", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(new Gtk.Label("pointer to"));
        }

        public override string serialize() {
            return "pointer to" + type.serialize();
        }
    }

    class EditableRound : RoundBlock {
        public EditableLabel lbl = new EditableLabel("name");

        public EditableRound() {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(lbl);
        }

        public override string serialize() {
            return lbl.serialize();
        }
    }

    class FunctionCall : RoundBlock {
        public EditableLabel lbl = new EditableLabel("function");
        public RoundPlace argsPlace = new RoundPlace();

        public FunctionCall() {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            content.append(lbl);
            content.append(argsPlace);
        }

        public override string serialize() {
            string name = lbl.serialize();
            string args = argsPlace.serialize();
            return @"$name($args)";
        }
    }

    class RoundPair : RoundBlock {
        public RoundPlace left = new RoundPlace();
        public RoundPlace right = new RoundPlace();
        public Gtk.Label lbl = null;

        public RoundPair(string text) {
            base("purple", new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4));
            lbl = new Gtk.Label(text);
            content.append(left);
            content.append(lbl);
            content.append(right);
        }

        public override string serialize() {
            return left.serialize() + lbl.label + right.serialize();
        }
    }
}
