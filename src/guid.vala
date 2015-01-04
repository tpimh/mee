namespace Mee {
	public class Guid {
		public enum Format {
			NONE,
			N, // 00000000000000000000000000000000
			D, // 00000000-0000-0000-0000-000000000000
			B, // {00000000-0000-0000-0000-000000000000}
			P, // (00000000-0000-0000-0000-000000000000)
			X, // {0x00000000,0x0000,0x0000,{0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}}
		}
		
		struct Parser {
			string src;
			int length;
			int cur;
			
			public Parser (string src) {
				this.src = src.strip();
				length = this.src.length;
				cur = 0;
			}
			
			void reset() {
				cur = 0;
				length = src.length;
			}
			
			bool eof { get { return cur >= length; } }
			
			public static bool has_hyphen (Format format) {
				switch (format) {
				case Format.D:
				case Format.B:
				case Format.P:
					return true;
				default:
					return false;
				}
			}
			
			bool try_parse_ndbp (Format format, out Guid guid) {
				ulong a, b, c;
				guid = new Guid (new uint8[16]);

				if (format == Format.B && !parse_char ('{'))
					return false;

				if (format == Format.P && !parse_char ('('))
					return false;

				if (!parse_hex (8, true, out a))
					return false;

				var hyphen = has_hyphen (format);

				if (hyphen && !parse_char ('-'))
					return false;

				if (!parse_hex (4, true, out b))
					return false;

				if (hyphen && !parse_char ('-'))
					return false;

				if (!parse_hex (4, true, out c))
					return false;

				if (hyphen && !parse_char ('-'))
					return false;

				var d = new uint8 [8];
				for (int i = 0; i < d.length; i++) {
					ulong dd;
					if (!parse_hex (2, true, out dd))
						return false;

					if (i == 1 && hyphen && !parse_char ('-'))
						return false;

					d [i] = (uint8) dd;
				}

				if (format == Format.B && !parse_char ('}'))
					return false;

				if (format == Format.P && !parse_char (')'))
					return false;

				if (!eof)
					return false;

				guid = new Guid.from_values ((int) a, (short) b, (short) c, d);
				return true;
			}

			bool try_parse_x (out Guid guid) {
				ulong a = 0, b = 0, c = 0;
				guid = new Guid (new uint8[16]);

				if (!(parse_char ('{')
					&& parse_hex_prefix ()
					&& parse_hex (8, false, out a)
					&& parse_char_with_white_spaces (',')
					&& parse_hex_prefix ()
					&& parse_hex (4, false, out b)
					&& parse_char_with_white_spaces (',')
					&& parse_hex_prefix ()
					&& parse_hex (4, false, out c)
					&& parse_char_with_white_spaces (',')
					&& parse_char_with_white_spaces ('{'))) {

					return false;
				}

				var d = new uint8 [8];
				for (int i = 0; i < d.length; ++i) {
					ulong dd = 0;

					if (!(parse_hex_prefix () && parse_hex (2, false, out dd)))
						return false;

					d [i] = (uint8) dd;

					if (i != 7 && !parse_char_with_white_spaces (','))
						return false;
				}

				if (!(parse_char_with_white_spaces ('}') && parse_char_with_white_spaces ('}')))
					return false;

				if (!eof)
					return false;

				guid = new Guid.from_values ((int) a, (short) b, (short) c, d);
				return true;
			}
			
			bool parse_hex_prefix()
			{
				// It can be prefixed with whitespaces
				while (cur < length - 1) {
					var ch = src [cur];
					if (ch == '0') {
						cur++;
						return src [cur++] == 'x';
					}

					if (ch.isspace())
						break;
					cur++;
				}

				return false;
			}

			bool parse_char_with_white_spaces (char c)
			{
				while (!eof) {
					var ch = src [cur++];
					if (ch == c)
						return true;

					if (!ch.isspace())
						break;
				}

				return false;
			}

			bool parse_char (char c)
			{
				if (!eof && src [cur] == c) {
					cur++;
					return true;
				}
				return false;
			}

			bool parse_hex (int length, bool strict, out ulong res)
			{
				res = 0;

				for (int i = 0; i < length; i++) {
					if (eof)
						return !(strict && (i + 1 != length));

					char c = src [cur];
					if (c.isdigit()) {
						res = res * 16 + c - '0';
						cur++;
						continue;
					}

					if (c >= 'a' && c <= 'f') {
						res = res * 16 + c - 'a' + 10;
						cur++;
						continue;
					}

					if (c >= 'A' && c <= 'F') {
						res = res * 16 + c - 'A' + 10;
						cur++;
						continue;
					}

					if (!strict)
						return true;

					return false; //!(strict && (i + 1 != length));
				}

				return true;
			}

			public bool parse (out Guid guid, Format format = Format.NONE)
			{
				if (format == Format.X)
					return try_parse_x (out guid);
				if (format == Format.NONE) {
					switch (length) {
					case 32:
						if (try_parse_ndbp (Format.N, out guid))
							return true;
						break;
					case 36:
						if (try_parse_ndbp (Format.D, out guid))
							return true;
						break;
					case 38:
						switch (src [0]) {
						case '{':
							if (try_parse_ndbp (Format.B, out guid))
								return true;
							break;
						case '(':
							if (try_parse_ndbp (Format.P, out guid))
								return true;
							break;
						}
						break;
					}

					reset ();
					return try_parse_x (out guid);
				}

				return try_parse_ndbp (format, out guid);
			}
		
			}
	
		internal int a;
		internal short b;
		internal short c;
		internal uint8 d;
		internal uint8 e;
		internal uint8 f;
		internal uint8 g;
		internal uint8 h;
		internal uint8 i;
		internal uint8 j;
		internal uint8 k;
		
		public static Guid empty {
			owned get {
				return new Guid (new uint8[16]));
			}
		}
		
		public static Guid parse (string str) {
			var parser = Parser (str);
			Guid guid;
			parser.parse (out guid);
			return guid;
		}
		
		public static bool try_parse (string str, out Guid guid = null) {
			var parser = Parser (str);
			return parser.parse (out guid);
		}
		
		public static Guid random() {
			var rand = new Rand();
			var list = new Gee.ArrayList<uint8>();
			for (var i = 0; i < 16; i++)
				list.add ((uint8)rand.int_range (0, 256));
			var guid = new Guid (list.to_array());
			guid.d = (uint8) ((guid.d & 0x3fu) | 0x80u);
			guid.c = (short) ((guid.c & 0x0fffu) | 0x4000u);
			return guid;
		}
		
		public Guid.copy (Guid guid) {
			a = guid.a;
			b = guid.b;
			c = guid.c;
			d = guid.d;
			e = guid.e;
			f = guid.f;
			g = guid.g;
			h = guid.h;
			i = guid.i;
			j = guid.j;
			k = guid.k;
		}
		
		public Guid.from_values (int a, short b, short c, uint8[] bytes) {
			this.a = a;
			this.b = b;
			this.c = c;
			d = bytes[0];
			e = bytes[1];
			f = bytes[2];
			g = bytes[3];
			h = bytes[4];
			i = bytes[5];
			j = bytes[6];
			k = bytes[7];
		}
	
		public Guid (uint8[] data) {
			var _a = new uint8[]{data[3], data[2], data[1], data[0]};
			a = BitConverter.to_int (_a);
			var _b = new uint8[]{data[5], data[4]};
			b = BitConverter.to_short (_b);
			var _c = new uint8[]{data[7], data[6]};
			c = BitConverter.to_short (_c);
			d = data[8];
			e = data[9];
			f = data[10];
			g = data[11];
			h = data[12];
			i = data[13];
			j = data[14];
			k = data[15];
		}
		
		public uint8[] to_array() {
			Gee.ArrayList<uint8> list = new Gee.ArrayList<uint8>();
			var _a = BitConverter.get_bytes<int> (a);
			list.add_all_array (_a);
			var _b = BitConverter.get_bytes<short> (b);
			list.add_all_array (_b);
			var _c = BitConverter.get_bytes<short> (c);
			list.add_all_array (_c);
			list.add (d);
			list.add (e);
			list.add (f);
			list.add (g);
			list.add (h);
			list.add (i);
			list.add (j);
			list.add (k);
			return list.to_array();
		}
		
		void append_int (StringBuilder sb, int number) {
			var _a = BitConverter.get_bytes<int> (number);
			foreach (uint8 u in _a)
				sb.append ("%.2x".printf (u));
		}
		
		void append_short (StringBuilder sb, short s) {
			var _a = BitConverter.get_bytes<short> (s);
			foreach (uint8 u in _a)
				sb.append ("%.2x".printf (u));
		}
		
		public bool equals (GLib.Value val) {
			if (val.type() == typeof (string))
				return equals_guid (parse ((string)val));
			if (val.type() == typeof (Guid))
				return equals_guid ((Guid)val);
			return false;
		}
		
		bool equals_guid (Guid other) {
			return (k != other.k || j != other.j || i != other.i ||
				h != other.h || g != other.g || f != other.f ||
				e != other.e || d != other.d || c != other.c ||
				b != other.b || a != other.a) ? false : true;
				
		}
	
		public string to_string (Format format = Mee.Guid.Format.D) {
			StringBuilder sb = new StringBuilder();
			if (format == Guid.Format.N) {
				append_int (sb, a);
				append_short (sb, b);
				append_short (sb, c);
				sb.append ("%.2x".printf (d));
				sb.append ("%.2x".printf (e));
				sb.append ("%.2x".printf (f));
				sb.append ("%.2x".printf (g));
				sb.append ("%.2x".printf (h));
				sb.append ("%.2x".printf (i));
				sb.append ("%.2x".printf (j));
				sb.append ("%.2x".printf (k));
			}
			if (format == Guid.Format.B) {
				sb.append_c ('{');
				append_int (sb, a);
				sb.append_c ('-');
				append_short (sb, b);
				sb.append_c ('-');
				append_short (sb, c);
				sb.append ("-%.2x%.2x-".printf (d, e));
				sb.append ("%.2x".printf (f));
				sb.append ("%.2x".printf (g));
				sb.append ("%.2x".printf (h));
				sb.append ("%.2x".printf (i));
				sb.append ("%.2x".printf (j));
				sb.append ("%.2x}".printf (k));
			}
			if (format == Guid.Format.D) {
				append_int (sb, a);
				sb.append_c ('-');
				append_short (sb, b);
				sb.append_c ('-');
				append_short (sb, c);
				sb.append ("-%.2x%.2x-".printf (d, e));
				sb.append ("%.2x".printf (f));
				sb.append ("%.2x".printf (g));
				sb.append ("%.2x".printf (h));
				sb.append ("%.2x".printf (i));
				sb.append ("%.2x".printf (j));
				sb.append ("%.2x".printf (k));
			}
			if (format == Guid.Format.P) {
				sb.append_c ('(');
				append_int (sb, a);
				sb.append_c ('-');
				append_short (sb, b);
				sb.append_c ('-');
				append_short (sb, c);
				sb.append ("-%.2x%.2x-".printf (d, e));
				sb.append ("%.2x".printf (f));
				sb.append ("%.2x".printf (g));
				sb.append ("%.2x".printf (h));
				sb.append ("%.2x".printf (i));
				sb.append ("%.2x".printf (j));
				sb.append ("%.2x)".printf (k));
			}
			if (format == Guid.Format.X) {
				sb.append ("{0x");
				append_int (sb, a);
				sb.append (",0x");
				append_short (sb, b);
				sb.append (",0x");
				append_short (sb, c);
				sb.append (",{");
				sb.append ("0x%.2x,".printf (d));
				sb.append ("0x%.2x,".printf (e));
				sb.append ("0x%.2x,".printf (f));
				sb.append ("0x%.2x,".printf (g));
				sb.append ("0x%.2x,".printf (h));
				sb.append ("0x%.2x,".printf (i));
				sb.append ("0x%.2x,".printf (j));
				sb.append ("0x%.2x}}".printf (k));
			}
			return sb.str;
		}
	}
}
