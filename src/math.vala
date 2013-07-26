namespace Mee
{
	
	public struct mint : int
{
	public mint square {
		get{
			return this * this;
		}
	}
	
	public mint cube {
		get{
			return this * square;
		}
	}
	
	public double pow(double r){
		return GLib.Math.pow((double)this,r);
	}
	
	public mint ppcm (mint num){
		int a = pgcd(num);
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
	
	internal mint dup(){
		return this;
	}
	
	internal void free(){
		delete &this;
	}
}

	
	namespace Math
	{
		public struct angle : double
		{
			internal angle dup(){
				return this;
			}
			
			internal void free(){
				delete &this;
			}
			public double to_degrees(){
				return this*180/GLib.Math.PI;
			}
			public string pi_string(){
				return "%fπ".printf(this/GLib.Math.PI);
			}
		}
		
		public struct Complex
		{
			public double real;
			public double i;
			
			public static Complex parse(string c){
				string[] t = c.split("+");
				Complex cx = {0,0};
				if(t.length == 2){
					cx.real = double.parse(t[0]);
					cx.i = double.parse(t[1].substring(0,t[1].length-1));
					if(t[1] == "i")cx.i = 1;
				}else{
					if(t[0].contains("i")){
						cx.i = double.parse(t[0].substring(0,t[0].length-1));
						if(t[0] == "i")cx.i = 1;
					}
					else cx.real = int.parse(t[0]);
				}
				return cx;
			}
			
			public double abs{
				get{
					return GLib.Math.sqrt(GLib.Math.pow(real,2)+GLib.Math.pow(i,2));
				}
			}
			public angle arg{
				get{
					return GLib.Math.acos(real / abs);
				}
			}
			public void addition(Complex c){
				real += c.real;
				i += i;
			}
			public void addition_c(double rx, double iy){
				addition({rx,iy});
			}
			public void divide(Complex c){
				multiply_c(c.real,-c.i);
				real = real / (GLib.Math.pow(c.abs,2));
				i = i / (GLib.Math.pow(c.abs,2));
			}
			public void divide_c(double rx, double iy){
				divide({rx,iy});
			}
			public void multiply(Complex c){
				var a = real*c.real - i*c.i;
				var b = real*c.i + i*c.real;
				real = a;
				i = b;
			}
			public void multiply_c(double rx, double iy){
				multiply({rx,iy});
			}
			
			public string to_string(bool exponent = false){
				if(exponent == false)
					return "%f+%si".printf(real,(i == 1)?"":i.to_string());
				else return "%fe^(%s)".printf(abs,arg.pi_string());
			}
		}
	}
}
