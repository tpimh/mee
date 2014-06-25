namespace Mee {
	namespace Text {
		public class StringReader : TextReader {
			string text;
			int position;
			int len;
			
			public StringReader (string s) {
				text = s;
				position = 0;
				len = s.length;
			}
			
			public override unichar peek() {
				int pos = position;
				unichar u;
				text.get_next_char (ref pos, out u);
				return u;
			}
			
			public override unichar read() {
				unichar u;
				text.get_next_char (ref position, out u);
				return u;
			}
		}
	}
}
