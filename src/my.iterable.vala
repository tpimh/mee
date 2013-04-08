namespace My
{
	public interface Iterable<G> : GLib.Object
	{
		public abstract Iterator<G> iterator();
	}

	public class Iterator<G>
	{
		IList<G> iter;
		int index;
		
		public Iterator(IList i){
			iter = i;
			index = 0;
		}
		
		public bool next(){
			if(index==iter.size)return false;
			index++;
			return true;
		}
		
		public bool prev(){
			if(index==0)return false;
			index--;
			return true;
		}
		
		public G @get(){
			return iter.get(index);
		}
	}
}
