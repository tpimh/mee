namespace Mee.Xml
{
	public enum ElementType
	{
		Null,
		Attribute,
		Xml,
		Node,
		Doc,
		Text,
		CData,
		Comment;
		
		public string to_string(){
			string[] t = {"null","attribute","xml","node","doc","text","cdata","comment"};
			return t[(int)this];
		}
	}
	
	public enum ParseOptions
	{
		Null,
		UncheckNS,
		CheckHtmlUtags,
		AllowUncorrectedTags
	}
}
