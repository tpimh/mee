using Mee.Collections;

namespace Mee.Linq
{
	public delegate T TFunc<T>(T item);
	public delegate bool WhereFunc<T>(T item);
	public delegate double DoubleFunc<T>(T item);
	
	public class Query<T> : ArrayList<T>
	{
		Query(){}
		
		public static Query from<T>(T[] array){
			Query<T> q = new Query<T>();
			q.add_array(array);
			return q;
		}
		
		public static Query from_i<T>(Iterable<T> iter){
			var query = new Query<T>();
			foreach(T item in iter)
				query.add(item);
			return query;
		}
		
		public Query where<T>(WhereFunc<T> func){
			Query<T> q = new Query<T>();
			foreach(var t in this)
				if(func(t))
					q.add(t);
			return q;
		}
		
		public Query select<T>(TFunc<T> func){
			Query<T> query = new Query<T>();
			foreach(T item in this)
				query.add(func(item));
			return query;
		}
		
		public Query reverse(){
			Query<T> q = new Query<T>();
			for(var i = size-1; i > -1; i--)
				q.add(this[i]);
			return q;
		}
		
		public double sum(DoubleFunc func){
			double res = 0;
			foreach(T item in this)
				res += func(item);
			return res;
		}
		
		public T aggregate(TFunc func){
			T result = this[0];
			for(var i = 1; i < size; i++)
				result = func(result);
			return result;
		}
	}
}
