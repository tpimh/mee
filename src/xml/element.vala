using Mee.Collections;

namespace Mee.Xml
{
	public enum ElementType
	{
		Null,
		Text,
		Comment,
		CData,
		Doc,
		Node,
		Xml;
		
		public string to_string(){
			var table = new string[]{"null","text","comment","cdata","doc","node","xml"};
			return table[(int)this];
		}
	}
	
	public interface Element 
	{
		public abstract Doc doc {get; protected set;}
		public abstract ArrayList<Node> children {get; set;}
		public abstract ElementType element_type {get; protected set;}
		public abstract string name {get; set;}
		public abstract Dictionary<string,string> attributes {get; protected set;}
	}
}
