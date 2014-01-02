namespace Mee {
    namespace Array {
        public delegate O ConvertFunc<I,O> (I input);
        public delegate bool Predicate<T> (T item);
        
        public static T aggregate<T> (T[] array, Gee.FoldFunc<T,T> func)
        {
            var src_list = new Gee.ArrayList<T>.wrap (array);
            return src_list.fold<T>(func, 0);
        }
        
        public static O[] convert<I,O> (I[] array, ConvertFunc<I,O> func)
        {
            var src_list = new Gee.ArrayList<I>.wrap (array);
            var output_list = new Gee.ArrayList<O>();
            for (var i = 0; i < src_list.size; i++)
                output_list.add(func(src_list[i]));
            return output_list.to_array();
        }
    
        public static bool copy<T> (T[] array, int start, ref T[] dest, int offset = 0, int length = -1)
        {
           if(array.length == 0 || dest.length == 0)
                return false;
            int count = length == -1 ? array.length : length;
            if (offset + count >= dest.length)
                return false;
            var src_list = new Gee.ArrayList<T>();
            var dest_list = new Gee.ArrayList<T>();
            src_list.add_all_array(array);
            dest_list.add_all_array(dest);
            for(var i = 0; i < count; i++)
                dest_list[i+offset] = src_list[i+start];
            dest = dest_list.to_array();
            return true;
        }
        
        public static T? find<T> (T[] array, Predicate<T> func)
        {
            var res = find_all<T>(array, func);
            return res.length == 0 ? null : res[0];
        }
        
        public static T[] find_all<T> (T[] array, Predicate<T> func)
        {
        
            var src_list = new Gee.ArrayList<T>.wrap (array);
            var output_list = new Gee.ArrayList<T>();
            src_list.filter((Gee.Predicate<T>)func).foreach (item => {
				output_list.add (item);
				return false;
			});
            return output_list.to_array();
        }
        
        public static void sort<T> (ref T[] array)
        {
            var list = new Gee.ArrayList<T>();
            list.add_all_array(array);
            list.sort();
            array = list.to_array();
        }
        
        public static void reverse<T> (ref T[] array)
        {
            var list = new Gee.ArrayList<T>();
            var src_list = new Gee.ArrayList<T>.wrap (array);
            for (var i = array.length - 1; i > -1; i--)
                list.add (src_list[i]);
            array = list.to_array();
        }
        
        public static T[] union<T> (T[] array1, T[] array2)
		{
			var dataset = new Gee.HashSet<T>();
			dataset.add_all_array (array1);
			dataset.add_all_array (array2);
			return dataset.to_array();
		}
        
        public static T[] concat<T> (T[] array1, T[] array2)
		{
			var list = new Gee.ArrayList<T>();
			list.add_all_array (array1);
			list.add_all_array (array2);
			return list.to_array();
		}
    }
}
