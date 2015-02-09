namespace Mee {
	public struct Duet<G>
	{
		public G left;
		public G right;
	}
	
	public static GenericSet<string> get_insensitive_cases (string[] data) {
		var gset = new GenericSet<string> (str_hash, str_equal);
		foreach (string str in data)
			get_insensitive_case (str).foreach (s => {
				gset.add (s);
			});
		return gset;
	}

	public static GenericSet<string> get_insensitive_case (string data) {
		var gset = new GenericSet<string> (str_hash, str_equal);
		if (data.length == 0)
			return gset;
		if (data.length == 1) {
			gset.add (data.down());
			gset.add (data.up());
		} else {
			get_insensitive_case (data.substring (1)).foreach (sub => {
				gset.add (data[0].to_string().down() + sub);
				gset.add (data[0].to_string().up() + sub);
			});
		}
		return gset;
	}
}
