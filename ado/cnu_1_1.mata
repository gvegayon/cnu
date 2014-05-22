*! version 0.13.10.23 23oct2013
mata:

// NOMBRE     : cnu_1_1
// DESCRIPCION: Calcula CNU para Pension de sobrevivencia para conyuge sin hijos (version escalar)
// RESULTADO  : CNU para Pension de sobrevivencia para conyuge sin hijos (version escalar)

real scalar cnu_1_1(
	real scalar y,          // Edad del conyuge
	real scalar mujer,      // Escalar binario (1 si el conyuge es mujer)
	string scalar tipo_tm,  // Tabla de mortalidad para el beneficiario
	real scalar agnovec,    // Agno del vector
	real scalar rv,         // Valor de la tasa para RV
	real scalar rp,         // Valor de la tasa para RP
	real scalar norp,       // Dicotomica indicando si calcula o no RP
	real scalar agnotabla,  // Agno de la tabla de mortalidad del beneficiario
	real scalar agnoactual, // Agno actual (de calculo)
	real scalar fsiniestro, // Fecha del siniestro
    | real scalar stepprint,
	string scalar path_tm,  // Directorio donde se encuentran las tablas de mortalidad
	string scalar path_v
	)
	{
	
	real scalar cnu, lyt, l_y, tmax, i, t
	real colvector qxtmp
	real matrix vec, tabla_mort
	string scalar mujer_tm
	
	// Valor inicial en rv
	l_y = 1

	// N periodos
	tmax = 110 - y

	// Mejoramiento de la tabla
	if (mujer) mujer_tm = "m"
	else mujer_tm = "h"
	
	// Asignacion dinamica de tabla
	if (fsiniestro != 0) agnotabla = cnu_which_tab_mort(fsiniestro, tipo_tm)
	
	tabla_mort = cnu_get_tab_mort(agnotabla, mujer_tm, tipo_tm, path_tm)
	qxtmp = cnu_mejorar_tabla(tabla_mort[.,1],tabla_mort[.,2], tabla_mort[.,3], agnotabla, agnoactual, y)
	st_local("tipotabla",tipo_tm)
	st_local("agnotabla", strofreal(agnotabla))
	
	// Genera vector
	if (norp) 
	{
		vec = ((1::191), J(191,1,rv))
	} 
	else if (rp != -1e100)
	{
		vec = ((1::191), J(191,1,rp))
	}
	else 
	{
		vec = cnu_get_vec_tasas(agnovec, path_v)
	}	
	
	// De termina si se imprime o no el resultado en pantalla
	if (stepprint == J(1, 1, .)) stepprint = 0
	
	// Sumatoria
	cnu = 1
	lyt = 1
	i = 0
	if (stepprint) { // En el caso de que se desee imprimir los resultados en pantalla
		printf("t = %3.0f: CNU = 1\n", 0)
		for (t=1 ; t<=tmax ; t++) {
			
			lyt = lyt*(1 - qxtmp[y + t])
			i = vec[t,2]

			//printf("t = %3.0f: CNU = %9.6f + (%g/%g)/(1 + %g)^%g\n", t, cnu, lyt, l_y, i, t)
			printf("t = %3.0f: cnu = %9.6f + %g/((1 + %g)^%g)\n", t, cnu, lyt, i, t)
			//cnu = cnu + (lyt/l_y)/((1 + i)^t)
			cnu = cnu + lyt/((1 + i)^t)
			
		}
	}
	else {
		for (t=1 ; t<=tmax ; t++) {
			
			lyt = lyt*(1 - qxtmp[y + t])
			i = vec[t,2]
			
			//cnu = cnu + (lyt/l_y)/((1 + i)^t)
			cnu = cnu + lyt/((1 + i)^t)
		}
	}
	
	return(round((.6*(cnu :- 11/24)), .000001))
}

// NOMBRE     : cnu_1_1_vec
// DESCRIPCION: Calcula CNU para Pension de sobrevivencia para conyuge sin hijos (version vectorial)
// RESULTADO  : CNU para Pension de sobrevivencia para conyuge sin hijos (version vectorial)

real colvector cnu_1_1_vec(
	real colvector y,           // Edad del conyuge
	real colvector mujer,       // Vector binario (1 si el conyuge es mujer)
	string colvector tipo_tm,      // Tipo de tabla de mortalidad (rv, mi, b)
	real colvector agnovec,     // Agno del vector
	real scalar norp,           // Dicotomica indicando si calcula o no RP
	real colvector rv,          // Valor de la tasa para RV
	real colvector rp,          // Valor de la tasa para RP
	real colvector agnotabla,      // Agno de la tabla de mortalidad del beneficiario
	real colvector vagnoactual, // Agno actual (de calculo)
	real colvector vfsiniestro, // Fecha del siniestro
	real colvector touse,       // Vector binario (1 si debe calcular para la observacion)
	real scalar printlistado,   // Dicotomica indicando si imprime listado de no calculados por problemas
	string scalar path_tm,
	string scalar path_v
	)
	{
	
	// Definicion de escalares
	real scalar N, sex, edad, nerr_menor_20, nerr_mayor_110, vecexists, j, nerr_vector
	string scalar err_menor_20, err_mayor_110, err_vector
	real colvector cnu
	
	N = rows(y)
	cnu = J(N,1,.)
	
	err_menor_20 = ""
	err_mayor_110 = ""
	err_vector = ""
	nerr_menor_20 = 0
	nerr_mayor_110 = 0
	nerr_vector = 0
	
	for (j=1 ; j <= N ; j++) { // Puede calcular CNU
	
		/* Verifica si se ha presionado la tecla break 
		accionada por parallel */
		parallel_break()
		
		if (touse[j,1]) { // Revisa si debe incluirse o no

			edad = y[j,1]
			sex=mujer[j,1]
			
			if (path_v=="") vecexists = fileexists(c("sysdir_plus")+"c/cnu_vec"+strofreal(agnovec[j]))
			else vecexists = fileexists(path_v+"cnu_vec"+strofreal(agnovec[j]))
			
			if (edad >= 20 & edad <= 110 & vecexists) {
							
				// Guarda resultado en vector CNU			
				cnu[j,1] = cnu_1_1(edad, sex, tipo_tm[j], agnovec[j], rv[j], rp[j], norp, agnotabla[j], vagnoactual[j], vfsiniestro[j], 0, path_tm, path_v)
			}
			else if (edad < 20) { // No puede calcular CNU por ser menor de 20
				if (nerr_menor_20++ < 20) err_menor_20 = err_menor_20+strofreal(j)+" "
			}
			else if (!vecexists) {
				if (nerr_vector++ < 20) err_vector = err_vector+strofreal(j)+" "
			}
			else { // No puede calcular CNU por ser mayor de 110
				if (nerr_mayor_110++ < 20) err_mayor_110 = err_mayor_110+strofreal(j)+" "
			}
		}
	}

	// Pasa listado de obs que no pudo procesar a una local
	if (printlistado) {
		st_local("err_menor_20", err_menor_20)
		st_local("err_mayor_110", err_mayor_110)
		st_local("err_vector", err_vector)
		
		st_local("nerr_menor_20", strofreal(nerr_menor_20))
		st_local("nerr_mayor_110", strofreal(nerr_mayor_110))
		st_local("nerr_menor_20", strofreal(nerr_menor_20))
	}
	
	return(cnu)
}


end
