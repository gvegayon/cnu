
cap mata mata drop cnu_proy_pens()
mata:
real matrix function cnu_proy_pens(
	real scalar x,              // Edad del afiliado
	real scalar y,              // Edad del conyuge
	real scalar cotmujer,       // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b)
	string scalar tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar saldoi,         // Saldo al momento del retiro
	real scalar agnovec,        // Agno del vector
	real scalar rp,             // Tasa RP a utilizar
	real scalar agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef, // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual,     // Agno actual (de calculo)
	real scalar fsiniestro,     // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar confaj,         // Si es con factor de ajuste o no
	real scalar edadm,          // (FAJ) Edad max 
	real scalar pcent,          // (FAJ) Porcentaje a cubrir 
	real scalar rp0,            // (FAJ) Pension de referencia (puede autocalcularse) 
	real scalar criter,         // (FAJ) Criterio de convergencia
	real scalar maxiter,        // (FAJ) Max num de iteraciones
	real scalar stepprint,
	string scalar path_tm,      // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
) {

	real colvector cnu, pens
	real matrix vec
	real scalar i, N, tasa
	
	N = 110 - x + 1
	
	// Calculando CNU que se utilizara
	cnu = cnu_proy_cnu(x,y,cotmujer,conymujer,tipo_tm_cot,
			tipo_tm_cony, agnovec, 0, J(191,1,rp), J(191,1,-1e100), agnotabla,
			agnotablabenef, agnoactual, fsiniestro, 0, path_tm, path_v)

	if (rp != -1e100) vec = ((1::191), J(191,1,rp))
	else vec = cnu_get_vec_tasas(agnovec, path_v)
	
	real colvector saldo
	
	// Pension sin factor de ajuste
	if (!confaj) 
	{
		pens  = J(N,1,.)
		saldo = J(N,1,.)
		
		pens[1]  = saldoi/cnu[1]
		saldo[1] = (saldoi - pens[1])*(1+vec[1,2])
		for(i=2;i<=N;i++)
		{
			pens[i]  = saldo[i-1]/cnu[i]
			saldo[i] = max(
				(0,(saldo[i-1] - pens[i])*(1+vec[i,2]))
				)
		}
		return((saldo,pens))
	}
	// Pension con factor de ajuste
	else
	{
		real scalar faj, fajactivo, pensfaj, saldofaj
		
		// Calculando FAJ
		faj = cnu_faj(x, cnu, vec[,2], edadm, saldoi, pcent, rp0,
			criter, maxiter)
		
		// Iniciando simulacion
		pens      = J(N,1,.)
		pensfaj   = pcent*saldoi/cnu[1]
		saldofaj  = J(N,1,0)
		fajactivo = 0
		saldo     = J(N,1,.)
		
		pens[1]     = pensfaj/pcent*(1-faj)
		saldo[1]    = (saldoi - pens[1] - pens[1]/(1-faj)*faj)*(1+vec[1,2])
		saldofaj[1] = pens[1]/(1-faj)*faj*(1+vec[1,2])
		for(i=2;i<=N;i++)
		{
			// Si faj no esta activo
			if (!fajactivo)
			{
				pens[i] = saldo[i-1]/cnu[i]*(1-faj)
			
				// Si es que la pension sigue siendo superior que la pension
				// FAJ. entonces entrar. De lo contrario, se activa la pension
				// FAJ y deja de entrar a este nivel.
				if (pens[i] > pensfaj)
				{
					saldofaj[i] = (saldofaj[i-1] + saldo[i-1]/cnu[i]*faj)*(1+vec[i,2])
					saldo[i]    = (saldo[i-1] - saldo[i-1]/cnu[i])*(1+vec[i,2])
					continue
				}
											
				fajactivo   = 1
				
			}

			// Calculando pension y saldos segun FAJ
			if ( (saldofaj[i-1] - (pensfaj-saldo[i-1]/cnu[i])) < 0) 
			{
				pens[i]  = saldo[i-1]/cnu[i]
				saldo[i] = (saldo[i-1] - saldo[i-1]/cnu[i])*(1+vec[i,2])
				continue
			}

			pens[i]     = pensfaj
			saldo[i]    = (saldo[i-1] - saldo[i-1]/cnu[i])*(1+vec[i,2])
			saldofaj[i] = (saldofaj[i-1] - (pensfaj-saldo[i-1]/cnu[i]))*(1+vec[i,2])

		}
		return((saldo,J(N,1,faj),saldofaj,pens))
	}
	
}

x=cnu_proy_pens(65,.,0,.,"rv","mi",1,2013,.03,2009,2006,2014,0,0)

y=cnu_proy_pens(65,.,0,.,"rv","mi",1,2013,.03,2009,2006,2014,0,1)
x
y
end
