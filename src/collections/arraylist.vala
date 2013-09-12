namespace Mee.Collections
{
	public class ArrayList<T> : Iterable<T>, List<T>, Collection<T>, GLib.Object
	{
		internal T[] array;
		
		EqualFunc get_equal_func_for (Type t) {
			if (t == typeof (string)) {
				return str_equal;
			} else {
				return direct_equal;
			}
		}
		
		int direct_compare (void* _val1, void* _val2) {
			long val1 = (long)_val1, val2 = (long)_val2;
			if (val1 > val2) {
				return 1;
			} else if (val1 == val2) {
				return 0;
			} else {
				return -1;
			}
		}
			
		CompareFunc get_compare_func_for (Type t) {
			if (t == typeof (string)) {
				return (CompareFunc) strcmp;
			} else {
				return (CompareFunc) direct_compare;
			}
		}
	
		EqualFunc func;
		CompareFunc cf;
		
		public GLib.Type list_type { get { return typeof(T); } }
		
		public List<T> read_only_view {
			owned get {
				return this;
			}
		}
		
		public ArrayList(EqualFunc? efunc = null){ 
			array = new T[0]; 
			func = (efunc == null) ? get_equal_func_for(typeof(T)) : efunc;
		}
		
		public T get(int index){
			return (index < size && index >= 0) ? array[index] : null;
		}
		public void set(int index, T item){
			if(index < size && index >= 0)
				array[index] = item;
		}
		public int index_of(T item){
			for(var i = 0; i < size; i++)
				if(func(item,array[i]))return i;
			return -1;
		}
		public bool contains(T item){ return index_of(item) != -1; }
		public void add (T item){
			array.resize(size+1);
			array[size-1] = item;
		}
		public void insert (int index, T item){
			if(index < 0 || index >= size)return;
			var nlist = new ArrayList<T>();
			for(var i=0; i<index; i++)
				nlist.add(array[i]);
			nlist.add(item);
			for(var i=index; i<size; i++)
				nlist.add(array[i]);
			array = nlist.array;
		}
		public T remove_at(int index){
			if(index < 0 || index >= size)return null;
			var list = new ArrayList<T>();
			for(var i = 0; i < index; i++)
				list.add(array[i]);
			var item = array[index];
			for(var i = index+1; i < size; i++)
				list.add(array[i]);			
			array = list.array;
			return item;
		}
		public bool remove(T item){
			if(index_of(item) > -1){
				remove_at(index_of(item));
				return true;
			}
			return false;
		}
		public List<T>? slice(int start, int end){
			if(start >= size || start < 0 || end <= start) return null;
			var list = new ArrayList<T>();
			for(var i = start; i < end; i++)
				list.add(array[i]);
			return list;
		}
		public bool add_all (List<T> list){
			foreach(var item in list){
				add(item);
			}
			return true;
		}
		
		public void insert_all(int index, List<T> list){
			if(index < 0)return;
			var nlist = new ArrayList<T>();
			for(var i=0; i<index; i++)
				nlist.add(array[i]);
			foreach(var item in list)
				nlist.add(item);
			for(var i=index; i<size; i++)
				nlist.add(array[i]);
			array = nlist.array;
		}
		public bool remove_all (List<T> list){
			int psize = size;
			foreach(var item in list)
				remove(item);
			return psize != size;
		}
		public bool retain_all (List<T> list){
			int psize = size;
			foreach(var item in this)
				if(!list.contains(item))
					remove(item);
			return psize != size;
		}
		public bool contains_all(List<T> list){
			if(list.size > size)return false;
			foreach(var item in list)
				if(!contains(item))
					return false;
			return true;
		}
		public void sort(CompareFunc? cfunc = null){
			cf = (cfunc == null) ? get_compare_func_for(typeof(T)) : cfunc;
			var list = this;
			_sort<T>(ref list);
			array = list.array;
		}
		void _sort<T> (ref ArrayList<T> list){
			if(list.size < 2)return;
			ArrayList<T> nlist = new ArrayList<T>();
			nlist.add(list[0]);
			for(var i = 1; i < list.size; i++){
				int c = cf(list[i],nlist[i-1]);
				if(c >= 0)nlist.add(list[i]);
				else nlist.insert(nlist.size-1,list[i]);
			}
			bool is_sorted = true;
			for(var i = 1; i < nlist.size; i++){
				if(cf(nlist[i],nlist[i-1]) < 0)is_sorted = false;
			}
			if(!is_sorted)_sort<T>(ref nlist);
			list = nlist;
		}
		/**
		 * {@inheritDoc}
		 */
		public Mee.Collections.Iterator<T> iterator(){ return new Iterator<T>(this); }
		public void clear(){ array = new T[0]; }
		public T first(){ return (size > 0) ? array[0] : null; }
		public T last(){ return (size > 0) ? array[size-1] : null; }
		public bool is_empty { get{ return size == 0; } }
		public int size { get{ return array.length; } }
		
		public void add_array(T[] table){
			if(typeof(T) == typeof(bool)){ foreach(bool b in (bool[])table)add(b); }
			else if(typeof(T) == typeof(char)){ foreach(char c in (char[])table)add(c); }
			else if(typeof(T) == typeof(uchar)){ foreach(uchar u in (uchar[])table)add(u); }
			else if(typeof(T) == typeof(int)){ foreach(int i in (int[])table)add(i); }
			else if(typeof(T) == typeof(uint)){ foreach(uint u in (uint[])table)add(u); }
			else if(typeof(T) == typeof(int64)){ foreach(int64 i in (int64[])table)add(i); }
			else if(typeof(T) == typeof(uint64)){ foreach(uint64 u in (uint64[])table)add(u); }
			else if(typeof(T) == typeof(long)){ foreach(long l in (long[])table)add(l); }
			else if(typeof(T) == typeof(ulong)){ foreach(ulong u in (ulong[])table)add(u); }
			else { foreach(var item in table)add(item); }
		}
		
		public static ArrayList from_array<T> (T[] table){
			var list = new ArrayList<T>();
			list.add_array(table);
			return list;
		}
		
		public Json.Array to_json_array(){
			Json.Array a = new Json.Array.empty();
				foreach(var t in this){
					if(typeof(T) == typeof(bool))
						a.add_boolean_element((bool)t);
					if(typeof(T) == typeof(int) || typeof(T) == typeof(uint) || 
						typeof(T) == typeof(int64) || typeof(T) == typeof(uint64) || 
						typeof(T) == typeof(long) || typeof(T) == typeof(ulong))
						a.add_int_element((int64)t);
					if(typeof(T) == typeof(char) || typeof(T) == typeof(uchar) )
						a.add_string_element(((char)t).to_string());
					if(typeof(T) == typeof(double) || typeof(T) == typeof(float))
						a.add_double_element((double?)t);
					if(typeof(T) == typeof(string))
						a.add_string_element((string)t);
					if(typeof(T).is_object())
						a.add_element(new Json.Node(Json.gobject_to_data((GLib.Object)t)));
				}
			return a;
		}
		
		public T[] to_array() {
			var t = typeof (T);
			if (t == typeof (bool)) {
				return (T[]) to_bool_array ((Collection<bool>) this);
			} else if (t == typeof (char)) {
				return (T[]) to_char_array ((Collection<char>) this);
			} else if (t == typeof (uchar)) {
				return (T[]) to_uchar_array ((Collection<uchar>) this);
			} else if (t == typeof (int)) {
				return (T[]) to_int_array ((Collection<int>) this);
			} else if (t == typeof (uint)) {
				return (T[]) to_uint_array ((Collection<uint>) this);
			} else if (t == typeof (int64)) {
				return (T[]) to_int64_array ((Collection<int64>) this);
			} else if (t == typeof (uint64)) {
				return (T[]) to_uint64_array ((Collection<uint64>) this);
			} else if (t == typeof (long)) {
				return (T[]) to_long_array ((Collection<long>) this);
			} else if (t == typeof (ulong)) {
				return (T[]) to_ulong_array ((Collection<ulong>) this);
			} else if (t == typeof (float)) {
				return (T[]) to_float_array ((Collection<float>) this);
			} else if (t == typeof (double)) {
				return (T[]) to_double_array ((Collection<double>) this);
			} else {
				T[] array = new T[size];
				int index = 0;
				foreach (T element in this) {
					array[index++] = element;
				}
				return array;
			}
		}
		
			private static bool[] to_bool_array (Collection<bool> coll) {
		bool[] array = new bool[coll.size];
		int index = 0;
		foreach (bool element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static char[] to_char_array (Collection<char> coll) {
		char[] array = new char[coll.size];
		int index = 0;
		foreach (char element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uchar[] to_uchar_array (Collection<uchar> coll) {
		uchar[] array = new uchar[coll.size];
		int index = 0;
		foreach (uchar element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static int[] to_int_array (Collection<int> coll) {
		int[] array = new int[coll.size];
		int index = 0;
		foreach (int element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint[] to_uint_array (Collection<uint> coll) {
		uint[] array = new uint[coll.size];
		int index = 0;
		foreach (uint element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static int64[] to_int64_array (Collection<int64?> coll) {
		int64[] array = new int64[coll.size];
		int index = 0;
		foreach (int64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint64[] to_uint64_array (Collection<uint64?> coll) {
		uint64[] array = new uint64[coll.size];
		int index = 0;
		foreach (uint64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static long[] to_long_array (Collection<long> coll) {
		long[] array = new long[coll.size];
		int index = 0;
		foreach (long element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static ulong[] to_ulong_array (Collection<ulong> coll) {
		ulong[] array = new ulong[coll.size];
		int index = 0;
		foreach (ulong element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static float?[] to_float_array (Collection<float?> coll) {
		float?[] array = new float?[coll.size];
		int index = 0;
		foreach (float element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static double?[] to_double_array (Collection<double?> coll) {
		double?[] array = new double?[coll.size];
		int index = 0;
		foreach (double element in coll) {
			array[index++] = element;
		}
		return array;
	}
		
		public ArrayList<O> transform<O>(TransformFunc func){
			var list = new ArrayList<O>();
			foreach(var item in this)
				list.add(func(item));
			return list;
		}
		
		class Iterator<T> : Mee.Collections.Iterator<T>, GLib.Object
		{
			ArrayList<T> list;
			int index;
			
			public Iterator(ArrayList a){ list = a; index = 0; }
			
			public new T get(){ return list[index-1]; }
			public bool next(){ if(index == list.size)return false; index++; return true; }
			public void reset(){ index = 0; }
		}
	}
}
