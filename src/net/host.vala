namespace Mee.Net
{
	public class Host : GLib.Object
	{
		public Host (string domain)
		{
			Object (domain: domain);
		}
		
		construct {
			var v4l = new Gee.ArrayList<IPV4Address> ();
			var v6l = new Gee.ArrayList<IPV6Address> ();
			AddressInfo[] infos = null;
			try{
				ipv6_supported = true;
				infos = AddressInfo.get_infos (domain, AddressFamily.IPV6);
				foreach(var info in infos)
					v6l.add (new IPV6Address.info (info));
			}catch {
				ipv6_supported = false;
			}
			infos = AddressInfo.get_infos (domain, AddressFamily.IPV4);
			foreach(var info in infos)
				v4l.add (new IPV4Address.info (info));
			var map4 = new Gee.HashMap<string,IPV4Address> ();
			foreach(var addr in v4l)
				map4[addr.ip] = addr;
			ipv4_addresses = map4.values.to_array ();
			var map6 = new Gee.HashMap<string,IPV6Address> ();
			foreach(var addr in v6l)
				map6[addr.ip] = addr;
			ipv6_addresses = map6.values.to_array ();
		}
		
		public IPV4Address[] ipv4_addresses { get; private set; }
		public IPV6Address[] ipv6_addresses { get; private set; }
		
		public string domain { get; construct; }
		
		public bool ipv6_supported { get; private set; }
	}
}
