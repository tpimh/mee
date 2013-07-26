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
		
		public string substring(){ return this.str.substring(this.index); }
		public char getc() { return this.str[index]; }
		public int index_of(string needle) { return this.str.index_of(needle,this.index); }
	}
}
