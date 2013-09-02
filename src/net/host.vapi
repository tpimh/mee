namespace Posix
{
	[SimpleType]
	[CCode(cname = "struct hostent", cheader_filename = "netdb.h", destroy_function = "")]
	public struct Host
	{
		[CCode(cname = "gethostbyname", cheader_filename = "netdb.h")]
		public static Host *by_name(string name);
		
		public string h_name;
		[CCode(array_length = false)]
		public string[] h_aliases;        
		public int    h_addrtype;        
		public int    h_length;    
		public InAddr** h_addr_list;
	}
}
