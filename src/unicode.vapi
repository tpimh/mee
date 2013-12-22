[CCode (cprefix = "G", lower_case_cprefix = "g_", cheader_filename = "glib.h", gir_namespace = "GLib", gir_version = "2.0")]
namespace GLib {
	namespace Ucs4 {
		public string to_utf8 (unichar* unicode, long len, out long read, out long written) throws GLib.Error;
	}
	namespace Utf16 {
		public string to_utf8 (uint16* unicode, long len, out long read, out long written) throws GLib.Error;
	}
}
