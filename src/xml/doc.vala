using Gee;

namespace Mee.Xml
{
	public class Doc : Node
	{
		public Doc.data(ref String data) throws Mee.Error
		{
			base.parse_xml(ref data);
			element_type = ElementType.Doc;
			Node node = null;
			int cnt = 0;
			while(data.index_of("<?xml") == 0){
				node = new Node.parse_xml(ref data);
				node.doc = this;
				node.parent = this;
				node.id = cnt;
				cnt++;
				children.add(node);
			}
			node = new Node.parse(ref data);
			node.doc = this;
			node.parent = this;
			node.id = cnt;
			cnt++;
			children.add(node);
			root_node = node;
		}
		public Doc.file(string file) throws Mee.Error
		{
			string contents;
			FileUtils.get_contents(file,out contents);
			var s = new String(contents);
			s = s.replace("\n","").replace("\t","").replace("\r","");
			this.data(ref s);
		}
		public Doc(){
			base.empty();
			attributes["version"] = "1.0";
			attributes["encoding"] = "UTF-8";
		}
		
		public void dump(GLib.FileStream fs = GLib.stdout){
			fs.puts("<?xml version='%s' encoding='%s' ?>\n".printf(version,encoding));
			foreach(var node in children){
				string s = "";
				foreach(var e in node.attributes.entries)
					s += "%s='%s' ".printf(e.key,e.value);
				switch(node.element_type){
					case ElementType.Xml:
					fs.puts("<?%s %s?>\n".printf(node.name,s));
					break;
					case ElementType.Node:
					fs.puts(node.print(0));
					break;
				}
			}
		}
		public void save_file(string filename){
			var fs = FileStream.open(filename,"w");
			dump(fs);
		}
		
		public Node root_node {get; set;}
		public string version {
			owned get{
				return attributes["version"];
			}
		}
		public string encoding {
			owned get{
				return attributes["encoding"];
			}
		}
	}
}
