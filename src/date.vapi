namespace Posix
{
	
	[CCode (cname = "strftime", cheader_filename = "time.h")]
	public size_t strftime (char[] s, string format, tm *tp) ;
	[CCode (cname = "gmtime", cheader_filename = "time.h")]
	public tm *gmtime (time_t *timer);
	[CCode (cname = "localtime", cheader_filename = "time.h")]
	public tm *localtime (time_t *timer);
}
