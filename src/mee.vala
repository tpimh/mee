namespace Mee {
	public struct Duet<G>
	{
		public G left;
		public G right;
	}
	
	static string codepoint_to_string (uint64 cp) {
		uint8[] bytes = null;
		if(cp <= 0x007Ful)
		{
			bytes = new uint8[1];
			bytes[0] = (uint8)cp;
		}

		else if(cp <= 0x07FFul)
		{
			bytes = new uint8[2];
			bytes[1] = (uint8)((2 << 6) | (cp & 0x3F));
			bytes[0] = (uint8)((6 << 5) | (cp >> 6));
		}

		else if(cp <= 0xFFFFul)
		{
			bytes = new uint8[3];
			bytes[2] = (uint8)(( 2 << 6) | ( cp       & 0x3F));
			bytes[1] = (uint8)(( 2 << 6) | ((cp >> 6) & 0x3F));
			bytes[0] = (uint8)((14 << 4) |  (cp >> 12));
		}

		else if(cp <= 0x10FFFFul)
		{
			bytes = new uint8[4];
			bytes[3] = (uint8)(( 2 << 6) | ( cp        & 0x3F));
			bytes[2] = (uint8)(( 2 << 6) | ((cp >>  6) & 0x3F));
			bytes[1] = (uint8)(( 2 << 6) | ((cp >> 12) & 0x3F));
			bytes[0] = (uint8)((30 << 3) |  (cp >> 18));
		}
		
		return (string)bytes;
	}
	
	public static string escape_entities (string src, bool escape_space = false) {
		var table = new List<Duet<string>?>();
		table.append ({ "AElig;", "Æ" });
		table.append ({ "Aacute;", "Á" });
		table.append ({ "Acirc;", "Â" });
		table.append ({ "Agrave;", "À" });
		table.append ({ "Alpha;", "Α" });
		table.append ({ "Aring;", "Å" });
		table.append ({ "Atilde;", "Ã" });
		table.append ({ "Auml;", "Ä" });
		table.append ({ "Beta;", "Β" });
		table.append ({ "Ccedil;", "Ç" });
		table.append ({ "Chi;", "Χ" });
		table.append ({ "Dagger;", "‡" });
		table.append ({ "Delta;", "Δ" });
		table.append ({ "ETH;", "Ð" });
		table.append ({ "Eacute;", "É" });
		table.append ({ "Ecirc;", "Ê" });
		table.append ({ "Egrave;", "È" });
		table.append ({ "Epsilon;", "Ε" });
		table.append ({ "Eta;", "Η" });
		table.append ({ "Euml;", "Ë" });
		table.append ({ "Gamma;", "Γ" });
		table.append ({ "Iacute;", "Í" });
		table.append ({ "Icirc;", "Î" });
		table.append ({ "Igrave;", "Ì" });
		table.append ({ "Iota;", "Ι" });
		table.append ({ "Iuml;", "Ï" });
		table.append ({ "Kappa;", "Κ" });
		table.append ({ "Lambda;", "Λ" });
		table.append ({ "Mu;", "Μ" });
		table.append ({ "Ntilde;", "Ñ" });
		table.append ({ "Nu;", "Ν" });
		table.append ({ "OElig;", "Œ" });
		table.append ({ "Oacute;", "Ó" });
		table.append ({ "Ocirc;", "Ô" });
		table.append ({ "Ograve;", "Ò" });
		table.append ({ "Omega;", "Ω" });
		table.append ({ "Omicron;", "Ο" });
		table.append ({ "Oslash;", "Ø" });
		table.append ({ "Otilde;", "Õ" });
		table.append ({ "Ouml;", "Ö" });
		table.append ({ "Phi;", "Φ" });
		table.append ({ "Pi;", "Π" });
		table.append ({ "Prime;", "″" });
		table.append ({ "Psi;", "Ψ" });
		table.append ({ "Rho;", "Ρ" });
		table.append ({ "Scaron;", "Š" });
		table.append ({ "Sigma;", "Σ" });
		table.append ({ "THORN;", "Þ" });
		table.append ({ "Tau;", "Τ" });
		table.append ({ "Theta;", "Θ" });
		table.append ({ "Uacute;", "Ú" });
		table.append ({ "Ucirc;", "Û" });
		table.append ({ "Ugrave;", "Ù" });
		table.append ({ "Upsilon;", "Υ" });
		table.append ({ "Uuml;", "Ü" });
		table.append ({ "Xi;", "Ξ" });
		table.append ({ "Yacute;", "Ý" });
		table.append ({ "Yuml;", "Ÿ" });
		table.append ({ "Zeta;", "Ζ" });
		table.append ({ "aacute;", "á" });
		table.append ({ "acirc;", "â" });
		table.append ({ "acute;", "´" });
		table.append ({ "aelig;", "æ" });
		table.append ({ "agrave;", "à" });
		table.append ({ "alefsym;", "ℵ" });
		table.append ({ "alpha;", "α" });
		table.append ({ "amp;", "&" });
		table.append ({ "and;", "∧" });
		table.append ({ "ang;", "∠" });
		table.append ({ "apos;", "'" });
		table.append ({ "aring;", "å" });
		table.append ({ "asymp;", "≈" });
		table.append ({ "atilde;", "ã" });
		table.append ({ "auml;", "ä" });
		table.append ({ "bdquo;", "„" });
		table.append ({ "beta;", "β" });
		table.append ({ "brvbar;", "¦" });
		table.append ({ "bull;", "•" });
		table.append ({ "cap;", "∩" });
		table.append ({ "ccedil;", "ç" });
		table.append ({ "cedil;", "¸" });
		table.append ({ "cent;", "¢" });
		table.append ({ "chi;", "χ" });
		table.append ({ "circ;", "ˆ" });
		table.append ({ "clubs;", "♣" });
		table.append ({ "cong;", "≅" });
		table.append ({ "copy;", "©" });
		table.append ({ "crarr;", "↵" });
		table.append ({ "cup;", "∪" });
		table.append ({ "curren;", "¤" });
		table.append ({ "dArr;", "⇓" });
		table.append ({ "dagger;", "†" });
		table.append ({ "darr;", "↓" });
		table.append ({ "deg;", "°" });
		table.append ({ "delta;", "δ" });
		table.append ({ "diams;", "♦" });
		table.append ({ "divide;", "÷" });
		table.append ({ "eacute;", "é" });
		table.append ({ "ecirc;", "ê" });
		table.append ({ "egrave;", "è" });
		table.append ({ "empty;", "∅" });
		table.append ({ "emsp;", " " });
		table.append ({ "ensp;", " " });
		table.append ({ "epsilon;", "ε" });
		table.append ({ "equiv;", "≡" });
		table.append ({ "eta;", "η" });
		table.append ({ "eth;", "ð" });
		table.append ({ "euml;", "ë" });
		table.append ({ "euro;", "€" });
		table.append ({ "exist;", "∃" });
		table.append ({ "fnof;", "ƒ" });
		table.append ({ "forall;", "∀" });
		table.append ({ "frac12;", "½" });
		table.append ({ "frac14;", "¼" });
		table.append ({ "frac34;", "¾" });
		table.append ({ "frasl;", "⁄" });
		table.append ({ "gamma;", "γ" });
		table.append ({ "ge;", "≥" });
		table.append ({ "gt;", ">" });
		table.append ({ "hArr;", "⇔" });
		table.append ({ "harr;", "↔" });
		table.append ({ "hearts;", "♥" });
		table.append ({ "hellip;", "…" });
		table.append ({ "iacute;", "í" });
		table.append ({ "icirc;", "î" });
		table.append ({ "iexcl;", "¡" });
		table.append ({ "igrave;", "ì" });
		table.append ({ "image;", "ℑ" });
		table.append ({ "infin;", "∞" });
		table.append ({ "int;", "∫" });
		table.append ({ "iota;", "ι" });
		table.append ({ "iquest;", "¿" });
		table.append ({ "isin;", "∈" });
		table.append ({ "iuml;", "ï" });
		table.append ({ "kappa;", "κ" });
		table.append ({ "lArr;", "⇐" });
		table.append ({ "lambda;", "λ" });
		table.append ({ "lang;", "〈" });
		table.append ({ "laquo;", "«" });
		table.append ({ "larr;", "←" });
		table.append ({ "lceil;", "⌈" });
		table.append ({ "ldquo;", "“" });
		table.append ({ "le;", "≤" });
		table.append ({ "lfloor;", "⌊" });
		table.append ({ "lowast;", "∗" });
		table.append ({ "loz;", "◊" });
		table.append ({ "lrm;", "\xE2\x80\x8E" });
		table.append ({ "lsaquo;", "‹" });
		table.append ({ "lsquo;", "‘" });
		table.append ({ "lt;", "<" });
		table.append ({ "macr;", "¯" });
		table.append ({ "mdash;", "—" });
		table.append ({ "micro;", "µ" });
		table.append ({ "middot;", "·" });
		table.append ({ "minus;", "−" });
		table.append ({ "mu;", "μ" });
		table.append ({ "nabla;", "∇" });
		table.append ({ "nbsp;", " " });
		table.append ({ "ndash;", "–" });
		table.append ({ "ne;", "≠" });
		table.append ({ "ni;", "∋" });
		table.append ({ "not;", "¬" });
		table.append ({ "notin;", "∉" });
		table.append ({ "nsub;", "⊄" });
		table.append ({ "ntilde;", "ñ" });
		table.append ({ "nu;", "ν" });
		table.append ({ "oacute;", "ó" });
		table.append ({ "ocirc;", "ô" });
		table.append ({ "oelig;", "œ" });
		table.append ({ "ograve;", "ò" });
		table.append ({ "oline;", "‾" });
		table.append ({ "omega;", "ω" });
		table.append ({ "omicron;", "ο" });
		table.append ({ "oplus;", "⊕" });
		table.append ({ "or;", "∨" });
		table.append ({ "ordf;", "ª" });
		table.append ({ "ordm;", "º" });
		table.append ({ "oslash;", "ø" });
		table.append ({ "otilde;", "õ" });
		table.append ({ "otimes;", "⊗" });
		table.append ({ "ouml;", "ö" });
		table.append ({ "para;", "¶" });
		table.append ({ "part;", "∂" });
		table.append ({ "permil;", "‰" });
		table.append ({ "perp;", "⊥" });
		table.append ({ "phi;", "φ" });
		table.append ({ "pi;", "π" });
		table.append ({ "piv;", "ϖ" });
		table.append ({ "plusmn;", "±" });
		table.append ({ "pound;", "£" });
		table.append ({ "prime;", "′" });
		table.append ({ "prod;", "∏" });
		table.append ({ "prop;", "∝" });
		table.append ({ "psi;", "ψ" });
		table.append ({ "quot;", "\"" });
		table.append ({ "rArr;", "⇒" });
		table.append ({ "radic;", "√" });
		table.append ({ "rang;", "〉" });
		table.append ({ "raquo;", "»" });
		table.append ({ "rarr;", "→" });
		table.append ({ "rceil;", "⌉" });
		table.append ({ "rdquo;", "”" });
		table.append ({ "real;", "ℜ" });
		table.append ({ "reg;", "®" });
		table.append ({ "rfloor;", "⌋" });
		table.append ({ "rho;", "ρ" });
		table.append ({ "rlm;", "\xE2\x80\x8F" });
		table.append ({ "rsaquo;", "›" });
		table.append ({ "rsquo;", "’" });
		table.append ({ "sbquo;", "‚" });
		table.append ({ "scaron;", "š" });
		table.append ({ "sdot;", "⋅" });
		table.append ({ "sect;", "§" });
		table.append ({ "shy;", "\xC2\xAD" });
		table.append ({ "sigma;", "σ" });
		table.append ({ "sigmaf;", "ς" });
		table.append ({ "sim;", "∼" });
		table.append ({ "spades;", "♠" });
		table.append ({ "sub;", "⊂" });
		table.append ({ "sube;", "⊆" });
		table.append ({ "sum;", "∑" });
		table.append ({ "sup1;", "¹" });
		table.append ({ "sup2;", "²" });
		table.append ({ "sup3;", "³" });
		table.append ({ "sup;", "⊃" });
		table.append ({ "supe;", "⊇" });
		table.append ({ "szlig;", "ß" });
		table.append ({ "tau;", "τ" });
		table.append ({ "there4;", "∴" });
		table.append ({ "theta;", "θ" });
		table.append ({ "thetasym;", "ϑ" });
		table.append ({ "thinsp;", " " });
		table.append ({ "thorn;", "þ" });
		table.append ({ "tilde;", "˜" });
		table.append ({ "times;", "×" });
		table.append ({ "trade;", "™" });
		table.append ({ "uArr;", "⇑" });
		table.append ({ "uacute;", "ú" });
		table.append ({ "uarr;", "↑" });
		table.append ({ "ucirc;", "û" });
		table.append ({ "ugrave;", "ù" });
		table.append ({ "uml;", "¨" });
		table.append ({ "upsih;", "ϒ" });
		table.append ({ "upsilon;", "υ" });
		table.append ({ "uuml;", "ü" });
		table.append ({ "weierp;", "℘" });
		table.append ({ "xi;", "ξ" });
		table.append ({ "yacute;", "ý" });
		table.append ({ "yen;", "¥" });
		table.append ({ "yuml;", "ÿ" });
		table.append ({ "zeta;", "ζ" });
		table.append ({ "zwj;", "\xE2\x80\x8D" });
		table.append ({ "zwnj;", "\xE2\x80\x8C" });
		
		int pos = 0;
		string output = "";
		unichar u;
		while (true) {
			src.get_next_char (ref pos, out u);
			if (u == 0)
				break;
			bool found = false;
			foreach (var pair in table) {
				unichar v;
				int p = 0;
				pair.right.get_next_char (ref p, out v);
				if (u == v) {
					if (!u.isspace() || escape_space) {
						found = true;
						output += "&" + pair.left;
					}
				}
			}
			if (!found)
				output += u.to_string();
		}
		return output;
	}

	public static string unescape_entities (string src) {
		var table = new List<Duet<string>?>();
		table.append ({ "AElig;", "Æ" });
		table.append ({ "Aacute;", "Á" });
		table.append ({ "Acirc;", "Â" });
		table.append ({ "Agrave;", "À" });
		table.append ({ "Alpha;", "Α" });
		table.append ({ "Aring;", "Å" });
		table.append ({ "Atilde;", "Ã" });
		table.append ({ "Auml;", "Ä" });
		table.append ({ "Beta;", "Β" });
		table.append ({ "Ccedil;", "Ç" });
		table.append ({ "Chi;", "Χ" });
		table.append ({ "Dagger;", "‡" });
		table.append ({ "Delta;", "Δ" });
		table.append ({ "ETH;", "Ð" });
		table.append ({ "Eacute;", "É" });
		table.append ({ "Ecirc;", "Ê" });
		table.append ({ "Egrave;", "È" });
		table.append ({ "Epsilon;", "Ε" });
		table.append ({ "Eta;", "Η" });
		table.append ({ "Euml;", "Ë" });
		table.append ({ "Gamma;", "Γ" });
		table.append ({ "Iacute;", "Í" });
		table.append ({ "Icirc;", "Î" });
		table.append ({ "Igrave;", "Ì" });
		table.append ({ "Iota;", "Ι" });
		table.append ({ "Iuml;", "Ï" });
		table.append ({ "Kappa;", "Κ" });
		table.append ({ "Lambda;", "Λ" });
		table.append ({ "Mu;", "Μ" });
		table.append ({ "Ntilde;", "Ñ" });
		table.append ({ "Nu;", "Ν" });
		table.append ({ "OElig;", "Œ" });
		table.append ({ "Oacute;", "Ó" });
		table.append ({ "Ocirc;", "Ô" });
		table.append ({ "Ograve;", "Ò" });
		table.append ({ "Omega;", "Ω" });
		table.append ({ "Omicron;", "Ο" });
		table.append ({ "Oslash;", "Ø" });
		table.append ({ "Otilde;", "Õ" });
		table.append ({ "Ouml;", "Ö" });
		table.append ({ "Phi;", "Φ" });
		table.append ({ "Pi;", "Π" });
		table.append ({ "Prime;", "″" });
		table.append ({ "Psi;", "Ψ" });
		table.append ({ "Rho;", "Ρ" });
		table.append ({ "Scaron;", "Š" });
		table.append ({ "Sigma;", "Σ" });
		table.append ({ "THORN;", "Þ" });
		table.append ({ "Tau;", "Τ" });
		table.append ({ "Theta;", "Θ" });
		table.append ({ "Uacute;", "Ú" });
		table.append ({ "Ucirc;", "Û" });
		table.append ({ "Ugrave;", "Ù" });
		table.append ({ "Upsilon;", "Υ" });
		table.append ({ "Uuml;", "Ü" });
		table.append ({ "Xi;", "Ξ" });
		table.append ({ "Yacute;", "Ý" });
		table.append ({ "Yuml;", "Ÿ" });
		table.append ({ "Zeta;", "Ζ" });
		table.append ({ "aacute;", "á" });
		table.append ({ "acirc;", "â" });
		table.append ({ "acute;", "´" });
		table.append ({ "aelig;", "æ" });
		table.append ({ "agrave;", "à" });
		table.append ({ "alefsym;", "ℵ" });
		table.append ({ "alpha;", "α" });
		table.append ({ "amp;", "&" });
		table.append ({ "and;", "∧" });
		table.append ({ "ang;", "∠" });
		table.append ({ "apos;", "'" });
		table.append ({ "aring;", "å" });
		table.append ({ "asymp;", "≈" });
		table.append ({ "atilde;", "ã" });
		table.append ({ "auml;", "ä" });
		table.append ({ "bdquo;", "„" });
		table.append ({ "beta;", "β" });
		table.append ({ "brvbar;", "¦" });
		table.append ({ "bull;", "•" });
		table.append ({ "cap;", "∩" });
		table.append ({ "ccedil;", "ç" });
		table.append ({ "cedil;", "¸" });
		table.append ({ "cent;", "¢" });
		table.append ({ "chi;", "χ" });
		table.append ({ "circ;", "ˆ" });
		table.append ({ "clubs;", "♣" });
		table.append ({ "cong;", "≅" });
		table.append ({ "copy;", "©" });
		table.append ({ "crarr;", "↵" });
		table.append ({ "cup;", "∪" });
		table.append ({ "curren;", "¤" });
		table.append ({ "dArr;", "⇓" });
		table.append ({ "dagger;", "†" });
		table.append ({ "darr;", "↓" });
		table.append ({ "deg;", "°" });
		table.append ({ "delta;", "δ" });
		table.append ({ "diams;", "♦" });
		table.append ({ "divide;", "÷" });
		table.append ({ "eacute;", "é" });
		table.append ({ "ecirc;", "ê" });
		table.append ({ "egrave;", "è" });
		table.append ({ "empty;", "∅" });
		table.append ({ "emsp;", " " });
		table.append ({ "ensp;", " " });
		table.append ({ "epsilon;", "ε" });
		table.append ({ "equiv;", "≡" });
		table.append ({ "eta;", "η" });
		table.append ({ "eth;", "ð" });
		table.append ({ "euml;", "ë" });
		table.append ({ "euro;", "€" });
		table.append ({ "exist;", "∃" });
		table.append ({ "fnof;", "ƒ" });
		table.append ({ "forall;", "∀" });
		table.append ({ "frac12;", "½" });
		table.append ({ "frac14;", "¼" });
		table.append ({ "frac34;", "¾" });
		table.append ({ "frasl;", "⁄" });
		table.append ({ "gamma;", "γ" });
		table.append ({ "ge;", "≥" });
		table.append ({ "gt;", ">" });
		table.append ({ "hArr;", "⇔" });
		table.append ({ "harr;", "↔" });
		table.append ({ "hearts;", "♥" });
		table.append ({ "hellip;", "…" });
		table.append ({ "iacute;", "í" });
		table.append ({ "icirc;", "î" });
		table.append ({ "iexcl;", "¡" });
		table.append ({ "igrave;", "ì" });
		table.append ({ "image;", "ℑ" });
		table.append ({ "infin;", "∞" });
		table.append ({ "int;", "∫" });
		table.append ({ "iota;", "ι" });
		table.append ({ "iquest;", "¿" });
		table.append ({ "isin;", "∈" });
		table.append ({ "iuml;", "ï" });
		table.append ({ "kappa;", "κ" });
		table.append ({ "lArr;", "⇐" });
		table.append ({ "lambda;", "λ" });
		table.append ({ "lang;", "〈" });
		table.append ({ "laquo;", "«" });
		table.append ({ "larr;", "←" });
		table.append ({ "lceil;", "⌈" });
		table.append ({ "ldquo;", "“" });
		table.append ({ "le;", "≤" });
		table.append ({ "lfloor;", "⌊" });
		table.append ({ "lowast;", "∗" });
		table.append ({ "loz;", "◊" });
		table.append ({ "lrm;", "\xE2\x80\x8E" });
		table.append ({ "lsaquo;", "‹" });
		table.append ({ "lsquo;", "‘" });
		table.append ({ "lt;", "<" });
		table.append ({ "macr;", "¯" });
		table.append ({ "mdash;", "—" });
		table.append ({ "micro;", "µ" });
		table.append ({ "middot;", "·" });
		table.append ({ "minus;", "−" });
		table.append ({ "mu;", "μ" });
		table.append ({ "nabla;", "∇" });
		table.append ({ "nbsp;", " " });
		table.append ({ "ndash;", "–" });
		table.append ({ "ne;", "≠" });
		table.append ({ "ni;", "∋" });
		table.append ({ "not;", "¬" });
		table.append ({ "notin;", "∉" });
		table.append ({ "nsub;", "⊄" });
		table.append ({ "ntilde;", "ñ" });
		table.append ({ "nu;", "ν" });
		table.append ({ "oacute;", "ó" });
		table.append ({ "ocirc;", "ô" });
		table.append ({ "oelig;", "œ" });
		table.append ({ "ograve;", "ò" });
		table.append ({ "oline;", "‾" });
		table.append ({ "omega;", "ω" });
		table.append ({ "omicron;", "ο" });
		table.append ({ "oplus;", "⊕" });
		table.append ({ "or;", "∨" });
		table.append ({ "ordf;", "ª" });
		table.append ({ "ordm;", "º" });
		table.append ({ "oslash;", "ø" });
		table.append ({ "otilde;", "õ" });
		table.append ({ "otimes;", "⊗" });
		table.append ({ "ouml;", "ö" });
		table.append ({ "para;", "¶" });
		table.append ({ "part;", "∂" });
		table.append ({ "permil;", "‰" });
		table.append ({ "perp;", "⊥" });
		table.append ({ "phi;", "φ" });
		table.append ({ "pi;", "π" });
		table.append ({ "piv;", "ϖ" });
		table.append ({ "plusmn;", "±" });
		table.append ({ "pound;", "£" });
		table.append ({ "prime;", "′" });
		table.append ({ "prod;", "∏" });
		table.append ({ "prop;", "∝" });
		table.append ({ "psi;", "ψ" });
		table.append ({ "quot;", "\"" });
		table.append ({ "rArr;", "⇒" });
		table.append ({ "radic;", "√" });
		table.append ({ "rang;", "〉" });
		table.append ({ "raquo;", "»" });
		table.append ({ "rarr;", "→" });
		table.append ({ "rceil;", "⌉" });
		table.append ({ "rdquo;", "”" });
		table.append ({ "real;", "ℜ" });
		table.append ({ "reg;", "®" });
		table.append ({ "rfloor;", "⌋" });
		table.append ({ "rho;", "ρ" });
		table.append ({ "rlm;", "\xE2\x80\x8F" });
		table.append ({ "rsaquo;", "›" });
		table.append ({ "rsquo;", "’" });
		table.append ({ "sbquo;", "‚" });
		table.append ({ "scaron;", "š" });
		table.append ({ "sdot;", "⋅" });
		table.append ({ "sect;", "§" });
		table.append ({ "shy;", "\xC2\xAD" });
		table.append ({ "sigma;", "σ" });
		table.append ({ "sigmaf;", "ς" });
		table.append ({ "sim;", "∼" });
		table.append ({ "spades;", "♠" });
		table.append ({ "sub;", "⊂" });
		table.append ({ "sube;", "⊆" });
		table.append ({ "sum;", "∑" });
		table.append ({ "sup1;", "¹" });
		table.append ({ "sup2;", "²" });
		table.append ({ "sup3;", "³" });
		table.append ({ "sup;", "⊃" });
		table.append ({ "supe;", "⊇" });
		table.append ({ "szlig;", "ß" });
		table.append ({ "tau;", "τ" });
		table.append ({ "there4;", "∴" });
		table.append ({ "theta;", "θ" });
		table.append ({ "thetasym;", "ϑ" });
		table.append ({ "thinsp;", " " });
		table.append ({ "thorn;", "þ" });
		table.append ({ "tilde;", "˜" });
		table.append ({ "times;", "×" });
		table.append ({ "trade;", "™" });
		table.append ({ "uArr;", "⇑" });
		table.append ({ "uacute;", "ú" });
		table.append ({ "uarr;", "↑" });
		table.append ({ "ucirc;", "û" });
		table.append ({ "ugrave;", "ù" });
		table.append ({ "uml;", "¨" });
		table.append ({ "upsih;", "ϒ" });
		table.append ({ "upsilon;", "υ" });
		table.append ({ "uuml;", "ü" });
		table.append ({ "weierp;", "℘" });
		table.append ({ "xi;", "ξ" });
		table.append ({ "yacute;", "ý" });
		table.append ({ "yen;", "¥" });
		table.append ({ "yuml;", "ÿ" });
		table.append ({ "zeta;", "ζ" });
		table.append ({ "zwj;", "\xE2\x80\x8D" });
		table.append ({ "zwnj;", "\xE2\x80\x8C" });

		string output = "";
		int old = 0;
		int pos = src.index_of ("&");
		while (pos != -1) {
			output += src.substring (old, pos - old);
			int c = src.index_of_char (';', pos);
			if (c == -1) {
				print ("failed to parse entity: %s\n", src.substring (pos));
				output += src.substring (pos);
				return output;
			}
			// pos: 3, c: 7
			string entity = src.substring (pos + 1, c - pos);
			string dec = "";
			if (entity[0] == '#') {
				entity = entity.substring (1);
				if (entity[0] == 'x')
					entity = "0" + entity;
				entity = entity.substring (0, entity.length - 1);
				dec = codepoint_to_string (uint64.parse (entity));
			}
			else
				foreach (var pair in table) {
					if (pair.left == entity)
						dec = pair.right;
				}
			output += dec;
			old = c + 1;
			pos = src.index_of ("&", c);
		}
		output += src.substring (old, pos - old);
		return output;
	}

	
	public static GenericSet<string> get_insensitive_cases (string[] data) {
		var gset = new GenericSet<string> (str_hash, str_equal);
		foreach (string str in data)
			get_insensitive_case (str).foreach (s => {
				gset.add (s);
			});
		return gset;
	}

	public static GenericSet<string> get_insensitive_case (string data) {
		var gset = new GenericSet<string> (str_hash, str_equal);
		if (data.length == 0)
			return gset;
		if (data.length == 1) {
			gset.add (data.down());
			gset.add (data.up());
		} else {
			get_insensitive_case (data.substring (1)).foreach (sub => {
				gset.add (data[0].to_string().down() + sub);
				gset.add (data[0].to_string().up() + sub);
			});
		}
		return gset;
	}
}
