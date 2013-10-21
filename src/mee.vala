using Gee;

namespace Mee
{
	public errordomain Error
	{
		Null,
		Content,
		Length,
		Type,
		Start,
		End,
		Malformed
	}
	
	public void println(string format, ...){
		print(format+"\n",va_list());
	}
	
	public struct Duet<G>
	{
		public G left;
		public G right;
	}
	
	namespace Array
	{
		public bool copy(uint8[] src, int start, uint8[] dest, int offset = 0, int len = -1){
			if (src == null || src.length == 0 || dest == null || dest.length == 0)
				return false;
			uint8[] _src = src;
			int length = len == -1 ? src.length : len;
			if (offset+length > dest.length)
				return false;
			for(var i = 0; i <= length - offset; i++){
				dest[i+offset] = _src[start+i];
			}
			return true;
		}
	}
}
