namespace Mee.Collections
{
	public delegate O TransformFunc<I,O> (I input);
	
	public interface Iterable<T> : Mee.Object
	{
		public abstract Iterator<T> iterator();
	}
	
	public interface Iterator<T> : Mee.Object
	{
		public abstract T get();
		public abstract bool next();
		public abstract void reset();
	}
	
	public interface Collection<T> : Iterable<T>
	{
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
	}
	
	public interface List<T> : Collection<T>
	{
		public abstract T get (int index);
		public abstract void set (int index, T item);
		public abstract int index_of(T item);
		public abstract void insert (int index, T item);
		public abstract T remove_at (int index);
		public abstract List<T>? slice (int start, int end);
		public abstract T first();
		public abstract T last();
		public abstract void insert_all (int index, Collection<T> collection);
		public abstract void sort (CompareFunc? compare_func = null);
	}
}
