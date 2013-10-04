namespace Mee.IO
{
	[CCode (cname = "__kernel_fsid_t", cheader_filename = "sys/statfs.h", destroy_function = "")]
	public struct fsid_t
	{
		public int[] val;
	}
	
	[CCode (cname = "struct statfs", cheader_filename = "sys/statfs.h", destroy_function = "")]
	public struct fsstat
	{
		public uint f_type;
		public uint f_bsize;
		public uint f_blocks;
		public uint f_bfree;
		public uint f_bavail;
		public uint f_files;
		public uint f_ffree;
		public fsid_t f_fsid;
		public uint f_namelen;
		public uint f_frsize;
		public uint f_flags;
		public uint[] f_spare;
	}
	
	[CCode (cname = "statfs", cheader_filename = "sys/statfs.h")]
	public int statfs (string path, out fsstat stat);
}
