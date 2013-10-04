namespace Mee.IO
{
	namespace Path
	{
		public static string get_extension(string path){
			var array = path.split(".");
			if(array.length < 2)
				return null;
			return array[array.length-1];
		}
		public static string get_filename(string path){
			if(!path.contains("/"))
				return path;
			var array = path.split("/");	
			return array[array.length-1];
		}
		public static string get_directoryname(string path){
			if(path.index_of("/") == -1)
				return ".";
			return path.substring(0,path.last_index_of("/"));
		}
	}
}
