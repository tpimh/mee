namespace Mee {
	public delegate bool WhereFunc<T> (T item);
	public delegate V SelectFunc<K,V> (K key);
	public delegate T TFunc<T> (T item);
	
	[GenericAccessors]
	public interface Queryable<T> : Object
	{
		public abstract Queryable<T> concat (Queryable<T> other);
		public abstract T? first (WhereFunc<T>? func = null);
		public abstract T get (int index);
		public abstract T? last (WhereFunc<T>? func = null);
		public abstract Queryable<T> union_t (Queryable<T> other);
		public abstract Queryable<T> where (WhereFunc<T> func);
		public abstract Queryable<V> select<V> (SelectFunc<T,V> func);
		
		public abstract int size { get; }
		
		public Gee.HashMap<T,V> to_map<V>(TFunc<T> tfunc, SelectFunc<T,V> sfunc){
			var map = new Gee.HashMap<T,V>();
			foreach (var item in this)
				map[tfunc (item)] = sfunc (item);
			return map;
		}
		
		public Gee.ArrayList<T> to_list()
		{
			var list = new Gee.ArrayList<T>();
			foreach (var item in this)
				list.add (item);
			return list;
		}
		
		public T[] to_array()
		{
			return to_list().to_array();
		}
	}
	
	public class List<T> : Gee.ArrayList<T>, Queryable<T>
	{
		public Queryable<T> concat (Queryable<T> other)
		{
			var list = new List<T>();
			list.add_all (this);
			foreach (T item in other)
				list.add (item);
			return list;
		}
		
		public new T? first (WhereFunc<T>? func = null)
		{
			if (func == null)
				return this[0];
			for (var i = 0; i < size; i++)
				if (func (this[i]))
					return this[i];
			return null;
		}
		
		public new T? last (WhereFunc<T>? func = null)
		{
			if (func == null)
				return this[size - 1];
			for (var i = size - 1; i >= 0; i--)
				if (func (this[i]))
					return this[i];
			return null;
		}
		
		public Queryable<V> select<V> (SelectFunc<T,V> func)
		{
			var list = new List<V>();
			foreach (var t in this)
				list.add (func (t));
			return list;
		}
		
		public Queryable<T> union_t (Queryable<T> other)
		{
			var data_set = new Gee.ConcurrentSet<T>();
			data_set.add_all (this);
			foreach (T item in other)
				data_set.add (item);
			var list = new List<T>();
			list.add_all (data_set);
			return list;
		}

		public Queryable<T> where (WhereFunc<T> func)
		{
			var list = new List<T>();
			foreach (var t in this)
				if (func(t))
					list.add (t);
			return list;
		}
	}
}
