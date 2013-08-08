namespace Mee.Xml
{
	public enum ElementType
	{
		Null,
		Xml,
		Node,
		Doc,
		Text,
		CData,
		Comment;
		
		public string to_string(){
			string[] t = {"null","xml","node","doc","text","cdata","comment"};
			return t[(int)this];
		}
	}
}
