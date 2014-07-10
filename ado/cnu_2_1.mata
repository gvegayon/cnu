*! version 0.13.10.23 23oct2013
mata:

// NOMBRE     : cnu_2_1_vec
// DESCRIPCION: Calcula CNU para afiliado soltero (version vectorial)
// RESULTADO  : CNU para afiliado soltero (version vectorial)

real colvector cnu_2_1_vec(
	real colvector x,            // Edad del afiliado
	real colvector mujer,        // Genero del afiliado
	string colvector tipo_tm,    // Tipo de tabla de mortalidad (rv, mi, b)
	real colvector agnovec,      // Agno del vector
	real scalar norp,            // 1 si no desea calcular Retiro Programado
	real colvector rv,           // Tasa rentabilidad (para Renta Vitalicia)
	real colvector rp,           // Tasa para RP
	real colvector agnotabla,    // Agno de la tabla de mortalidad
	real colvector vagnoactual,  // Agno actual de calculo
	real colvector vfsiniestro,  // Fecha del siniestro (para definicion dinamica de tabla de mortalidad)
	real colvector touse,        // 1 si incluira a observacion en el calculo
	real scalar printlistado,    // 1 si retornara listado de errores
	string scalar path_tm,       // Path a tablas de mortalidad
	string scalar path_v         // Path a tablas de mortalidad
	)
	{
	
	// Definicion de escalares
	real scalar N, sex, edad, nerr_menor_20, nerr_mayor_110, nerr_vector, vecexists, j
	string scalar err_menor_20, err_mayor_110, err_vector
	real colvector cnu
	
	N = rows(x)
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
		
		if (!touse[j]) continue

		edad = x[j,1]
		sex=mujer[j,1]
		
		if (path_v=="")	vecexists = fileexists(c("sysdir_plus")+"c/cnu_vec"+strofreal(agnovec[j]))
		else vecexists = fileexists(path_v+"cnu_vec"+strofreal(agnovec[j]))
		
		if (edad >= 20 & edad <= 110 & vecexists) {
						
			// Guarda resultado en vector CNU			
			cnu[j,1] = cnu_2_1(edad, sex, tipo_tm[j], agnovec[j], rv[j], rp[j], norp, agnotabla[j], vagnoactual[j], vfsiniestro[j], 0, path_tm, path_v)
		}
		else if (edad < 20) { // No puede calcular CNU por ser menor de 20
			if (nerr_menor_20++ < 20) err_menor_20 = err_menor_20+strofreal(j)+" "
		}
		else if (!vecexists) { // Vector inexistente
			if (nerr_vector++ < 20) err_vector = err_vector+strofreal(j)+" "
		}
		else { // No puede calcular CNU por ser mayor de 110
			if (nerr_mayor_110++ < 20) err_mayor_110 = err_mayor_110+strofreal(j)+" "
		}
	}

	// Pasa listado de obs que no pudo procesar a una local
	if (printlistado) {
		st_local("err_menor_20", err_menor_20)
		st_local("err_mayor_110", err_mayor_110)
		st_local("err_vector", err_vector)
		
		st_local("nerr_menor_20", strofreal(nerr_menor_20))
		st_local("nerr_mayor_110", strofreal(nerr_mayor_110))
		st_local("nerr_vector", strofreal(nerr_vector))
	}
	
	return(cnu)
}

// NOMBRE     : cnu_2_1
// DESCRIPCION: Calcula CNU para afiliado soltero (version escalar)
// RESULTADO  : CNU para afiliado soltero (version escalar)

real scalar cnu_2_1(
	real scalar x,          // Edad del afiliado
	real scalar mujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm,  // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar agnovec,    // Agno del vector
	real scalar rv,         // Valor de la tasa para RV
	real scalar rp,
	real scalar norp,       // Dicotomica indicando si calcula o no RP
	real scalar agnotabla,  // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual, // Agno actual (de calculo)
	real scalar fsiniestro, // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar stepprint,
	string scalar path_tm,  // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
	)
	{
	
	real scalar cnu, lxt, l_x, tmax, i, t
	real colvector qxtmp
	real matrix vec, tabla_mort
	string scalar mujer_tm
	
	// Verifica si desea imprimir resultados en panalla
	if (stepprint == J(1,1,.)) stepprint = 0
	
	// Valor inicial en rv
	l_x = 1

	// N periodos
	tmax = 110 - x + 1

	// Mejoramiento de la tabla
	if (mujer) mujer_tm = "m"
	else mujer_tm = "h"
	
	// Asignacion dinamica de tabla
	if (fsiniestro != 0) agnotabla = cnu_which_tab_mort(fsiniestro, tipo_tm)
	st_local("tipotabla",tipo_tm)
	st_local("agnotabla",strofreal(agnotabla))
	
	tabla_mort = cnu_get_tab_mort(agnotabla, mujer_tm, tipo_tm, path_tm)
	
	qxtmp = cnu_mejorar_tabla(tabla_mort[.,1],tabla_mort[.,2], tabla_mort[.,3], agnotabla, agnoactual, x)
	
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
	
	// Sumatoria
	cnu = 1
	lxt = 1
	i = 0
	// Calcula CNU
	if (stepprint) {
		printf("t = %3.0f: CNU = 1\n", 0)
		for (t=1 ; t<=tmax ; t++) {
			
			lxt = lxt*(1 - qxtmp[x + t - 1])
			i = vec[t,2]
			
			// printf("t = %3.0f: CNU = %9.6f + (%g/%g)/((1 + %g)^%g)\n",t,cnu,lxt,l_x,i,t)
			printf("t = %3.0f: cnu = %9.6f + %g/((1 + %g)^%g)\n", t, cnu , lxt, i, t)
			//cnu = cnu + (lxt/l_x)/((1 + i)^t)
			cnu = cnu + lxt/((1 + i)^t)
		}
	}
	else {
		for (t=1 ; t<=tmax ; t++) {
			
			lxt = lxt*(1 - qxtmp[x + t - 1])
			i = vec[t,2]
							
			//cnu = cnu + (lxt/l_x)/((1 + i)^t)
			cnu = cnu + lxt/((1 + i)^t)
		}
	}
	return(round((cnu :- 11/24), .000001))
}

end

