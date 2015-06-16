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
				return new Guid (new uint8[16]);
			}
		}
		
		public static Guid parse (string str) {
			Guid guid = null;
			if (!try_parse (str, out guid))
				return new Guid (new uint8[16]);
			return guid;
		}
		
		public static bool try_parse (string str, out Guid result = null) {
			string guid_string = str.replace (" ", "");
			if (guid_string[0] == '{' || guid_string[0] == '(')
				return try_parse_bracket (guid_string, out result);
			if (guid_string.index_of ("-") == -1)
				return try_parse_str (guid_string, out result);
			int a; short b; short c; uint8 d; uint8 e; uint8 f; uint8 g; uint8 h; uint8 i; uint8 j; uint8 k;
			if (str.length != 36 || str[8] != '-' || str[13] != '-' || str[18] != '-' || str[23] != '-')
				return false;
			if (!parse_int (str.substring (0, 8), out a))
				return false;
			if (!parse_short (str.substring (9, 4), out b))
				return false;
			if (!parse_short (str.substring (14, 4), out c))
				return false;
			if (!parse_byte (str.substring (19, 2), out d))
				return false;
			if (!parse_byte (str.substring (21, 2), out e))
				return false;
			if (!parse_byte (str.substring (24, 2), out f))
				return false;
			if (!parse_byte (str.substring (26, 2), out g))
				return false;
			if (!parse_byte (str.substring (28, 2), out h))
				return false;
			if (!parse_byte (str.substring (30, 2), out i))
				return false;
			if (!parse_byte (str.substring (32, 2), out j))
				return false;
			if (!parse_byte (str.substring (34, 2), out k))
				return false;
			var guid = new Guid (new uint8[16]);
			guid.a = a;
			guid.b = b;
			guid.c = c;
			guid.d = d;
			guid.e = e;
			guid.f = f;
			guid.g = g;
			guid.h = h;
			guid.i = i;
			guid.j = j;
			guid.k = k;
			result = guid;
			return true;
		}
		
		static bool try_parse_str (string str, out Guid result = null) {
			if (str.length != 32)
				return false;
			int a; short b; short c; uint8 d; uint8 e; uint8 f; uint8 g; uint8 h; uint8 i; uint8 j; uint8 k;
			if (!parse_int (str.substring (0, 8), out a))
				return false;
			if (!parse_short (str.substring (9, 4), out b))
				return false;
			if (!parse_short (str.substring (13, 4), out c))
				return false;
			if (!parse_byte (str.substring (17, 2), out d))
				return false;
			if (!parse_byte (str.substring (19, 2), out e))
				return false;
			if (!parse_byte (str.substring (21, 2), out f))
				return false;
			if (!parse_byte (str.substring (23, 2), out g))
				return false;
			if (!parse_byte (str.substring (25, 2), out h))
				return false;
			if (!parse_byte (str.substring (27, 2), out i))
				return false;
			if (!parse_byte (str.substring (39, 2), out j))
				return false;
			if (!parse_byte (str.substring (31, 2), out k))
				return false;
			var guid = new Guid (new uint8[16]);
			guid.a = a;
			guid.b = b;
			guid.c = c;
			guid.d = d;
			guid.e = e;
			guid.f = f;
			guid.g = g;
			guid.h = h;
			guid.i = i;
			guid.j = j;
			guid.k = k;
			result = guid;
			return true;
		}
		
		static bool try_parse_bracket (string str, out Guid result = null) {
			if (str[0] != '{' && str[0] != '(')
				return false;
			char _char = str[0] == '{' ? '}' : ')';
			if (str[2].tolower() == 'x')
				return try_parse_hex (str, out result);
			int a; short b; short c; uint8 d; uint8 e; uint8 f; uint8 g; uint8 h; uint8 i; uint8 j; uint8 k;
			if (str.length != 38 || str[9] != '-' || str[14] != '-' || str[19] != '-' || str[24] != '-' || str[37] != _char)
				return false;
			if (!parse_int (str.substring (1, 8), out a))
				return false;
			if (!parse_short (str.substring (10, 4), out b))
				return false;
			if (!parse_short (str.substring (15, 4), out c))
				return false;
			if (!parse_byte (str.substring (20, 2), out d))
				return false;
			if (!parse_byte (str.substring (22, 2), out e))
				return false;
			if (!parse_byte (str.substring (25, 2), out f))
				return false;
			if (!parse_byte (str.substring (27, 2), out g))
				return false;
			if (!parse_byte (str.substring (29, 2), out h))
				return false;
			if (!parse_byte (str.substring (31, 2), out i))
				return false;
			if (!parse_byte (str.substring (33, 2), out j))
				return false;
			if (!parse_byte (str.substring (35, 2), out k))
				return false;
			var guid = new Guid (new uint8[16]);
			guid.a = a;
			guid.b = b;
			guid.c = c;
			guid.d = d;
			guid.e = e;
			guid.f = f;
			guid.g = g;
			guid.h = h;
			guid.i = i;
			guid.j = j;
			guid.k = k;
			result = guid;
			return true;
		}
		
		static bool try_parse_hex (string str, out Guid result = null) {
			print ("str-length: %d\n",str.length);
			if (str.length != 68 || str[0] != '{' || str[11] != ',' || str[18] != ',' || str[25] != ',' ||
				str[26] != '{' || str[31] != ','|| str[36] != ','|| str[41] != ','|| str[46] != ','|| 
				str[51] != ','|| str[56] != ','|| str[61] != ','|| str[66] != '}'|| str[67] != '}')
				return false;
			var guid = new Guid (new uint8[16]);
			int a = 0; short b = 0; short c = 0; uint8 d = 0; uint8 e = 0; 
			uint8 f = 0; uint8 g = 0; uint8 h = 0; uint8 i = 0; uint8 j = 0; uint8 k = 0;
			if (str.substring (1, 2).down() != "0x" || !parse_int (str.substring (3, 8), out a))
				return false;
			if (str.substring (12, 2).down() != "0x" || !parse_short (str.substring (14, 4), out b))
				return false;
			if (str.substring (19, 2).down() != "0x" || !parse_short (str.substring (21, 4), out c))
				return false;
			if (str.substring (27, 2).down() != "0x" || !parse_byte (str.substring (29, 2), out d))
				return false;
			if (str.substring (32, 2).down() != "0x" || !parse_byte (str.substring (34, 2), out e))
				return false;
			if (str.substring (37, 2).down() != "0x" || !parse_byte (str.substring (39, 2), out f))
				return false;
			if (str.substring (42, 2).down() != "0x" || !parse_byte (str.substring (44, 2), out g))
				return false;
			if (str.substring (47, 2).down() != "0x" || !parse_byte (str.substring (49, 2), out h))
				return false;
			if (str.substring (52, 2).down() != "0x" || !parse_byte (str.substring (54, 2), out i))
				return false;
			if (str.substring (57, 2).down() != "0x" || !parse_byte (str.substring (59, 2), out j))
				return false;
			if (str.substring (62, 2).down() != "0x" || !parse_byte (str.substring (64, 2), out k))
				return false;
			guid.a = a;
			guid.b = b;
			guid.c = c;
			guid.d = d;
			guid.e = e;
			guid.f = f;
			guid.g = g;
			guid.h = h;
			guid.i = i;
			guid.j = j;
			guid.k = k;
			result = guid;
			return true;
		}
		
		static bool parse_int (string str, out int result) {
			uint8[] data = new uint8[4];
			for (var i = 3; i >= 0; i--) {
				int64 u = 0;
				if (!Mee.try_parse_hex (str.substring (2 * (3 - i), 2), out u))
					return false;
				data[i] = (uint8)u;
			}
			result = ((int)data[3] << 24) | ((int)data[2] << 16) | ((int)data[1] << 8) | data[0];
			return true;
		}
		
		static bool parse_short (string str, out short result) {
			uint8[] data = new uint8[2];
			for (var i = 1; i >= 0; i--) {
				int64 u = 0;
				if (!Mee.try_parse_hex (str.substring (2 * (1 - i), 2), out u))
					return false;
				data[i] = (uint8)u;
			}
			result = ((short)data[1] << 8) | data[0];
			return true;
		}
		
		static bool parse_byte (string str, out uint8 result) {
			int64 u = 0;
			if (!Mee.try_parse_hex (str.substring (0, 2), out u))
				return false;
			result = (uint8)u;
			return true;
		}
		
		public static Guid random() {
			var rand = new Rand();
			var list = new GenericArray<uint8>();
			for (var i = 0; i < 16; i++)
				list.add ((uint8)rand.int_range (0, 256));
			var guid = new Guid (list.data);
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
			var _a = new uint8[]{data[0], data[1], data[2], data[3]};
			a = BitConverter.to_int (_a);
			var _b = new uint8[]{data[4], data[5]};
			b = BitConverter.to_short (_b);
			var _c = new uint8[]{data[6], data[7]};
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
			var data = new uint8[16];

            data[0] = (uint8)a;
            data[1] = (uint8)(a >> 8);
            data[2] = (uint8)(a >> 16);                        
            data[3] = (uint8)(a >> 24);
            data[4] = (uint8)(b);
            data[5] = (uint8)(b >> 8);
            data[6] = (uint8)(c);
            data[7] = (uint8)(c >> 8);
            data[8] = d;
            data[9] = e;
            data[10] = f;
            data[11] = g;
            data[12] = h;
            data[13] = i;
            data[14] = j;
            data[15] = k;

            return data;
		}
		
		void append_int (StringBuilder sb, int number) {
			var _a = BitConverter.get_bytes<int> (number);
			for (var i = _a.length - 1; i >= 0; i--)
				sb.append ("%.2x".printf (_a[i]));
		}
		
		void append_short (StringBuilder sb, short s) {
			var _a = BitConverter.get_bytes<short> (s);
			for (var i = _a.length - 1; i >= 0; i--)
				sb.append ("%.2x".printf (_a[i]));
		}
		
		public bool equals (GLib.Value val) {
			if (val.type() == typeof (string))
				return equals_guid (parse ((string)val));
			if (val.type() == typeof (Guid))
				return equals_guid ((Guid)val);
			return false;
		}
		
		bool equals_guid (Guid other) {
			return strcmp (other.to_string().down(), to_string().down()) == 0;	
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
