namespace Mee {
	public class StreamReader : TextReader {
		InputStream stream;
		unichar current_char;
		
		public Encoding encoding { get; private set; }
		
		public bool eof {
			get {
				return peek() == 0;
			}
		}
		
		public StreamReader (InputStream base_stream, Encoding base_encoding = Encoding.utf8) throws GLib.Error {
			stream = base_stream;
			encoding = base_encoding;
			current_char = encoding.read_char (stream);
		}
		
		public StreamReader.from_path (string path, Encoding base_encoding = Encoding.utf8) throws GLib.Error {
			this (File.new_for_path (path).read(), base_encoding);
		}
		
		public override unichar peek() {
			return current_char;
		}
		
		public override unichar read() {
			unichar u = current_char;
			current_char = encoding.read_char (stream);
			return u;
		}
	}
}
