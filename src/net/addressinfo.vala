namespace Mee.Net
{
	public class AddressInfo : GLib.Object
	{
		internal Posix.AddrInfo *info;
		
		public AddressInfo () {
			var i = Posix.AddrInfo();
			info = &i;
		}
		
		public static AddressInfo[] get_infos (string domain, AddressFamily af, string? service = null) throws Error
		{
			Posix.AddrInfo *res;
			Posix.AddrInfo hint = Posix.AddrInfo();
			hint.ai_family = af;
			int err = Posix.getaddrinfo(domain, service, hint, out res);
			if(err == -2)
				throw new NetError.INVALID ("invalid domain");
			if(err == -8)
				throw new NetError.INVALID ("invalid service");
			if(err == -1)
				throw new NetError.INVALID ("invalid hint info");
			var list = new Gee.ArrayList<AddressInfo> ();
			while (res != null){
				var ai = new AddressInfo ();
				ai.info = res;
				list.add (ai);
				res = res->ai_next;
			}
			return list.to_array ();
		}
		
		public SocketType socket_type {
			get {
				return (SocketType)info->ai_socktype;
			}
			set {
				info->ai_socktype = value;
			}
		}
		
		public AddressFamily family {
			get {
				return (AddressFamily)info->ai_family;
			}
			set {
				info->ai_family = value;
			}
		}
		
		public int protocol {
			get { return info->ai_protocol; }
			set { info->ai_protocol = value; }
		}
	}
}
