namespace Mee
{
	[CCode(cname = "struct printf_info", cheader_filename="printf.h")]
	public struct PrintInfo
	{
		public int prec;			/* Precision.  */
		public int width;			/* Width.  */
		public int spec;			/* Format letter.  */
		public uint is_long_double;/* L flag.  */
		public uint is_short;	/* h flag.  */
		public uint is_long;	/* l flag.  */
		public uint alt;		/* # flag.  */
		public uint space;		/* Space flag.  */
		public uint left;		/* - flag.  */
		public uint showsign;	/* + flag.  */
		public uint group;		/* ' flag.  */
		public uint extra;		/* For special use.  */
		public uint is_char;	/* hh flag.  */
		public uint wide;		/* Nonzero for wide character streams.  */
		public uint i18n;		/* I flag.  */
		uint __pad;		/* Unused so far.  */
		public ushort user;	/* Bits for user-installed modifiers.  */
		public int pad;			/* Padding character.  */
	}
	
	[CCode(cname = "PA_POINTER", cheader_filename = "printf.h")]
	public static int PA_POINTER;
	
	[CCode(has_target = false)]
	public delegate int printf_function(GLib.FileStream file, PrintInfo info, void **args);
	[CCode(has_target = false)]
	public delegate int printf_arginfo_size_function(PrintInfo info, size_t n, int *argtypes, int *size);
	[CCode(cname = "register_printf_specifier", cheader_filename = "printf.h")]
	public static int register_printf_specifier(int spec, printf_function func, printf_arginfo_size_function arginfo);
	
	[CCode(has_target = false)]
	public delegate GLib.Type TypeGetFunc ();
	[CCode(cname = "g_module_symbol", cheader_filename = "gmodule.h")]
	public static bool retrieve_symbol(GLib.Module mod, string symbol_name, void *pointer);
}
