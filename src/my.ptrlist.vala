namespace My
{
	public class PtrList : My.List<void *>
	{
		public void **data
		{
			get{
				return (void *)to_array();
			}
		}
	}
}
