using Mee.Json.Parser;

namespace Mee.Json
{
	public class Array
	{
		string raw;
		Gee.ArrayList<string> list;
		
		public Array.empty(){
			list = new Gee.ArrayList<string>();
		}
		
		public Array(string data) throws Mee.Error
		{
			raw = data;
			list = new Gee.ArrayList<string>();
			string str = data.replace("\t","").replace("\n","").replace("\r","").chug().chomp();
			if(!data.contains("[")&&!data.contains("]"))throw new Mee.Error.Type("this isn't an array");
			var i = str.index_of("[");
			if(i>0)throw new Mee.Error.Malformed("extra data at beginning (%d)\n",i);
			var j = str.last_index_of("]");
			if(j != str.length-1)throw new Mee.Error.Malformed("extra data at end (%d)\n",j);
			parse_array(str.substring(1,str.length-2));
		}
		
		void parse_array(string s){
			var i = s.index_of(",");
			while(true){
				bool b1 = check(s.substring(0,i),'{','}');
				bool b2 = check(s.substring(0,i),'[',']');
				bool b3 = check(s.substring(0,i),'"','"');
				if(b1 == true && b2 == true && b3 == true)break;
				i = s.index_of(",",i+1);
			}
			list.add(s.substring(0,i));
			if(i!=-1)parse_array(s.substring(i+1));
		}
		
		public void add_array(Array array){
			list.add(array.to_string());
		}
		public void add_object(Object o){
			list.add(o.to_string());
		}
		public void add_double(double d){
			list.add(d.to_string());
		}
		public void add_int(int i){
			list.add(i.to_string());
		}
		public void add_bool(bool b){
			list.add(b.to_string());
		}
		public void add_node(Node node){
			list.add(node.to_string());
		}
		
		public Node @get(int index){
			return new Node(list[index]);
		}
		public Array get_array(int index){
			return new Array(list[index]);
		}
		public Object get_object(int index){
			return new Object(list[index]);
		}
		public double get_double(int index){
			return double.parse(list[index]);
		}
		public int get_int(int index){
			return int.parse(list[index]);
		}
		public bool get_bool(int index){
			return bool.parse(list[index]);
		}
		public string get_string(int index){
			return list[index].replace("\"","");
		}
		
		public string to_string(){
			string s = "[";
			for(int i=0; i<list.size-1; i++)
				s += list[i]+",";
			s += list[list.size-1]+"]";
			return s;
		}
	}
}
