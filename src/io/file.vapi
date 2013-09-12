namespace Mee.IO
{
	[CCode (cname = "fread", cheader_filename = "stdio.h")]
	public size_t fread (uint8[] buf, size_t size = 1, Posix.FILE file);
	[CCode (cname = "fwrite", cheader_filename = "stdio.h")]
	public size_t fwrite (uint8[] buf, size_t size = 1, Posix.FILE file);
}
