namespace Mee.Collections
{
	public delegate void ForeachFunc<G>(G item);
	
	public interface IList<G> : GLib.Object
	{
		public abstract void insert(int index, G item);
		public abstract G get(int index);
		public abstract void set(int index, G item);
		public abstract void add(G item);
		public abstract void add_all(IList<G> list);
		public abstract void clear();
		public abstract bool contains(G item);
		public abstract int index_of(G item);
		public abstract void remove(G item);
		public abstract G remove_at(int index);
		public abstract IEnumerator<G> iterator();
		public abstract void sort();
		public abstract G[] to_array();
		public abstract bool is_empty { get; }
		public abstract int size { get; }
	}
}
