namespace Mee {
	public class StringWriter : TextWriter {
		StringBuilder sb;
		
		public StringWriter (StringBuilder? builder = null) {
			sb = new StringBuilder();
			if (builder != null)
				sb.append (builder.str);
		}
		
		public string to_string() {
			return sb.str;
		}
		
		public override void write (GLib.Value value) {
			if (value.type() == typeof (bool))
				sb.append ((bool)value ? "1" : "0");
			else if (value.type() == typeof (char))
				sb.append_c ((char)value);
			else if (value.type() == typeof (int8))
				sb.append (((int8)value).to_string());
			else if (value.type() == typeof (uint8))
				sb.append (((uint8)value).to_string());
			else if (value.type() == typeof (int))
				sb.append (((int)value).to_string());
			else if (value.type() == typeof (uint))
				sb.append (((uint)value).to_string());
			else if (value.type() == typeof (int64))
				sb.append (((int64)value).to_string());
			else if (value.type() == typeof (uint64))
				sb.append (((uint64)value).to_string());
			else if (value.type() == typeof (long))
				sb.append (((long)value).to_string());
			else if (value.type() == typeof (ulong))
				sb.append (((ulong)value).to_string());
			else if (value.type() == typeof (float))
				sb.append (((float)value).to_string());
			else if (value.type() == typeof (double))
				sb.append (((double)value).to_string());
			else if (value.type() == typeof (string))
				sb.append ((string)value);
		}
		
		public override Encoding encoding {
			owned get {
				return Encoding.utf8;
			}
		}
	}
}
