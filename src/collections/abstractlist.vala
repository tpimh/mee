namespace Mee.Collections
{
	public abstract class AbstractList<T> : Iterable<T>, Collection<T>, List<T>, Mee.Object
	{
		public abstract new T get (int index);
		public abstract new void set (int index, T item);
		public abstract int index_of(T item);
		public abstract void insert (int index, T item);
		public abstract T remove_at (int index);
		public abstract List<T>? slice (int start, int end);
		public abstract T first();
		public abstract T last();
		public abstract void insert_all (int index, Collection<T> collection);
		public abstract void sort (CompareFunc? compare_func = null);
		public abstract int size { get; }
		public abstract bool is_empty { get; }
		public abstract bool contains (T item);
		public abstract void add (T item);
		public abstract bool remove (T item);
		public abstract void clear ();
		public abstract bool add_all (Collection<T> collection);
		public abstract bool contains_all (Collection<T> collection);
		public abstract bool remove_all (Collection<T> collection);
		public abstract bool retain_all (Collection<T> collection);
		public abstract Iterator<T> iterator();
	}
}
