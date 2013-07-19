using Mee.Json.Parser;
using Mee.Collections;

namespace Mee.Json
{
	public class Object
	{
		string raw;
		Dictionary<string,string> map;
		ArrayList<Pair?> list;
		
		public Object(string data) throws Mee.Error
		{
			raw = data;
			string str = data.replace("\t","").replace("\n","").replace("\r","");
			var i = str.index_of("{");
			if(i>0)throw new Mee.Error.Malformed("extra data at beginning (%d)\n",i);
			var j = str.last_index_of("}");
			if(j != str.length-1)throw new Mee.Error.Malformed("extra data at end (%d)\n",j);
			string s = str.substring(i+1,str.length-i-2);
			map = new Dictionary<string,string>();
			list = new ArrayList<Pair?>();
			parse_object(s);
		}
		
		void parse_object(string s) throws Mee.Error
		{
			var i = s.index_of("\"");
			if(i>0)throw new Mee.Error.Malformed("extra data at beginning (%d)\n",i);
			var j = s.index_of("\"",i+1);
			if(!is_valid(s.substring(i+1,j-i-1)))throw new Mee.Error.Malformed("string isn't valid");
			var name = s.substring(i+1,j-i-1);
			var k = s.index_of(":",j);
			if(s.substring(j+1,k-j-1).chug().length>0)throw new Mee.Error.Malformed("string contains illegal characters");
			var l = s.index_of(",",k);
			while(true){
				bool b1 = check(s.substring(k+1,l-k-1),'{','}');
				bool b2 = check(s.substring(k+1,l-k-1),'[',']');
				bool b3 = check(s.substring(k+1,l-k-1),'"','"');
				if(b1 == true && b2 == true && b3 == true)break;
				l = s.index_of(",",l+1);
			}
			var end = false;
			if(l==-1){
				l = 1+s.last_index_of("}");
				end = true;
			}
			map[name] = s.substring(k+1,l-k-1).chug();
			list.add({name,new Node(map[name])});
			if(!end)parse_object(s.substring(l+1,s.length-l-1));
		}
		
		public Node @get(string name){
			return new Node(map[name]);
		}
		
		public Object get_object(string name){
			return new Object(map[name]);
		}
		public double get_double(string name){
			return double.parse(map[name]);
		}
		public Array get_array(string name){
			return new Array(map[name]);
		}
		public string get_string(string name){
			return map[name].replace("\"" ,"");
		}
		public int get_int(string name){
			return int.parse(map[name]);
		}
		public bool get_bool(string name){
			return bool.parse(map[name]);
		}
		public void set_array(string name, Array array){
			map[name] = array.to_string();
		}
		public void set_object(string name, Object o){
			map[name] = o.to_string();
		}
		public void set_node(string name, Node n){
			map[name] = n.to_string();
		}
		
		public string to_string(){
			string s = "{";
			for(var i=0; i<map.keys.size-1; i++)
				s += "\"%s\" : %s,".printf(map.keys.to_array()[i],map.values.to_array()[i]);
			s += "\"%s\" : %s}".printf(map.keys.to_array()[map.keys.size-1],map.values.to_array()[map.values.size-1]);
			return s;
		}
		
		public ArrayList<Pair?> entries{
			owned get{
				list = new ArrayList<Pair?>();
				foreach(var e in map.entries)
					list.add({e.key,new Mee.Json.Node(e.value)});
				return list;
			}
		}
	}
}
