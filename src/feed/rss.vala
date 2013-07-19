using Mee.Collections;
using Mee;
using Mee.Xml;

namespace Mee.Feed
{
	
	public class Rss : Doc
	{
		public Rss(string file) throws Mee.Error
		{
			base.file(file);
			if(root_node.name != "rss"){
				var e = new Error.Type("file isn't a rss feed");
				error_occured(e);
				throw e;
			}
			channels = new ArrayList<Channel>();
			foreach(var node in root_node.children)
				if(node.name == "channel")
					channels.add(new Channel(node));
		}
		
		public ArrayList<Channel> channels {get; set;}
	}
	
	public class Channel : Object
	{
		internal Channel(Xml.Node n)
		{
			base(n);
			items = new ArrayList<Item>();
			foreach(var child in node.children)
				if(child.name == "item")
					items.add(new Item(child));
		}
		
		public Date pub_date {
			owned get { return new Date.pub(node["pubDate"].inner_text); }
		}	
		
		public Image image {
			owned get { return new Image(node["image"]); }
		}
		
		public ArrayList<Item> items {get; set;}
	}
	
	public class Item : Object
	{
		internal Item(Xml.Node n)
		{
			base(n);
		}
		
		public Date pub_date {
			owned get { return new Date.pub(node["pubDate"].inner_text); }
		}
	}
	
	public class Image : Object
	{
		internal Image(Xml.Node n)
		{
			base(n);
		}
		
		public string url {
			owned get { return node["url"].inner_text; }
		}
	}
	
	public class Enclosure
	{
		Xml.Node node;
		
		internal Enclosure(Xml.Node n)
		{
			node = n;
		}
		
		public string url {
			owned get { return node.attributes["url"]; }
			set { node.attributes["url"] = value; }
		}
		
		public string mime_type {
			owned get { return node.attributes["type"]; }
			set { node.attributes["type"] = value; }
		}
		
		public long length {
			get { return long.parse(node.attributes["length"]); }
			set { node.attributes["length"] = value.to_string(); }
		}
	}
	
	public class Guid 
	{
		Xml.Node node;
		
		internal Guid(Xml.Node n)
		{
			node = n;
		}	
		
		public bool is_permalink {
			get { return bool.parse(node.attributes["isPermaLink"]); }
			set { node.attributes["isPermaLink"] = value.to_string(); }
		}
		
		public string val {
			owned get{ return node.inner_text; }
			set{ node.inner_text = value; }
		}
	}
}
