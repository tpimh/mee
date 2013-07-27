using Mee.Collections;

namespace Mee.Json
{
	public delegate void ObjectForeachFunc(string id, Node node);

	public class Object : Mee.Object
	{
		HashTable<string,string> map;
		
		public Object.empty(){ map = new HashTable<string,string>(str_hash, str_equal); }
		
		public static Object parse(string data) throws Mee.Error
		{
			string str = data.replace("\t","").replace("\n","").replace("\r","").chug();
			istring s = {str,0};
			return new Object(ref s);
		}

		public Object(ref istring data) throws Mee.Error
		{
			map = new HashTable<string,string>(str_hash, str_equal);
			if(data.getc() != '{'){
				var e = new Error.Malformed("provided data doesn't start with correct character");
				error_occured(e);
				throw e;
			}
			data.index ++;
			parse_member(ref data);
		}
		
		void parse_member(ref istring data) throws Mee.Error
		{
			string id = Parser.valid_string(data.substring().chug());
			stdout.printf(id+"\n");
			if(id == null){
				var e = new Error.Malformed("valid string don't found");
				error_occured(e);
				throw e;
			}
			data.index = data.index_of(data.substring().chug())+id.length+2;
			data.index = data.index_of(data.substring().chug());
			if(data.getc() != ':'){
				var e = new Error.Malformed("provided data doesn't start with correct character (%c)".printf(':'));
				error_occured(e);
				throw e;
			}
			data.index++;
			data.index = data.index_of(data.substring().chug());
			if(data.getc() == '{'){
				var a = data.index;
				var obj = new Object(ref data);
				map[id] = data.str.substring(a,data.index-a+1);
				data.index = data.index_of(data.substring().chug());
			}
			else if(data.getc() == '['){
				var i = data.index;
				var a = new Array(ref data);
				map[id] = data.str.substring(i,data.index-i);
				data.index = data.index_of(data.substring().chug());
			}
			else if(data.getc() == '"' || data.getc() == '\''){
				var val = Parser.valid_string(data.substring().chug());
				map[id] = val;
				data.index += val.length+2;
				data.index = data.index_of(data.substring().chug());
			}
			else {
				String val = new String(data.substring());
				string val1 = val.substring(0,val.indexs_of(",","}"," ")[0]).str;
				if(val1.down() == "false" || val1.down() == "true" || val1.down() == "null")
					map[id] = val1;
				else {
					float f;
					if(val1.scanf("%f",&f)==0){
						var e = new  Error.Type("value isn't a number");
						error_occured(e);
						throw e;
					}
					map[id] = val1;
				}
				data.index += val1.length;
				data.index = data.index_of(data.substring().chug());
			}
			if(data.getc() == ','){
				data.index += 1;
				parse_member(ref data);
			}else if(data.getc() == '}'){
				data.index += 1;
			}else {
				var e = new Mee.Error.Malformed("end of object section don't found");
				error_occured(e);
				throw e;
			}
		}
	
		public bool get_boolean_member(string name){ return bool.parse(map[name]); }
		public double get_double_member(string name){ return double.parse(map[name]); }
		public int64 get_int_member(string name){ return int64.parse(map[name]); }
		public Node get_member(string name){ return new Node(map[name]); }
		public List<Node> get_members(){
			List<Node> l = new List<Node>();
			foreach(var s in map.get_values())
				l.append(new Node(s));
			return l;
		}
		public List<string> get_values(){ return map.get_values(); }
		public string get_string_member(string name){ return map[name]; }
		public Array get_array_member(string name){
			istring str = {map[name],0};
			return new Array(ref str);
		}
		public Object get_object_member(string name){
			istring str = {map[name],0};
			return new Object(ref str);
		}
		public bool has_member(string name){ return map.contains(name); }
		public void @foreach(ObjectForeachFunc func){
			foreach(string id in map.get_keys())
				func(id,new Node(map[id]));
		}
		public new Node @get(string name){ return new Node(map[name]); }
		public bool remove_member(string name){ return map.remove(name); }
		public void set_array_member(string name, Array array){ map[name] = array.to_string(); }
		public void set_boolean_member(string name, bool value){ map[name] = value.to_string(); }
		public void set_double_member(string name, double value){ map[name] = value.to_string(); }
		public void set_int_member(string name, int64 value){ map[name] = value.to_string(); }
		public void set_member(string name, Node value){ map[name] = value.to_string(); }
		public void set_null_member(string name){ map[name] = "null"; }
		public void set_object_member(string name, Object value){ map[name] = value.to_string(); }
		public void set_string_member(string name, string value){ map[name] = value; }
		public string to_string(){
			string s = "{";
			for(var i=0; i<size-1; i++)
				s += map.get_keys().nth_data(i)+" : "+map.get_values().nth_data(i)+",";
			s += map.get_keys().nth_data(size-1)+" : "+map.get_values().nth_data(size-1)+"}";
			return s;
		}
		public uint size { get{ return get_members().length(); } }
	}
}
