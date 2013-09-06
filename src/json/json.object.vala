namespace Mee.Json
{
	public class Object : GLib.Object
	{
		HashTable<string,string> table;
		
		public Object.empty(){
			table = new HashTable<string,string>(str_hash,str_equal);
		}
		
		public Object(string data) throws Json.Error
		{
			var str = data.replace ("\t","").replace ("\r","").replace ("\n","").strip ();
			this.parse(ref str);
		}
		
		internal Object.parse(ref string data) throws Json.Error
		{
			this.empty();
			if(data[0] != '{')
				throw new Json.Error.Start("invalid character (%s)".printf(data));
			data = data.substring (1).chug ();
			if(data[0] == '}')
				data = data.substring (1).chug ();
			else
			while(data.length > 0){
				string str = valid_string(data);
				data = data.substring (str.length+2).chug ();
				if(data[0] != ':')
					throw new Json.Error.NotFound("':' char not found");
				data = data.substring (1).chug ();
				if(data[0] == ',' || data[0] == '}')
					throw new Json.Error.NotFound("value not found");
				if(data[0] == '{'){
					var object = new Object.parse(ref data);
					table[str] = object.to_string();
				}else if(data[0] == '['){
					var array = new Array.parse (ref data);
					table[str] = array.to_string();
				}else if(data[0] == '"' || data[0] == '\''){
					var s = valid_string (data);
					data = data.substring (s.length+2).chug ();
					table[str] = "\"%s\"".printf(s);
				}else{
					int a = data.index_of ("}");
					int b = data.index_of (",");
					int c = (a == -1 && b != -1) ? b : 
							(a != -1 && b == -1) ? a : 
							(a > b) ? b : 
							(b > a) ? a : -1 ;
					if(c == -1)
						throw new Json.Error.NotFound("end of member not found");
					var val = data.substring(0,c).strip();
					if(val != "false" && val != "true" && val != "null"){
						double d = -1;
						if(double.try_parse (val,out d) == false)
							throw new Json.Error.Type("invalid value");
					}
					table[str] = val;
					data = data.substring(val.length).chug();
				}
				if(data[0] != ',' && data[0] != '}')
					throw new Json.Error.Type("invalid end of section");
				bool end = (data[0] == '}') ? true : false;
				data = data.substring(1).chug();
				if(end)break;
			}
		}

		public Node? get_member(string id){
			if(!table.contains (id))
				return null;
			return new Node(table[id]);
		}
		public List<Node> get_members(){
			List<Node> nlist = new List<Node>();
			this.foreach((name,node) => { nlist.append(node); });
			return nlist.copy();
		}
		public List<string> get_keys(){ return table.get_keys().copy(); }
		
		public Array? get_array_member(string id){ return get_member(id).as_array(); }
		public double get_double_member(string id){ return get_member(id).as_double(); }
		public Object? get_object_member(string id){ return get_member(id).as_object(); }
		public bool get_boolean_member(string id){ return get_member(id).as_bool(); }
		public double get_int_member(string id){ return get_member(id).as_int(); }
		public bool get_null_member(string id){ return (table[id] == "null") ? true : false; }
		public string get_string_member(string id){ return get_member(id).as_string(); }
		
		public void remove_member(string id){ table.remove(id); }

		public void set_member(string id, Node node){
			table[id] = node.str;
		}
		public void set_null_member(string id){ table[id] = "null"; }
		public void set_array_member(string id, Array array){ table[id] = array.to_string(); }
		public void set_boolean_member(string id, bool value){ table[id] = value.to_string(); }
		public void set_double_member(string id, double value){ table[id] = value.to_string(); }
		public void set_int_member(string id, int64 value){ table[id] = value.to_string(); }
		public void set_object_member(string id, Object value){ table[id] = value.to_string(); }
		public void set_string_member(string id, string value){
			try{
				string s = valid_string("\""+value+"\"");
				table[id] = "\""+value+"\"";
			}catch{}
		}
		
		public bool has_member(string id){
			return table[id] != null;
		}

		public delegate void ObjectForeach(string name, Node node);
		
		public void foreach(ObjectForeach func){
			table.foreach((name,val) => {
				func(name,new Node(val));
			});
		}

		public string to_string(){
			if(table.get_keys ().length () == 0)
				return "{}";
			string s = "{ ";
			for(uint i = 0; i < table.size() - 1; i++) {
				s += "\""+table.get_keys().nth_data(i)+"\" : "+get_member(table.get_keys().nth_data(i)).to_string()+" , ";
			}
			s += "\""+table.get_keys().nth_data(table.size()-1)+"\" : "
			+get_member(table.get_keys().nth_data(table.size()-1)).to_string()+" }";
			return s;
		}
		public string dump(int indent = 0){
			if(table.get_keys ().length () == 0)
				return "{}";
			string ind = "";
			for(var i = 0; i < indent; i++)
				ind += "\t";
			string s = "{"+ind+"\n";
			for(uint i = 0; i < table.size() - 1; i++) {
				s += ind+"\t\""+table.get_keys().nth_data(i)+"\" : "+get_member(table.get_keys().nth_data(i)).dump(indent+1)+" ,\n";
			}
			s += ind+"\t\""+table.get_keys().nth_data(table.size()-1)+"\" : "
			+get_member(table.get_keys().nth_data(table.size()-1)).dump(indent+1)+"\n";
			s += ind+"}";
			return s;
		}
		
		public uint size { get{ return table.size(); } }
	}
}
