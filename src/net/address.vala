namespace Mee.Net
{
	public enum AddressFamily
	{
		UNSPEC = 0,
		UNIX = 1,
		IPV4 = 2,
		IPV6 = 10
	}
	
	public class Address : GLib.Object
	{
		internal Address (){}
		
		public AddressFamily family { get; protected set; }
		public string ip { owned get; protected set; }
		public uint16 port { get; protected set; }
	}
	
	public class IPV4Address : Address
	{
		internal Posix.SockAddrIn addr;
		
		public IPV4Address (){
			addr = Posix.SockAddrIn ();
			addr.sin_family = Posix.AF_INET;
			family = AddressFamily.IPV4;
		}
		
		public IPV4Address.uri (Uri url) throws Error
		{
			this ();
			var host = new Host (url.domain);
			if(host.ipv4_addresses.length < 1)
				throw new NetError.NULL ("no ipv4 for this uri");
			addr.sin_addr.s_addr = Posix.inet_addr (host.ipv4_addresses[0].ip);
			addr.sin_port = Posix.htons (url.port);
			ip = host.ipv4_addresses[0].ip;
			port = addr.sin_port;
		}
		
		internal IPV4Address.info (AddressInfo ai){
			Posix.InAddr *ia = (Posix.InAddr*)malloc (sizeof(Posix.InAddr));
			ia->s_addr = ((Posix.SockAddrIn*)ai.info->ai_addr)->sin_addr.s_addr;
			uint8[] buffer = new uint8[64];
			Posix.inet_ntop (Posix.AF_INET,&(ia->s_addr),buffer);
			ip = (string)buffer;
			port = ((Posix.SockAddrIn*)ai.info->ai_addr)->sin_port;
			family = AddressFamily.IPV4;
		}
	}
	
	public class IPV6Address : Address
	{
		internal Posix.SockAddrIn6 addr;
		
		public IPV6Address (){
			addr = Posix.SockAddrIn6 ();
			addr.sin6_family = Posix.AF_INET6;
			family = AddressFamily.IPV6;
		}
		
		public IPV6Address.uri (Uri url) throws Error
		{
			this ();
			var host = new Host (url.domain);
			if(!host.ipv6_supported || host.ipv6_addresses.length < 1)
				throw new NetError.NULL ("no ipv6 for this uri");
			Posix.inet_pton (family, host.ipv6_addresses[0].ip, &addr.sin6_addr.s6_addr);
			addr.sin6_port = Posix.htons (url.port);
			ip = host.ipv6_addresses[0].ip;
			port = addr.sin6_port;
		}
		
		internal IPV6Address.info (AddressInfo ai){
			Posix.In6Addr *ia = (Posix.In6Addr*)malloc (sizeof(Posix.In6Addr));
			ia->s6_addr = ((Posix.SockAddrIn6*)ai.info->ai_addr)->sin6_addr.s6_addr;
			uint8[] buffer = new uint8[64];
			Posix.inet_ntop (Posix.AF_INET6,&(ia->s6_addr),buffer);
			ip = (string)buffer;
			port = ((Posix.SockAddrIn6*)ai.info->ai_addr)->sin6_port;
			family = AddressFamily.IPV6;
		}
	}
}
