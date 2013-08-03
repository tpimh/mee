namespace Mee.Json
{
	public class Parser : Mee.Object
	{
		public Parser(){}
		
		public signal void parse_end ();
		public signal void parse_start ();
		
		public Node parse_file(string path) throws Mee.Error
		{
			string s = "";
			FileUtils.get_contents(path,out s);
			return parse_data(s);
		}
		
		public Node parse_data(string data) throws Mee.Error
		{
			parse_start();
			var obj = Object.parse(data);
			parse_end();
			return new Node(obj.to_string());
		}
		
		public static string valid_string(string data){
			if(data[0] == '"' && data.index_of("\"",1) == -1 ||
			   data[0] == '\'' && data.index_of("'",1) == -1 ||
			   data.index_of("'") == -1 && data.index_of("\"") == -1 ||
			   data[0] != '"' && data[0] != '\'')return null;
			return data.substring(1,data.index_of(data[0].to_string(),1)-1);
		}
		public static string value_to_string(string val){
			var node = new Node(val);
				string st = null;
				if(node.is_array() || node.is_object() 
				|| node.to_string().down() == "false"
				|| node.to_string().down() == "true" 
				|| node.to_string().down() == "null")
					st = node.to_string();
				else{
					float f;
					if(node.to_string().scanf("%f",&f)==0)
						st = "'"+node.to_string()+"'";
					else st = node.to_string();
				}
			return st;
		}
	}
	
	public interface Serializable : GLib.Object
	{
		public abstract ParamSpec[] properties { owned get; }
		public abstract void get_property (string property_name, ref GLib.Value value);
	}
	
	[Experimental]
	public static Object object_to_data(GLib.Object object){
		var obj_class = (ObjectClass) object.get_type().class_ref ();
		Object o = new Object.empty();
		foreach(var prop in obj_class.list_properties()){
			GLib.Value val = GLib.Value(prop.value_type);
			object.get_property(prop.name, ref val);
			if(val.type().is_object()){
				o.set_object_member(prop.name,object_to_data(val.get_object()));
			}
			else if(val.type() != typeof(void*))
				o.set_member(prop.name,new Node(val.strdup_contents()));
			else {
				Array array = new Array.empty();
				var i = 1;
				long *ptr = (long*)val.get_pointer();
				array.add_int_element((int64)ptr[0]);
				while(ptr[i] != 0){
					array.add_int_element((int64)ptr[i]);
					i++;
				}
				o.set_member(prop.name,new Node(array.to_string()));
			}
		}
		return o;
	}
}
