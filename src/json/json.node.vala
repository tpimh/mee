namespace Mee.Json
{
	public class Node : Mee.Object
	{
		Mee.Value val;
		
		public Node.empty(){ this(""); }
		
		public Node(string data){ val = new Mee.Value(data); }

		public string to_string(){ 
			if(is_object() || is_array() || is_null() || val.val.down() == "false"
			 || val.val.down() == "true" || val.val.down() == "null")
				return val.val; 
			float f;
			if(val.val.scanf("%f",&f) == 0)
				return "'"+val.val+"'";
			if(val.val.scanf("%f",&f) == -1) 
				return "null";
			return val.val;
		}
		public bool to_boolean(){ return bool.parse(val.val); }
		public int64 to_int(){ return int64.parse(val.val); }
		public double to_double(){ return double.parse(val.val); }
		public Object to_object() throws Mee.Error { istring i = {val.val,0}; return new Object.parse(ref i); }
		public Array to_array() throws Mee.Error { istring i = {val.val,0}; return new Array(ref i); }
		public Value to_value(){ return val; }
		public bool is_null(){ return val.val.length > 0 && val.val != "null"; }
		public bool is_object(){
			try{ var o = to_object(); return true; }
			catch(Mee.Error e){ return false; }
		}
		public bool is_array(){
			try{ var a = to_array(); return true; }
			catch(Mee.Error e){ return false; }
		}
		public void set_array(Array value){ val.val = value.to_string(); }
		public void set_boolean(bool value){ val.val = value.to_string(); }
		public void set_double(double value){ val.val = value.to_string(); }
		public void set_int(int64 value){ val.val = value.to_string(); }
		public void set_node(Node value){ val.val = value.to_string(); }
		public void set_object(Object value){ val.val = value.to_string(); }
		public void set_string(string value){ val.val = value; }
		public void set_value(Mee.Value value){ val = value; }
		
		
		public Node? get(string id) throws Mee.Error
		{
			if(is_object()){
				var o = to_object();
				return o.get_member(id);
			}
			if(is_array()){
				var a = to_array();
				int i = int.parse(id);
				if(i < 0 || i >= a.size)
					return null;
				return a[i];
			}
			return null;
		}
	}
	
}
