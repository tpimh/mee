namespace Mee.Collections
{
	public delegate O TransformFunc<I,O> (I input);
	
	/**
	 * an interface to compare two objects 
	 */
	public interface Comparable<T> : GLib.Object
	{
		/**
		 * Compare provided object with this.
		 * 
		 * @return < 0, 0 or > 0 as this object is less than, equal to, or greater than the specified object 
		 */
		public abstract int compare_to(T val);
	}
	
	/**
	 * An object that can provide an {@link Iterator}.
	 */
	public interface Iterable<T> : GLib.Object
	{
		/**
		 * Returns a {@link Iterator} that can be used for simple iteration over a
		 * collection.
		 *
		 * @return a {@link Iterator} that can be used for simple iteration over a
		 *         collection
		 */
		public abstract Iterator<T> iterator();
	}
	
	public interface Iterator<T> : GLib.Object
	{
		public abstract T get();
		public abstract bool next();
		public abstract void reset();
	}
	
	public interface List<T> : Iterable<T>
	{
		public abstract T get (int index);
		public abstract int index_of(T item);
		public abstract List<T>? slice (int start, int end);
		public abstract T first();
		public abstract T last();
		public abstract T[] to_array();
		public abstract int size { get; }
		public abstract bool is_empty { get; }
		public abstract bool contains (T item);
		public abstract bool contains_all (List<T> list);
	}
	
	public interface Collection<T> : List<T>
	{
		public abstract void sort (CompareFunc? compare_func = null);
		public abstract void insert (int index, T item);
		public abstract T remove_at (int index);
		public abstract void set (int index, T item);
		public abstract void add (T item);
		public abstract bool remove (T item);
		public abstract void clear ();
		public abstract bool add_all (List<T> list);
		public abstract void insert_all (int index, List<T> list);
		public abstract bool remove_all (List<T> list);
		public abstract bool retain_all (List<T> list);
		
		public abstract List<T> read_only_view { owned get; }
	}
}
