namespace Mee.Json
{
	public class Array : GLib.Object
	{
		List<string> list;

		public Array(string data) throws Json.Error
		{
			var str = data.strip ();
			this.parse (ref str);
		}
		
		public Array.empty(){ list = new List<string>(); }
		
		internal Array.parse(ref string data) throws Json.Error
		{
			this.empty();
			if(data[0] != '[')
				throw new Json.Error.Start("invalid character");
			data = data.substring (1).chug ();
			if(data[0] == ']')
				data = data.substring (1).chug ();
			else
			while(data.length > 0){
				
				if(data[0] == '['){
					var array = new Array.parse (ref data);
					list.append(array.to_string ());
				}else if(data[0] == '{'){
					var object = new Object.parse (ref data);
					list.append(object.to_string());
				}else if(data[0] == '"' || data[0] == '\''){
					var str = valid_string (data);
					data = data.substring (str.length+2).chug ();
					list.append ("\"%s\"".printf(str));
				}else{
					int a = data.index_of ("]");
					int b = data.index_of (",");
					int c = (a == -1 && b != -1) ? b : 
							(a != -1 && b == -1) ? a : 
							(a > b) ? b : 
							(b > a) ? a : -1 ;
					if(c == -1)
						throw new Json.Error.NotFound("end of element not found");
					var val = data.substring(0,c).strip();
					if(val != "false" && val != "true" && val != "null"){
						double d = -1;
						if(double.try_parse (val,out d) == false)
							throw new Json.Error.Type("invalid value");
					}
					list.append(val);
					data = data.substring(val.length).chug();
				}
				if(data[0] != ',' && data[0] != ']')
						throw new Json.Error.Type("invalid end of element");
					bool end = (data[0] == ']') ? true : false;
					data = data.substring(1).chug();
					if(end)break;
			}
		}

		public Node? get_element(uint index){
			if(index < 0 || index >= list.length ())
				return null;
			return new Node(list.nth_data (index));
		}
		public Array? get_array_element(uint index){ return get_element(index).as_array(); }
		public Object? get_object_element(uint index){ return get_element(index).as_object(); }
		public double get_double_element(uint index){ return get_element(index).as_double(); }
		public bool get_boolean_element(uint index){ return get_element(index).as_bool(); }
		public int64 get_int_element(uint index){ return get_element(index).as_int(); }
		public bool get_null_element(uint index){ return list.nth_data(index) == "null"; }
		public string get_string_element(uint index){ return get_element(index).as_string(); }
		
		public void add_element(Node node){ list.append(node.str); }
		public void add_array_element(Array array){ list.append(array.to_string()); }
		public void add_object_element(Object object){ list.append(object.to_string()); }
		public void add_double_element(double val){ list.append(val.to_string()); }
		public void add_boolean_element(bool val){ list.append(val.to_string()); }
		public void add_int_element(int64 i){ list.append(i.to_string()); }
		public void add_null_element(){ list.append("null"); }
		public void add_string_element(string str){
			try{
				string s = valid_string("\""+str+"\"");
				list.append("\""+str+"\"");
			}catch{}
		}
		public void remove_element(uint index){
			if(index < 0 || index >= length)
				return;
			List<string> nlist = new List<string>();
			for(uint i = 0; i < index; i++)
				nlist.append(list.nth_data(i));
			for(uint i = index+1; i < length; i++)
				nlist.append(list.nth_data(i));
			list = nlist.copy();
		}
		
		public List<Node> get_elements(){
			List<Node> nlist = new List<Node>();
			this.foreach((u,node) => { nlist.append(node); });
			return nlist.copy();
		}
		
		public void foreach(ArrayForeach func){
			for(uint i = 0; i < list.length(); i++){
				var node = new Node(list.nth_data(i));
				func(i,node);
			}
		}
		
		public delegate void ArrayForeach(uint index, Node node);

		public string to_string(){
			if(list.length () == 0)return "[]";
			string s = "[ ";
			for(uint i = 0; i < list.length () - 1; i++)
				s += list.nth_data(i) + " , ";
			s += list.nth_data(list.length ()-1)+" ]";
			return s;
		}
		
		public uint length {
			get {
				return list.length();
			}
		}
	}
}
