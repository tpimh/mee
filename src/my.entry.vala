namespace My
{
	public class Entry<K,V>
	{
		K _key;
		V _value;
		
		public Entry(K k = null, V v = null){
			_key = k; _value = v;
		}
		
		public K key{
			get{return _key;}
			set{_key = value;}
		}
		
		public V @value{
			get{return _value;}
			set{_value = value;}
		}
	}
}
