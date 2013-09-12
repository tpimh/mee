namespace Mee.Collections
{
	public class Entry<K,V> : GLib.Object
	{
		K k; V v;
		
		public K key { get{ return k; } }
		public V @value { get{ return v; } set{ v = value; } }
		
		public Entry(K _k, V _v){k = _k; v = _v;}
	}
}
