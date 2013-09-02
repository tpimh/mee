namespace Mee.Json
{
	public class Node : GLib.Object
	{
		internal string str;

		public Node(string val){ str = val; }

		public Object? as_object(){
			try{
				var o = new Object(str);
				return o;
			}catch(Json.Error e){
				print(e.message+"\n");
				return null;
			}
		}
		public Array? as_array(){
			try{
				return new Array(str);
			}
			catch(Json.Error e){
				return null;
			}
		}
		public int64 as_int(){ return int64.parse(str); }
		public double as_double(){ return double.parse(str); }
		public bool as_bool(){ return (str == "true") ? true : false; }
		public string? as_string(){
			try{ return valid_string(str); }
			catch(Json.Error e){ return null; }
		}
		public GLib.Value? as_value(){
			GLib.Value val;
			var obj = as_object();
			if(obj != null){
				val = GLib.Value(typeof(Object));
				val.set_object(obj);
				return val;
			}else{
				var array = as_array();
				if(array != null){
					val = GLib.Value(typeof(Array));
					val.set_object(array);
					return val;
				}else{
					int64 i;
					if(int64.try_parse (str,out i)){
						val = GLib.Value(typeof(int64));
						val.set_int64(i);
						return val;
					}else{
						double d;
						if(double.try_parse(str,out d)){
							val = GLib.Value(typeof(double));
							val.set_double(d);
							return val;
						}else{
							if(as_string() != null){
								val = GLib.Value(typeof(string));
								val.set_string(as_string());
								return val;
							}else{
								if(str == "true" || str == "false"){
									val = GLib.Value(typeof(bool));
									val.set_boolean(bool.parse(str));
									return val;
								}
							}
						}
					}
				}
			}
		return null;
		}

		public bool is_null(){ return (str == "null") ? true : false; }
		public bool is_bool(){ return (str == "true" || str == "false") ? true : false; }
		public bool is_double(){ double d; return double.try_parse (str, out d); }
		public bool is_int(){ int64 i; return int64.try_parse (str, out i); }
		public bool is_array(){ return (as_array () == null) ? false : true; }
		public bool is_object(){ return (as_object () == null) ? false : true; }
		public bool is_string(){ return (as_string () == null) ? false : true; }
		
		public Node? get(string id) throws Json.Error
		{
			if(is_object ())
				return as_object ().get_member (id);
			if(is_array ())
				return as_array ().get_element ((uint)int.parse (id));
			return null;
		}
		
		public string to_string(){ return str; }
	}
}
