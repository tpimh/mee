using Mee.Collections;

namespace Mee
{
	public struct Duet<G>
	{
		public G left;
		public G right;
		
		public void test(){}
	}
	
	public struct istring
	{
		public string str;
		public int index;
		
		public string substring(int length = -1){ return this.str.substring(this.index,length); }
		public char getc() { return this.str[index]; }
		public int index_of(string needle) { return this.str.index_of(needle,this.index); }
		public int[] indexs_of(string str, ...){
			var list = va_list();
			var alist = new ArrayList<int>();
			alist.add(index_of(str));
			for (string? s = list.arg<string?> (); s != null ; s = list.arg<string?> ()){
				alist.add(index_of(s));
			}
			alist.sort();
			for(var i = 0; i<alist.size; i++){
				if(alist[0] == -1){
					alist.add(alist.remove_at(0));
				}
			}
			return alist.to_array();
		}
		public void scale(int offset){
			this.index += offset;
			this.index = this.index_of(this.substring().chug());
		}
	}
}
