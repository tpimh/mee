using Soup;

namespace My
{
	namespace IO
	{
		public errordomain Error
		{
			Null
		}
		
		public static void download_file(string uri, string dest_file) throws IO.Error
		{
			if(dest_file == null)throw new IO.Error.Null("name of destination cannot be null");
			uint8[] data = download_data(uri);
			if(data.length < 1)throw new IO.Error.Null("data length is too short or null");
			FileUtils.set_data(dest_file,data);
		}
		
		public static uint8[] download_data(string uri){
			var session = new SessionSync();
			var message = new Message("GET",uri);
			session.send_message(message);
			return message.response_body.data;
		}

		public static string download_string(string uri){
			return (string)download_data(uri);
		}
	}
}
