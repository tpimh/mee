namespace Mee {
	public class StreamWriter : TextWriter {
		Encoding base_encoding;
		OutputStream base_stream;
		
		public StreamWriter.from_path (string path, Encoding base_encoding = Encoding.utf8) throws GLib.Error {
			var file = File.new_for_path (path);
			if (file.query_exists()) {
				base_stream = file.open_readwrite().output_stream;
				this.base_encoding = base_encoding;
				
			}
			else {
				base_stream = file.create (FileCreateFlags.NONE);
				this.base_encoding = base_encoding;
			}
		}
		
		public StreamWriter (OutputStream base_stream, Encoding base_encoding = Encoding.utf8) {
			this.base_encoding = base_encoding;
			this.base_stream = base_stream;
		}
		
		public override void write (GLib.Value value) {
			if (value.type() == typeof (bool))
				base_encoding.write_chars (base_stream, (bool)value ? "1" : "0");
			else if (value.type() == typeof (char))
				base_encoding.write_chars (base_stream, ((char)value).to_string());
			else if (value.type() == typeof (int8))
				base_encoding.write_chars (base_stream, ((int8)value).to_string());
			else if (value.type() == typeof (uint8))
				base_encoding.write_chars (base_stream, ((uint8)value).to_string());
			else if (value.type() == typeof (int))
				base_encoding.write_chars (base_stream, ((int)value).to_string());
			else if (value.type() == typeof (uint))
				base_encoding.write_chars (base_stream, ((uint)value).to_string());
			else if (value.type() == typeof (int64))
				base_encoding.write_chars (base_stream, ((int64)value).to_string());
			else if (value.type() == typeof (uint64))
				base_encoding.write_chars (base_stream, ((uint64)value).to_string());
			else if (value.type() == typeof (long))
				base_encoding.write_chars (base_stream, ((long)value).to_string());
			else if (value.type() == typeof (ulong))
				base_encoding.write_chars (base_stream, ((ulong)value).to_string());
			else if (value.type() == typeof (float))
				base_encoding.write_chars (base_stream, ((float)value).to_string());
			else if (value.type() == typeof (double))
				base_encoding.write_chars (base_stream, ((double)value).to_string());
			else if (value.type() == typeof (string))
				base_encoding.write_chars (base_stream, (string)value);
		}
		
		public override Encoding encoding {
			owned get {
				return base_encoding;
			}
		}
	}
}
