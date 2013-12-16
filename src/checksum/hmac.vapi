namespace Mee {
[Compact]
	[CCode (cname = "GHmac", lower_case_cprefix = "g_hmac_", ref_function = "g_hmac_ref", unref_function = "g_hmac_unref")]
	public class Hmac {
		public Hmac (GLib.ChecksumType digest_type, [CCode (array_length_type = "gsize")] uint8[] key);
		public Hmac copy ();
		public void update (uint8[] data);
		public unowned string get_string ();
		
		public void get_digest ([CCode (array_length = false)] uint8[] buffer, ref size_t digest_len);
		[CCode (cname = "g_compute_hmac_for_data")]
		public static string compute_for_data (GLib.ChecksumType checksum_type, uint8[] key, uint8[] data);
		[CCode (cname = "g_compute_hmac_for_string")]
		public static string compute_for_string (GLib.ChecksumType checksum_type, uint8[] key, string str, size_t length = -1);
	}
}
