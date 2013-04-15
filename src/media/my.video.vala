using My;
using Soup;
using Json;

namespace My.Media
{
public static string join_list(My.List<string> list, string join)
{
    bool itag  = false;
    string s = "";
    foreach(string str in list){
        if(!str.contains("itag="))
        s += str+join;
        if(str.contains("itag=")&&itag==false){
            s += str+join;itag=true;
        }
    }
    return s;
}
    
    public class Video
    {
        protected My.List<string> _urls;
        protected string data;
        
        public My.List<string> urls{get{return _urls;}}
        
        public Video()
        {
            _urls = new My.List<string>();
        }
        
        public Video.from_url(string url)
        {
            this();
            data = My.IO.download_string(url);
        }
    }
    
    public class Youtube : Video
    {
		public Youtube(string url){
			string[] prms = url.split_set("?&");
			foreach(string p in prms){
				string[] i = p.split("=");
				if(i[0]=="v"){this.id(i[1]);break;}
			}
		}
		
        public Youtube.id(string id)
        {
            base.from_url("http://www.youtube.com/get_video_info?&video_id="+id);
            data = data.split("url_encoded_fmt_stream_map=",0)[1].split("&")[0];
            data = data.replace("%253A",":")
                    .replace("%25253A","%3A")
                    .replace("%252F","/")
                    .replace("%253F","?")
                    .replace("%253D","=")
                    .replace("%3D","=")
                    .replace("%2522","\"")
                    .replace("%2526","&")
                    .replace("%26","&")
                    .replace("%2C","&")
                    .replace("%25252C","%2C")
                    .replace("&sig=","&signature=");
            int pos = data.index_of("=");
            string prm = data.substring(0,pos+1);
            string[] table = data.split(prm,100);
            for(int i=0; i<table.length; i++)
            table[i] = prm+table[i];
            My.List<string> list = new My.List<string>();
            list.add_range(table);
            list.remove(list.get(0));
            table = list.to_array();
            if(table.length>0){
                for(int z=0; z<table.length; z++){
                    My.List<string> list2 = new My.List<string>();
                    list2.add_range(table[z].split("&",100));
                    while(true){
                    list2.add(list2.get(0));
                    list2.remove(list2.get(0));
                    if(list2.get(0).contains("url="))break;
                    }
                    string s = join_list(list2,"&").replace("url=","");
                    s = s.substring(0,s.length-1);
                    if(s.has_suffix("&"))s = s.substring(0,s.length-1);
                    _urls.add(s);
                }
            }
        }
    }

    public class Dailymotion : Video
    {
        public Dailymotion(string url)
        {
            base.from_url(url);
            FileUtils.set_data("temp",data.data);
            Parser parser = new Parser();
            FileStream fs = FileStream.open("temp","r");
            string str;
            while((str = fs.read_line())!=null){
                if(str.contains("var flashvars")){
                    string[] tab = str.split(" = ",10);
                    tab[1] = tab[1].replace(";","");
                    parser.load_from_data(tab[1]);
                    break;
                }
            }
            var o = parser.get_root().get_object();
            str = Uri.unescape_string(o.get_string_member("sequence"));
            parser.load_from_data(str);
            o = parser.get_root().get_object();
            o = o.get_array_member("sequence").get_object_element(0)
            .get_array_member("layerList").get_object_element(0)
            .get_array_member("sequenceList").get_object_element(2)
            .get_array_member("layerList").get_object_element(2).get_object_member("param");
			_urls.add(o.get_string_member("ldURL"));
			_urls.add(o.get_string_member("sdURL"));
			_urls.add(o.get_string_member("hqURL"));
        }
    }
    
    public class IGN : Video
    {
        public IGN(string url){
            base.from_url(url);
            FileUtils.set_data("temp",data.data);
            FileStream fs = FileStream.open("temp","r");
            string str = "";
            string[] t = new string[]{""};
            while((str = fs.read_line())!=null){
                if(str.contains("iPadVideoSource_0")){
                    t = str.split("\"");
                    _urls.add(t[3]);
                }
                if(str.contains("videoSource_0")){
                    t = str.split("\"");
                    _urls.add(t[3]);
                }
                if(str.contains("mVideoSource_0")){
                    t = str.split("\"");
                    _urls.add(t[3]);
                }
            }
        }
    }
}
