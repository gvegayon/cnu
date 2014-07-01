
cap mata mata drop cnu_proy_pens()
mata:
real colvector function cnu_proy_pens(
	real scalar x,              // Edad del afiliado
	real scalar y,              // Edad del conyuge
	real scalar cotmujer,       // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b)
	string scalar tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar agnovec,        // Agno del vector
	real scalar rp,             // Tasa RP a utilizar
	real scalar agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef, // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual,     // Agno actual (de calculo)
	real scalar fsiniestro,     // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar stepprint,
	string scalar path_tm,      // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
) {

	real colvector cnu, pens
	real matrix vec
	real scalar saldo, i, N, tasa
	
	N = 110 - x + 1
	
	// Calculando CNU que se utilizara
	cnu = cnu_proy_cnu(x,y,cotmujer,conymujer,tipo_tm_cot,
			tipo_tm_cony, agnovec, 0, J(191,1,rp), J(191,1,-1e100), agnotabla,
			agnotablabenef, agnoactual, fsiniestro, 0, path_tm, path_v)
			
	if (rp != -1e100) vec = ((1::191), J(191,1,rp))
	else vec = cnu_get_vec_tasas(agnovec, path_v)

			
	pens  = J(N,1,.)
	saldo = 1
	for(i=1;i<=N;i++)
	{
		pens[i] = saldo/cnu[i]
		saldo   = (saldo - pens[i])*(1+vec[i,2])
	}
	saldo
	return(pens)
}

cnu_proy_pens(65,.,0,.,"rv","mi",2013,.03,2009,2006,2014,0)

end
