namespace Mee.Json
{
	public errordomain Error
	{
		Null,
		NotFound,
		Start,
		Type
	}

	internal static string valid_string(string data) throws Json.Error
	{
		if(data[0] == '"' && data.index_of("\"",1) == -1 ||
		   data[0] == '\'' && data.index_of("'",1) == -1 ||
		   data.index_of("'") == -1 && data.index_of("\"") == -1 ||
		   data[0] != '"' && data[0] != '\'')
			throw new Json.Error.Type("invalid string");
			
		int ind = data.index_of(data[0].to_string(),1);
		string str = data.substring(1,ind-1);
		while(str[str.length-1] == '\\'){
			ind = data.index_of(data[0].to_string(),1+ind);
			if(ind == -1)
				throw new Json.Error.NotFound("end not found");
			str = data.substring(1,ind-1);
		}
		return str;
	}

	public class Parser : GLib.Object
	{
		public signal void parse_start();
		public signal void parse_end();

		public Parser(){}

		public Node parse_file(string path)
		{
			string data;
			try{
				FileUtils.get_contents(path,out data);
				return parse_data (data);
			}catch{
				return null;
			}
		}

		public Node parse_data(string data) throws Json.Error
		{
			parse_start();
			var n = new Node(new Object(data).to_string());
			parse_end();
			return n;
		}
	}
}
