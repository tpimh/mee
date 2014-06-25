namespace Mee {
	namespace Text {
		public class String : Gee.ArrayList<unichar>
		{
			public String (string init = "")
			{
				add_string (init);
			}
			
			public void add_string (string str)
			{
				unichar u;
				int i = 0;
				while (str.get_next_char (ref i, out u))
					add (u);
			}

			public String substring (int start, int count = -1)
			{
				var s = new String();
				s.add_all (this.slice (start, start + (count == -1 || start + count >= size ? size - start : count)));
				return s;
			}

			long find_not_in_table (long pos, long target, long change, unichar[] table)
			{
				while (pos != target)
				{
					unichar c = this[(int)pos];
					long i = 0;
					for (i = 0; i < table.length; i++)
					if (table[i] == c)
						break;
					if (i == table.length)
						return pos;
					pos += change;
				}
				return pos;
			}

			public String chug (unichar[] chars = {' '})
			{
				int res = 0;
				while (res < size)
				{
					if (this[res] in chars)
						res++;
					else
						return substring (res, size - res);
				}
				return this;
			}

			public String chomp (unichar[] chars = {' '})
			{
				int res = size;
				while (res - 1 >= 0)
				{
					if (this[res - 1] in chars)
						res--;
					else
						return substring (0, res - 1);
				}
				return this;
			}

			public String strip (unichar[] chars = {' '})
			{
				return chug (chars).chomp (chars);
			}

			public string to_string()
			{
				string s = "";
				foreach (unichar u in this)
					s += u.to_string();
				return s;
			}

			public string str {
				owned get {
					return to_string();
				}
				set {
					clear();
					add_string (value);
				}
			}
		}
	}
}
