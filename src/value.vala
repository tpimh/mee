namespace Mee
{
	public class Value : GLib.Object
	{
		static bool is_init = false;

		void init(){
			if(is_init)
				return;
			GLib.Value.register_transform_func(typeof(string),typeof(int),(vin, ref vout)=>{
				vout = GLib.Value(typeof(int));
				vout.set_int(int.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(uint),(vin, ref vout)=>{
				vout = GLib.Value(typeof(uint));
				vout.set_uint((uint)int.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(char),(vin, ref vout)=>{
				vout = GLib.Value(typeof(char));
				vout.set_char(((char*)vin.get_string())[0]);
			});
			GLib.Value.register_transform_func(typeof(string),typeof(int8),(vin, ref vout)=>{
				vout = GLib.Value(typeof(char));
				vout.set_schar ((int8)vin.get_string()[0]);
			});
			GLib.Value.register_transform_func(typeof(string),typeof(uchar),(vin, ref vout)=>{
				vout = GLib.Value(typeof(uchar));
				vout.set_uchar(vin.get_string().data[0]);
			});
			GLib.Value.register_transform_func(typeof(string),typeof(bool),(vin, ref vout)=>{
				vout = GLib.Value(typeof(bool));
				vout.set_boolean(bool.parse(vin.get_string().down()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(int64),(vin, ref vout)=>{
				vout = GLib.Value(typeof(int64));
				vout.set_int64(int64.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(uint64),(vin, ref vout)=>{
				vout = GLib.Value(typeof(uint64));
				vout.set_uint64((uint64)int64.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(long),(vin, ref vout)=>{
				vout = GLib.Value(typeof(long));
				vout.set_long(long.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(ulong),(vin, ref vout)=>{
				vout = GLib.Value(typeof(ulong));
				vout.set_ulong((ulong)long.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(double),(vin, ref vout)=>{
				vout = GLib.Value(typeof(double));
				vout.set_double(double.parse(vin.get_string()));
			});
			GLib.Value.register_transform_func(typeof(string),typeof(float),(vin, ref vout)=>{
				vout = GLib.Value(typeof(float));
				vout.set_double((float)double.parse(vin.get_string()));
			});
			is_init = true;
		}

		public Value(string val = "0"){
			Object (val: val);
		}
		public Value.from_gval(GLib.Value value){
			this();
			if(value.type() == typeof(bool))
				val = value.get_boolean().to_string();
			else if(value.type() == typeof(int))
				val = value.get_int().to_string();
			else if (value.type() == typeof (int8))
				val = value.get_schar().to_string();
			else if(value.type() == typeof(uint))
				val = value.get_uint().to_string();
			else if(value.type() == typeof(char))
				val = value.get_char().to_string();
			else if(value.type() == typeof(uchar))
				val = value.get_uchar().to_string();
			else if(value.type() == typeof(long))
				val = value.get_long().to_string();
			else if(value.type() == typeof(ulong))
				val = value.get_ulong().to_string();
			else if(value.type() == typeof(int64))
				val = value.get_int64().to_string();
			else if(value.type() == typeof(uint64))
				val = value.get_uint64().to_string();
			else if(value.type() == typeof(float))
				val = value.get_float().to_string();
			else if(value.type() == typeof(double))
				val = value.get_double().to_string();
			else if(value.type() == typeof(string))
				val = value.get_string();
			else if(value.type().is_enum()){
				EnumClass ec = (EnumClass)value.type().class_ref();
				unowned EnumValue? eval = ec.get_value(value.get_enum());
				val = eval.value_nick;
			}
			else if(value.type().is_flags()){
				FlagsClass fc = (FlagsClass)value.type().class_ref();
				unowned FlagsValue? fval = fc.get_first_value(value.get_flags());
				val = fval.value_nick;
			}
		}
		
		public bool as_bool(){
			return bool.parse (val);		
		}
		public int as_int(){
			return (int)as_int64();
		}
		public uint as_uint(){
			return (uint)as_int64();
		}
		public int64 as_int64(){
			return int64.parse (val);
		}
		public uint64 as_uint64(){
			return (uint64)as_int64();
		}
		public long as_long(){
			return (long)as_int64();
		}
		public ulong as_ulong(){
			return (ulong)as_int64();
		}
		public double as_double(){
			return double.parse (val);
		}
		public float as_float(){
			return (float)as_double();
		}
		public uchar as_uchar(){
			return val == null || val.length == 0 ? 255 : Mee.Text.Encoding.latin1.get_bytes(val)[0];
		}
		public char as_char(){
			return (char)as_uchar();
		}
		public int as_enum(Type t) throws GLib.Error
		{
			if(!t.is_enum())
				throw new MeeError.TYPE("type isn't an enum");
			EnumClass klass = (EnumClass)t.class_ref();
			unowned EnumValue? eval = klass.get_value_by_nick (val);
			return eval.value;
		}
		public int as_flags(Type t) throws GLib.Error
		{
			if(!t.is_flags())
				throw new MeeError.TYPE("type isn't flag");		
			FlagsClass klass = (FlagsClass)t.class_ref();
			unowned FlagsValue? eval = klass.get_value_by_nick (val);
			return eval.value;
		}
		
		public GLib.Value as_value(Type t){
			GLib.Value v = GLib.Value(t);
			if(t.is_enum())
				v.set_enum(as_enum(t));
			else if(t.is_flags())
				v.set_flags(as_flags(t));
			else if (t == typeof (bool))
				return as_bool();
			else if (t == typeof (char))
				return as_char();
			else if (t == typeof (int8))
				return (int8)as_char();
			else if (t == typeof (uint8))
				return as_uchar();
			else if (t == typeof (int))
				return as_int();
			else if (t == typeof (uint))
				return as_uint();
			else if (t == typeof (int64))
				return as_int64();
			else if (t == typeof (uint64))
				return as_uint64();
			else if (t == typeof (long))
				return as_long();
			else if (t == typeof (ulong))
				return as_ulong();
			else if (t == typeof (float))
				return as_float();
			else if (t == typeof (double))
				return as_double();
			else {
				var gval = GLib.Value (typeof (string));
				gval.set_string (val);
				gval.transform(ref v);
			}
			return v;
		}
		
		public uint8[] as_data(){
			return Base64.decode (val);
		}
		
		public string val { get; set construct; }
	}
}
