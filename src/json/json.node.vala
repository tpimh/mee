namespace Mee.Json
{
	public class Node : Mee.Object
	{
		Mee.Value val;
		
		public Node.empty(){ this(""); }
		
		public Node(string data){ val = new Mee.Value(data); }

		public string to_string(int indent = 0){ 
			if(is_object())
				return to_object().to_string(indent);
			if(is_array())
				return to_array().to_string(indent);
			return val.val;
		}
		public string as_string(){ 
			var str = Parser.valid_string(val.val);
			return (str == null) ? to_string() : str; 
		}
		public bool to_boolean(){ return bool.parse(val.val); }
		public int64 to_int(){ return int64.parse(val.val); }
		public double to_double(){ return double.parse(val.val); }
		public Object to_object() throws Mee.Error { istring i = {val.val,0}; return new Object.parse(ref i); }
		public Array to_array() throws Mee.Error { istring i = {val.val,0}; return new Array(ref i); }
		public Value to_value(){ return val; }
		public bool is_null(){ return val.val.length < 1 || val.val == "null"; }
		public bool is_string(){ return null != Parser.valid_string(val.val); }
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
		
		public bool has(string id){ return null != this[id]; }
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
