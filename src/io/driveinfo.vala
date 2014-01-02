namespace Mee.IO
{
	public class DriveInfo : GLib.Object
	{
		internal DriveInfo.internal(string path, string drive_format, string mounted_path){
			Object(name: path, drive_format: drive_format, mounted_path: mounted_path);
		}
		
		internal DriveInfo.by_line(string line){
			string[] array = line.split (" ");
			Object(
				name: array[4],
				drive_format: array[6] == "-" ? array[7] : array[8],
				mounted_path: array[6] == "-" ? array[8] : array[9]
			);
		}
		
		public DriveInfo (string name) throws GLib.Error
		{
			foreach(var info in get_drives ()){
				if(info.name == name || info.label == name || info.mounted_path == name){
					this.internal (info.name, info.drive_format, info.mounted_path);
					break;
				}
			}
			if(this.name == null)
				throw new MeeError.NULL ("the drive name doesn't exist.");
		}
		
		public static DriveInfo[] get_drives (){
			string[] lines = File.read_all_lines ("/proc/self/mountinfo");
			Gee.ArrayList<DriveInfo> list = new Gee.ArrayList<DriveInfo>();
			foreach (string line in lines){
				string[] array = line.split (" ");
				list.add (new DriveInfo.by_line(line));
			}
			return list.to_array ();
		}
		
		public DriveType drive_type {
			get {
				DriveType dt;
				get_drive_type_name (name, out dt);
				return dt;
			}
		}
		public string name { get; construct; }
		public string mounted_path { get; construct; }
		public string drive_format { get; construct; }
		public ulong free_space {
			get {
				fsstat stat;
				statfs (name, out stat);
				return stat.f_bsize * (ulong)stat.f_bavail;
			}
		}
		public ulong size {
			get {
				fsstat stat;
				statfs (name, out stat);
				return stat.f_bsize * (ulong)stat.f_blocks;
			}
		}
		public ulong used_space {
			get {
				return size - free_space;
			}
		}
		public DirectoryInfo directory_info {
			owned get {
				return new DirectoryInfo(name);
			}
		}
		public string label {
			owned get {
				string[] mpa = mounted_path.split("/");
				string[] na = name.split("/");
				if(name == "/")
					return (mpa.length < 1) ? null : mpa[mpa.length - 1];
				return (na.length < 1) ? null : na[na.length - 1];
			}
		}
	}
}
