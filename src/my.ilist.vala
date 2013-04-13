namespace My
{
	public abstract class IList<G> : GLib.Object
	{
		public abstract int size{get;}
		public abstract G @get(int index);
		public abstract void @set(int index, G val);
		public abstract void add(G item);
		public abstract void add_range(G[] items);
		public abstract void add_collection(IList<G> coll);
		public abstract bool contains(G item);
		public abstract void insert(int position, G item);
		public abstract void insert_all(int position, G[] items);
		public abstract void insert_collection(int position, IList<G> coll);
		public abstract void reverse();
		public abstract int index_of(G item);
		public abstract int[] index_of_all(G item);
		public abstract void remove(G item);
		public abstract void remove_at(int index);
		public abstract void remove_all(G item);
		public abstract void remove_range(int start, int length);
		public virtual G[] to_array () {
		var t = typeof (G);
		if (t == typeof (bool)) {
			return (G[]) to_bool_array((IList<bool>) this);
		} else if (t == typeof (char)) {
			return (G[]) to_char_array((IList<char>) this);
		} else if (t == typeof (uchar)) {
			return (G[]) to_uchar_array((IList<uchar>) this);
		} else if (t == typeof (int)) {
			return (G[]) to_int_array((IList<int>) this);
		} else if (t == typeof (uint)) {
			return (G[]) to_uint_array((IList<uint>) this);
		}  else if (t == typeof (int64)) {
			return (G[]) to_int64_array((IList<int64>) this);
		} else if (t == typeof (uint64)) {
			return (G[]) to_uint64_array((IList<uint64>) this);
		} else if (t == typeof (long)) {
			return (G[]) to_long_array((IList<long>) this);
		} else if (t == typeof (ulong)) {
			return (G[]) to_ulong_array((IList<ulong>) this);
		} else if (t == typeof (float)) {
			return (G[]) to_float_array((IList<float>) this);
		} else if (t == typeof (double)) {
			return (G[]) to_double_array((IList<double>) this);
		} else {
			G[] array = new G[size];
			int index = 0;
			foreach (G element in this) {
				array[index++] = element;
			}
			return array;
		}
	}
	private static bool[] to_bool_array(IList<bool> coll) {
		bool[] array = new bool[coll.size];
		int index = 0;
		foreach (bool element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static char[] to_char_array(IList<char> coll) {
		char[] array = new char[coll.size];
		int index = 0;
		foreach (char element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uchar[] to_uchar_array(IList<uchar> coll) {
		uchar[] array = new uchar[coll.size];
		int index = 0;
		foreach (uchar element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static int[] to_int_array(IList<int> coll) {
		int[] array = new int[coll.size];
		int index = 0;
		foreach (int element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint[] to_uint_array(IList<uint> coll) {
		uint[] array = new uint[coll.size];
		int index = 0;
		foreach (uint element in coll) {
			array[index++] = element;
		}
		return array;
	}
	
	private static int64[] to_int64_array(IList<int64?> coll) {
		int64[] array = new int64[coll.size];
		int index = 0;
		foreach (int64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static uint64[] to_uint64_array(IList<uint64?> coll) {
		uint64[] array = new uint64[coll.size];
		int index = 0;
		foreach (uint64 element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static long[] to_long_array(IList<long> coll) {
		long[] array = new long[coll.size];
		int index = 0;
		foreach (long element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static ulong[] to_ulong_array(IList<ulong> coll) {
		ulong[] array = new ulong[coll.size];
		int index = 0;
		foreach (ulong element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static float[] to_float_array(IList<float?> coll) {
		float[] array = new float[coll.size];

		int index = 0;
		foreach (float element in coll) {
			array[index++] = element;
		}
		return array;
	}

	private static double[] to_double_array(IList<double?> coll) {
		double[] array = new double[coll.size];
		int index = 0;
		foreach (double element in coll) {
			array[index++] = element;
		}
		return array;
	}
	}
}
