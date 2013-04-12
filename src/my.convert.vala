using Base64;

namespace My
{
	namespace Convert
	{
		public static uint8[] to_uint8_array(string s){
			if(s.length<1)return new uint8[0];
			return decode(s);
		}
		
		public static string to_base64_string(uint8[] array, int offset = 0, int length = array.length){
			if(offset+length>array.length)length = array.length-offset;
			ByteVector bv = new ByteVector();
			for(int i=offset; i<length; i++)
				bv.add(array[i]);
			return encode(bv.to_array());
		}
		
		public static string unicode_to_utf8(uint16[] array)
		{
			string str = "";
			
			for(int i=0; i<array.length;i++)
				str += ((char)(array[i]/256)).to_string();
			return str;
		}
		
		public static uint16[] utf8_to_unicode(string str){
			uint8[] array = str.data;
			uint16[] t = new uint16[array.length*2];
			for(int i=0; i<array.length; i++)
				t[i] = 256*array[i];
			for(int i=0; i<array.length; i++)
				t[i+array.length] = 0;
			return t;
		}
	}
}
