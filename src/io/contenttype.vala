namespace Mee.IO
{
	namespace MimeType
	{
		public static string? from_array(uint8[] data){
			var magic = new LibMagic.Magic (LibMagic.Flags.MIME_TYPE);
			magic.load ();
			return magic.buffer (data, data.length);
		}
		
		public static string? from_filename(string filename){
			var magic = new LibMagic.Magic (LibMagic.Flags.MIME_TYPE);
			magic.load ();
			return magic.file (filename);
		}
	}
}
