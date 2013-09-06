namespace Mee
{
	public struct Time
	{
		public Time(int h, int m, int s){
			hour = h; minute = m; second = s;
		}
		
		public int hour;
		public int minute;
		public int second;
		public string to_string(){
			if (hour > 0)
				return "%i:%.2d:%.2d".printf(hour,minute,second);
			else return "%.2d:%.2d".printf(minute,second);
		}
		public static Time from_string(string str){
			return Time(
				int.parse(str.substring(0,2)),
				int.parse(str.substring(3,2)),
				int.parse(str.substring(6,2))
			);
		}
	}
	
	public class Date : Object
	{
		public Date()
		{
			months = new HashTable<string,int>(str_hash,str_equal);
			months["Jan"] = 1;
			months["Feb"] = 2;
			months["Mar"] = 3;
			months["Apr"] = 4;
			months["May"] = 5;
			months["Jun"] = 6;
			months["Jul"] = 7;
			months["Aug"] = 8;
			months["Sep"] = 9;
			months["Oct"] = 10;
			months["Nov"] = 11;
			months["Dec"] = 12;
			
			days = new HashTable<string,int>(str_hash,str_equal);
			days["Mon"] = 1;
			days["Tue"] = 2;
			days["Wed"] = 3;
			days["Thu"] = 4;
			days["Fri"] = 5;
			days["Sat"] = 6;
			days["Sun"] = 7;
		}
		public Date.now(){
			this.from_datetime(new DateTime.now_utc());
		}
		public Date.from_datetime(DateTime dt){
			this();
			year = dt.get_year();
			month = dt.get_month();
			day = dt.get_day_of_month();
			days.foreach((key,value)=>{
				if(value == dt.get_day_of_week())day_of_week = key;
			});
			time = {dt.get_hour(),dt.get_minute(),dt.get_second()};
		}
		public Date.iso(string iso_date)
		{
			this();
			parse_iso_date(iso_date);
		}
		public Date.pub(string pub_date) throws Mee.Error
		{
			this();
			string[] t = pub_date.split(" ");
			if(t.length != 6){
				var e = new Error.Length("pub_date doesn't appear to be a valid date");
				error_occured(e);
				throw e;
			}
			t[5].replace("GMT","+0000");
			parse_iso_date("%s-%.2d-%sT%s%s:%s".printf(t[3],months[t[2]],t[1],t[4],t[5].substring(0,3),t[5].substring(3,2)));
		}
		
		void parse_iso_date(string str)
		{
			var val = TimeVal();
			val.from_iso8601(str);
			var dt = new DateTime.from_timeval_utc(val);
			year = dt.get_year();
			month = dt.get_month();
			day = dt.get_day_of_month();
			days.foreach((key,value)=>{
				if(value == dt.get_day_of_week())day_of_week = key;
			});
			time = {dt.get_hour(),dt.get_minute(),dt.get_second()};
		}
		
		public int year {get;set;}
		public int month {get;set;}
		public int day {get;set;}
		public Time time {get;set;}
		public string day_of_week {get; private set;}
		public HashTable<string,int> months {get;private set;}
		public HashTable<string,int> days {get;private set;}
		
		public DateTime to_datetime(){
			var tv = TimeVal();
			tv.from_iso8601(to_iso_string());
			return new DateTime.from_timeval_utc(tv);
		}
		public string to_string(){
			string m = "";
			months.foreach((key,value)=>{
				if(value == month)m = key;
			});
			return "%s, %.2d %s %d %s +0000".printf(day_of_week,day,m,year,time.to_string());
		}
		public string to_iso_string(){
			return "%d-%.2d-%.2dT%s+00:00".printf(year,month,day,time.to_string());
		}
	}
}
