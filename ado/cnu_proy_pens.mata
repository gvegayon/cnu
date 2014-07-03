
cap mata mata drop cnu_proy_pens()
mata:
real matrix function cnu_proy_pens(
	real scalar x,              // Edad del afiliado
	real scalar y,              // Edad del conyuge
	real scalar cotmujer,       // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b)
	string scalar tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar saldoi,
	real scalar agnovec,        // Agno del vector
	real scalar rp,             // Tasa RP a utilizar
	real scalar agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef, // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual,     // Agno actual (de calculo)
	real scalar fsiniestro,     // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar confaj,         // Si es con factor de ajuste o no
	real scalar edadm,          // (FAJ) Edad max 
	real scalar pcent,          // (FAJ) Porcentaje a cubrir 
	real scalar rp0,            // (FAJ) Monto ahorrado inicial 
	real scalar criter,         // (FAJ) Criterio de convergencia
	real scalar maxiter,        // (FAJ) Max num de iteraciones
	real scalar stepprint,
	string scalar path_tm,      // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
) {

	real colvector cnu, pens
	real matrix vec
	real scalar i, N, tasa
	
	N = 110 - x 
	
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
		saldo = J(N,1,saldoi)
		for(i=1;i<=N;i++)
		{
			pens[i]  = saldo[i]/cnu[i]
			if (i==1) saldo[i] = (saldo[i] - pens[i])*(1+vec[i,2])
			else      saldo[i] = (saldo[i-1] - pens[i])*(1+vec[i,2])
		}
	}
	// Pension con factor de ajuste
	else
	{
		real scalar faj, fajactivo, pensfaj, saldofaj
		
		// Calculando FAJ
		faj = cnu_faj(x, cnu, vec[,2], edadm, saldoi, pcent, rp0,
			criter, maxiter)
		
		// Iniciando simulacion
		pens      = J(edadm-x,1,.)
		pensfaj   = pcent*saldoi/cnu[1]
		saldofaj  = J(edadm-x,1,0)
		fajactivo = 0
		saldo     = J(edadm-x,1,saldoi)
		for(i=1;i<=(edadm-x);i++)
		{
			// Si faj no esta activo
			if (!fajactivo)
			{
				pens[i] = saldo[i]/cnu[i]*(1-faj)
			
				if (pens[i] < pensfaj)
				{
					pens[i]     = pensfaj
					saldofaj[i] = 0
					saldo[i]    = saldo[i-1] + saldofaj[i-1]
					fajactivo   = 1
				}
				
			}
			
			if (!fajactivo)
			{
				if (i==1) 
				{
					saldo[i]    = (saldo[i] - pens[i] - saldo[i]/cnu[i]*faj)*(1+vec[i,2])
					saldofaj[i] = (saldo[i]/cnu[i]*faj)*(1+vec[i,2])
				}
				else
				{
					saldofaj[i] = (saldofaj[i-1] + saldo[i-1]/cnu[i]*faj)*(1+vec[i,2])
					saldo[i]    = (saldo[i-1] - pens[i] - saldo[i-1]/cnu[i]*faj)*(1+vec[i,2])
				}
			}
			else
			{
				pens[i] = pensfaj
				saldo[i] = (saldo[i-1] - pens[i])*(1+vec[i,2])
			}
		/*
		
		// Pension agno a ango
		gen saldo     = 1 in 1
		gen pension   = saldo/cnu*(1-faj) in 1
		gen saldo_faj = saldo/cnu*faj in 1
		replace saldo = (saldo - pension - saldo_f)*(1+`tasa') in 1

		local mini    = `mini'*saldo[1]/cnu[1]
		di `mini'
		local activo = 0
		// Pension con faj
forval i=2/`=c(N)' {

	quietly {
	
		// Monto de pension
		if (!`activo') {
			replace pension   = saldo[_n-1]/cnu*(1-faj) in `i'
			
			if (pension[`i'] < `mini') {
				replace pension = `mini' if _n >= `i'
				replace saldo_f = 0 if _n >= `i'
				local activo = 1
			}
		}

		// Ajuste de saldos
		if (!`activo') {
			replace saldo_faj = (saldo_faj[_n-1] + saldo[_n-1]/cnu*faj)*(1+`tasa') in `i'
			replace saldo     = (saldo[_n-1] - pension - saldo[_n-1]/cnu*faj)*(1+`tasa') in `i'
		}
		else {
			replace saldo = (saldo[_n-1] - pension + saldo_f[_n-1])*(1+`tasa') in `i'
		}

	}
	di "pens:`=pension[`i']' mini:`mini'"
}
 
		*/
		}
	
	}
	return((saldo,pens))
}

x=cnu_proy_pens(65,.,0,.,"rv","mi",1,2013,.03,2009,2006,2014,0,1)
x
end
