namespace Mee
{
	public struct Set
	{
		public string left;
		public string right;
		
		public bool is_incomplete(){
			return left == null || right == null;
		}
		
		public string to_string(){
			return "[%s,%s]".printf(left,right);
		}
		public string[] to_array(){
			return new string[]{left,right};
		}
	}
	
	public struct Sub
	{
		public int left;
		public int right;
		public int max { get{ return (left > right) ? left : right; } }
		public int min { get{ return (left < right) ? left : right; } }
		
		public int res(){
			return left - right;
		}
		public bool is_incomplete(){
			return left == -1 || right == -1;
		}
		public string to_string(){
			return "{%d,%d}".printf(left,right);
		}
		public int[] to_array(){
			return new int[]{left,right};
		}
	}
	
}
