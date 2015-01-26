namespace Mee {
	public abstract class Encoding : Object {
		public abstract uint8[] get_bytes (string str, int offset = 0, int count = -1);
		
		public abstract string get_string (uint8[] bytes, int offset = 0, int count = -1);
		
		public virtual unichar[] get_chars (uint8[] bytes, int offset = 0, int count = -1) {
			var list = new Gee.ArrayList<unichar>();
			int pos = 0;
			unichar u;
			string s = get_string (bytes, offset, count);
			while (s.get_next_char (ref pos, out u))
				list.add (u);
			return list.to_array();
		}
		
		public abstract unichar read_char (InputStream stream);
		
		public void write_char (OutputStream stream, unichar u) {
			var bytes = get_bytes (u.to_string());
			stream.write (bytes);
		}
		
		public void write_chars (OutputStream stream, string s) {
			var bytes = get_bytes (s);
			stream.write (bytes);
		}
		
		public abstract string name { owned get; }

		public static Encoding from_path (string path) throws GLib.Error
		{
			uint8[] buffer = new uint8[10];
			File.new_for_path (path).read().read (buffer);
			return from_buffer (buffer);
		}
		
		static int[] n_to_bin (uint8 u)
		{
			var i = 128;
			uint8 tmp = u;
			int[] bin = new int[0];
			while (i >= 1)
			{
				bin += tmp / i;
				tmp -= i * (tmp / i);
				if (i == 1)
					break;
				i /= 2;
			}
			return bin;
		}
		
		public static Encoding from_buffer (uint8[] buffer) {
			if (buffer.length >= 4 &&
				buffer[0] == 0 && buffer[1] == 0 && buffer[2] == 254 && buffer[3] == 255) 
				return new Utf32Encoding();
			if (buffer.length >= 4 &&
				buffer[0] == 255 && buffer[1] == 254 && buffer[2] == 0 && buffer[3] == 0) 
				return new Utf32Encoding (false);
			if (buffer.length >= 3 && buffer[0] == 239 && buffer[1] == 187 && buffer[2] == 191)
				return new Utf8Encoding (true);
			if (buffer.length >= 2 && buffer[0] == 255 && buffer[1] == 254) 
				return new UnicodeEncoding (false);
			if (buffer.length >= 2 && buffer[0] == 254 && buffer[1] == 255) 
				return new UnicodeEncoding();
			if (buffer.length >= 4 && buffer[0] == 0 && buffer[1] < 16)
				return new Utf32Encoding (true, false);
			if (buffer.length >= 4 && buffer[3] == 0 && buffer[2] < 16)
				return new Utf32Encoding (false, false);
			if (buffer.length >= 2 && buffer[0] > 0 && buffer[1] == 0)
				return new UnicodeEncoding (false, false);
			if (buffer.length >= 2 && buffer[0] == 0 && buffer[1] > 0)
				return new UnicodeEncoding (true, false);
			if (buffer.length >= 4) {
				if (buffer[0] >= 216 && buffer[0] <= 219 && buffer[2] >= 220 && buffer[2] <= 223)
					return new UnicodeEncoding (true, false);
				if (buffer[1] >= 216 && buffer[1] <= 219 && buffer[3] >= 220 && buffer[3] <= 223)
					return new UnicodeEncoding (false, false);
			}
			// return UTF-8 by default.
			return new Utf8Encoding();
		}
		
		static uint8 bin_to_n (int[] bin) {
			int res = 128 * bin[0]
					+  64 * bin[1]
					+  32 * bin[2]
					+  16 * bin[3]
					+   8 * bin[4]
					+   4 * bin[5]
					+   2 * bin[6]
					+       bin[7];
			return (uint8)res;
		}
		
		public static new Encoding? get (string name)
		{
			if (name.down() == "utf-8")
				return Encoding.utf8;
			if (name.down() == "ascii" || name.down() == "us-ascii")
				return Encoding.ascii;
			if (name.down() == "latin-1" || name.down() == "iso-8859-1")
				return Encoding.latin1;
			if (name.down() == "utf-16le")
				return new UnicodeEncoding (false);
			if (name.down() == "utf-16be")
				return new UnicodeEncoding();
			if (name.down() == "utf-32le")
				return new Utf32Encoding (false);
			if (name.down() == "utf-32be")
				return new Utf32Encoding();
			return null;
		}

		public static Encoding ascii {
			owned get {
				return new AsciiEncoding();
			}
		}

		public static Encoding big_endian_unicode {
			owned get {
				return new UnicodeEncoding ();
			}
		}

		public static Encoding latin1 {
			owned get {
				return new Latin1Encoding();
			}
		}

		public static Encoding unicode {
			owned get {
				return new UnicodeEncoding (false);
			}
		}

		public static Encoding utf8 {
			owned get {
				return new Utf8Encoding();
			}
		}

		public static Encoding utf32 {
			owned get {
				return new Utf32Encoding (false);
			}
		}
	}

	public class AsciiEncoding : Encoding {
		public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
		{
			uint8[] data = new uint8[0];
			foreach (uint8 u in str.substring (offset, count).data)
				data += u >= 128 ? (uint8)'?' : u;
			return data;
		}

		public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
		{
			string s = "";
			foreach (uint8 u in bytes)
				s += u >= 128 ? "?" : ((char)u).to_string();
			return s.substring (offset, count);
		}
		
		public override unichar read_char (InputStream stream) {
			var buffer = new uint8[1];
			stream.read (buffer);
			return (buffer[0] > 127) ? '?' : (unichar)buffer[0];
		}

		public override string name {
			owned get {
				return "ascii";
			}
		}
	}
	
	public class Latin1Encoding : Encoding {
		public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
		{
			string s = (string)convert (str, str.length, "ISO_8859-1", "UTF-8");
			return s.substring (offset, count).data;
		}

		public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
		{
			string s = (string)convert ((string)bytes, bytes.length, "UTF-8", "ISO_8859-1");
			return s.substring (offset, count);
		}
		
		public override unichar read_char (InputStream stream) {
			var buffer = new uint8[1];
			stream.read (buffer);
			return (unichar)buffer[0];
		}

		public override string name {
			owned get {
				return "latin-1";
			}
		}
	}

	public class UnicodeEncoding : Encoding {
		static int[] n_to_bin (uint8 u)
		{
			var i = 128;
			uint8 tmp = u;
			int[] bin = new int[0];
			while (i >= 1)
			{
				bin += tmp / i;
				tmp -= i * (tmp / i);
				if (i == 1)
					break;
				i /= 2;
			}
			return bin;
		}

		static uint8 bin_to_n (int[] bin) {
			int res = 128 * bin[0]
					+  64 * bin[1]
					+  32 * bin[2]
					+  16 * bin[3]
					+   8 * bin[4]
					+   4 * bin[5]
					+   2 * bin[6]
					+       bin[7];
			return (uint8)res;
		}
		
		
		public UnicodeEncoding (bool big_endian = true, bool bom = true)
		{
			Object (bom: bom, big_endian: big_endian);
		}
		
		public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
		{
			size_t r; size_t w;
			char *output = convert (str.substring (offset, count), str.length, big_endian ? "UTF16BE" : "UTF16LE", "UTF-8", out r, out w);
			Gee.ArrayList<uint8> list = new Gee.ArrayList<uint8>();
			if (bom)
				list.add_all_array (big_endian ? new uint8[]{254,255} : new uint8[]{255,254});
			for (var i = 0; i < w; i++)
				list.add (output[i]);
			return list.to_array();
		}

		public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
		{
			var array = bytes;
			int bp = array.length;
			if(bom  && bytes.length > 2 && 
			(big_endian && bytes[0] == 254 && bytes[1] == 255 ||
			!big_endian && bytes[1] == 254 && bytes[0] == 255)){
				array.move (2, 0, bp - 2);
				bp -= 2;
			}
			return ((string)convert ((string)(char*)array, bp, "UTF-8", big_endian ? "UTF16BE" : "UTF16LE")).substring (offset, count);
		}
		
		public override unichar read_char (InputStream stream) {
			var buffer = new uint8[2];
			stream.read (buffer);
			if (bom && (buffer[0] == 254 && buffer[1] == 255 && big_endian ||
				buffer[1] == 254 && buffer[0] == 255 && !big_endian))
				stream.read (buffer);
			if (big_endian) {
				var bin = n_to_bin (buffer[0]);
				if (bin[0] == 1 && bin[1] == 1 && bin[2] == 0 && bin[3] == 1 && bin[4] == 1 && bin[5] == 0) {
					var buffer2 = new uint8[2];
					stream.read (buffer2);
					return get_string (new uint8[]{buffer[0], buffer[1], buffer2[0], buffer2[1]}).get_char();
				} else return get_string (buffer).get_char(); 
			} else {
				var bin = n_to_bin (buffer[1]);
				if (bin[0] == 1 && bin[1] == 1 && bin[2] == 0 && bin[3] == 1 && bin[4] == 1 && bin[5] == 0) {
					var buffer2 = new uint8[2];
					stream.read (buffer2);
					return get_string (new uint8[]{buffer[0], buffer[1], buffer2[0], buffer2[1]}).get_char();
				} else return get_string (buffer).get_char(); 
			}
		}

		public bool big_endian { get; construct; }
		public bool bom { get; construct; }

		public override string name {
			owned get {
				return "utf-16%s%s".printf (big_endian ? "be" : "le", bom ? " (with BOM)" : "");
			}
		}
	}

	public class Utf32Encoding : Encoding {
		public Utf32Encoding (bool big_endian = true, bool bom = true)
		{
			Object (bom: bom, big_endian: big_endian);
		}

		public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
		{
			size_t r; size_t w;
			char *output = convert (str.substring (offset, count), str.length, big_endian ? "UTF32BE" : "UTF32LE", "UTF-8", out r, out w);
			Gee.ArrayList<uint8> list = new Gee.ArrayList<uint8>();
			if (bom)
				list.add_all_array (big_endian ? new uint8[]{0,0,254,255} : new uint8[]{255,254,0,0});
			for (var i = 0; i < w; i++)
				list.add (output[i]);
			return list.to_array();
		}

		public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
		{
			var array = bytes;
			int bp = array.length;
			if (bom && bytes.length >= 4)
				if (big_endian && bytes[0] == 0 && bytes[1] == 0 && bytes[2] == 254 && bytes[3] == 255 ||
				   !big_endian && bytes[0] == 255 && bytes[1] == 254 && bytes[2] == 0 && bytes[3] == 0){
				array.move (4, 0, bp - 4);
				bp -= 4;
			}
			return ((string)convert ((string)(char*)array, bp, "UTF-8", big_endian ? "UTF32BE" : "UTF32LE")).substring (offset, count);
		}
		
		public override unichar read_char (InputStream stream) {
			var buffer = new uint8[4];
			stream.read (buffer);
			if (bom && (buffer[0] == 0 && buffer[1] == 0 && buffer[2] == 254 && buffer[3] == 255 && big_endian ||
				 buffer[2] == 0 && buffer[3] == 0 && buffer[1] == 254 && buffer[0] == 255 && !big_endian))
				stream.read (buffer);
			if (big_endian)
				return (unichar)(buffer[3] + 256 * buffer[2] + 256 * 256 * buffer[1]  + 256 * 256 * 256 * buffer[0]);
			else
				return (unichar)(buffer[0] + 256 * buffer[1] + 256 * 256 * buffer[2]  + 256 * 256 * 256 * buffer[3]);
		}

		public bool big_endian { get; construct; }
		public bool bom { get; construct; }

		public override string name {
			owned get {
				return "utf-32%s%s".printf (big_endian ? "be" : "le", bom ? " (with BOM)" : "");
			}
		}
	}

	public class Utf8Encoding : Encoding {
		public Utf8Encoding (bool bom = false)
		{
			Object (bom: bom);
		}
		
		public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
		{
			var list = new Gee.ArrayList<uint8>();
			if (bom)
			{
				list.add (239);
				list.add (187);
				list.add (191);
			}
			list.add_all_array (str.substring (offset, count).data);
			return list.to_array();
		}
		
		public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
		{
			var array = bytes;
			if (bom && bytes.length >= 3 && bytes[0] == 239 && bytes[1] == 187 && bytes[2] == 191)
				array.move (3, 0, bytes.length - 3);
			var sb = new StringBuilder();
			foreach (uint8 u in array)
				sb.append_c ((char)u);
			return sb.str.substring (offset, count);
		}
		
		static int[] n_to_bin (uint8 u)
		{
			var i = 128;
			uint8 tmp = u;
			int[] bin = new int[0];
			while (i >= 1)
			{
				bin += tmp / i;
				tmp -= i * (tmp / i);
				if (i == 1)
					break;
				i /= 2;
			}
			return bin;
		}
		
		public override unichar read_char (InputStream stream) {
			var byte = new uint8[1];
			stream.read (byte);
			if (byte[0] < 128)
				return (unichar)byte[0];
			if (byte[0] >= 0xC2 && byte[0] < 0xE0) {
				var byte1 = new uint8[1];
				stream.read (byte1);
				return ((string)new uint8[]{byte[0], byte1[0]}).get_char();
			}
			if (byte[0] >= 0xE0 && byte[0] < 0xEF) {
				var byte1 = new uint8[2];
				stream.read (byte1);
				return ((string)new uint8[]{byte[0], byte1[0], byte1[1]}).get_char();
			}
			if (byte[0] >= 0xEF) {
				var byte1 = new uint8[2];
				stream.read (byte1);
				if (bom && byte[0] == 239 && byte1[0] == 187 && byte1[1] == 191)
					return read_char (stream);
				var byte2 = new uint8[1];
				stream.read (byte2);
				return ((string)new uint8[]{byte[0], byte1[0], byte1[1], byte2[0]}).get_char();
			}
			return 0;
		}

		public override string name {
			owned get {
				return "utf-8%s".printf (bom ? " (with BOM)" : "");
			}
		}

		public bool bom { get; construct; }
	}
}
