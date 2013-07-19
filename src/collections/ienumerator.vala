namespace Mee.Collections
{
	public interface IEnumerator<G> : GLib.Object
	{
		public abstract G get();
		public abstract bool next();
		public abstract void reset();
	}
	
	public interface IEnumerable<G> : GLib.Object
	{
		public abstract IEnumerator<G> iterator();
	}
}
