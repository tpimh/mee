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
			fd1 = -1;
			JoystickEvent je1 = JoystickEvent();
			Timeout.add(100,()=>{
				read(fd1,&je1,sizeof(JoystickEvent));
				var i = open("/dev/input/js0",O_RDONLY);
				if(i == -1) { fd1 = -1; joystick_connected(false); }
				else if(fd1 == -1){
					fd1 = Posix.open("/dev/input/js0",O_RDONLY);
					fcntl(fd1,F_SETFL,O_NONBLOCK);
					joystick_connected(true);
				}
				
				joystick_state_changed(je1);
				if(je1.type == JoyType.Axe)
					joystick_axe_moved_event(je1);
				else if(je1.type == JoyType.Button)
					joystick_button_pressed_event(je1);
				return true;
			});
		}
		
		public signal void error_occured(Mee.Error e);	
		public signal void modified(string property,void *data);	
		public signal void joystick_connected(bool is_co);
		public signal void joystick_state_changed(JoystickEvent event);
		public signal void joystick_axe_moved_event(JoystickEvent event);
		public signal void joystick_button_pressed_event(JoystickEvent event);
	}
}
