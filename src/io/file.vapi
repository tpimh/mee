namespace Mee.IO
{
	[CCode (cname = "fread", cheader_filename = "stdio.h")]
	public size_t fread ([CCode (array_length_pos = 2.1)] uint8[] buf, size_t size, Posix.FILE file);
	[CCode (cname = "fwrite", cheader_filename = "stdio.h")]
	public size_t fwrite ([CCode (array_length_pos = 2.1)] uint8[] buf, size_t size, Posix.FILE file);
}
