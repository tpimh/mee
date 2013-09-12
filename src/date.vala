using Mee.Collections;

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
			_months = new Dictionary<string,int>();
			_months["Jan"] = 1;
			_months["Feb"] = 2;
			_months["Mar"] = 3;
			_months["Apr"] = 4;
			_months["May"] = 5;
			_months["Jun"] = 6;
			_months["Jul"] = 7;
			_months["Aug"] = 8;
			_months["Sep"] = 9;
			_months["Oct"] = 10;
			_months["Nov"] = 11;
			_months["Dec"] = 12;
			
			_days = new Dictionary<string,int>();
			_days["Mon"] = 1;
			_days["Tue"] = 2;
			_days["Wed"] = 3;
			_days["Thu"] = 4;
			_days["Fri"] = 5;
			_days["Sat"] = 6;
			_days["Sun"] = 7;
		}
		public Date.now(){
			this.from_datetime(new DateTime.now_utc());
		}
		public Date.from_datetime(DateTime dt){
			this();
			year = dt.get_year();
			month = dt.get_month();
			day = dt.get_day_of_month();
			_days.foreach((key,value)=>{
				if((int)value == dt.get_day_of_week())day_of_week = (string)key;
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
			_days.foreach((key,value)=>{
				if((int)value == dt.get_day_of_week())day_of_week = (string)key;
			});
			time = {dt.get_hour(),dt.get_minute(),dt.get_second()};
		}
		
		public int year {get;set;}
		public int month {get;set;}
		public int day {get;set;}
		public Time time {get;set;}
		public string day_of_week {get; private set;}
		
		Dictionary<string,int> _months;
		Dictionary<string,int> _days;
		
		public IDictionary<string,int> months {
			owned get {
				return _months;
			}
		}
		public IDictionary<string,int> days {
			owned get {
				return _days;
			}
		}
		
		public DateTime to_datetime(){
			var tv = TimeVal();
			tv.from_iso8601(to_iso_string());
			return new DateTime.from_timeval_utc(tv);
		}
		public string to_string(){
			string m = "";
			_months.foreach((key,value)=>{
				if((int)value == month)m = (string)key;
			});
			return "%s, %.2d %s %d %s +0000".printf(day_of_week,day,m,year,time.to_string());
		}
		public string to_iso_string(){
			return "%d-%.2d-%.2dT%s+00:00".printf(year,month,day,time.to_string());
		}
	}
}
