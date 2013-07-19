namespace Mee.Collections
{
	public class ArrayList<G> : IList<G>, GLib.Object
	{
		G[] array;
		
		public ArrayList(){ array = new G[0]; }
		
		public void add(G item){
			array.resize(array.length+1);
			array[array.length-1] = item;
		}
		public void add_all(IList<G> list){
			foreach(G item in list)
				add(item);
		}
		
		public G get(int index){
			return array[index];
		}
		public void set(int index, G item){
			if(index < 0 || index >= array.length)return;
			array[index] = item;
		}
		
		public void clear(){ array = new G[0]; }
		public int index_of(G item){
			for(var i = 0; i < array.length; i++)
				if(array[i] == item)return i;
			return -1;
		}
		public bool contains(G item){
			return index_of(item) != -1;
		}
		public void insert(int index, G item){
			ArrayList<G> list = new ArrayList<G>();
			int i = (index < 0) ? 0 : index;
			if(i >= array.length) i = array.length - 1;
			for(var j = 0; j < array.length; j++){
				if(j == i)list.add(item);
				list.add(array[j]);
			}
			array = list.to_array();
		}
		public G remove_at(int index){
			ArrayList<G> list = new ArrayList<G>();
			G val = null;
			for(var j = 0; j < array.length; j++){
				if(j != index)list.add(array[j]);
				else val = array[j];
			}
			array = list.to_array();
			return val;			
		}
		public void remove(G item){
			remove_at(index_of(item));
		}
		public void sort(){
			CompareFunc<G> func = Mee.Functions.get_compare_func_for(typeof(G));
			for(var z=0; z<size; z++){
				ArrayList<G> slist = new ArrayList<G>();
				slist.add(array[0]);
				for(var i=1; i<size; i++)
					if(func(array[i],array[i-1]) == 1)
						slist.add(array[i]);
					else slist.insert(slist.size-1,array[i]);
				array = slist.to_array();
			}
		}
		public void foreach(ForeachFunc func){
			for(var i=0; i<array.length; i++)
				func(array[i]);
		}
		public IEnumerator<G> iterator(){
			return new Iterator<G>(this);
		}
		public G[] to_array(){ return array; }
		
		public bool is_empty { get { return size == 0; } }
		public int size { get { return array.length; } }
			
		class Iterator<G> : IEnumerator<G>, GLib.Object
		{
			ArrayList<G> list;
			int i = -1;
			
			public Iterator(ArrayList cls){
				list = cls;
			}
			public bool next(){
				if(i==list.size-1)return false;
				i++; return true;
			}
			public G get(){ return list[i]; }
			public void reset(){ i = -1; }
		}
	}
}
