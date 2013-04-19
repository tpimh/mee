namespace My
{
	public abstract class IList<G> : GLib.Object
	{
		public abstract int size{get;}
		public abstract G @get(int index);
		public abstract void @set(int index, G val);
		public abstract void add(G item);
		public abstract void add_range(G[] items);
		public abstract void add_collection(IList<G> coll);
		public abstract bool contains(G item);
		public abstract void insert(int position, G item);
		public abstract void insert_all(int position, G[] items);
		public abstract void insert_collection(int position, IList<G> coll);
		public abstract void reverse();
		public abstract int index_of(G item);
		public abstract int[] index_of_all(G item);
		public abstract void remove(G item);
		public abstract void remove_at(int index);
		public abstract void remove_all(G item);
		public abstract void remove_range(int start, int length);
	}
}
