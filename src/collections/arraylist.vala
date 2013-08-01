namespace Mee.Collections
{
	public class ArrayList<T> : AbstractList<T>
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
		
		public ArrayList(EqualFunc? efunc = null){ 
			array = new T[0]; 
			func = (efunc == null) ? get_equal_func_for(typeof(T)) : efunc;
		}
		
		public override T get(int index){
			return (index < size && index >= 0) ? array[index] : null;
		}
		public override void set(int index, T item){
			if(index < size && index >= 0)
				array[index] = item;
		}
		public override int index_of(T item){
			for(var i = 0; i < size; i++)
				if(func(item,array[i]))return i;
			return -1;
		}
		public override bool contains(T item){ return index_of(item) != -1; }
		public override void add (T item){
			array.resize(size+1);
			array[size-1] = item;
		}
		public override void insert (int index, T item){
			if(index < 0 || index >= size)return;
			var nlist = new ArrayList<T>();
			for(var i=0; i<index; i++)
				nlist.add(array[i]);
			nlist.add(item);
			for(var i=index; i<size; i++)
				nlist.add(array[i]);
			array = nlist.array;
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
			foreach(var item in collection){
				add(item);
			}
			return true;
		}
		public override void insert_all(int index, Collection<T> collection){
			if(index < 0)return;
			var nlist = new ArrayList<T>();
			for(var i=0; i<index; i++)
				nlist.add(array[i]);
			foreach(var item in collection)
				nlist.add(item);
			for(var i=index; i<size; i++)
				nlist.add(array[i]);
			array = nlist.array;
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
		
		public override Mee.Collections.Iterator<T> iterator(){ return new Iterator<T>(this); }
		public override void clear(){ array = new T[0]; }
		public override T first(){ return (size > 0) ? array[0] : null; }
		public override T last(){ return (size > 0) ? array[size-1] : null; }
		public override bool is_empty { get{ return size == 0; } }
		public override int size { get{ return array.length; } }
		
		public T[] to_array() { return array; }
		
		public ArrayList<O> transform<O>(TransformFunc func){
			var list = new ArrayList<O>();
			foreach(var item in this)
				list.add(func(item));
			return list;
		}
		
		class Iterator<T> : Mee.Collections.Iterator<T>, Mee.Object
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
