using Mee.Collections;

namespace Mee.Xml
{
	internal static bool is_valid_id(string id){
		if(id.contains("/") || id.contains("\\") ||
		   id.contains("[") || id.contains("]") ||
		   id.contains("{") || id.contains("}") ||
		   id.contains("(") || id.contains(")") ||
		   id.contains("'") || id.contains("\"") ||
		   id.contains("&") || id.contains("~") ||
		   id.contains("#") || id.contains("|") ||
		   id.contains("`") || id.contains("^") ||
		   id.contains("@") || id.contains("°") ||
		   id.contains("+") || id.contains(";") ||
		   id.contains("=") || id.contains("*") ||
		   id.contains("%") || id.contains("<") || 
		   id.contains(">"))
			return false;
		return true;
	}
	
	internal static string valid_string(string data){
			if(data[0] == '"' && data.last_index_of("\"") != data.length-1 ||
			   data[0] == '\'' && data.last_index_of("'") != data.length-1 ||
			   data[0] != '"' && data[0] != '\'')return null;
			return data.substring(1,data.index_of(data[0].to_string(),1)-1);
		}
	
	public class Doc : Node
	{
		public Doc(){
			base();
			attributes["version"] = "1.0";
			attributes["encoding"] = "UTF-8";
		}
		
		public Node root_node {
			owned get{
				return children[children.size-1];
			}
			set{
				value.doc = this;
				if(children.size > 0)
					children.remove_at(children.size-1);
				children.add(value);
			}
		}
		
		public double version {
			get { return double.parse(attributes["version"]); }
		}
		public string encoding {
			owned get { return attributes["encoding"]; }
		}
		
		public static Doc load_file(string path) throws Mee.Error
		{
			string data;
			FileUtils.get_contents(path,out data);
			return load_xml(data);
		}
		
		public static Doc load_xml(string xml) throws Mee.Error
		{
			if(xml.index_of("<?xml") != 0)
				throw new Error.Malformed("XML declaration allowed only at the start of the document");
			string data = xml.replace("\n","").replace("\t","").replace("\r","");
			var node = Node.parse_xml(ref data);
			var doc = new Doc();
			doc.element_type = ElementType.Doc;
			if(node.attributes["version"] == null || node.attributes["encoding"] == null ||
				node.attributes.size() != 2)
				throw new Error.Length("invalid xml declaration (%u)".printf(node.attributes.size()));
			doc.attributes = node.attributes;
			doc.name = "xml";
			doc.namespaces = new HashTable<string,string>(str_hash,str_equal);
			doc.doc = doc;
			doc.children = new ArrayList<Node>();
			Node n;
			while(data.length > 0){
				data = data.chug();
				if(data.index_of("<!--") == 0)
					n = Node.parse_comment(ref data);
				else if(data.index_of("<?xml") == 0)
					n = Node.parse_xml(ref data);
				else if(data.index_of("<![CDATA[") == 0 || data[0] != '<')
					throw new Error.Type("extra content at end");
				else n = Node.parse(ref data, doc);
					n.doc = doc;
					n.parent = node;
					doc.children.add(n);
			}
			return doc;
		}
		
	}
}
