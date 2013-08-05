using Mee.Collections;

namespace Mee.Json
{
	public delegate void ArrayForeachFunc(Node node);
	
	public class Array : Mee.Object
	{
		ArrayList<Node> list;
		
		public Array.empty() { list = new ArrayList<Node>(); }
		public Array.sized(int l) {
			this.empty();
			for(var i = 0; i < l; i++)
				list.add(new Node("null"));
		}
		
		public Array(ref istring data) throws Mee.Error
		{
			list = new ArrayList<Node>();
			if(data.getc() != '['){
				var e = new Error.Malformed("provided data doesn't start with correct character (%c)"
												.printf(data.getc()));
				error_occured(e);
				throw e;
			}
			data.index++;
			data.index = data.index_of(data.substring().chug());
			if(data.getc() == ']'){
				data.index++;
				data.index = data.index_of(data.substring().chug());
			}else
			parse_index(ref data);
		}
		
		void parse_index(ref istring data) throws Mee.Error
		{
			data.index = data.str.index_of(data.substring().chug());
			if(data.getc() == '{'){
				var a = data.index;
				var obj = new Object.parse(ref data);
				list.add(new Node(data.str.substring(a,data.index-a)));
				data.index = data.index_of(data.substring().chug());
			}else if(data.getc() == '['){
				var i = data.index;
				var a = new Array(ref data);
				list.add(new Node(data.str.substring(i,data.index-i)));
				data.index = data.index_of(data.substring().chug());
			}else if(data.getc() == '"' || data.getc() == '\''){
				var val = Parser.valid_string(data.substring().chug());
				list.add(new Node(val));
				data.index += val.length+2;
				data.index = data.index_of(data.substring().chug());
			}else {
				String val = new String(data.substring());
				string val1 = val.substring(0,val.indexs_of(",","]"," ")[0]).str.strip();
				if(val1 == "false" || val1 == "true" || val1 == "null")
					list.add(new Node(val1));
				else {
					float f;
					if(val1.scanf("%f",&f)==0){
						var e = new  Error.Type("value isn't a number (%s)".printf(val1));
						error_occured(e);
						throw e;
					}
					list.add(new Node(val1));
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
				stdout.printf("%s\n",data.substring());
				var e = new Mee.Error.Malformed("end of array section don't found");
				error_occured(e);
				throw e;
			}
		}
		public void add_array_element(Array value){ list.add(new Node(value.to_string())); }
		public void add_boolean_element(bool value){ list.add(new Node(value.to_string())); }
		public void add_double_element(double value){ list.add(new Node(value.to_string())); }
		public void add_element(Node value){ list.add(value); }
		public void add_int_element(int64 value){ list.add(new Node(value.to_string())); }
		public void add_null_element(){ list.add(new Node("null")); }
		public void add_object_element(Object value){ list.add(new Node(value.to_string())); }
		public void add_string_element(string value){ list.add(new Node(value)); }
		public int64 get_int_element(int index){ return list[index].to_int(); }
		public double get_double_element(int index){ return list[index].to_double(); }
		public string get_string_element(int index){ return list[index].to_string(); }
		public Array get_array_element(int index){ return list[index].to_array(); }
		public Object get_object_element(int index){ return list[index].to_object(); }
		public void @foreach(ArrayForeachFunc func){ foreach(var node in list)func(node); }
		public new Node @get(int index){ return list[index]; }
		public new void @set(int index, Node node){ 
			if(index > -1 && index < list.size)
			list[index] = node; 
		}
		public bool get_null_element(int index){ return (list[index].is_null()) ? true : false; }
		public bool get_boolean_element(int index){ return list[index].to_boolean(); }
		public ArrayList<Node> get_elements(){ return list; }
		public void remove(int index){ list.remove_at(index); }
		public string to_string(){
			string str = "[";
			if(size < 1) return "[]";
			for(var i=0; i<size-1; i++)
				str += this[i].to_string() + ",";
			str += this[size-1].to_string() + "]";
			return str;
		}
		public int size { get{ return list.size; } }
	}
}
