namespace Mee
{
	public errordomain Error
	{
		Null,
		Content,
		Length,
		Type,
		Start,
		End
	}
	
	public class Object : GLib.Object
	{
		public signal void error_occured(Mee.Error e);		
	}
}
