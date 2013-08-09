using Mee.Collections;

namespace Mee.Json
{
	public delegate void ObjectForeachFunc(string id, Node node);

	public class Object : Mee.Object
	{
		Dictionary<string,Node> map;
		
		public Object.empty(){ map = new Dictionary<string,Node>(); }
		
		public Object (string? data = null) throws Mee.Error
		{
			string str = data;
			this.parse(ref str);
		}

		internal Object.parse(ref string data) throws Mee.Error
		{
			map = new Dictionary<string,Node>();
			if(data[0] != '{'){
				var e = new Error.Malformed("provided data doesn't start with correct character: %c".printf(data[0]));
				error_occured(e);
				throw e;
			}
			data = data.substring(1).chug();
			if(data[0] == '}'){
				data = data.substring(1).chug();
			}else
			parse_member(ref data);
		}
		
		void parse_member(ref string data) throws Mee.Error
		{
			data = data.chug();
			string id = Parser.valid_string(data);
			if(id == null){
				var e = new Error.Malformed("valid string don't found");
				error_occured(e);
				throw e;
			}
			data = data.substring(id.length+2).chug();
			if(data[0] != ':'){
				stdout.printf(data+"\n");
				var e = new Error.Malformed("provided data doesn't start with correct character (%c)".printf(':'));
				error_occured(e);
				throw e;
			}
			data = data.substring(1).chug();
			if(data[0] == '{'){
				var str = data;
				var obj = new Object.parse(ref data);
				map[id] = new Node(str.substring(0,str.length-data.length));
				data = data.chug();
			}
			else if(data[0] == '['){
				var str = data;
				var a = new Array(ref data);
				map[id] = new Node(str.substring(0,str.length - data.length));
				data = data.chug();
			}
			else if(data[0] == '"' || data[0] == '\''){
				var val = Parser.valid_string(data);
				map[id] = new Node("'"+val+"'");
				data = data.substring(2+val.length).chug();
			}
			else {
				String val = new String(data);
				string val1 = val.substring(0,val.indexs_of(",","}"," ")[0]).str.strip();
				if(val1 == "false" || val1 == "true" || val1 == "null")
					map[id] = new Node(val1);
				else {
					float f;
					if(val1.scanf("%f",&f)==0){
						var e = new  Error.Type("value isn't a number (%s)".printf(val1));
						error_occured(e);
						throw e;
					}
					map[id] = new Node(val1);
				}
				data = data.substring(val1.length).chug();
			}
			if(data[0] == ','){
				data = data.substring(1).chug();
				parse_member(ref data);
			}else if(data[0] == '}'){
				data = data.substring(1).chug();
			}
			else {
				
				var e = new Mee.Error.Malformed("end of object section don't found : "+data.length.to_string());
				error_occured(e);
				throw e;
			}
		}
	
		public bool get_boolean_member(string name){ return map[name].to_boolean(); }
		public double get_double_member(string name){ return map[name].to_double(); }
		public int64 get_int_member(string name){ return map[name].to_int(); }
		public Node get_member(string name){ return map[name]; }
		public Mee.Collections.List<Node> get_members(){ return map.values; }
		public Collection<string> get_values(){
			var list = new ArrayList<string>();
			foreach(var node in map.values)
				list.add(node.to_string());
			return list;
		}
		public string get_string_member(string name){ return map[name].to_string(); }
		public Array get_array_member(string name){ return map[name].to_array(); }
		public Object get_object_member(string name){ return map[name].to_object(); }
		public bool has_member(string name){ return map.has_key(name); }
		public void @foreach(ObjectForeachFunc func){ foreach(string id in map.keys)func(id,map[id]); }
		public new Node @get(string name){ return map[name]; }
		public bool remove_member(string name){ return map.unset(name); }
		public void set_array_member(string name, Array value){ map[name] = new Node(value.to_string()); }
		public void set_boolean_member(string name, bool value){ map[name] = new Node(value.to_string()); }
		public void set_double_member(string name, double value){ map[name] = new Node(value.to_string()); }
		public void set_int_member(string name, int64 value){ map[name] = new Node(value.to_string()); }
		public void set_member(string name, Node value){ map[name] = value; }
		public void set_null_member(string name){ map[name] = new Node("null"); }
		public void set_object_member(string name, Object value){ map[name] = new Node(value.to_string()); }
		public void set_string_member(string name, string value){ map[name] = new Node("'"+value+"'"); }
		public string to_string(int indent = 0){
			if(size < 1)return "null";
			string ind = "";
			for(var i = 0; i < indent; i++)
				ind += "\t";
			string s = "{\n";
			for(var i=0; i<size-1; i++){
				s += ind+"\t\""+map.keys[i]+"\" : "+map.values[i].to_string(indent+1)+",\n";
			}
			s += ind+"\t\""+map.keys[size-1]+"\" : "+map.values[size-1].to_string(indent+1)+"\n";
			s += ind+"}";
			return s;
		}
		public void dump(GLib.FileStream stream =  GLib.stdout){
			stream.write(to_string().data);
		}
		public int size { get{ return get_members().size; } }
	}
}
