namespace Mee.Json
{
	namespace Parser
	{
		public static Object parse_file(string filename) throws Mee.Error
		{
			string s;
			FileUtils.get_contents(filename,out s);
			return parse_data(s);
		}
		
		public static Object parse_data(string data) throws Mee.Error
		{
			return new Object(data);
		}
		
		public static bool check(string needle, char c, char d){
			int i = 0;
			for(var j=0; j<needle.length; j++){
				if(needle[j] == d)i--;
				if(needle[j] == c)i++;
			}
			return i==0;
		}
		
		public static bool is_valid(string str){
			if(str.contains(",") || str.contains("?") || 
				str.contains("!") || str.contains("#") || 
				str.contains("+") || str.contains("*") || 
				str.contains(":") || str.contains("/") || 
				str.contains("%") || str.contains("¨") || 
				str.contains("{") || str.contains("}") || 
				str.contains("[") || str.contains("]") || 
				str.contains("(") || str.contains(")") || 
				str.contains(";") || str.contains("<") || 
				str.contains(">") || str.contains(" "))return false;
			return true;
		}
	}
	
	public static string object_to_data(GLib.Object o, int indent = 0){
		string ind = "";
		for(int i=0; i<indent; i++)
			ind += "\t";
		string s = "{\n";
		var obj_class = (ObjectClass) o.get_type().class_ref ();
		var properties = obj_class.list_properties ();	
		for(var z=0; z<properties.length; z++){
			GLib.Value val = GLib.Value(properties[z].value_type);
			o.get_property(properties[z].name,ref val);
			
			s += ind+"\"%s\" : ".printf(properties[z].name);
			if(val.type().is_object()){
				if(val.get_object() != null)
					s += object_to_data(val.get_object(),indent+1);
				else s += "NULL";
			}
			else
				s+= val.strdup_contents();
			if(z<properties.length-1)s+=",\n";
		}	
		s += "\n"+ind+"}";
		return s;
	}
	
	public static GLib.Object data_to_object(GLib.Type t, string data) throws Mee.Error
	{
		var obj = Parser.parse_data(data);
		GLib.Object o = GLib.Object.new(t);
		var obj_class = (ObjectClass) o.get_type().class_ref ();
		var properties = obj_class.list_properties ();
		foreach(var p in properties){
			GLib.Value val = GLib.Value(p.value_type);
			stdout.printf("%s\n",p.value_type.name());
			foreach(var pair in obj.entries){
				if(pair.name == p.name){
					if(pair.node.is_object())
						val.set_object(data_to_object(p.value_type,pair.node.to_string()));
					else if(!pair.node.is_array()){
						switch(p.value_type.name()){
							case "gchararray":
								val.set_string(pair.node.as_string());
							break;
							case "gint":
								val.set_int((int)pair.node.as_int());
							break;
							case "gint64":
								val.set_int64(pair.node.as_int());
							break;
							case "glong":
								val.set_long((long)pair.node.as_int());
							break;
							case "guint":
								val.set_uint((uint)pair.node.as_int());
							break;
							case "guint64":
								val.set_uint64((uint64)pair.node.as_int());
							break;
							case "gulong":
								val.set_ulong((ulong)pair.node.as_int());
							break;
							case "gchar":
								val.set_char((char)pair.node.as_int());
							break;
							case "guchar":
								val.set_uchar((uchar)pair.node.as_int());
							break;
							case "gboolean":
								val.set_boolean(pair.node.as_bool());
							break;
							case "gfloat":
								val.set_float((float)pair.node.as_double());
							break;
							case "gdouble":
								val.set_double(pair.node.as_double());
							break;
						}
					}
				}
			}
			o.set_property(p.name,val);
		}
		return o;
	}
}
