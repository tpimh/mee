namespace Mee.Text
{
	public class String : GLib.Object
	{
		public string str { get; set construct; }
		
		public String(string init = ""){
			Object(str: init);
		}
		
		public int length {
			get {
				return str.length;
			}
		}
		
		public int size {
			get {
				return get_chars().length;
			}
		}
		
		public void add (unichar u)
		{
			str += u.to_string();
		}
		public void add_all (unichar[] array)
		{
			foreach (unichar u in array)
				add (u);
		}
		
		public bool @is(string data){
			return data == str;
		}
		
		public unichar get(long index){
			if (index < 0 || index >= size)
				return 0;
			return get_chars()[index];
		}
		
		public String substring (long start, long len = -1)
        {
            var new_string = new String();
            long count = len == -1 ? size : len;
            if (start+count >= size)
                count = size - start;
            for (var i = 0; i < count; i++)
                new_string.add (this[i+start]);
            return new_string;
        }
		
		public unichar[] get_chars ()
		{
			var list = new Gee.ArrayList<unichar>();
			unichar u;
			int i = 0;
			while (str.get_next_char (ref i, out u))
				list.add (u);
			return list.to_array();
		}
		
		public Duet<int> count(Duet<string> s){
			Duet<int> res = Duet<int>();
			for(var i = 0; i < str.length ; i++){
				if((str.length - i >= s.left.length) && str.substring(i,s.left.length) == s.left){res.left++;i++;}
				if((str.length - i >= s.right.length) && str.substring(i,s.right.length) == s.right){res.right++;i++;}
			}
			return res;
		}	
		public String replace(string old, string replacement){
			return new String(str.replace(old,replacement));
		}
		
		public bool contains_set(Duet<string> s){
			Duet<int> sub = count(s);
			if(sub.left < 1 || sub.right < 1)
				return false;
			return true;
		}
		public bool contains(string needle){
			return str.contains(needle);
		}	
		public int last_index_of(string needle,int start = 0){
			return str.last_index_of(needle,start);
		}
		public int[] indexs_of(string str, ...){
			var list = va_list();
			var alist = new List<int>();
			alist.append(index_of(str));
			for (string? s = list.arg<string?> (); s != null ; s = list.arg<string?> ()){
				alist.append(index_of(s));
			}
			alist.sort((a, b) => {
				return (int) (a > b) - (int) (a < b);
			});
			for(var i = 0; i<alist.length(); i++){
				if(alist.nth_data(0) == -1){
					var a = alist.nth_data(0);
					alist.remove(a);
					alist.append(a);
				}
			}
			return list_to_array<int>(alist);
		}
		public int[] last_indexs_of(string str, ...){
			var list = va_list();
			var alist = new List<int>();
			alist.append(last_index_of(str));
			for (string? s = list.arg<string?> (); s != null ; s = list.arg<string?> ()){
				alist.append(index_of(s));
			}
			alist.sort((a, b) => {
				return (int) (a > b) - (int) (a < b);
			});
			for(var i = 0; i<alist.length(); i++){
				if(alist.nth_data(0) == -1){
					var a = alist.nth_data(0);
					alist.remove(a);
					alist.append(a);
				}
			}
			return list_to_array<int>(alist);
		}
		public int index_of(string needle, Duet<string> s = {"",""}, int start = 0){
			int i = str.index_of(needle,start);
			Duet<string> _s = {"",""};
			if(s == _s)return i;
			if(i == -1)return -1;
			Duet<int> sub = index_of_set(s,start);
			if(sub.left > sub.right)return -1;
			if(i < sub.left || i > sub.right)return i;
			return index_of(needle,s,sub.right+2);
		}			
		public Duet<int> index_of_set(Duet<string> s, int start = 0, bool count_n = false){
			Duet<int> res = {str.index_of(s.left,start),str.index_of(s.right,start)};
			if(count_n == true){
				var c = new String(str.substring(res.left,res.right-res.left+s.right.length)).count(s);
				int i = start;
				while(c.left - c.right != 0 && res.right < str.length - s.right.length){
					res.right = str.index_of(s.right,res.right+1);
					c = new String(str.substring(res.left,res.right-res.left+s.right.length)).count(s);
					if(res.right == -1)return res;
				}
			}
			return res;
		}
		long find_not_in_table (long pos, long target, long change, unichar[] table)
        {
            while (pos != target)
            {
                unichar c = this[pos];
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
            long res = find_not_in_table (0, size, 1, chars);
            if (res == 0)
                return this;
            return substring (res, size - res);
        }
        
        public String chomp (unichar[] chars = {' '})
        {
            long res = find_not_in_table (size - 1, -1, -1, chars);
            res++;
            if (res == size)
                return this;
            return substring (0, res);
        }
        public String strip (unichar[] chars = {' '})
        {
            return chug (chars).chomp (chars);
        }
		public String[] split_r(Regex r, bool ree = false){
			string[] t = r.split(str);
			var list = new List<weak String>();
				foreach(string st in t)
					if(ree == false || ree == true && st.length > 0)
						list.append(new String(st));
			return list_to_array<weak String>(list);
		}
		public String[] split(string s, int tokens = 0, bool ree = false){
			string[] t = str.split(s,tokens);
			var list = new List<weak String>();
				foreach(string st in t)
					if(ree == false || ree == true && st.length > 0)
						list.append(new String(st));
			return list_to_array<weak String>(list);
		}
		public String[] split_t(char[] table = {' '}, bool ree = false){
			if(table.length < 1)return new String[]{new String()};
			string[] t = str.split(table[0].to_string());
			for(var i = 1; i < table.length; i++){
				var list = new List<string>();
				foreach(string s in t)
					foreach(string st in s.split(table[i].to_string()))
						if(ree == false || ree == true && st.length > 0)
							list.append(st);
				t = list_to_array<string>(list);
			}
			String[] array = new String[t.length];
			for(var i = 0; i < array.length; i++)
				array[i] = new String(t[i]);
			return array;
		}
		
		public String copy(){
			return new String(str);
		}
		
		G[] list_to_array<G>(List<G> list){
			G[] array = new G[list.length()];
			for(var i=0; i<array.length; i++)
				array[i] = list.nth_data((uint)i);
			return array;
		}
	}
}
