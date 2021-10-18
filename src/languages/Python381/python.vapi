[CCode (lower_case_cprefix = "Py_", cheader_filename = "Python.h,node.h")]
namespace Python
{
    public void Initialize ();
    public void Finalize ();
    public void Main([CCode (array_length_pos = 0.1)] string[] args);

    [CCode (lower_case_cprefix = "PyRun_")]
    namespace Run
    {
        public void SimpleString (string @string);
    }

	[CCode (cname = "PyObject", cprefix = "PyObject_",
	ref_function = "Py_INCREF", unref_function = "Py_DECREF" )]
	[Compact]
	public class Object {
	}

	[CCode (cprefix = "PyCF_")]
	public enum CF {
		SOURCE_IS_UTF8,
		DONT_IMPLY_DEDENT,
		ONLY_AST,
		IGNORE_COOKIE,
		TYPE_COMMENTS,
		ALLOW_TOP_LEVEL_AWAIT,
		COMPILE_MASK
	}

	// valac ignore struct's `default_value`, so it should be separate constant
	[CCode (cname = "_PyCompilerFlags_INIT")]
	public const CompilerFlags CF_INIT;
	[CCode (cname = "PyCompilerFlags", default_value = "_PyCompilerFlags_INIT" )]
	public struct CompilerFlags {
		[CCode (cname = "cf_flags")]
		public int flags;
		[CCode (cname = "cf_feature_version")]
		public int feature_version;
	}

	public enum CompilerInput {
		[CCode (cname = "Py_single_input")]
		SINGLE,
		[CCode (cname = "Py_file_input")]
		FILE,
		[CCode (cname = "Py_eval_input")]
		EVAL,
		[CCode (cname = "Py_func_type_input")]
		FUNC_TYPE
	}

	public Python.Object CompileStringFlags(string source,
											string file, CompilerInput type, ref CompilerFlags f);

	[CCode (lower_case_cprefix = "PyParser_")]
	namespace Parser {
		[CCode (cname = "struct _node", cprefix="", free_function = "PyNode_Free")]
		[Compact]
		public class Node {
			public short  n_type;
			public char*  n_str;
			public int    n_lineno;
			public int    n_col_offset;
			public int    n_nchildren;
			public void*  n_child; // it is not array of objects :(
			public int    n_end_lineno;
			public int    n_end_col_offset;
			// functions
			[CCode (cname = "PyNode_New")]
			public Node(int type);
			[CCode (cname = "PyNode_AddChild")]
			public int add_child(int type, uint8* s, int line, int col, int end_line, int end_col);
			[CCode (cname = "PyNode_ListTree")]
			public void list_tree();
			// macro accessors
			[CCode (cname = "CHILD")]
			public unowned Node get(int index);
			public int size   { [CCode (cname = "NCH")]   get; }
			public int type   { [CCode (cname = "TYPE")]   get; }
			public string str { [CCode (cname = "STR")]    get; }
			public int lineno { [CCode (cname = "LINENO")] get; }
			[CCode (cname = "REQ")]
			public void reqtype(int type);
			// my own helpers
			public void set_child(int index, Node newvalue) {
			    unowned var old = this[index];
			    old.n_type = newvalue.n_type;
                old.n_str = newvalue.n_str;
                old.n_lineno = newvalue.n_lineno;
                old.n_col_offset = newvalue.n_col_offset;
                old.n_nchildren = newvalue.n_nchildren;
                old.n_child = newvalue.n_child;
                old.n_end_lineno = newvalue.n_end_lineno;
                old.n_end_col_offset = newvalue.n_end_col_offset;
			}
			public bool indirect() {
			    if (this[0].type == Python.Token.SIMPLE_STMT)
			        return false;
			    if (this[0][0].type == Python.Token.DECORATED)
			        return true;
			    if (this[0][0].type == Python.Token.CLASSDEF)
			        return true;
			    if (this[0][0].type == Python.Token.FUNCDEF)
			        return true;
			    if (this[0][0].type == Python.Token.ASYNC_STMT)
			        if (this[0][0][0].type == Python.Token.FUNCDEF)
			            return true;
		        return false;
			}
		}
		public Node SimpleParseString(uint8* s, Python.Token input);
	}
}
