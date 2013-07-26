namespace Mee.Json
{
	public class Node : Mee.Object
	{
		Mee.Value val;
		
		public Node.empty(){ this(""); }
		
		public Node(string data){ val = new Mee.Value(data); }

		public string to_string(){ return val.val; }
		public bool to_boolean(){ return bool.parse(val.val); }
		public int64 to_int(){ return int64.parse(val.val); }
		public double to_double(){ return double.parse(val.val); }
		public Object to_object() throws Mee.Error { istring i = {val.val,0}; return new Object(ref i); }
		public Array to_array() throws Mee.Error { istring i = {val.val,0}; return new Array(ref i); }
		public Value to_value(){ return val; }
		public bool is_null(){ return val.val.length > 0 && val.val != "null"; }
		public void set_array(Array value){ val.val = value.to_string(); }
		public void set_boolean(bool value){ val.val = value.to_string(); }
		public void set_double(double value){ val.val = value.to_string(); }
		public void set_int(int64 value){ val.val = value.to_string(); }
		public void set_node(Node value){ val.val = value.to_string(); }
		public void set_object(Object value){ val.val = value.to_string(); }
		public void set_string(string value){ val.val = value; }
		public void set_value(Mee.Value value){ val = value; }
	}
	
}
