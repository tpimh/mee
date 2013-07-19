using Mee.Xml;
using Mee.Collections;

namespace Mee.Html
{
	[Experimental]
	public class Node : Xml.Node
	{
		Node(){ base.empty(); }
		
		public Node.parse(ref String data) throws Mee.Error
		{
			this();
			
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
			if(data.substring(name.length+1,data.indexs_of("/>",">")[0]-name.length-1).contains("="))
				get_attrs(data.substring(name.length+1,data.indexs_of("/>",">")[0]-name.length-1));
			if(data.index_of("/>") != data.index_of(">")-1 && name != "meta" && name != "link" && name != "input"){
				var i = index_of_end(data,name);
				if(i == -1){
					var e = new Error.End("end tag not found: %s (id=%s)".printf(name,attributes["id"]));
					error_occured(e);
					throw e;						
				}
				var s = data.substring(data.index_of(">")+1,i-data.index_of(">")-1);
				children = new ArrayList<Node>();
				var n = new Xml.Node.text(s.substring(0,s.index_of("<")));
				n.doc = doc;
				n.parent = this;
				n.id = 0;
				children.add(n);
				int cnt = 1;
				s = s.substring(s.index_of("<"));
				while(s.length > 0){
					if(s.index_of("<") == -1)break;
					if(s.index_of("<!--") == 0)n = new Xml.Node.parse_comment(ref s);
					else if(s.index_of("<![CDATA[") == 0)n = new Xml.Node.parse_cdata(ref s);
					else n = new Node.parse(ref s);
					n.doc = doc;
					n.parent = this;
					n.id = cnt;
					cnt++;
					children.add(n);
					n = new Xml.Node.text(s.substring(0,s.index_of("<")));
					n.doc = doc;
					n.parent = this;
					n.id = cnt;
					cnt++;
					children.add(n);
					s = s.substring(s.index_of("<"));
				}
				var j = data.str.index_of(">",i);
				data = data.substring(j+1);
			}
			else if(name != "meta" && name != "link" && name != "input"){
				data = data.substring(data.index_of("/>")+2);
			}else{
				data = data.substring(data.index_of(">")+1);
			}
		}
	}
}
