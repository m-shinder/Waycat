namespace Example {
    string Angle2printf(AngleBlock? type) {
        if (type == null)
            return "";
        if (type.get_type() == typeof(TypeInteger) )
            return "%d";
        if (type.get_type() == typeof(TypeChar) )
            return "%c";
        if (type.get_type() == typeof(TypeVoid) )
            return "";
        if (type.get_type() == typeof(TypeFloat) )
            return "%f";
        if (type.get_type() == typeof(TypePointer) )
            return "%p";
        if (type.get_type() == typeof(TypeString) )
            return "%p";
        return "";
    }
}
