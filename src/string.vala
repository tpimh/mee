namespace Mee
{
	public class String : GLib.StringBuilder
	{
		static bool rec = false;
		
		static void init_print(){
			if(rec == false){
				register_printf_specifier(
				'W',
				(file,info,args)=>{
					String* s=*((String**)(args[0]));
					file.puts(s->str);
					return s->length;
				},
				(info, n, argtypes, size)=>{
					argtypes[0] = PA_POINTER;
					return 1;
				});
				rec = true;
			}
		}
		
		public String(string init = ""){
			base(init);
			init_print();
		}
		
		public int length { get{ return str.length; } }
		
		public bool @is(string data){
			return data == str;
		}
		public Sub count(Set s){
			Sub res = Sub();
			for(var i = 0; i < str.length ; i++){
				if((str.length - i >= s.left.length) && str.substring(i,s.left.length) == s.left)res.left++;
				if((str.length - i >= s.right.length) && str.substring(i,s.right.length) == s.right)res.right++;
			}
			return res;
		}	
		public String replace(string old, string replacement){
			return new String(str.replace(old,replacement));
		}
		public String substring(long offset, long len = -1){
			return new String(str.substring(offset,len));
		}
		public bool contains_set(Set s){
			Sub sub = count(s);
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
			var alist = new Gee.ArrayList<int>();
			alist.add(index_of(str));
			for (string? s = list.arg<string?> (); s != null ; s = list.arg<string?> ()){
				if(index_of(s) != -1)alist.add(index_of(s));
			}
			alist.sort();
			return alist.to_array();
		}
		public int[] last_indexs_of(string str, ...){
			var list = va_list();
			var alist = new Gee.ArrayList<int>();
			alist.add(last_index_of(str));
			for (string? s = list.arg<string?> (); s != null ; s = list.arg<string?> ()){
				if(index_of(s) != -1)alist.add(last_index_of(s));
			}
			alist.sort();
			return alist.to_array();
		}
		public int index_of(string needle, Set s = {"",""}, int start = 0){
			int i = str.index_of(needle,start);
			Set _s = {"",""};
			if(s == _s)return i;
			if(i == -1)return -1;
			Sub sub = index_of_set(s,start);
			if(sub.left > sub.right)return -1;
			if(i < sub.left || i > sub.right)return i;
			return index_of(needle,s,sub.right+2);
		}			
		public Sub index_of_set(Set s, int start = 0, bool count_n = false){
			Sub res = Sub();
			res.left = str.index_of(s.left,start);
			res.right = str.index_of(s.right,start);
			if(count_n == true){
				var c = new String(str.substring(res.left,res.right-res.left+s.right.length)).count(s);
				int i = start;
				while(c.res() != 0 && res.right < str.length - s.right.length){
					res.right = str.index_of(s.right,res.right+1);
					c = new String(str.substring(res.left,res.right-res.left+s.right.length)).count(s);
					if(res.right == -1)return res;
				}
			}
			return res;
		}	
		public void chug(char c = ' '){
			while(str.index_of(c.to_string()) == 0){
				str = str.substring(1);
			}
		}
		public void chomp(char c = ' '){
			while(str.last_index_of(c.to_string()) == str.length - 1)
				str = str.substring(0,str.length-1);
		}
		public void strip(char c = ' '){
			chug(c);
			chomp(c);
		}
		public String[] split(String delimiter, int tokens = 0){
			return split_s(delimiter.str,tokens);
		}
		public String[] split_r(Regex r){
			string[] t = r.split(str);
			String[] table = new String[t.length];
			for(var i=0; i<table.length; i++)
				table[i] = new String(t[i]);
			return table;
		}
		public String[] split_s(string s, int tokens = 0){
			string[] t = str.split(s,tokens);
			String[] table = new String[t.length];
			for(var i=0; i<table.length; i++)
				table[i] = new String(t[i]);
			return table;
		}
		public String[] split_t(char[] table = {' '}, bool ree = false){
			if(table.length < 1)return new String[]{new String()};
			string[] t = str.split(table[0].to_string());
			for(var i = 1; i < table.length; i++){
				var list = new Gee.ArrayList<string>();
				foreach(string s in t)
					foreach(string st in s.split(table[i].to_string()))
						if(ree == false || ree == true && st.length > 0)
							list.add(st);
				t = list.to_array();
			}
			String[] array = new String[t.length];
			for(var i = 0; i < array.length; i++)
				array[i] = new String(t[i]);
			return array;
		}
	}
}
