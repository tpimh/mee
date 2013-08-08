using Mee.Collections;

namespace Mee.Xml
{
	
	public class Node : Object
	{
		
		public ElementType element_type {get; protected set;}
		public string name {get; set;}
		public ArrayList<Node> children {get; protected set;}
		public HashTable<string,string> namespaces {get; protected set;}
		public Node parent {get; internal set;}
		public HashTable<string,string> attributes {get; protected set;}
		public string content {get; set;}
		public Doc doc {get; protected set;}
		
		public Node get(string name){
			foreach(var node in children)
				if(node.name == name)
					return node;
			return null;
		}
		
		string print_attr(){
			string s = " ";
			attributes.foreach((k,v)=>{
				s += "%s='%s' ".printf((string)k,(string)v);
			});
			return s;
		}
		
		public string to_string(){
			switch(element_type){
				case ElementType.Comment:
					return "<!--%s-->".printf(content);
				case ElementType.CData:
					return "<![CDATA[%s]]>".printf(content);
				case ElementType.Text:
					return content;
				case ElementType.Xml:
					return "<?%s%s?>".printf(name,print_attr());
				case ElementType.Node:
					string s = "";
					foreach(var child in children)	s += child.to_string();
					return "<%s%s>%s</%s>".printf(name,print_attr(),s,name);
				case ElementType.Doc:
					string s = "";
					foreach(var child in children)	s += child.to_string();
					return "<?xml %s?>%s".printf(print_attr(),s);
				default:
					return null;
			}
		}
		
		public string inner_text {
			owned get {
				switch(element_type){
					case ElementType.Comment:
					case ElementType.CData:
					case ElementType.Text:
						return content;
					case ElementType.Node:
						string s = "";
						foreach(var child in children)	s += child.inner_text;
						return s;
					case ElementType.Doc:
					case ElementType.Xml:
					default:
						return null;
				}
			}
			set{
				switch(element_type){
					case ElementType.Comment:
					case ElementType.CData:
					case ElementType.Text:
						content = value;
					break;
					case ElementType.Node:
						children = null;
						string data = value;
						parse_children(ref data);
					break;
				}
			}
		}
		
		public string inner_xml {
			owned get{
				switch(element_type){
					case ElementType.Comment:
					case ElementType.CData:
					case ElementType.Text:
						return content;
					case ElementType.Node:
						string s = "";
						foreach(var child in children)	s += child.to_string();
						return s;
					case ElementType.Doc:
					case ElementType.Xml:
					default:
						return null;
				}
			}
			set{
				switch(element_type){
					case ElementType.Comment:
					case ElementType.CData:
					case ElementType.Text:
						content = value;
					break;
					case ElementType.Node:
						children = null;
						string data = value;
						parse_children(ref data);
					break;
				}
			}
		}
		
		/**
		 * these functions are added for introspection, and skip a segfault error
		 */
		public Node get_child(int index){ return children[index]; }
		public Node[] get_childnodes(){ return children.to_array(); }
		public void set_prop(string name, string val){
			if(name == null)return;
			attributes[name] = val;
		}
		public string get_prop(string name){
			return attributes[name];
		}
		public bool has_prop(string name){ return null != attributes[name]; }
		public bool has_ns(string ns){ return namespaces[ns] != null; }
		public string get_ns(string ns){ return namespaces[ns]; }
		public void set_ns(string ns, string uri){ 
			if(ns == null)return;
			namespaces[ns] = uri; 
		}
		/**
		 * end of introspection section
		 */
		
		public Node(){}
		
		public GLib.List<Node> get_elements_by_tag_name(string name){
			var list = new GLib.List<Node>();
			foreach(var node in children){
				if(node.name == name)list.append(node);
				foreach(var n in node.get_elements_by_tag_name(name))
					list.append(n);
			}
			return list;
		}
		
		public void add(Node node){
			node.parent = parent;
			node.doc = doc;
			children.add(node);
		}
		public void insert(int index, Node node){
			node.parent = parent;
			node.doc = doc;
			children.insert(index,node);
		}
		public void add_all(GLib.List<Node> list){
			foreach(var node in list)
				add(node);
		}
		public void add_next_sibling(Node node){ parent.add(node); }
		public void add_prev_sibling(Node node){
			parent.insert(parent.children.size-2,node);
		}
		public bool is_text(){ return element_type == ElementType.Text; }
		public bool is_blank(){ return content == null; }
		public void unlink(){
			
		}
		
		internal static Node parse_xml(ref string data) throws Mee.Error
		{
			if(data.index_of("<?xml") != 0)
				throw new Error.Malformed("provided data doesn't start with correct tag");
			if(data.index_of("?>") == -1)
				throw new Error.Malformed("end of xml declaration not found");
			int i = data.index_of(" ");
			int j = data.index_of("?>");
			if(i == -1 || i > j) i = j;
			var node = new Node();
			node.children = new ArrayList<Node>();
			node.name = data.substring(2,i-2);
			if(!is_valid_id(node.name))
				throw new Error.Content("string isn't valid");
			node.attributes = parse_attributes(data.substring(i,data.index_of("?>")-i));
			node.element_type = ElementType.Xml;
			data = data.substring(data.index_of("?>")+2);
			return node;
		}
		
		internal static Node parse_comment(ref string data) throws Mee.Error
		{
			if(data.index_of("<!--") != 0)
				throw new Error.Malformed("provided data doesn't start with correct tag");
			if(data.index_of("-->") == -1)
				throw new Error.Malformed("end of xml comment not found");
			var node = new Node();
			node.children = new ArrayList<Node>();
			node.element_type = ElementType.Comment;
			node.name = "comment";
			node.content = data.substring(4,data.index_of("-->")-4);
			data = data.substring(data.index_of("-->")+3);
			return node;
		}
		
		internal static Node parse_cdata(ref string data) throws Mee.Error
		{
			if(data.index_of("<![CDATA[") != 0)
				throw new Error.Malformed("provided data doesn't start with correct tag");
			if(data.index_of("]]>") == -1)
				throw new Error.Malformed("end of xml cdata not found");
			var node = new Node();
			node.children = new ArrayList<Node>();
			node.element_type = ElementType.CData;
			node.name = "cdata";
			node.content = data.substring(9,data.index_of("]]>")-9);
			data = data.substring(data.index_of("]]>")+3);
			return node;
		}
		
		void parse_children(ref string data){
			children = new ArrayList<Node>();
			Node n = parse_text(data.substring(0,data.index_of("<")));
			n.parent = this;
			n.doc = doc;
			children.add(n);
			int i = data.index_of("<");
			data = (i == -1) ? "" : data.substring(i);
			while(data.length > 0){
				if(data.index_of("<!--") == 0)
					n = parse_comment(ref data);
				else if(data.index_of("<![CDATA[") == 0)
					n = parse_cdata(ref data);
				else if(data.index_of("<") == 0){
					n = parse(ref data, this);
					if(n.name.contains(":")){
						string nns = n.name.split(":")[0];
						n.name = n.name.split(":")[1];
						if(n.name.contains(":"))
							throw new Error.Content("string isn't valid");
						if(namespaces[nns] == null)
							throw new Error.Null("undefined namespace");
					}
				}
				n.parent = this;
				n.doc = doc;
				children.add(n);
				n = parse_text(data.substring(0,data.index_of("<")));
				n.parent = this;
				n.doc = doc;
				children.add(n);
				i = data.index_of("<");
				data = (i == -1) ? "" : data.substring(i);
			}
		}
		
		internal static Node parse(ref string data, Node parent_node) throws Mee.Error
		{
			if(data.index_of("<") != 0)
				throw new Error.Malformed("provided data doesn't start with correct tag");
			if(data.index_of(">") == -1)
				throw new Error.Malformed("end of tag not found");
			int i = data.index_of(" ");
			int k = data.index_of("/>");
			int j = data.index_of(">");
			bool unique = (k < j && k != -1) ? true : false;
			if(k == -1 || k > j) k = j;
			if(i == -1 || i > k) i = k;
			var node = new Node();
			node.element_type = ElementType.Node;
			node.name = data.substring(1,i-1);
			if(!is_valid_id(node.name))
				throw new Error.Content("string isn't valid");
			node.attributes = parse_attributes(data.substring(i,k-i));
			node.namespaces = parent_node.namespaces;
			node.attributes.foreach((k,v)=>{
				string id = (string)k;
				if(id.contains(":")){
					string ns = id.split(":")[1];
					if(id.split(":")[0] != "xmlns")
						throw new Error.Type("invalid namespace declaration");
					node.namespaces[ns] = (string)v;
				}
			});
			node.children = new ArrayList<Node>();
			data = data.substring(j+1);
			if(unique)
				return node;
			if(data.index_of("</"+node.name) == -1)
				throw new Error.Malformed("end of tag not found");
			Node n = parse_text(data.substring(0,data.index_of("<")));
			n.parent = node;
			n.doc = parent_node.doc;
			node.children.add(n);
			data = data.substring(data.index_of("<"));
			while(true){
				if(data.index_of("</"+node.name) == 0)break;
				if(data.index_of("<!--") == 0)
					n = parse_comment(ref data);
				else if(data.index_of("<![CDATA[") == 0)
					n = parse_cdata(ref data);
				else if(data.index_of("<") == 0){
					n = parse(ref data, node);
					if(n.name.contains(":")){
						string nns = n.name.split(":")[0];
						n.name = n.name.split(":")[1];
						if(n.name.contains(":"))
							throw new Error.Content("string isn't valid");
						if(node.namespaces[nns] == null)
							throw new Error.Null("undefined namespace");
					}
				}
				n.parent = node;
				n.doc = parent_node.doc;
				node.children.add(n);
				n = parse_text(data.substring(0,data.index_of("<")));
				n.parent = node;
				n.doc = parent_node.doc;
				node.children.add(n);
				data = data.substring(data.index_of("<"));
			}
			if(data.index_of(">") == -1)
				throw new Error.Malformed("> not found");
			if(data.substring(node.name.length+2,data.index_of(">")-node.name.length-2).chug().length != 0)
				throw new Error.Length("illegal sequence in end tag : (%s)".printf(data.substring(node.name.length+2,data.index_of(">")-node.name.length-2)));
			data = data.substring(1+data.index_of(">"));
			return node;
		}
		
		internal static Node parse_text(string data) throws Mee.Error
		{
			if(data.contains("]]>"))
				throw new Error.Content("Sequence ']]>' not allowed in content");
			var node = new Node();
			node.children = new ArrayList<Node>();
			node.name = "text";
			node.element_type = ElementType.Text;
			node.content = data;
			return node;
		}
		
		static HashTable<string,string> parse_attributes(string data) throws Mee.Error
		{
			HashTable<string,string> dico = new HashTable<string,string>(str_hash,str_equal);
			string s = data.chug();
			while(s.length > 0){
				if(s.index_of("=") == -1)
					throw new Error.Null("'=' not found");
				string id = s.substring(0,s.index_of("="));
				if(!is_valid_id(id))
					throw new Error.Content("string isn't valid");
				int i = s.index_of("=")+1;
				int j = (s[i] == '"') ? s.index_of("\"",i+1) : s.index_of("'",i+1);
				string val = valid_string(s.substring(i,1+j-i));
				if(val == null)
					throw new Error.Null("invalid string: "+s.substring(i,1+j-i));
				dico[id] = val;
				s = s.substring(j+1).chug();
			}
			return dico;
		}
	}
}
