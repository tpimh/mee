namespace Mee.Text
{
	
	/**
	 * Encoding base class 
	 */
	public abstract class Encoding : GLib.Object
	{
		/**
		 * returns bytes of given string, with actual encoding.
		 * 
		 * @param text the text from which we take the bytes
		 * @param start index where take start
		 * @param count number of characters to read
		 * 
		 * @return a byte array, representing given string.
		 */
		public abstract uint8[] get_bytes(string text, int start = 0, int count = -1);
		/**
		 * returns string from byte array, with actual encoding.
		 * @param bytes the array to decode
		 * @param start index of take start
		 * @param count number of characters of string
		 * 
		 * @return string decoded. 
		 */
		public abstract string get_string(uint8[] bytes, int start = 0, int count = -1);
		/**
		 * name of actual encoding 
		 */
		public abstract string name { owned get; }
		/**
		 * try to guess the encoding from his name.
		 * @param encoding_name encoding's name
		 * 
		 * @return encoding who corresponding to name, or null if failed. 
		 */
		public static Encoding? get_encoding(string encoding_name){
			string name = encoding_name.down();
			if(name == "utf-16" || name == "utf-16le")
				return new UnicodeEncoding();
			else if(name == "utf-16be")
				return new UnicodeEncoding(true);
			else if(name == "utf-8")
				return new Utf8Encoding();
			else if(name == "latin-1" || name == "iso-8859-1")
				return new Latin1Encoding();
			else if(name == "ascii" || name == "us-ascii")
				return new ASCIIEncoding();
			return null;
		}
		/**
		 * try to guess the encoding from a byte array.
		 * @param data the byte array
		 * 
		 * @return null if failed, or the corrresponding Encoding. 
		 */
		public static Encoding? correct_encoding (uint8[] data){
			var magic = new LibMagic.Magic (LibMagic.Flags.MIME_ENCODING);
			magic.load ();
			return get_encoding (magic.buffer (data, data.length));
		}
		/**
		 * ASCII encoding ({@link ASCIIEncoding})
		 */
		public static Encoding ascii {
			owned get {
				return new ASCIIEncoding();
			}
		}
		/**
		 * UTF-16 little-endian unicode encoding
		 */
		public static Encoding unicode {
			owned get {
				return new UnicodeEncoding();
			}
		}
		/**
		 * UTF-16 big-endian unicode encoding
		 */
		public static Encoding big_endian_unicode {
			owned get {
				return new UnicodeEncoding(true);
			}
		}
		/**
		 * UTF-8 encoding ({@link Utf8Encoding})
		 */
		public static Encoding utf8 {
			owned get {
				return new Utf8Encoding();
			}
		}
		/**
		 * iso-8859-1 encoding ({@link Latin1Encoding})
		 */
		public static Encoding latin1 {
			owned get {
				return new Latin1Encoding();
			}
		}
	}
		
	public class UnicodeEncoding : Encoding
	{
		/**
		 * instance a new UnicodeEncoding.
		 * @param big_endian boolean indicates that is big endian or not.
		 * @param bom Byte Order Mark. if true, ensure bytes start with the BOM identifier
		 */
		public UnicodeEncoding(bool big_endian = false, bool bom = true){
			Object(big_endian: big_endian, bom: bom);
		}
		/**
		 * {@inheritDoc}
		 */
		public override string get_string(uint8[] bytes, int s = 0, int count = -1){
			var sb = new StringBuilder();
			var bp = 0;
			if(bom && 
			(big_endian && bytes[0] == 254 && bytes[1] == 255 ||
			!big_endian && bytes[1] == 254 && bytes[0] == 255))
				bp += 2;
			for(var i = bp; i < bytes.length-1; i+=2){
				int a = (int)bytes[i];
				int b = (int)bytes[i+1];
				if(!big_endian)
					a = 256*b + a;
				else
					a = 256*a + b;
				if(a >= 0xD800 && a <= 0x0DBFF){
					int start = 0x10000;
					int d = 0xD800;
					int e = 0xDC00;
					int c = 0;
					for(var hex = start; hex <= 0x10FC00; hex++){
						if(d == a){
							int z = (int)bytes[i+2];
							int y = (int)bytes[i+3];
							if(!big_endian)
								z = 256*y + z;
							else
								z = 256*z + y;
							if(z == e){
								sb.append_unichar(hex);
								i += 2;
								break;
							}
						}
						c++;
						e++;
						if(c == 1024){
							c = 0;
							e = 0xDC00;
							d++;
						}
					}
				}else {
					sb.append_unichar(a);
				}
			}
			return sb.str.substring(s,count);
		}
		/**
		 * {@inheritDoc}
		 */
		public override uint8[] get_bytes(string text, int s = 0, int count = -1){
			var list = new Gee.ArrayList<uint8>();
			if(bom)
				if(big_endian){
					list.add (254); 
					list.add (255);
				}else {
					list.add (255);
					list.add (254);
				}
			var str = new String(text.substring(s,count));
			foreach(unichar u in str){
				if(u < 65536){
					uint8 a = (uint8)(u / 256);
					uint8 b = (uint8)(u - 256*a);
					if(!big_endian){
						list.add (b);
						list.add (a);
					}else {
						list.add (a);
						list.add (b);
					}
				}
				else {
					int i = (int)u;
					var a = 0xD800;
					var aa = 0xDC00;
					var b = 0;
					var c = 0;
					int start = 0x10000;
					for(var hex = start; hex <= 0x10FC00; hex++){
						if(hex == i){
							uint8 l1 = (uint8)((a+b) / 256);
							uint8 l2 = (uint8)((a+b) - 256*l1);
							if(!big_endian){
								list.add (l2);
								list.add (l1);
							}else {
								list.add (l1);
								list.add (l2);
							}
							l1 = (uint8)(aa / 256);
							l2 = (uint8)(aa - 256*l1);
							if(!big_endian){
								list.add (l2);
								list.add (l1);
							}else {
								list.add (l1);
								list.add (l2);
							}
							break;
						}
						c++;
						aa++;
						if(c == 1024){
							aa = 0xDC00;
							c = 0;
							b++;
						}
						if(b == 16){
							b = 0;
							a += 16;
						}
					}
				}
			}
			return list.to_array();
		}
		/**
		 * {@inheritDoc}
		 */
		public override string name {
			owned get {
				return big_endian ? "utf-16be" : "utf-16le";
			}
		}
		/**
		 * indicates whether the encoding is big or little endian
		 */
		public bool big_endian { get; construct; }
		/**
		 * if true, ensure bytes start with the BOM identifier 
		 */
		public bool bom { get; construct; }
	}
	
	public class Utf8Encoding : Encoding
	{
		/**
		 * {@inheritDoc}
		 */		
		public override uint8[] get_bytes(string text, int start = 0, int count = -1){ return text.substring(start,count).data; }
		/**
		 * {@inheritDoc}
		 */
		public override string get_string(uint8[] bytes, int start = 0, int count = -1) {
			return ((string)bytes).substring(start,count);
		}
		/**
		 * {@inheritDoc}
		 */		
		public override string name {
			owned get { return "utf-8"; }
		}
	}
	
	public class Latin1Encoding : Encoding
	{
		/**
		* {@inheritDoc}
		*/
		public override string get_string(uint8[] bytes, int start = 0, int count = -1)
		{
			var str = new String();
			str.add_array (bytes);
			return str.str.substring(start, count);
		}
		/**
		* {@inheritDoc}
		*/
		public override uint8[] get_bytes(string text, int start = 0, int count = -1)
		{
			var chars = new String (text).substring(start, count).get_chars();
			uint8[] buffer = new uint8[chars.length];
			for(var i = 0; i < buffer.length; i++){
				buffer[i] = (chars[i] >= 256) ? (uint8)'?' : (uint8)chars[i];
			}
			return buffer;
		}
		/**
		* {@inheritDoc}
		*/
		public override string name {
			owned get {
				return "latin-1";
			}
		}
	}
	
	public class ASCIIEncoding : Encoding
	{
		/**
		 * {@inheritDoc}
		 */		
		public override string get_string(uint8[] bytes, int start = 0, int count = -1){
			StringBuilder sb = new StringBuilder();
			foreach(uint8 u in bytes){
				sb.append_c((u > 127) ? (char)'?' : (char)u);
			}
			return sb.str.substring(start,count);
		}
		/**
		 * {@inheritDoc}
		 */		
		public override uint8[] get_bytes(string text, int start = 0, int count = -1){
			uint[] data = new String(text.substring(start,count)).get_chars();
			uint8[] buffer = new uint8[data.length];
			for(var i = 0; i < buffer.length; i++){
				buffer[i] = (data[i] >= 0x0080) ? (uint8)'?' : (uint8)data[i];
			}
			return buffer;
		}
		/**
		 * {@inheritDoc}
		 */		
		public override string name {
			owned get {
				return "ascii";
			}
		}
	}
}
