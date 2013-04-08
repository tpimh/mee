namespace My
{
	public class ByteVector : My.List<uint8>
	{
		public ByteVector(string init = ""){
				add_string(init);
		}
		
		public void add_string(string str){
			for(int i=0; i<str.length; i++)
				add((uint8)str.get_char(i));
		}
		
		public string substring(int start, int end = size-1){
			if(end>=size)end = size-1;
			ByteVector bv = slice(start,end) as ByteVector;
			return bv.to_string();
		}
		
		public ByteVector mid(int start, int length){
			ByteVector bv = new ByteVector();
			if(length>size)return bv;
			if(start+length>size)return bv;
			for(int i=start; i<length; i++)
				bv.add(this.get(i));
			return bv;
		}
		
		public uint to_uint (bool most = true)
		{
			uint sum = 0;
			int last = size > 4 ? 3 : size - 1;
			
			for (int i = 0; i <= last; i++) {
				int offset = most ? last-i : i;
				sum |= (uint) ((int)this.get(i) << (offset * 8));
			}
			
			return sum;
		}
		
		public ulong to_ulong (bool most = true)
		{
			ulong sum = 0;
			int last = size > 8 ? 7 : size - 1;
			for(int i = 0; i <= last; i++) {
				int offset = most ? last-i : i;
				sum |= (ulong) ((int)this.get(i) << (offset * 8));
			}
			return sum;
		}
		
		public ushort to_ushort (bool most = true)
		{
			ushort sum = 0;
			int last = size > 2 ? 1 : size - 1;
			for(int i = 0; i <= last; i++) {
				int offset = most ? last-i : i;
				sum |= (ushort) ((int)this.get(i) << (offset * 8));
			}
			return sum;
		}
		
		public static ByteVector from_ulong (ulong value,
		                                    bool most)
		{
			ByteVector vector = new ByteVector();
			for(int i = 0; i < 8; i++) {
				int offset = most ? 7-i : i;
				vector.add ((uint8)(value >> (offset * 8) & 0xFF));
			}
			return vector;
		}
		
		public static ByteVector from_uint (uint value,
		                                   bool most)
		{
			ByteVector vector = new ByteVector();
			for(int i = 0; i < 4; i++) {
				int offset = most ? 3-i : i;
				vector.add ((uint8)(value >> (offset * 8) & 0xFF));
			}
			
			return vector;
		}
		
		public string to_string(){
			string s = "";
			foreach(uint8 u in this)
				s += ((char)u).to_string();
			return s;
		}
	}

	public class ByteVectorCollection : My.List<ByteVector>
	{
		public ByteVectorCollection(){}
		
		public ByteVector to_bytevector(ByteVector separator){
			ByteVector bv = new ByteVector();
			for(int i=0; i<size; i++){
				if(i != 0 && separator.size > 0)
					bv.add_collection(separator);
				bv.add_collection(this.get(i));
			}
			return bv;
		}
	}
}
