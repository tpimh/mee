namespace Mee.Json
{
	public class Array : Mee.Object
	{
		List<string> list;
		
		public Array.empty() { list = new List<string>(); }
		public Array.sized(uint size) { this.empty(); list.append(""); }
		
		public Array(ref istring data) throws Mee.Error
		{
			list = new List<string>();
			if(data.getc() != '['){
				var e = new Error.Malformed("provided data doesn't start with correct character");
				error_occured(e);
				throw e;
			}
			data.index++;
			parse_index(ref data);
		}
		
		void parse_index(ref istring data) throws Mee.Error
		{
			data.index = data.str.index_of(data.substring().chug());
			if(data.getc() == '{'){
				var a = data.index;
				var obj = new Object(ref data);
				list.append(data.str.substring(a,data.index-a+1));
			}else if(data.getc() == '['){
				var i = data.index;
				var a = new Array(ref data);
				list.append(data.str.substring(i,data.index-i));
				stdout.printf("%s\n",data.str.substring(i,data.index-i));
			}else if(data.getc() == '"' || data.getc() == '\''){
				var val = Parser.valid_string(data.substring().chug());
				list.append(val);
				data.index += val.length+2;
				data.index = data.index_of(data.substring().chug());
			}else {
				String val = new String(data.substring());
				string val1 = val.substring(0,val.indexs_of(",","]"," ")[0]).str;
				if(val1.down() == "false" || val1.down() == "true" || val1.down() == "null")
					list.append(val1);
				else {
					float f;
					if(val1.scanf("%f",&f)==0){
						var e = new  Error.Type("value isn't a number");
						error_occured(e);
						throw e;
					}
					list.append(val1);
				}
				data.index += val1.length;
				data.index = data.index_of(data.substring().chug());
			}
			if(data.getc() == ','){
				data.index += 1;
				parse_index(ref data);
			}else if(data.getc() == ']'){
				data.index += 1;
			}else {
				var e = new Mee.Error.Malformed("end of array section don't found");
				error_occured(e);
				throw e;
			}
		}
		public void add_array_element(Array array){ list.append(array.to_string()); }
		public void add_boolean_element(bool value){ list.append(value.to_string()); }
		public void add_double_element(double value){ list.append(value.to_string()); }
		public void add_element(Node value){ list.append(value.to_string()); }
		public void add_int_element(int64 value){ list.append(value.to_string()); }
		public void add_null_element(){ list.append("null"); }
		public void add_object_element(Object value){ list.append(value.to_string()); }
		public void add_string_element(string value){ list.append(value); }
		public int64 get_int_element(uint index){ return int64.parse(list.nth_data(index)); }
		public double get_double_element(uint index){ return double.parse(list.nth_data(index)); }
		public string get_string_element(uint index){ return list.nth_data(index); }
		public Array get_array_element(uint index){
			istring str = {list.nth_data(index),0};
			return new Array(ref str);
		}
		public Object get_object_element(uint index){
			istring str = {list.nth_data(index),0};
			return new Object(ref str);
		}
		public new Node @get(uint index){ return new Node(list.nth_data(index)); }
		public new void @set(uint index, Node node){
			remove(index);
			list.insert(node.to_string(),(int)index);
		}
		public bool get_null_element(uint index){ return (list.nth_data(index)=="null") ? true : false; }
		public bool get_boolean_element(uint index){ return (list.nth_data(index)=="true") ? true : false; }
		public List<Node> get_elements(){
			var l = new List<Node>();
			foreach(var elem in list)
				l.append(new Node(elem));
			return l;
		}
		public void remove(uint index){ list.remove(list.nth_data(index)); }
		public string to_string(){
			string str = "[";
			for(var i=0; i<length-1; i++)
				str += this[i].to_string() + ",";
			str += this[length-1].to_string() + "]";
			return str;
		}
		public uint length { get{ return list.length(); } }
	}
}
