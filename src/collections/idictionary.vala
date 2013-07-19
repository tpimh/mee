namespace Mee.Collections
{
	public class Entry<K,V>
	{
		public K key;
		public V value;
		
		public Entry(K k, V v = null){ key = k; value = v; }
	}
	
	public interface IDictionary<K,V> : GLib.Object
	{
		public abstract void set(K key, V value);
		public abstract V get(K key);
		public abstract void unset(K key, out V value = null);
		public abstract void clear();
		public abstract bool contains_key(K key);
		public abstract bool contains_value(V value);
		public abstract IEnumerator<Entry<K,V>> iterator();
		public abstract IList<K> keys { owned get; }
		public abstract IList<V> values { owned get; }
		public abstract IList<Entry<K,V>> entries { owned get; }
		public abstract bool is_empty { get; }
		public abstract int size { get; }
	}
}
