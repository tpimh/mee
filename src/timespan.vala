namespace Mee {
	public class TimeSpan : GLib.Object {
		internal GLib.TimeSpan ts;
		
		public static TimeSpan zero {
			owned get {
				return new TimeSpan();
			}
		}
		
		public TimeSpan (int64 days = 0, int64 hours = 0, int64 minutes = 0, int64 seconds = 0, int64 milliseconds = 0) {
			ts = milliseconds * GLib.TimeSpan.MILLISECOND + seconds * GLib.TimeSpan.SECOND + minutes * GLib.TimeSpan.MINUTE + hours * GLib.TimeSpan.HOUR + days * GLib.TimeSpan.DAY;
		}
		
		public void add (Mee.TimeSpan timespan) {
			ts += timespan.ts;
		}
		
		public bool equals (Mee.TimeSpan timespan) {
			return ts == timespan.ts;
		}
		
		public void substract (Mee.TimeSpan timespan) {
			ts -= timespan.ts;
		}
		
		public string to_string() {
			string n = ts != ts.abs() ? "-" : "";
			string d = days == 0 ? "" : "%lld.".printf (days.abs());
			string ms = milliseconds == 0 ? "" : ".%.3lld".printf (milliseconds.abs());
			return "%s%s%.2lld:%.2lld:%.2lld%s".printf (n, d, hours.abs(), minutes.abs(), seconds.abs(), ms);
		}
		
		public int64 days {
			get {
				return ts / GLib.TimeSpan.DAY;
			}
		}
		public int64 hours {
			get {
				return (ts - days * GLib.TimeSpan.DAY) / GLib.TimeSpan.HOUR;
			}
		}
		public int64 minutes {
			get {
				return (ts - days * GLib.TimeSpan.DAY - hours * GLib.TimeSpan.HOUR) / GLib.TimeSpan.MINUTE;
			}
		}
		public int64 seconds {
			get {
				return (ts - days * GLib.TimeSpan.DAY - hours * GLib.TimeSpan.HOUR - minutes * GLib.TimeSpan.MINUTE) / GLib.TimeSpan.SECOND;
			}
		}
		public int64 milliseconds {
			get {
				return (ts - days * GLib.TimeSpan.DAY - hours * GLib.TimeSpan.HOUR - minutes * GLib.TimeSpan.MINUTE - seconds * GLib.TimeSpan.SECOND) / GLib.TimeSpan.MILLISECOND;
			}
		}
		
		public int64 ticks {
			get {
				return ts;
			}
		}
		
		public double total_days {
			get {
				return (double)ts / GLib.TimeSpan.DAY;
			}
		}
		
		public double total_hours {
			get {
				return (double)ts / GLib.TimeSpan.HOUR;
			}
		}
		
		public double total_minutes {
			get {
				return (double)ts / GLib.TimeSpan.MINUTE;
			}
		}
		
		public double total_seconds {
			get {
				return (double)ts / GLib.TimeSpan.SECOND;
			}
		}
		
		public double total_milliseconds {
			get {
				return (double)ts / GLib.TimeSpan.MILLISECOND;
			}
		}
		
		static Mee.TimeSpan from (double val, int64 mux) {
			var timespan = new Mee.TimeSpan();
			timespan.ts = mux * (int64)val;
			return timespan;
		}
		
		public static Mee.TimeSpan from_gtimespan (GLib.TimeSpan ts) {
			var timespan = new Mee.TimeSpan();
			timespan.ts = ts;
			return timespan;
		}
		
		public static Mee.TimeSpan from_days (double days) {
			return from (days, GLib.TimeSpan.DAY);
		}
		
		public static Mee.TimeSpan from_hours (double hours) {
			return from (hours, GLib.TimeSpan.HOUR);
		}
		
		public static Mee.TimeSpan from_minutes (double minutes) {
			return from (minutes, GLib.TimeSpan.MINUTE);
		}
		
		public static Mee.TimeSpan from_seconds (double seconds) {
			return from (seconds, GLib.TimeSpan.SECOND);
		}
		
		public static Mee.TimeSpan from_milliseconds (double ms) {
			return from (ms, GLib.TimeSpan.MILLISECOND);
		}
			
		public static Mee.TimeSpan parse (string str) {
			Mee.TimeSpan ts;
			try_parse (str, out ts);
			return ts;
		}
		
		public static bool try_parse (string str, out Mee.TimeSpan ts = null) {
			ts = new Mee.TimeSpan();
			string ts_string = str.chomp().chug();
			bool res = ts_string[0] == '-' || ts_string[0] == '+' || ts_string[0].isdigit();
			if (!res)
				return false;
			bool n = ts_string[0] == '-';
			int64 val = 0;
			if (int64.try_parse (ts_string, out val)) {
				ts = new Mee.TimeSpan (val);
				return true;
			}
			if (ts_string[0] == '-' || ts_string[0] == '+')
				ts_string = ts_string.substring (1);
			var sb = new StringBuilder();
			int pos = 0;
			while (ts_string[pos].isdigit()) {
				sb.append_c (ts_string[pos]);
				pos++;
			}
			string str1 = sb.str;
			if (ts_string[pos] != '.' && ts_string[pos] != ':')
				return false;
			int64 dv = ts_string[pos] == '.' ? (int64)uint64.parse (str1) : 0;
			int64 hv = ts_string[pos] == ':' ? (int64)uint64.parse (str1) : 0;
			char c = ts_string[pos];
			pos++;
			sb = new StringBuilder();
			while (ts_string[pos].isdigit()) {
				sb.append_c (ts_string[pos]);
				pos++;
			}
			string str2 = sb.str;
			int64 mv = 0;
			if (c == '.')
				hv = (int64)uint64.parse (str2);
			else if (c == ':')
				mv = (int64)uint64.parse (str2);
			if (ts_string[pos] == 0 && c == ':') {
				ts = new TimeSpan (n ? -dv : dv, n ? -hv : hv, n ? -mv : mv);
				return true;
			}
			if (ts_string[pos] != ':')
				return false;
			pos++;
			sb = new StringBuilder();
			while (ts_string[pos].isdigit()) {
				sb.append_c (ts_string[pos]);
				pos++;
			}
			string str3 = sb.str;
			int64 sv = 0;
			if (c == '.')
				mv = (int64)uint64.parse (str3);
			else if (c == ':')
				sv = (int64)uint64.parse (str3);
			if (ts_string[pos] == 0) {
				if (c == ':') {
					ts = new TimeSpan (n ? -dv : dv, n ? -hv : hv, n ? -mv : mv, n ? -sv : sv);
					return true;
				}
				else return false;
			}
			char d = ts_string[pos];
			if (d != ':' && d != '.')
				return false;
			pos++;
			sb = new StringBuilder();
			while (ts_string[pos].isdigit()) {
				sb.append_c (ts_string[pos]);
				pos++;
			}
			string str4 = sb.str;
			if (c == '.' && d == ':')
				sv = (int64)uint64.parse (str4);
			if (ts_string[pos] == 0 && c == '.') {
				ts = new TimeSpan (n ? -dv : dv, n ? -hv : hv, n ? -mv : mv, n ? -sv : sv);
				return true;
			}
			else if (ts_string[pos] == 0 && c == ':') {
				int64 v =  (int64)uint64.parse (str4);
				ts = new TimeSpan (n ? -dv : dv, n ? -hv : hv, n ? -mv : mv, n ? -sv : sv, n ? -v : v);
				return true;
			}
			else if (ts_string[pos] == 0)
				return false;
			if (c == '.' && ts_string[pos] == '.') {
				pos++;
				sb = new StringBuilder();
				while (ts_string[pos].isdigit()) {
					sb.append_c (ts_string[pos]);
					pos++;
				}
				if (ts_string[pos] != 0)
					return false;
				int64 v =  (int64)uint64.parse (sb.str);
				ts = new TimeSpan (n ? -dv : dv, n ? -hv : hv, n ? -mv : mv, n ? -sv : sv, n ? -v : v);
				return true;
			}
			return false;
		}
	}
}	
