namespace My
{
	public class Dictionary<K,V> : IEquatable, IDictionary<K,V>, GLib.Object
	{
		EqualFunc kf;
		EqualFunc vf;
		My.List<K> _keys;
		My.List<V> _values;
		My.List<Entry<K,V>> _entries;
		
		public EqualFunc keys_func{get{return kf;}}
		public EqualFunc values_func{get{return vf;}}
		
		public Dictionary(EqualFunc key_equal = null, EqualFunc value_equal = null){
			kf = key_equal; vf = value_equal;
			if(key_equal == null)kf = Functions.equal_func_for(typeof(K));
			if(value_equal == null)vf = Functions.equal_func_for(typeof(V));
			_keys = new My.List<K>();
			_values = new My.List<V>();
			_entries = new My.List<Entry<K,V>>();
		}
		
		public new void add (K key, V val){
			if(key==null)return;
			_keys.add(key);
			_values.add(val);
		}
		
		public new V @get (K key){
			int pos = _keys.index_of(key);
			if(pos==-1)return null;
			return _values.get(pos);
		}
		
		public new void @set(K key, V val){
			int pos = _keys.index_of(key);
			if(pos==-1)add(key,val);
			else{
				_values.set(pos,val);
			}
		}
		
		public new bool unset(K key, out V val = null){
			if(has_key(key)){
				int i = _keys.index_of(key);
				_keys.remove_at(i);
				val = _values.get(i);
				_values.remove_at(i);
				return true;
			}
			return false;
		}
		
		public new bool has_key(K key){return _keys.contains(key);}
		public new bool has_value(V val){return _values.contains(val);}
		
		public new bool equals(GLib.Object o){
			if(!(o is Dictionary))return false;
			if(!(o as Dictionary).values.equals(values))return false;
			if(!(o as Dictionary).keys.equals(keys))return false;
			return true;
		}
		
		public new List<K> keys{
			get{return _keys;}
		}
		
		public new List<V> values{
			get{return _values;}
		}
		
		public new int size{
			get{return _keys.size;}
		}
		
		public IList<Entry<K,V>> entries
		{
			get{
				_entries = new My.List<Entry<K,V>>();
				for(int i=0; i<size; i++)
					_entries.add(new Entry<K,V>(_keys.get(i),_values.get(i)));
				return _entries;
			}
		}
	}
}
