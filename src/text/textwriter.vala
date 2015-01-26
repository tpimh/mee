namespace Mee {
	public abstract class TextWriter : GLib.Object {
		public abstract void write (GLib.Value value);
		
		public void writef (string format, ...) {
			write (format.printf (va_list()));
		}
		
		public void write_line (GLib.Value value) {
			write (value);
			write ('\n');
		}
		
		public abstract Encoding encoding { owned get; }
	}
}
