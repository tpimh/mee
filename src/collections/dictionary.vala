namespace Mee.Collections
{
	public interface IDictionary<K,V> : GLib.Object
	{
		public abstract int size { get; }
		public abstract bool is_empty { get; }
		public abstract List<K> keys { owned get; }
		public abstract List<V> values { owned get; }
		public abstract List<Entry<K,V>> entries { owned get; }
		public abstract bool has_key (K key);
		public abstract bool has_value (V value);
		public abstract bool has_entry (K key, V value);
		public abstract V? get (K key);
		public abstract  void @foreach(HFunc func);
		
	}
	
	public class Dictionary<K,V> : Iterable<Entry<K,V>>, IDictionary<K,V>, GLib.Object
	{
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
	
		
		ArrayList<K> keylist;
		ArrayList<V> valuelist;
		
		public Dictionary(EqualFunc? keyfunc = null, EqualFunc? valuefunc = null){
			keylist = new ArrayList<K>(keyfunc);
			valuelist = new ArrayList<V>(valuefunc);
		}
		
		public bool has_key(K key){ return keylist.contains(key); }
		public bool has_value(V value){ return valuelist.contains(value); }
		public bool has_entry(K key,V value){ var e = new Entry<K,V>(key,value); return entries.contains(e); }
		public new void set(K key, V value){
			if(!keylist.contains(key)){
				keylist.add(key);
				valuelist.add(value);
			}else{
				valuelist[keylist.index_of(key)] = value;
			}
		}
		public new V? get(K key){
			return (keylist.contains(key)) ? valuelist[keylist.index_of(key)] : null;
		}
		public bool unset(K key, out V value = null){
			if(!keylist.contains(key))return false;
			value = valuelist.remove_at(keylist.index_of(key));
			keylist.remove_at(keylist.index_of(key));
			return true;
		}
		public void set_all(IDictionary<K,V> dictionary){
			foreach(var entry in dictionary.entries)
				set(entry.key,entry.value);
		}
		public void clear(){ keylist.clear(); valuelist.clear(); }
		public int size { get{ return keylist.size; } }
		public bool is_empty { get{ return size == 0; } }
		public List<K> keys { owned get{ return keylist; } }
		public List<V> values { owned get{ return valuelist; } }
		public List<Entry<K,V>> entries {
			owned get{
				var eset = new ArrayList<Entry<K,V>>();
				for(var i=0; i<size; i++)
					eset.add(new Entry<K,V>(keylist[i],valuelist[i]));
				return eset;
			}
		}
		public void @foreach(HFunc func){
			for(var i=0; i<size; i++)
				func(entries[i].key,entries[i].value);
		}
		
		public IDictionary<K,V> read_only_view {
			owned get {
				return this;
			}
		}
		
		public Mee.Collections.Iterator<Entry<K,V>> iterator(){ return new Iterator<K,V>(entries); }
		
		class Iterator<K,V> : Mee.Collections.Iterator<Entry<K,V>>, GLib.Object
		{
			Mee.Collections.List<Entry<K,V>> list;
			int index;
			
			public Iterator(Mee.Collections.List<Entry<K,V>> a){ list = a; index = 0; }
			
			public new Entry<K,V> get(){ return list[index-1]; }
			public bool next(){ if(index == list.size)return false; index++; return true; }
			public void reset(){ index = 0; }
		}
	}
}
