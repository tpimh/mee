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
			istring str = {data,0};
			this.parse(ref str);
		}

		internal Object.parse(ref istring data) throws Mee.Error
		{
			map = new Dictionary<string,Node>();
			if(data.getc() != '{'){
				var e = new Error.Malformed("provided data doesn't start with correct character");
				error_occured(e);
				throw e;
			}
			data.index ++;
			data.index = data.index_of(data.substring().chug());
			if(data.getc() == '}'){
				data.index++;
				data.index = data.index_of(data.substring().chug());
			}else
			parse_member(ref data);
		}
		
		void parse_member(ref istring data) throws Mee.Error
		{
			string id = Parser.valid_string(data.substring().chug());
			if(id == null){
				var e = new Error.Malformed("valid string don't found"+data.substring().chug());
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
				var obj = new Object.parse(ref data);
				map[id] = new Node(data.str.substring(a,data.index-a));
				data.index = data.index_of(data.substring().chug());
			}
			else if(data.getc() == '['){
				var i = data.index;
				var a = new Array(ref data);
				map[id] = new Node(data.str.substring(i,data.index-i));
				data.index = data.index_of(data.substring().chug());
			}
			else if(data.getc() == '"' || data.getc() == '\''){
				var val = Parser.valid_string(data.substring().chug());
				map[id] = new Node(val);
				data.index += val.length+2;
				data.index = data.index_of(data.substring().chug());
			}
			else {
				String val = new String(data.substring());
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
				data.index += val1.length;
				data.index = data.index_of(data.substring().chug());
			}
			if(data.getc() == ','){
				data.index += 1;
				parse_member(ref data);
			}else if(data.getc() == '}'){
				data.index += 1;
			}
			else {
				
				var e = new Mee.Error.Malformed("end of object section don't found : "+data.substring().length.to_string());
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
		public void set_string_member(string name, string value){ map[name] = new Node(value); }
		public string to_string(){
			string s = "{";
			for(var i=0; i<size-1; i++){
				s += "\""+map.keys[i]+"\" : "+map.values[i].to_string()+",\n";
			}
			s += "\""+map.keys[size-1]+"\" : "+map.values[size-1].to_string()+"}";
			return s;
		}
		public int size { get{ return get_members().size; } }
	}
}
