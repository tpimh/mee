namespace Mee.Feed
{
	public class Object : Mee.Object
	{
		internal Xml.Node node;
		
		public Object(Xml.Node n)
		{
			node = n;
		}
		
		public string title {
			owned get { return node["title"].inner_text; }
		}
		
		public string link {
			owned get { return node["link"].inner_text; }
		}
		
		public string description {
			owned get { return node["description"].inner_text; }
		}
	}
}
