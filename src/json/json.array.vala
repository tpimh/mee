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
		
		public Array(ref string data) throws Mee.Error
		{
			list = new ArrayList<Node>();
			if(data[0] != '['){
				var e = new Error.Malformed("provided data doesn't start with correct character (%c)"
												.printf(data[0]));
				error_occured(e);
				throw e;
			}
			data = data.substring(1).chug();
			if(data[0] == ']'){
				data = data.substring(1).chug();
			}else
			parse_index(ref data);
		}
		
		void parse_index(ref string data) throws Mee.Error
		{
			data = data.chug();
			if(data[0] == '{'){
				var str = data;
				var obj = new Object.parse(ref data);
				list.add(new Node(str.substring(0,str.length-data.length)));
				data = data.chug();
			}else if(data[0] == '['){
				var str = data;
				var a = new Array(ref data);
				list.add(new Node(str.substring(0,str.length - data.length)));
				data = data.chug();
			}else if(data[0] == '"' || data[0] == '\''){
				var val = Parser.valid_string(data);
				list.add(new Node("'"+val+"'"));
				data = data.substring(2+val.length).chug();
			}else {
				String val = new String(data);
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
				data = data.substring(val1.length).chug();
			}
			if(data[0] == ','){
				data = data.substring(1).chug();
				parse_index(ref data);
			}else if(data[0] == ']'){
				data = data.substring(1).chug();
			}else {
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
		public void add_string_element(string value){ list.add(new Node("'"+value+"'")); }
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
		public string to_string(int indent = 0){
			string str = "[\n";
			string ind = "";
			for(var i = 0; i < indent; i++)
				ind += "\t";
			if(size < 1) return "null";
			for(var i=0; i<size-1; i++)
				str += ind+"\t"+this[i].to_string(indent+1) + ",\n";
			str += ind+"\t"+this[size-1].to_string(indent+1) + "\n";
			str += ind+"]";
			return str;
		}
		public int size { get{ return list.size; } }
	}
}
