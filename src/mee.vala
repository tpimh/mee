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
		
		public void test(){}
	}
}
