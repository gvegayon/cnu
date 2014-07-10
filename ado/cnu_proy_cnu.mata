mata:
real colvector function cnu_proy_cnu(
	real scalar x,              // Edad del afiliado
	real scalar y,              // Edad del conyuge
	real scalar cotmujer,       // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b)
	string scalar tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar agnovec,        // Agno del vector
	real scalar norp,           // 1 si no corresponde a RP
	real colvector rp,          // Tasa RP a utilizar
	real colvector rv,          // Tasa RV a utilizar
	real scalar agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef, // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual,     // Agno actual (de calculo)
	real scalar fsiniestro,     // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar stepprint,
	string scalar path_tm,      // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
	) {

	// Proyectando CNU
	real colvector cnu, xs, agnosa
	real scalar n
	
	xs     = x::110
	n      = length(xs)
	agnosa = agnoactual::(agnoactual + n-1)
		
	cnu = cnu_2_1_vec(
		xs, J(n,1,cotmujer), J(n,1,tipo_tm_cot), J(n,1,agnovec), norp, rv, rp,
		J(n,1,agnotabla), agnosa,J(n,1,fsiniestro), J(n,1,1), stepprint,
		path_tm, path_v
		)

	// Si es que tiene conyuge
	if (y != .) 
	{
		real colvector ys
		ys  = y::(y+n-1)
			
		cnu = cnu + editmissing(cnu_2_2_vec(
				xs, ys, J(n,1,cotmujer), J(n,1,conymujer),
				J(n,1,tipo_tm_cot), J(n,1,tipo_tm_cony),
				J(n,1,agnovec), norp, rv, rp,
				J(n,1,agnotabla), J(n,1,agnotablabenef),
				agnosa,J(n,1,fsiniestro), J(n,1,1), path_tm, path_v
			),0)
		
	}			
	return(cnu)
	
}
end
