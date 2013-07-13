using Gee;

namespace Mee.Xml
{
	public class Node : Object, Element
	{
		internal Node.empty(){
			children = new ArrayList<Node>();
			attributes = new HashMap<string,string>();
		}
		public Node(string n) throws Mee.Error
		{
			element_type = ElementType.Node;
			name = n;
		}
		public Node.parse(ref String data) throws Mee.Error
		{
			element_type = ElementType.Node;
			if(data.index_of("<") != 0){
				var e = new Error.Start("provided data doesn't start correctly: %d".printf(data.index_of("<")));
				error_occured(e);
				throw e;				
			}
			name = data.substring(1,data.indexs_of("/"," ",">")[0]-1).str;
			if(data.index_of(">") == -1){
				var e = new Error.End("end of tag not found");
				error_occured(e);
				throw e;				
			}
			get_attrs(data.substring(name.length+1,data.indexs_of("/>",">")[0]-name.length-1));
			if(data.index_of("/>") != data.index_of(">")-1){
				var i = index_of_end(data,name);
				if(i == -1){
					var e = new Error.End("end tag not found: %s".printf(name));
					error_occured(e);
					throw e;						
				}
				var s = data.substring(data.index_of(">")+1,i-data.index_of(">")-1);
				parse_children(s);
				var j = data.str.index_of(">",i);
				data = data.substring(j+1);
			}
			else{
				data = data.substring(data.index_of("/>")+2);
			}
		}
		public Node.text(String data) throws Mee.Error
		{
			element_type = ElementType.Text;
			if(data.contains("]]>")){
				var e = new Error.Content("Sequence ']]>' not allowed in content");
				error_occured(e);
				throw e;
			}
			content = data.str;
		}
		public Node.cdata(string data) throws Mee.Error
		{
			if(data.contains("]]>")){
				var e = new Error.Content("Sequence ']]>' not allowed in content");
				error_occured(e);
				throw e;
			}
			element_type = ElementType.CData;
			content = data;
		}
		public Node.parse_cdata(ref String data) throws Mee.Error
		{
			element_type = ElementType.CData;
			if(data.index_of("<![CDATA[") != 0){
				var e = new Error.Start("provided data doesn't start correctly: %d".printf(data.index_of("<![CDATA[")));
				error_occured(e);
				throw e;			
			}
			if(data.index_of("]]>") == -1){
				var e = new Error.End("end of cdata section not found");
				error_occured(e);
				throw e;
			}
			content = data.substring(9,data.index_of("]]>")-9).str;
			data = data.substring(data.index_of("]]>")+3);
		}
		public Node.comment(string comment){
			element_type = ElementType.Comment;
			content = comment;
		}
		public Node.parse_comment(ref String data) throws Mee.Error
		{
			element_type = ElementType.Comment;
			if(data.index_of("<!--") != 0){
				var e = new Error.Start("provided data doesn't start correctly: %d".printf(data.index_of("<!--")));
				error_occured(e);
				throw e;			
			}
			if(data.index_of("-->") == -1){
				var e = new Error.End("end of comment not found");
				error_occured(e);
				throw e;
			}
			content = data.substring(4,data.index_of("-->")-4).str;
			data = data.substring(data.index_of("-->")+3);
		}
		public Node.parse_xml(ref String data) throws Mee.Error
		{
			this.empty();
			element_type = ElementType.Xml;
			if(data.index_of("<?") != 0){
				var e = new Error.Start("provided data doesn't start correctly: %d".printf(data.index_of("<?")));
				error_occured(e);
				throw e;
			}
			Sub sub = data.index_of_set({"<?","?>"},0,true);
			String str = data.substring(sub.left,sub.right-sub.left+2);
			if(str.index_of("<?") != 0 || str.last_index_of("?>") != str.length-2){
				var e = new Error.Type("provided data doesn't seem a valid declaration");
				error_occured(e);
				throw e;
			}
			get_attrs(str.substring(2,sub.right-2));
			name = data.substring(2,data.index_of(" ")-2).str;
			data = data.substring(sub.right-sub.left+2);
		}
		
		internal int index_of_end(String end, string n, int start = 0) throws Mee.Error
		{
			int c = 0;
			for(var i=0; i<end.length; i++){
				if(end.substring(i,n.length+1).is("<"+n))c++;
				if(end.substring(i,n.length+2).is("</"+n))c--;
				if(c == 0)return i;
				if(end.substring(i,9).is("<![CDATA[")){
					if(end.str.index_of("]]>",i) == -1)return -1;
					i = end.str.index_of("]]>",i);
				}
				if(end.substring(i,4).is("<!--")){
					if(end.str.index_of("-->",i) == -1)return -1;
					i = end.str.index_of("-->",i);
				}
			}
			return -1;
		}
		
		internal void parse_children(String data){
			String s = data.copy();
			children = new ArrayList<Node>();
			var n = new Node.text(s.substring(0,s.index_of("<")));
			n.doc = doc;
			n.parent = this;
			n.id = 0;
			children.add(n);
			int cnt = 1;
			s = s.substring(s.index_of("<"));
			while(s.length > 0){
				if(s.index_of("<") == -1)break;
				if(s.index_of("<!--") == 0)n = new Node.parse_comment(ref s);
				else if(s.index_of("<![CDATA[") == 0)n = new Node.parse_cdata(ref s);
				else n = new Node.parse(ref s);
				n.doc = doc;
				n.parent = this;
				n.id = cnt;
				cnt++;
				children.add(n);
				n = new Node.text(s.substring(0,s.index_of("<")));
				n.doc = doc;
				n.parent = this;
				n.id = cnt;
				cnt++;
				children.add(n);
				s = s.substring(s.index_of("<"));
			}
		}
		
		internal void get_attrs(String data)
		{
			attributes = new HashMap<string,string>();
			if(data.index_of(" ") == -1)return;
			var table = data.split_r(/([^" ]*("[^"]*")[^" ]*)|[^" ]+/);
			for(var i=0; i<table.length; i++){
				if(table[i].contains("=")){
					String[] t = table[i].split_s("=",2);
					t[0].strip();
					if(t.length >= 2 && t[1].length>2){
						t[1].strip('"');
						t[1].strip('\'');
					}
					attributes[t[0].str] = t[1].str; 
				}
				
			}
		}
		
		public ArrayList<Node> get_elements_by_tag_name(string tagname){
			ArrayList<Node> list = new ArrayList<Node>();
			if(children == null)return list;
			foreach(var node in children){
				if(node.name == tagname)
					list.add(node);
				if(node.get_elements_by_tag_name(tagname) != null)	
					list.add_all(node.get_elements_by_tag_name(tagname));
			}
			return list;
		}
		public Node @get(string node_name){
			foreach(var node in children)
				if(node.name == node_name)
					return node;
			return null;
		}
		public void unlink(){
			if(parent != null)
				parent.children.remove_at(id);
		}
		public bool is_text(){
			return element_type == ElementType.Text;
		}
		public string inner_text {
			owned get{
				string s = "";
				foreach(var node in children)
					if(node.element_type == ElementType.Text)
						s += node.content;
					else if(node.element_type == ElementType.Node)
						s += node.inner_text;
				return s;
			}
			set{ parse_children(new String(value)); }
		}
		public string inner_xml {
			owned get{
				string s = "";
				foreach(var node in children)
					if(node.element_type == ElementType.Text)
						s += node.content;
					else if(node.element_type == ElementType.CData)
						s += "<![CDATA["+node.content+"]]>";
					else if(node.element_type == ElementType.Comment)
						s += "<!--"+node.content+"-->";
					else if(node.element_type == ElementType.Node){
						string attr = "";
						foreach(var e in attributes.entries)
							attr += "%s='%s' ".printf(e.key,e.value);
						s += "<div %s>%s</div>".printf(attr,node.inner_xml);
					}
				return s;
			}
			set{ parse_children(new String(value)); }
		}
		
		internal string print(int indent){
			string s = "";
			if(attributes != null)
			foreach(var e in attributes.entries)
				s += "%s='%s' ".printf(e.key,e.value);	
			string val = "<%s %s".printf(name,s);
			if(element_type == ElementType.CData){
				return "<![CDATA[%s]]>".printf(content);
			}
			if(element_type == ElementType.Comment){
				return "<!--%s-->".printf(content);
			}
			if(element_type == ElementType.Text){
				return content+"\n";
			}
			if(children.size > 0){
				val += ">\n";
				foreach(var node in children)
					val += node.print(indent+1);
				val += "</"+name+">\n";
			}else if(content != null){
				val += ">\n";
				val += content+"\n";
				val += "</"+name+">\n";
			}else val += "/>";
			return val;
		}
		
		internal int id {get; set;}
		public ArrayList<Node> children {get; set;}
		public Node prev {
			owned get{
				return (parent != null) ? parent.children[id-1] : null;
			}
		}
		public Node next {
			owned get{
				return (parent != null) ? parent.children[id+1] : null;
			}
		}
		public Node parent {get; protected set;}
		public Doc doc {get; protected set;}
		public ElementType element_type {get; protected set;}
		public string name {get; set;}
		public HashMap<string,string> attributes {get; protected set;}
		public string content {get; set;}
	}
	
	public class Doctype : Node
	{
		Doctype(){
			base.empty();
		}
		
		public Doctype.parse(ref String data) throws Mee.Error
		{			
			this();
			// <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
			String[] table = data.split_s(" ");
			if(!table[0].is("<!DOCTYPE") || table.length < 2){
				var e = new Error.Type("provided data doesn't seem a valid doctype");
				error_occured(e);
				throw e;			
			}
			name = table[1].str;
			var c = data.substring(data.index_of(" ")+1,data.index_of(">")-data.index_of(" ")-1);
			table = c.split_t({'"'},true);
			if(table.length >= 2)
				external_id = table[1].str;
			if(table.length >= 4)
				system_id = table[3].str;
			data = data.substring(data.index_of(">")+1);
		}
		
		public string external_id {get; private set;}
		public string system_id {get; private set;}
	}
}
