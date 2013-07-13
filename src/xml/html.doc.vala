namespace Mee.Html
{
	public class Doc : Mee.Xml.Doc
	{
		public Doc.file(string file) throws Mee.Error
		{
			string contents;
			FileUtils.get_contents(file,out contents);
			var s = new String(contents);
			s = s.replace("\n","").replace("\t","").replace("\r","");
			this.data(ref s);
		}
		
		public Doc.data(ref String data) throws Mee.Error
		{
			Xml.Node node = null;
			int cnt = 0;
			children = new Gee.ArrayList<Xml.Node>();
			if(data.index_of("<!DOCTYPE") == 0){
				node = new Xml.Doctype.parse(ref data);
				node.doc = this;
				node.parent = this;
				children.add(node);
			}
			if(data.index_of("<!--") == 0){
				node = new Xml.Node.parse_comment(ref data);
				node.doc = this;
				node.parent = this;
				children.add(node);
			}
			node = new Html.Node.parse(ref data);
			node.doc = this;
			node.parent = this;
			children.add(node);
			root_node = node;
		}
	}
}
