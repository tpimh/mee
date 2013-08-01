using Mee.Collections;

namespace Mee
{
	public delegate T SelectFunc<T>(T item);
	public delegate bool WhereFunc<T>(T item);
	
	public class Query<T> : ArrayList<T>
	{
		Query(){}
		
		public static Query from<T>(T[] array){
			var query = new Query<T>();
			for(var i=0; i<array.length; i++)
				query.add(array[i]);
			return query;
		}
		public static Query from_i<T>(Iterable<T> iter){
			var query = new Query<T>();
			foreach(T item in iter)
				query.add(item);
			return query;
		}
		
		public Query where(WhereFunc func){
			Query<T> q = new Query<T>();
			foreach(var t in this)
				if(func(t))
					q.add(t);
			return q;
		}
		
		public void select(SelectFunc func){
			for(var i = 0; i < size; i++)
				this[i] = func(this[i]);
		}
	}
}
