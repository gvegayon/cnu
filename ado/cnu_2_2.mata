*! version 0.13.10.23 23oct2013
mata:

// NOMBRE     : cnu_2_2_vec
// DESCRIPCION: Calcula CNU para conyuge sin hijos (vectorial)
// RESULTADO  : CNU para conyuge sin hijos (vector)
real colvector cnu_2_2_vec(
	real colvector x,           // Edad del afiliado
	real colvector y,           // Edad del conyuge
	real colvector cotmujer,    // Vector binario (1 si el cotizante es mujer)
	real colvector conymujer,   // Vector binario (1 si el conyuge es mujer)
	string colvector tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b) para el cotizante
	string colvector tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b) para el beneficiario
	real colvector agnovec,     // Agno del vector
	real scalar norp,           // Dicotomica indicando si calcula o no RP
	real colvector rv,          // Valor de la tasa para RV
	real colvector agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real colvector agnotablabenef, // Agno de la tabla de mortalidad del beneficiario
	real colvector vagnoactual, // Agno actual (de calculo)
	real colvector vfsiniestro, // Fecha del siniestro
	real colvector touse,       // Vector binario (1 si debe calcular para la observacion)
	string scalar path_tm,
	string scalar path_v
	)
	{
		
	// Definicion de escalares
	real scalar N, s_cot, s_cony, edad_cot, edad_cony, j, vecexists
	real scalar nerr_menor_20_cot, nerr_mayor_110_cot, nerr_menor_20_cony, nerr_mayor_110_cony, nerr_vector
	string scalar err_menor_20_cot, err_mayor_110_cot, err_menor_20_cony, err_mayor_110_cony, err_vector
	real colvector cnu
	
	N = rows(x)
	cnu = J(N,1,.)
	
	err_menor_20_cot = ""
	err_menor_20_cony = ""
	err_mayor_110_cot = ""
	err_mayor_110_cony = ""
	err_vector = ""
	nerr_menor_20_cot = 0
	nerr_menor_20_cony = 0
	nerr_mayor_110_cot = 0
	nerr_mayor_110_cony = 0
	nerr_vector = 0	

	for (j=1 ; j <= N ; j++) {
	
		/* Verifica si se ha presionado la tecla break 
		(parallel) */
		parallel_break()
	
		if (touse[j,1]) {
		
			edad_cot = x[j,1]
			edad_cony = y[j,1]
			
			if (path_v == "") vecexists = fileexists(c("sysdir_plus")+"c/cnu_vec"+strofreal(agnovec[j]))
			else vecexists = fileexists(path_v+"cnu_vec"+strofreal(agnovec[j]))
			
			if (edad_cot >= 20 & edad_cot <= 110 & edad_cony >= 20 & edad_cony <= 110 & vecexists) {
			
				// Mujer
				s_cot = cotmujer[j,1]
				s_cony = conymujer[j,1]			
								
				// Guarda resultado en vector CNU
				cnu[j,1] = cnu_2_2(edad_cot, edad_cony, s_cot, s_cony, tipo_tm_cot[j], tipo_tm_cony[j], agnovec[j], rv[j], norp, agnotabla[j], agnotablabenef[j], vagnoactual[j], vfsiniestro[j], 0, path_tm, path_v)
			} 
			else if (edad_cot < 20) {
				if (nerr_menor_20_cot++ < 20) err_menor_20_cot = err_menor_20_cot+strofreal(j)+" "
			}
			else if (edad_cony < 20) {
				if (nerr_menor_20_cony++ < 20) err_menor_20_cony = err_menor_20_cony+strofreal(j)+" "
			}
			else if (edad_cot > 110) {
				if (nerr_mayor_110_cot++ < 20) err_mayor_110_cot = err_mayor_110_cot+strofreal(j)+" "
			}
			else if (!vecexists) {
				if (nerr_vector++ < 20) err_vector = err_vector + strofreal(j)+" "
			}
			else {
				if (nerr_mayor_110_cony++ < 20) err_mayor_110_cony = err_mayor_110_cony+strofreal(j)+" "
			}
		}	
	}

	st_local("err_menor_20_cot", err_menor_20_cot)
	st_local("err_menor_20_cony", err_menor_20_cony)
	st_local("err_mayor_110_cot", err_mayor_110_cot)
	st_local("err_mayor_110_cony", err_mayor_110_cony)
	st_local("err_vector", err_mayor_110_cony)
	
	st_local("nerr_menor_20_cot", strofreal(nerr_menor_20_cot))
	st_local("nerr_menor_20_cony", strofreal(nerr_menor_20_cony))
	st_local("nerr_mayor_110_cot", strofreal(nerr_mayor_110_cot))
	st_local("nerr_mayor_110_cony", strofreal(nerr_mayor_110_cony))
	st_local("nerr_vector", strofreal(nerr_mayor_110_cony))
	
	return(cnu)
}

// NOMBRE     : cnu_2_2
// DESCRIPCION: Calcula CNU para conyuge sin hijos (escalar)
// RESULTADO  : CNU para conyuge sin hijos (escalar)

real scalar cnu_2_2(
	real scalar x,               // Edad del afiliado
	real scalar y,               // Edad del conyuge
	real scalar cotmujer,        // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,       // Escalar binario (1 si el conyuge es mujer)
	string scalar tipo_tm_cot,   // Tabla de mortalidad para el cotizante
	string scalar tipo_tm_cony,  // Tabla de mortalidad para el beneficiario
	real scalar agnovec,         // Agno del vector
	real scalar rv,              // Valor de la tasa para RV
	real scalar norp,            // Dicotomica indicando si calcula o no RP
	real scalar agnotabla,       // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef,  // Agno de la tabla de mortalidad del beneficiario
	real scalar agnoactual,      // Agno actual (de calculo)
	real scalar fsiniestro,      // Fecha del siniestro
  | real scalar stepprint,
	string scalar path_tm,       // Directorio donde se encuentran las tablas de mortalidad
	string scalar path_v	
	)
	{
	
	real scalar l_x, l_y, tmax, cnu, i, lxt, lyt, t
	real colvector qxtmp_cot, qxtmp_cony
	real matrix vec, tabla_mort_cot, tabla_mort_cony
	string scalar cotmujer_tm, conymujer_tm
	
	// Verifica si desea imprimir en pantalla
	if (stepprint == J(1,1,.)) stepprint = 0
	
	// Valor inicial en rv			
	l_x = 1
	l_y = 1

	// N periodos
	tmax = 110 - y + 1

	// Mejoramiento de la tabla
	if (cotmujer) cotmujer_tm = "m"
	else cotmujer_tm = "h"
	
	if (conymujer) conymujer_tm = "m"
	else conymujer_tm = "h"
	
	// Asignacion dinamica de tabla
	if (fsiniestro != 0) {
		agnotabla      = cnu_which_tab_mort(fsiniestro, tipo_tm_cot)
		agnotablabenef = cnu_which_tab_mort(fsiniestro, tipo_tm_cony)
	}
	st_local("tipotabla", tipo_tm_cot)
	st_local("tipotablabenef", tipo_tm_cony)
	st_local("agnotabla", strofreal(agnotabla))
	st_local("agnotablabenef", strofreal(agnotablabenef))
	
	tabla_mort_cot  = cnu_get_tab_mort(agnotabla, cotmujer_tm, tipo_tm_cot, path_tm)
	tabla_mort_cony = cnu_get_tab_mort(agnotablabenef, conymujer_tm, tipo_tm_cony, path_tm)
	
	qxtmp_cot = cnu_mejorar_tabla(tabla_mort_cot[.,1], tabla_mort_cot[.,2], tabla_mort_cot[.,3], agnotabla, agnoactual, x)
	qxtmp_cony = cnu_mejorar_tabla(tabla_mort_cony[.,1], tabla_mort_cony[.,2], tabla_mort_cony[.,3], agnotablabenef, agnoactual, y)
	
	// Genera vector
	if (norp) {
		vec = ((1::191), J(191,1,rv))
	} 
	else {
		vec = cnu_get_vec_tasas(agnovec, path_v)
	}
	
	// Sumatoria
	cnu = 0
	i = 0
	lxt = 1
	lyt = 1
	if (stepprint) { // En el caso de que desee mostrar los resultados en pantalla
		printf("t = %3.0f: CNU = 1\n", 0)
		for (t=1 ; t<=tmax ; t++) {
			
			i = vec[t,2]
			
			lxt  = lxt *(1 -  qxtmp_cot[x + t - 1])
			lyt  = lyt *(1 - qxtmp_cony[y + t])
			// printf("t = %3.0f: CNU = %9.6f + (%g/((1 + %g)^%g)) - ((%g*%g)/(%g*%g*(1 + %g)^%g))\n", t, cnu, lyt, i, t, lxt, lyt, l_x, l_y,i,t)
			printf("t = %3.0f: cnu = %9.6f + (%g/(1 + %g)^%g)*(1 - %g)\n", t, cnu, lyt, i, t, lxt, )
			//cnu = cnu + (lyt/(l_y*(1 + i)^t)) - ((lxt*lyt)/(l_x*l_y*(1 + i)^t))
			cnu = cnu + (lyt/(1 + i)^t)*(1 - lxt)
		}
	}
	else {
		for (t=1 ; t<=tmax ; t++) {
			
			i = vec[t,2]
			
			lxt  = lxt *(1 -  qxtmp_cot[x + t - 1])
			lyt  = lyt *(1 - qxtmp_cony[y + t])
			
			//cnu = cnu + (lyt/(l_y*(1 + i)^t)) - ((lxt*lyt)/(l_x*l_y*(1 + i)^t))
			cnu = cnu + (lyt/(1 + i)^t)*(1 - lxt)
		}
	}
	
	return(round((.6 :* cnu), .000001))
}

end
