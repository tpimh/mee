namespace Mee {
	namespace Text {
		public abstract class Encoding : Object
		{
			public abstract uint8[] get_bytes (string str, int offset = 0, int count = -1);
			
			public abstract string get_string (uint8[] bytes, int offset = 0, int count = -1);
			
			public abstract string name { owned get; }

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

			public static Encoding from_path (string path) throws GLib.Error
			{
				uint8[] buffer;
				FileUtils.get_data (path, out buffer);
				return from_buffer (buffer);
			}

			public static Encoding from_buffer (uint8[] data)
			{
				var prev_encoding = Encoding.latin1;
				int offset = 0;
				while (offset < data.length)
				{
					if (data.length >= 4)
					{
						if(data[0] == 0 && data[1] == 0 && data[2] == 254 && data[3] == 255)
							return new Utf32Encoding (true, true);
						if(data[0] == 255 && data[1] == 254 && data[2] == 0 && data[3] == 0)
							return new Utf32Encoding (false, true);
					}
					if (data.length >= 2)
					{
						if (data[0] == 254 && data[1] == 255)
							return new UnicodeEncoding (true, true);
						if (data[1] == 254 && data[0] == 255)
							return new UnicodeEncoding (false, true);
					}
					if (data.length >= 3 && data[0] == 239 && data[1] == 187 && data[2] == 191)
						return new Utf8Encoding (true);
					int[] i = n_to_bin (data[offset]);
					if (data.length >= offset+4 && i[0] == 1 && i[1] == 1 && i[2] == 1 && i[3] == 1 && i[4] == 0)
					{
						int[] j = n_to_bin (data[offset+1]);
						int[] k = n_to_bin (data[offset+2]);
						int[] l = n_to_bin (data[offset+3]);
						if (j[0] == 1 && j[1] == 0 && k[0] == 1 && k[1] == 0 && l[0] == 1 && l[1] == 0)
						{
							prev_encoding = Encoding.utf8;
							offset += 4;
							continue;
						}
					}
					if (data.length >= offset+3 && i[0] == 1 && i[1] == 1 && i[2] == 1 && i[3] == 0)
					{
						int[] j = n_to_bin (data[offset+1]);
						int[] k = n_to_bin (data[offset+2]);
						if (j[0] == 1 && j[1] == 0 && k[0] == 1 && k[1] == 0)
						{
							prev_encoding = Encoding.utf8;
							offset += 3;
							continue;
						}
					}
					if (data.length >= offset+2 && i[0] == 1 && i[1] == 1 && i[2] == 0)
					{
						int[] j = n_to_bin (data[offset+1]);
						if (j[0] == 1 && j[1] == 0)
						{
							prev_encoding = Encoding.utf8;
							offset += 2;
							continue;
						}
					}
					if (data.length >= offset+4 && i[0] == 1 && i[1] == 1 && i[2] == 0 && i[3] == 1 && i[4] == 1 && i[5] == 0)
					{
						int[] j = n_to_bin (data[offset+2]);
						if (j[0] == 1 && j[1] == 1 && j[2] == 0 && j[3] == 1 && j[4] == 1 && j[5] ==1)
						{
							prev_encoding = new UnicodeEncoding (true, false);
							offset += 4;
							continue;
						}
					}
					i = n_to_bin (data[offset+1]);
					if (data.length >= offset+4 && i[0] == 1 && i[1] == 1 && i[2] == 0 && i[3] == 1 && i[4] == 1 && i[5] == 0)
					{
						int[] j = n_to_bin (data[offset+3]);
						if (j[0] == 1 && j[1] == 1 && j[2] == 0 && j[3] == 1 && j[4] == 1 && j[5] ==1)
						{
							prev_encoding = new UnicodeEncoding (false, false);
							offset += 4;
							continue;
						}
					}
					if (data.length >= offset+4 && data[offset+2] <= 16 && data[offset+3] == 0)
					{
						prev_encoding = new Utf32Encoding (false, false);
						offset += 4;
						continue;
					}
					if (data.length >= offset+4 && data[offset] == 0 && data[offset+1] <= 16)
					{
						prev_encoding = new Utf32Encoding (true, false);
						offset += 4;
						continue;
					}
					if (data.length >= offset+2 && data[offset+1] == 0)
					{
						prev_encoding = new UnicodeEncoding (false, false);
						offset += 2;
						continue;
					}
					if (data.length >= offset+2 && data[offset] == 0)
					{
						prev_encoding = new UnicodeEncoding (true, false);
						offset += 2;
						continue;
					}
					offset++;
					if (offset == 64)
						break;
				}
				return prev_encoding;
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

		public class AsciiEncoding : Encoding
		{
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

			public override string name {
				owned get {
					return "ascii";
				}
			}
		}
		
		public class Latin1Encoding : Encoding
		{
			public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
			{
				var s = convert (str, str.length, "ISO_8859-1", "UTF-8");
				return ((string)s).substring (offset, count).data;
			}

			public override string get_string (uint8[] bytes, int offset = 0, int count = -1)
			{
				return ((string)convert ((string)bytes, bytes.length, "UTF-8", "ISO_8859-1")).substring (offset, count);
			}

			public override string name {
				owned get {
					return "latin-1";
				}
			}
		}

		public class UnicodeEncoding : Encoding
		{
			public UnicodeEncoding (bool big_endian = true, bool bom = true)
			{
				Object (bom: bom, big_endian: big_endian);
			}
			
			public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
			{
				size_t r; size_t w;
				char *output = convert (str.substring (offset, count), str.length, "UTF-8", big_endian ? "UTF16BE" : "UTF16LE", out r, out w);
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

			public bool big_endian { get; construct; }
			public bool bom { get; construct; }

			public override string name {
				owned get {
					return "utf-16%s%s".printf (big_endian ? "be" : "le", bom ? " (with BOM)" : "");
				}
			}
		}

		public class Utf32Encoding : Encoding
		{
			public Utf32Encoding (bool big_endian = true, bool bom = true)
			{
				Object (bom: bom, big_endian: big_endian);
			}

			public override uint8[] get_bytes (string str, int offset = 0, int count = -1)
			{
				size_t r; size_t w;
				char *output = convert (str.substring (offset, count), str.length, "UTF-8", big_endian ? "UTF32BE" : "UTF32LE", out r, out w);
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

			public bool big_endian { get; construct; }
			public bool bom { get; construct; }

			public override string name {
				owned get {
					return "utf-32%s%s".printf (big_endian ? "be" : "le", bom ? " (with BOM)" : "");
				}
			}
		}

		public class Utf8Encoding : Encoding
		{
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
				return ((string)array).substring (offset, count);
			}

			public override string name {
				owned get {
					return "utf-8%s".printf (bom ? " (with BOM)" : "");
				}
			}

			public bool bom { get; construct; }
		}
	}
}
