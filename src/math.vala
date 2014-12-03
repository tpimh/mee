namespace Mee
{
	public static int64 try_parse_hex (string hex){
		string h = hex.index_of("0x") == 0 ? hex : "0x"+hex;
		int64 res;
		int64.try_parse (h, out res);
		return res;
	}
	
	public class Matrix : Object {
		internal double[,] map;
		
		construct {
			clear();
		}
		
		public static Matrix identity (int size) {
			var matrix = new Matrix.empty (size, size);
			for (var i = 0; i < size; i++)
				matrix[i,i] = 1;
			return matrix;
		}
		
		public Matrix (double[,] table) {
			this.empty (table.length[0], table.length[1]);
			map = table;
		}
		
		public Matrix.empty (int height, int width) {
			Object (width: width, height: height);
		}
		
		public Matrix? add (Matrix other) {
			if (other.width != width || other.height != height)
				return null;
			Matrix result = new Matrix.empty (height, width);
			for (var i = 0; i < width; i++)
				for (var j = 0; j < height; j++)
					result [j, i] = other[j, i] + this[j, i];
			return result;
		}
		
		public void clear() {
			map = new double[height,width];
			for (var i = 0; i < width; i++)
				for (var j = 0; j < height; j++)
					map[j, i] = 0;
		}
		
		public bool equals (GLib.Object object) {
			if (!object.get_type().is_a (typeof (Matrix)))
				return false;
			Matrix other = (Matrix)object;
			if (other.width != width || other.height != height)
				return false;
			for (var i = 0; i < width; i++)
				for (var j = 0; j < height; j++)
					if (map[j, i] != other[j, i])
						return false;
			return true;
		}
		
		public new double get (int ordered, int abscissa) {
			return map[ordered, abscissa];
		}
		
		public Matrix? multiply (Matrix other) {
			if (other.height != width)
				return null;
			Matrix result = new Matrix.empty (height, other.width);
			for (var i = 0; i < result.width; i++)
				for (var j = 0; j < result.height; j++) {
					double res = 0;
					for (var k = 0; k < width; k++)
						res += this[j, k] * other[k, i];
					result[j, i] = res;
				}
						
			return result;
		}
		
		public Matrix multiply_scalar (double val) {
			Matrix result = new Matrix.empty (height, width);
			for (var i = 0; i < result.height; i++)
				for (var j = 0; j < result.width; j++)
					result[i, j] = val * this[i, j];
			return result;
		}
		
		public new void set (int ordered, int abscissa, double val) {
			map[ordered, abscissa] = val;
		}
		
		public Matrix? substract (Matrix other) {
			if (other.width != width || other.height != height)
				return null;
			Matrix result = new Matrix.empty (height, width);
			for (var i = 0; i < width; i++)
				for (var j = 0; j < height; j++)
					result [j, i] = this[j, i] - other [j , i];
			return result;
		}
		
		public string to_string() {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < height; i++) {
				if (width == 0) {
					sb.append ("[]\n");
					continue;
				}
				sb.append_c ('[');
				for (int j = 0; j < width - 1; j++)
					sb.append ("%g, ".printf (this[i, j]));
				sb.append ("%g]\n".printf (this[i, width - 1]));
			}
			return sb.str;
		}
		
		public int height { get; construct; }
		public int width { get; construct; }
		
		public bool is_square {
			get {
				return height == width;
			}
		}
		
		public double determinant {
			get {
				double result = 0;
				if (!is_square)
					error ("isn't a square matrix.");
				if (width == 1)
					return 0;
				if (width == 2) {
					return (this[0,0] * this[1,1] - this[0,1] * this[1,0]);
				}
				for (var i = 0; i < width; i++) {
					int pos = i;
					double res = this[pos, 0];
					for (var j = 1; j < width; j++) {
						if (pos + j == width)
							pos = -j;
						res = res * this [pos + j, j];
					}
					result += res;
				}
				for (var i = 0; i < width; i++) {
					int pos = i;
					double res = this[pos, width - 1];
					pos++;
					for (var j = width - 2; j >= 0; j--) {
						if (pos == width)
							pos = 0;
						res = res * this[pos, j];
						pos++;
					}
					result -= res;
				}	
				return result;
			}
		}
	}

	
	public struct mint : int
	{
		mint dup(){ return this; }
		void free(){ delete &this; }
		
		public mint pow(mint power){
			if(power == 0)return 1;
			return this*pow(power-1);
		}
		
		public mint ppcm (mint num){
			mint a = pgcd(num);
			return this * num / a;
		}

		public mint pgcd(mint num){
			mint a; mint b;
			if(this > num){
				a = this;
				b = num;
			}else{
				a = num;
				b = this;
			}
			if(b == a-b)return b;
			return b.pgcd(a-b);
		}
	}
	
	public struct mfloat : float
	{
		mfloat dup(){ return this; }
		void free(){ delete &this; }
		
		public static bool try_parse(string str, out mfloat f = null){
			return (str.scanf("%f",&f) == 0) ? false : true;
		}	
		public static mfloat parse (string str){
			mfloat f = 0;
			try_parse(str, out f);
			return f;
		}
	}
	
	public struct mdouble : double
	{
		mdouble dup(){ return this; }
		void free(){ delete &this; }
		
		public mdouble pow(mint power){
			if(power == 0)return 1;
			return this*pow(power-1);
		}
		
		public Duet<mint> to_fraction(){
			Duet<mint> d = {0,0};
			string s = ((float)this).to_string();
			string[] t = s.split(".");
			if(s.index_of(".") == -1) t = {s,"0"};
			d.left = int.parse(s.replace(".",""));
			mint p = 10;
			d.right = (t[1] == "0") ? 1 : p.pow(t[1].length);
			return d;
		}
		
		public mdouble powd(mdouble power){
			var duet = power.to_fraction();
			return (this.root(duet.right)).pow(duet.left);
		}
		
		public mdouble root(mint power){
			mdouble val = 2;
			mdouble x = ((power-1)*val+this/val.pow(power-1))/power;
			for(var i=0; i<100; i++)
				x = ((power-1)*x+this/x.pow(power-1))/power;
			return x;
		}
		
		public mdouble rootd(mdouble power){
			var duet = power.to_fraction();
			return (this.root(duet.left)).pow(duet.right);
		}
	}
}
