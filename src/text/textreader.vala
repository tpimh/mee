namespace Mee {
	namespace Text {
		/**
		 * An abstract class designed for text reading. 
		 */
		public abstract class TextReader : Object {
			/**
			 * Returns current character;
			 * 
			 * @return current character; 
			 */
			public abstract unichar peek();
			/**
			 * Reads next character and returns it. 
			 * 
			 * @return next character.
			 */
			public abstract unichar read();
			/**
			 * Reads next counted characters into provided buffer, at specified index.
			 * 
			 * @param buffer char array where write characters.
			 * @param index 0-based index of buffer where start writing characters.
			 * @param count number of characters to read.
			 * 
			 * @return number of characters read.
			 */
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
			/**
			 * Reads a line.
			 * 
			 * @return a line of text. 
			 */
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
}
