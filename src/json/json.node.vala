namespace Mee.Json
{
	public struct Pair
	{
		public string name;
		public Node node;
	}
	
	public class Node : GLib.Object
	{
		string raw;
		
		public Node.empty(){}
		
		public Node(string data){
			raw = data;
		}
		public bool is_object(){
			try{var o = new Object(raw);}
			catch(Mee.Error j){
				return false;
			}
			return true;
		}
		public bool is_array(){
			try{var o = new Array(raw);}
			catch(Mee.Error j){
				return false;
			}
			return true;
		}
		public Object as_object(){ return new Object(raw); }
		public Array as_array(){ return new Array(raw); }
		public double as_double(){ return double.parse(raw); }
		public int64 as_int(){ return int64.parse(raw); }
		public bool as_bool(){ return bool.parse(raw); }
		public string as_string(){ return raw.replace("\"",""); }
		public void set_string(string s){ raw = "\"%s\"".printf(s); }
		public void set_object(Object o){ raw = o.to_string(); }
		public void set_array(Array a){ raw = a.to_string(); }
		public void set_value(GLib.Value val){
			if(val.type().is_object())
				raw = object_to_data(val.get_object());
			else if(val.type() == typeof(string))
				raw = "\"%s\"".printf(val.strdup_contents());
			else raw = val.strdup_contents();
		}
		
		public string to_string(){
			return raw;
		}
	}
}
