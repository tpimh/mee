namespace Mee
{
	public abstract class Encoding : GLib.Object
	{
		public abstract uint8[] get_bytes(string text, int start = 0, int count = -1);
		
		public abstract string get_string(uint8[] bytes, int start = 0, int count = -1);
		
		public abstract string name { owned get; }
		
		public static Encoding? get_encoding(string name){
			if(name == "utf-16")
				return new UnicodeEncoding();
			else if(name == "utf-8")
				return new Utf8Encoding();
			else if(name == "ascii")
				return new ASCIIEncoding();
			return null;
		}
		
		public static Encoding ascii {
			owned get {
				return new ASCIIEncoding();
			}
		}
		
		public static Encoding unicode {
			owned get {
				return new UnicodeEncoding();
			}
		}
		public static Encoding utf8 {
			owned get {
				return new Utf8Encoding();
			}
		}
	}
	
	public class UnicodeEncoding : Encoding
	{
		public UnicodeEncoding(){}
		
		public override string get_string(uint8[] bytes, int s = 0, int count = -1){
			var sb = new StringBuilder();
			for(var i = 0; i < bytes.length-1; i+=2){
				int a = (int)bytes[i];
				int b = (int)bytes[i+1];
				a = 256*b + a;
				if(a >= 0xD800 && a <= 0x0DBFF){
					int start = 0x10000;
					int d = 0xD800;
					int e = 0xDC00;
					int c = 0;
					for(var hex = start; hex <= 0x10FC00; hex++){
						if(d == a){
							int z = (int)bytes[i+2];
							int y = (int)bytes[i+3];
							z = 256*y + z;
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
		
		public override uint8[] get_bytes(string text, int s = 0, int count = -1){
			var list = new Collections.ArrayList<uint8>();
			var str = new String(text.substring(s,count));
			for(var z = 0; z < str.length; z++){
				unichar u = str.to_utf16()[z];
				if(u < 65536){
					uint8 a = (uint8)(u / 256);
					uint8 b = (uint8)(u - 256*a);
					list.add(b);
					list.add(a);
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
							list.add(l2);
							list.add(l1);
							l1 = (uint8)(aa / 256);
							l2 = (uint8)(aa - 256*l1);
							list.add(l2);
							list.add(l1);
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
		
		public override string name {
			owned get { return "utf-16"; }
		}
	}
	
	public class Utf8Encoding : Encoding
	{
		public Utf8Encoding(){}
		
		public override uint8[] get_bytes(string text, int start = 0, int count = -1){ return text.substring(start,count).data; }
		public override string get_string(uint8[] bytes, int start = 0, int count = -1) {
			StringBuilder sb = new StringBuilder();
			foreach(uint8 u in bytes)
				sb.append_c((char)u);
			return sb.str.substring(start,count);
		}
		
		public override string name {
			owned get { return "utf-8"; }
		}
	}
	
	public class ASCIIEncoding : Encoding
	{
		public ASCIIEncoding(){}
		
		public override string get_string(uint8[] bytes, int start = 0, int count = -1){
			StringBuilder sb = new StringBuilder();
			foreach(uint8 u in bytes){
				sb.append_c((u > 127) ? (char)'?' : (char)u);
			}
			return sb.str.substring(start,count);
		}
		
		public override uint8[] get_bytes(string text, int start = 0, int count = -1){
			uint[] data = new String(text.substring(start,count)).to_utf16();
			uint8[] buffer = new uint8[data.length];
			for(var i = 0; i < buffer.length; i++){
				buffer[i] = (data[i] >= 0x0080) ? (uint8)'?' : (uint8)data[i];
			}
			return buffer;
		}
		
		public override string name {
			owned get {
				return "ascii";
			}
		}
	}
}
