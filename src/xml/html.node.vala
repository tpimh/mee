using Mee.Collections;
using Mee.Xml;

[Experimental]
namespace Mee.Html
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
		
		public string inner_html {
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
		
		public GLib.List<Node> get_elements_by_class_name(string name){
			var list = new GLib.List<Node>();
			foreach(var node in children){
				if(node.attributes["class"] != null && node.attributes["class"].contains(name))
					list.append(node);
				foreach(var n in node.get_elements_by_class_name(name))
					list.append(n);
			}
			return list;
		}
		
		public Node? get_element_by_id(string id){
			foreach(var child in children)
				if(child.get_element_by_id(id) != null)
					return child.get_element_by_id(id);
			foreach(var child in children)
				if(child.attributes["id"] != null && child.attributes["id"] == id)
					return child;
			return null;
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
			node.attributes = parse_attributes(ref data);
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
		
		internal static Node? parse_script(ref string data, Node parent_node) throws Mee.Error
		{
			if(data.index_of("<script") != 0 || data.index_of("/script") == -1)
				throw new Error.Malformed("invalid script");
			var node = new Node();
			node.element_type = ElementType.Node;
			node.name = "script";
			data = data.substring(node.name.length+1);
			data = data.chug();
			node.attributes = parse_attributes(ref data);
			data = data.substring(data.index_of(">")+1);
			node.doc = parent_node.doc;
			node.children = new ArrayList<Node>();
			Node n = parse_text(data.substring(0,data.index_of("</script>")));
			n.parent = node;
			n.doc = parent_node.doc;
			node.children.add(n);
			data = data.substring(data.index_of("</script>")+9);
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
		
		internal static Node parse(ref string data, Node? parent_node) throws Mee.Error
		{
			if(data.index_of("<") != 0)
				throw new Error.Malformed("provided data doesn't start with correct tag");
			if(data.index_of(">") == -1)
				throw new Error.Malformed("end of tag not found (%s)".printf(data.substring(0,20)));
			int i = data.index_of(" ");
			int k = data.index_of("/>");
			int j = data.index_of(">");
			bool unique = (k < j && k != -1) ? true : false;
			if(k == -1 || k > j) k = j;
			if(i == -1 || i > k) i = k;
			var node = new Node();
			node.element_type = ElementType.Node;
			node.name = data.substring(1,i-1);
			if(parent_node.doc == null){
				throw new Error.Null("null, null, null ! "+parent_node.doc.name);
			}
			if(parent_node.doc.options == Xml.ParseOptions.AllowUncorrectedTags){
				if(node.name[0] == '/'){
					node.name = node.name.substring(1);
				data = data.substring(1);
				}
			}
			else if(!is_valid_id(node.name))
				throw new Error.Content("string isn't valid : "+node.name+" ** "+parent_node.doc.options.to_string());
			data = data.substring(node.name.length+1);
			data = data.chug();
			
			node.attributes = parse_attributes(ref data);
			node.namespaces = parent_node.namespaces;
			node.doc = parent_node.doc;
			node.attributes.foreach((k,v)=>{
				string id = (string)k;
				if(id.contains(":")){
					string ns = id.split(":")[1];
					node.namespaces[ns] = (string)v;
				}
			});
			node.children = new ArrayList<Node>();
			data = data.substring(data.index_of(">")+1);
			if(
				unique || 
				(
					(node.name.down() == "p" || 
					node.name.down() == "img" || node.name.down() == "hr" || node.name.down() == "br" || 
					node.name.down() == "link" || node.name.down() == "meta" || node.name.down() == "input") 
						&& node.doc.options != ParseOptions.CheckHtmlUtags
				)
			)
				return node;
			if(data.index_of("</"+node.name) == -1)
				throw new Error.Malformed("end of tag not found (%s)".printf(node.name));
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
				else if(data.index_of("<script") == 0)
					n = parse_script(ref data, node);
				else if(data.index_of("<") == 0){
					n = parse(ref data, node);
					if(n.name.contains(":")){
						string nns = n.name.split(":")[0];
						n.name = n.name.split(":")[1];
						if(n.name.contains(":"))
							throw new Error.Content("string isn't valid * (%s)".printf(n.name));
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
		
		static HashTable<string,string> parse_attributes(ref string data) throws Mee.Error
		{
			HashTable<string,string> dico = new HashTable<string,string>(str_hash,str_equal);
			if(data.index_of(">") == -1)
				throw new Error.Null("'>' not found");
			data = data.chug();
			if(data.index_of("/>") == 0 || data.index_of(">") == 0)
				return dico;
			string ch = (data.index_of("/>") < data.index_of(">") && data.index_of("/>") != -1) ? "/>" : ">";
			string c = data.substring(0,data.index_of(ch));
			if(!c.contains("\"")){
				string[] t = c.split(" ");
				foreach(var s in t){
					string[] t1 = s.split("=");
					dico[t1[0]] = t1[1];
				}
				return dico;
			}
			while(true){
				string id = data.substring(0,data.index_of("="));
				if(!is_valid_id(id))
					throw new Error.Content("string isn't valid ** (%s)".printf(id));
				data = data.substring(id.length);
				data = data.chug();
				if(data[0] != '=')
					throw new Error.Null("'=' not found");
				data = data.substring(1);
				data = data.chug();
				string val = Xml.valid_string(data);
				data = data.substring(val.length+2);
				data = data.chug();
				dico[id] = val;
				if(data.index_of("/>") == 0 || data.index_of(">") == 0)break;
			}
			return dico;
		}
	}
}
