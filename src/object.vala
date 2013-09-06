using Posix;

namespace Mee
{
	public errordomain Error
	{
		Null,
		Content,
		Length,
		Type,
		Start,
		End,
		Malformed
	}
	
	public struct JoystickEvent
	{
		public uint32 time;
		public int16 value;
		public uint8 type;
		public uint8 number;
	}
	
	public enum JoyType
	{
		Button = 0x01,
		Axe    = 0x02,
		Init   = 0x80
	}
	
	public class Object : GLib.Object
	{
		int fd1;
		
		public Object(){
			
		}
		
		public signal void error_occured(Mee.Error e);	
		public signal void modified(string property,void *data);	
		public signal void joystick_connected(bool is_co);
		public signal void joystick_state_changed(JoystickEvent event);
		public signal void joystick_axe_moved_event(JoystickEvent event);
		public signal void joystick_button_pressed_event(JoystickEvent event);
	}
}
