namespace Mee.Linq
{
	public class Query<G> : Gee.ArrayList<G>
	{
		public static Query from<G>(G[] array){
			var list = new Query<G>();
			for(var i = 0; i < array.length; i++)
				list.add(array[i]);
			return list;
		}
		public static Query from_e<G>(Gee.Iterable<G> e){
			var list = new Query<G>();
			foreach(var item in e)
				list.add(item);
			return list;
		}
		
		public Query select(SelectFunc func){
			var list = new Query<G>();
			foreach(var item in this){
				list.add(func(item));
			}
			return list;
		}
		
		public Query where(WhereFunc func){
			var list = new Query<G>();
			foreach(var item in this)
				if(func(item))
					list.add(item);
			return list;
		}
		
	}

	public delegate bool WhereFunc<G>(G item);
	public delegate G SelectFunc<G>(G item);
}
