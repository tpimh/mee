namespace Mee.Collections
{
	public class Dictionary<K,V> : IDictionary<K,V>, GLib.Object
	{
		ArrayList<K> lkey;
		ArrayList<V> lvalue;
		
		public Dictionary(){
			lkey = new ArrayList<K>();
			lvalue = new ArrayList<V>();
		}
		
		public void clear(){
			lkey.clear();
			lvalue.clear();
		}
		
		public bool contains_key(K key){
			return lkey.contains(key);
		}
		public bool contains_value(V value){
			return lvalue.contains(value);
		}
		
		public void set(K key, V value){
			var i = lkey.index_of(key);
			if(i == -1){
				lkey.add(key);
				lvalue.add(value);
			}
			else{
				lvalue[i] = value;
			}
		}
		public V get(K key){
			var i = lkey.index_of(key);
			if(i == -1)return null;
			else return lvalue[i];
		}
		public void unset(K key, out V value = null){
			var i = lkey.index_of(key);
			value = get(key);
			if(i != -1){
				lkey.remove_at(i);
				lvalue.remove_at(i);
			}
		}
		public IEnumerator<Entry<K,V>> iterator(){ return new Iterator<K,V>(this); }
		
		public IList<K> keys { owned get { return lkey; } }
		public IList<V> values { owned get { return lvalue; } }
		public IList<Entry<K,V>> entries {
			owned get {
				ArrayList<Entry<K,V>> list = new ArrayList<Entry<K,V>>();
				for(var i = 0; i < lkey.size; i++)
					list.add(new Entry<K,V>(lkey[i],lvalue[i]));
				return list;
			} 
		}
		public int size { get { return lkey.size; } }
		public bool is_empty { get { return size == 0; } }
		
		class Iterator<K,V> : IEnumerator<Entry<K,V>>, GLib.Object
		{
			Dictionary<K,V> dic;
			int i = -1;
			
			public Iterator(Dictionary d){
				dic = d;
			}
			
			public bool next(){
				if(i==dic.size-1)return false;
				i++; return true;
			}
			public Entry<K,V> get(){ return dic.entries[i]; }
			public void reset(){ i = -1; }
		}
	}
}
