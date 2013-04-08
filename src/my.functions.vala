namespace My
{
	namespace Functions
	{
		public static EqualFunc equal_func_for(Type t){
			if(t == typeof(string))return str_equal;
			return direct_equal;
		}
		
		public static CompareFunc compare_func_for(Type t){
			if(t == typeof(string))return (CompareFunc)strcmp;
			return direct_compare;
		}
		
		public static int direct_compare (void* _val1, void* _val2) {
			long val1 = (long)_val1, val2 = (long)_val2;
			if (val1 > val2) {
				return 1;
			} else if (val1 == val2) {
				return 0;
			} else {
				return -1;
			}
		}
	}
}
