namespace Mee {
    namespace BitConverter {
        static void put_bytes (uint8 *dest, uint8[] src, int start, int count)
        {
            for (int i = 0; i < count; i++)
                dest[i] = src[i+start];
        }
        
        static uint8[] _get_bytes (uint8 *ptr, int count)
        {
            var array = new uint8[count];
            for (var i = 0; i < count; i++)
                array[i] = ptr[i];
            return array;
        }
        
        static uint8[] get_bytes_from_double (double val)
        {
            return _get_bytes((uint8*)(&val), 8);
        }
        
        static uint8[] get_bytes_from_ulong (ulong val)
        {
            return _get_bytes((uint8*)(&val), 8);
        }
        
        static uint8[] get_bytes_from_long (long val)
        {
            return _get_bytes((uint8*)(&val), 8);
        }
        
        static uint8[] get_bytes_from_uint (uint val)
        {
            return _get_bytes((uint8*)(&val), 4);
        }
        
        static uint8[] get_bytes_from_int (int val)
        {
            return _get_bytes((uint8*)(&val), 4);
        }
        
        static uint8[] get_bytes_from_ushort (ushort val)
        {
            return _get_bytes((uint8*)(&val), 2);
        }
        
        static uint8[] get_bytes_from_short (short val)
        {
            return _get_bytes((uint8*)(&val), 2);
        }
        
        static uint8[] get_bytes_from_char (char val)
        {
            return _get_bytes((uint8*)(&val), 2);
        }
        
        static uint8[] get_bytes_from_bool (bool val)
        {
            return _get_bytes((uint8*)(&val), 1);
        }
       
        static uint8[] get_bytes_from_float (float val)
        {
            return _get_bytes((uint8*)(&val), 4);
        }
        
        public static uint8[]? get_bytes<T> (T item)
        {
            if (typeof(T) == typeof(double?))
                return get_bytes_from_double ((double?)item);
            if (typeof(T) == typeof(float?))
                return get_bytes_from_float ((float?)item);
            if (typeof(T) == typeof(int64))
                return get_bytes_from_long ((long)item);
            if (typeof(T) == typeof(uint64))
                return get_bytes_from_ulong ((ulong)item);
            if (typeof(T) == typeof(long))
                return get_bytes_from_long ((long)item);
            if (typeof(T) == typeof(ulong))
                return get_bytes_from_ulong ((ulong)item);
            if (typeof(T) == typeof(int))
                return get_bytes_from_int ((int)item);
            if (typeof(T) == typeof(uint))
                return get_bytes_from_uint ((uint)item);
            if (typeof(T) == typeof(short))
                return get_bytes_from_short ((short)item);
            if (typeof(T) == typeof(ushort))
                return get_bytes_from_ushort ((ushort)item);
            if (typeof(T) == typeof(char))
                return get_bytes_from_char ((char)item);
            if (typeof(T) == typeof(bool))
                return get_bytes_from_bool ((bool)item);
            return null;
        }
        
        public static bool to_boolean (uint8[] array, int start = 0)
        {
            if (start < 0 || start >= array.length)
                return false;
            return array[start] != 0;
        }
        
        public static char to_char (uint8[] array, int start = 0)
        {
            char res = '?';
            if (array.length < 2)
                return res;
            put_bytes ((uint8*)(&res), array, start, 2);
            return res;
        }
        
        public static short to_short (uint8[] array, int start = 0)
        {
            short res = 0;
            if (array.length < 2)
                return res;
            put_bytes ((uint8*)(&res), array, start, 2);
            return res;
        }
        
        public static ushort to_ushort (uint8[] array, int start = 0)
        {
            ushort res = 0;
            if (array.length < 2)
                return res;
            put_bytes ((uint8*)(&res), array, start, 2);
            return res;
        }
        
        public static int to_int (uint8[] array, int start = 0)
        {
            int res = 0;
            if (array.length < 4)
                return res;
            put_bytes ((uint8*)(&res), array, start, 4);
            return res;
        }
        
        public static uint to_uint (uint8[] array, int start = 0)
        {
            uint res = 0;
            if (array.length < 4)
                return res;
            put_bytes ((uint8*)(&res), array, start, 4);
            return res;
        }
        
        public static long to_long (uint8[] array, int start = 0)
        {
            long res = 0;
            if (array.length < 8)
                return res;
            put_bytes ((uint8*)(&res), array, start, 8);
            return res;
        }
        
        public static ulong to_ulong (uint8[] array, int start = 0)
        {
            ulong res = 0;
            if (array.length < 8)
                return res;
            put_bytes ((uint8*)(&res), array, start, 8);
            return res;
        }
        
        public static double to_double (uint8[] array, int start = 0)
        {
            double res = 0;
            if (array.length < 8)
                return res;
            put_bytes ((uint8*)(&res), array, start, 8);
            return res;
        }
        
        public static float to_float (uint8[] array, int start = 0)
        {
            float res = 0;
            if (array.length < 4)
                return res;
            put_bytes ((uint8*)(&res), array, start, 4);
            return res;
        }
    }
}
