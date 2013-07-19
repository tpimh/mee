using Mee.Collections;

namespace Mee.Functions{
		public static CompareFunc get_compare_func_for (Type t) {
			if (t == typeof (string)) {
				return (a, b) => {
					if (a == b)
						return 0;
					else if (a == null)
						return -1;
					else if (b == null)
						return 1;
					else
						return strcmp((string) a, (string) b);
				};
			} else if (t.is_a (typeof (Comparable))) {
				return (a, b) => {
					if (a == b)
						return 0;
					else if (a == null)
						return -1;
					else if (b == null)
						return 1;
					else
						return ((Comparable<Comparable>) a).compare ((Comparable) b);
				};
			} else {
				return (_val1, _val2) => {
					long val1 = (long)_val1, val2 = (long)_val2;
					if (val1 > val2) {
						return 1;
					} else if (val1 == val2) {
						return 0;
					} else {
						return -1;
					}
				};
			}
		}
}
