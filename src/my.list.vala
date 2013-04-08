namespace My
{
	public class List<G> : IList<G>, Iterable<G>, IEquatable, GLib.Object
	{
		G[] array;
		EqualFunc f;
		CompareFunc cf;
		
		public EqualFunc equal_func{get{return f;}}
		
		public List(EqualFunc func = null, CompareFunc cfunc = null){
			f = func;
			cf = cfunc;
			if(func == null)
				f = Functions.equal_func_for(typeof(G));
			if(cfunc == null)
				cf = Functions.compare_func_for(typeof(G));
			array = new G[0];
		}
		
		public new void add(G item){
			G[] new_array = new G[array.length+1];
			for(int i=0; i<array.length; i++)
				new_array[i] = array[i];
			new_array[array.length] = item;
			array = new_array;
		}
		
		public new void reverse(){
			My.List<G> list = new My.List<G>();
			for(int i = size-1; i>-1; i--)
				list.add(array[i]);
			array = list.to_array();
		}
		
		public new void insert(int position, G item){
			My.List<G> list = new My.List<G>();
			for(int i=0; i<position; i++)
				list.add(array[i]);
			list.add(item);
			for(int i=position; i<size; i++)
				list.add(array[i]);
			array = list.to_array();
		}
		
		public new void insert_all(int position, G[] items){
			for(int i=items.length-1; i>-1; i--)
				insert(position,items[i]);
		}
		
		public new void insert_collection(int position, IList<G> collection){
			for(int i=collection.size-1; i>-1; i--)
				insert(position,collection.get(i));
		}
		
		public My.List<G> slice(int start, int end){
			My.List<G> list = new My.List<G>();
			for(int i = start; i<=end; i++)
				list.add(array[i]);
			return list;
		}
		
		public void sort(){
			My.List<G> list = new My.List<G>();
			list.add(array[0]);
			int c = 0;
			for(int i=1; i<size; i++){
				for(int j=0; j<list.size; j++)
					if(cf(array[i],list.get(j))<0){list.insert(j,array[i]);break;}
					else{if(j==list.size-1)c=1;continue;}
				if(c==1){list.add(array[i]); c=0;}
			}
			array = list.to_array();
		}		
		
		public new void add_range(G[] items){
			foreach(G item in items)
				add(item);
		}
		
		public new void add_collection(IList<G> coll){
			foreach(G item in coll)
				add(item);
		}
		
		public new G @get(int index){
			return array[index];
		}
		
		public new void @set(int index, G val){
			if(index>=size)return;
			array[index] = val;
		}
		
		public new bool contains(G item){
			if(index_of(item)==-1)return false;
			return true;
		}
		
		public new int index_of(G item){
			for(int i=0; i<size; i++)
				if(f(array[i],item))return i;
			return -1;
		}
		
		public new int[] index_of_all(G item){
			My.List<int> list = new My.List<int>();
			for(int i=0; i<size; i++)
				if(f(array[i],item))list.add(i);
			return list.to_array();
		}
		
		public new void remove_at(int index){
			My.List<G> list = new My.List<G>();
			for(int i=0; i<size; i++){
				if(i!=index)list.add(array[i]);
			} 
			array = list.to_array();
		}
		
		public new void remove_range(int start, int length){
			for(int i=0; i<length; i++)
				remove_at(start);
		}
		
		public new void remove_all(G item){
			while(index_of(item)>-1)remove_at(index_of(item));
		}
		
		public new void remove(G item){
			if(index_of(item)>-1)remove_at(index_of(item));
		}
		
		public G[] to_array(){
			return array;
		}
			
		public new Iterator<G> iterator(){
			return new Iterator<G>(this);
		}
		
		public void clear(){
			array = new G[0];
		}
		
		public new bool equals(GLib.Object o){
			if(!(o is My.List<G>))return false;
			My.List<G> list = (My.List<G>)o;
			if(size!=list.size)return false;
			for(int i=0; i<size; i++)
				if(!f(array[i],list.get(i)))return false;
			return true;
		}
		
		public int size{get{return array.length;}}
		
		~List(){clear();}
	}
}
