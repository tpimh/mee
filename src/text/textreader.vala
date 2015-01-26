namespace Mee {
	public abstract class TextReader : Object {
		public abstract unichar peek();
		
		public abstract unichar read();
		
		public virtual int read_chars (unichar[] buffer, int index, int count) {
			int i = 0;
			for ( i = 0; i < count; i++) {
				unichar num;
				if ((num = read()) == 0)
					return i;
				buffer[index + i] = num;
			}
			return i;
		}
		
		public virtual string read_line() {
			var sb = new StringBuilder();
			unichar u;
			while ((u = read()) != 0) {
				if (u == 10)
					break;
				if (u == 13) {
					if (peek() == 10)
						read();
					break;
				}
				sb.append_unichar (u);
			}
			if (u == 0 || sb.len == 0)
				return "";
			return sb.str;
		}
	}
}
