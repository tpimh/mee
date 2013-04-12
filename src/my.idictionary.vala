namespace My
{
	public interface IDictionary<K,V> : GLib.Object
	{
		public abstract void add(K key, V val);
		public abstract V @get(K key);
		public abstract void @set(K key, V val);
		public abstract bool unset(K key, out V val);
		public abstract bool has_key(K key);
		public abstract bool has_value(V val);
		public abstract List<K> keys{get;}
		public abstract List<V> values{get;}
		public abstract int size{get;}
	}
}
