namespace Mee.Collections
{
	public class Entry<K,V> : Mee.Object
	{
		K k; V v;
		
		public K key { get{ return k; } }
		public V @value { get{ return v; } set{ v = value; } }
		
		public Entry(K _k, V _v){k = _k; v = _v;}
	}
	
	public class Set<T> : AbstractList<T>
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
		
		public Set(EqualFunc? efunc = null){ 
			array = new T[0]; 
			func = (efunc == null) ? get_equal_func_for(typeof(T)) : efunc;
		}
		
		public override T get(int index){
			return (index < size && index >= 0) ? array[index] : null;
		}
		public override void set(int index, T item){
			if(index < size && index >= 0)
				if(!contains(item))array[index] = item;
		}
		public override int index_of(T item){
			for(var i = 0; i < size; i++)
				if(func(item,array[i]))return i;
			return -1;
		}
		public override bool contains(T item){ return index_of(item) != -1; }
		public override void add (T item){
			if(contains(item))return;
			array.resize(size+1);
			array[size-1] = item;
		}
		public override void insert (int index, T item){
			if(contains(item))return;
			if(index < 0)return;
			var list = new ArrayList<T>();
			for(var i = 0; i < index; i++)
				list.add(array[i]);
			list.add(item);
			for(var i = index; i < size; i++)
				list.add(array[i]);
			array = list.array;
		}
		public override T remove_at(int index){
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
		public override bool remove(T item){
			if(index_of(item) > -1){
				remove_at(index_of(item));
				return true;
			}
			return false;
		}
		public override List<T>? slice(int start, int end){
			if(start >= size || start < 0 || end <= start) return null;
			var list = new ArrayList<T>();
			for(var i = start; i < end; i++)
				list.add(array[i]);
			return list;
		}
		public override bool add_all (Collection<T> collection){
			if(collection.is_empty)return false;
			foreach(var item in collection)
				add(item);
			return true;
		}
		public override void insert_all(int index, Collection<T> collection){
			if(collection == null)return;
			foreach(var item in collection)
				insert(index,item);
		}
		public override bool remove_all (Collection<T> collection){
			int psize = size;
			foreach(var item in collection)
				remove(item);
			return psize != size;
		}
		public override bool retain_all (Collection<T> collection){
			int psize = size;
			foreach(var item in this)
				if(!collection.contains(item))
					remove(item);
			return psize != size;
		}
		public override bool contains_all(Collection<T> collection){
			if(collection.size > size)return false;
			foreach(var item in collection)
				if(!contains(item))
					return false;
			return true;
		}
		public override void sort(CompareFunc? cfunc = null){
			cf = (cfunc == null) ? get_compare_func_for(typeof(T)) : cfunc;
			var list = this;
			_sort<T>(ref list);
			array = list.array;
		}
		void _sort<T> (ref Set<T> list){
			if(list.size < 2)return;
			Set<T> nlist = new Set<T>();
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
		
		public override Mee.Collections.Iterator<T> iterator(){ return new Iterator<T>(this); }
		public override void clear(){ array = new T[0]; }
		public override T first(){ return (size > 0) ? array[0] : null; }
		public override T last(){ return (size > 0) ? array[size-1] : null; }
		public override bool is_empty { get{ return size == 0; } }
		public override int size { get{ return array.length; } }
		
		class Iterator<T> : Mee.Collections.Iterator<T>, Mee.Object
		{
			Set<T> list;
			int index;
			
			public Iterator(Set a){ list = a; index = 0; }
			
			public new T get(){ return list[index]; }
			public bool next(){ if(index == list.size)return false; index++; return true; }
			public void reset(){ index = 0; }
		}
	}
}
