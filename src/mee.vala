namespace Mee {
	public struct Duet<G>
	{
		public G left;
		public G right;
	}
	
	public static Gee.Collection<string> get_insensitive_cases (string[] data)
    {
		var data_set = new Gee.HashSet<string>();
		foreach(string str in data)
			data_set.add_all (get_insensitive_case (str));
		return data_set;
	}
    
    static Gee.Collection<string> get_insensitive_case (string data)
    {
		var data_set = new Gee.HashSet<string>();
		if (data.length == 0)
			return data_set;
		if (data.length == 1)
		{
			data_set.add (data.down ());
			data_set.add (data.down ().up ());
		}
		else
			foreach (var str in get_insensitive_case (data.substring (1)))
			{
				data_set.add (data[0].to_string().down() + str);
				data_set.add (data[0].to_string().down().up() + str);
			}
		return data_set;
	}
}
