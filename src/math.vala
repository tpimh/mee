namespace Mee
{
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
