namespace Mee.Net
{
	public enum SocketType
	{
		NULL,
		STREAM,
		DGRAM,
		RAW,
		RDRAM,
		SEQPACKET
	}
	
	public enum SocketOptions
	{
		Reception,
		Transmission,
		Both
	}
	
	public class Socket : GLib.Object
	{
		size_t size;
		
		public Socket (AddressFamily family = Mee.Net.AddressFamily.IPV4, SocketType stype = Mee.Net.SocketType.STREAM){
			Object (address_family: family, socket_type: stype);
		}
		
		construct {
			descriptor = Posix.socket (address_family, socket_type, 0);
			size = address_family == AddressFamily.IPV6 ? sizeof(Posix.SockAddrIn6) : sizeof(Posix.SockAddrIn);
		}
		
		public int accept (out Address address){
			if(address_family == AddressFamily.IPV6){
				var addr = new IPV6Address ();
				address = addr;
				return Posix.accept (descriptor, &addr.addr, &size);
			}
			var addr = new IPV4Address ();
			address = addr;
			return Posix.accept (descriptor, &addr.addr, &size);
		}
		
		public int close(SocketOptions options = Mee.Net.SocketOptions.Both){
			return Posix.shutdown(descriptor,(int)options);
		}
		
		public int connect_ipv4_address (IPV4Address addr){
			return Posix.connect(descriptor,&addr.addr,size);
		}
		
		public int connect_ipv6_address (IPV6Address addr){
			return Posix.connect(descriptor,&addr.addr,size);
		}
		
		public int bind(Address address){
			if (address.family == AddressFamily.IPV6)
				return Posix.bind(descriptor,&(address as IPV6Address).addr,size);
			return Posix.bind(descriptor,&(address as IPV4Address).addr,size);
		}
		
		public int listen(int log = 0){
			return Posix.listen(descriptor,log);
		}
		
		public SocketType socket_type { get; construct; }
		public AddressFamily address_family { get; construct; }
		public int descriptor { get; private set; }
	}
}
