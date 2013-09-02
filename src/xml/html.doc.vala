using Mee.Collections;

[Experimental]
namespace Mee.Html
{
	public class Doc : Node
	{
		Doc(){}
		
		public static Doc load_file(string path){
			string html = "";
			FileUtils.get_contents(path,out html);
			return load_html(html);
		}
		public static Doc load_html(string html){
			var doc = new Doc();
			doc.options = Xml.ParseOptions.AllowUncorrectedTags;
			doc.name = "xml";
			doc.doc = doc;
			string s = null;
			if(html.index_of("<!DOCTYPE") == 0)
				doc.doctype = new Doctype(html);
			s = html.substring(html.index_of("<html")).replace("\n","").replace("\t","").replace("\r","").strip();
			doc.root_node = Node.parse(ref s,doc);
			return doc;
		}
		
		public Doctype doctype { get; private set; }
		public Node root_node { get; set; }
		public Mee.Xml.ParseOptions options { get; private set; }
	}
	
	public class Doctype
	{
		public Doctype(string raw) throws Mee.Error
		{
			if(raw.index_of("<!DOCTYPE") != 0)
				throw new Error.Start("invalid doctype");
			string data = raw.substring("<!DOCTYPE".length);
			data = data.chug();
			document_type = data.substring(0,data.index_of(" "));
			data = data.substring(data.index_of(" "));
			data = data.chug();
			is_public = (data.index_of("PUBLIC") == 0) ? true : false;
			data = data.substring(data.index_of(" ",1));
			dtd = data.substring(1,data.index_of("\"",2)-1);
			data = data.substring(dtd.length+2);
			data = data.chug();
			url = data.substring(1,data.index_of("\"",2)-1);
		}
		
		public string document_type { get; private set; }
		public string dtd { get; private set; }
		public string url { get; private set; }
		public bool is_public { get; private set; }
	}
}
