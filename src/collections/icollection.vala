namespace Mee.Collections
{
	public interface ICollection<G> : GLib.Object
	{
		public abstract void add(G item);
		public abstract void clear();
		public abstract bool contains(G item);
		public abstract int index_of(G item);
		public abstract void remove(G item);
		public abstract void remove_at(int index);
		public abstract void sort();
		public abstract bool is_empty { get; }
		public abstract int size { get; }
	}
	
	public interface Comparable<G> : GLib.Object
	{
		public abstract int compare(G object);
	}
	
	
}
