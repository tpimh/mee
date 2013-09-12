using Mee.Collections;

namespace Mee.Json
{
	public class Array : GLib.Object
	{
		ArrayList<string> list;

		public Array(string data) throws Json.Error
		{
			var str = data.strip ();
			this.parse (ref str);
		}
		
		public Array.empty(){ list = new ArrayList<string>(); }
		
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
					list.add(array.to_string ());
				}else if(data[0] == '{'){
					var object = new Object.parse (ref data);
					list.add(object.to_string());
				}else if(data[0] == '"' || data[0] == '\''){
					var str = valid_string (data);
					data = data.substring (str.length+2).chug ();
					list.add ("\"%s\"".printf(str));
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
					list.add(val);
					data = data.substring(val.length).chug();
				}
				if(data[0] != ',' && data[0] != ']')
						throw new Json.Error.Type("invalid end of element");
					bool end = (data[0] == ']') ? true : false;
					data = data.substring(1).chug();
					if(end)break;
			}
		}

		public Node? get_element(int index){
			if(index < 0 || index >= list.size)
				return null;
			return new Node(list[index]);
		}
		public Array? get_array_element(int index){ return get_element(index).as_array(); }
		public Object? get_object_element(int index){ return get_element(index).as_object(); }
		public double get_double_element(int index){ return get_element(index).as_double(); }
		public bool get_boolean_element(int index){ return get_element(index).as_bool(); }
		public int64 get_int_element(int index){ return get_element(index).as_int(); }
		public bool get_null_element(int index){ return list[index] == "null"; }
		public string get_string_element(int index){ return get_element(index).as_string(); }
		
		public void add_element(Node node){ list.add(node.str); }
		public void add_array_element(Array array){ list.add(array.to_string()); }
		public void add_object_element(Object object){ list.add(object.to_string()); }
		public void add_double_element(double val){ list.add(val.to_string()); }
		public void add_boolean_element(bool val){ list.add(val.to_string()); }
		public void add_int_element(int64 i){ list.add(i.to_string()); }
		public void add_null_element(){ list.add("null"); }
		public void add_string_element(string str){
			try{
				string s = valid_string("\""+str+"\"");
				list.add("\""+str+"\"");
			}catch{}
		}
		public void remove_element(int index){
			if(index < 0 || index >= length)
				return;
			list.remove_at(index);
		}
		
		public ArrayList<Node> get_elements(){
			var nlist = new ArrayList<Node>();
			this.foreach((u,node) => { nlist.add(node); });
			return nlist;
		}
		
		public void foreach(ArrayForeach func){
			for(int i = 0; i < list.size; i++){
				var node = new Node(list[i]);
				func(i,node);
			}
		}
		
		public delegate void ArrayForeach(int index, Node node);

		public string to_string(){
			if(list.size == 0)return "[]";
			string s = "[ ";
			for(int i = 0; i < list.size - 1; i++)
				s += get_element(i).to_string() + " , ";
			s += get_element(list.size - 1).to_string()+" ]";
			return s;
		}
		public string dump(int indent = 0){
			if(list.size == 0)return "[]";
			string ind = "";
			for(var i = 0; i < indent; i++)
				ind += "\t";
			string s = "[\n";
			for(int i = 0; i < list.size - 1; i++)
				s += ind+"\t"+get_element(i).dump(indent+1) + " ,\n";
			s += ind+"\t"+get_element(list.size - 1).dump(indent+1)+"\n";
			s += ind+"]";
			return s;
		}
		
		public int length {
			get {
				return list.size;
			}
		}
	}
}
