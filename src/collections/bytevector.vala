namespace Mee.Collections
{
	public class ByteVector : ArrayList<uint8>
	{
		public ByteVector(string init = ""){
			add_string(init);
		}
		
		public void add_string(string str){
			foreach(uint8 u in str.data)
				add(u);
		}
		
		public string to_string(){ return (string)to_array(); }
	}
}
