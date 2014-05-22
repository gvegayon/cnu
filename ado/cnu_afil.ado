*! vers 1.13.11 08nov2013
*! auth: George G. Vega
*! Calcula CNU para Afiliado pensionado (Segun punto 2.1 del anexo de la circular
*! 1626)
cap program drop cnu_afil
program def cnu_afil, rclass

	version 10.0

	#delimit ;
	syntax 
		varlist(max=1 numeric) [if] [in] , Generate(name) [
			Replace 
			Tabla(string)
			DIRTablas(string)
			DIRVectores(string)
			VTabla(varname)
			COTMujer(varname) 
			AGNOVector(integer 2013)
			VAGNOVector(varname)
			AGNOActual(integer 0)
			VAGNOActual(varname)
			Fsiniestro(integer 0)
			VFsiniestro(varname)
			NORP
			RV(real -1e100)
			RP(real -1e100)
			VRV(varname)
			VRP(varname)
			]
	;
	#delimit cr
	
	/* Chequeando que parallel este instalado */
	cap findfile parallel.ado
	if (_rc) {
		di "-cnu- requiere de -parallel- para funcionar..."
		di "descargando de -ssc-..."
		ssc install parallel
		di "listo."
	}
	
	return clear
	
	tokenize `varlist'
	local x `1'
	
	// Marca segun if
	marksample touse
	
	// Verifica si calcula RP
	if ("`norp'"!="") di as result "La opci{c 'o}n -norp- ya no est{c 'a} disponible. CNU determina esto autom{c 'a}ticamente."
        if (`rv'==-1e100) local norp = 0
        else local norp = 1

	
	// Selecciona tabla
	tempvar vagnotabla vtipotabla
	if (length("`vtabla'") == 0) {
		if length("`tabla'") == 0 {
			local agnotabla = 2009
			local tipotabla = "rv"
		}
		else {
			local agnotabla = regexr("`tabla'", "[a-zA-Z]*", "")
			local tipotabla = regexr("`tabla'", "[0-9]+", "")
		}
		gen `vagnotabla' = `agnotabla'
		gen `vtipotabla' = "`tipotabla'"
	}
	else {
		gen `vagnotabla' = regexs(2) if regexm(`vtabla', "^([a-zA-Z]+)([0-9]*)")
		gen `vtipotabla' = regexs(1) if regexm(`vtabla', "^([a-zA-Z]+)([0-9]*)")
		qui destring `vagnotabla', replace force
	}
		
	// Agno actual
	if (length("`vagnoactual'") == 0) {
		if `agnoactual' == 0 local agnoactual = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")
		tempvar vagnoactual
		gen `vagnoactual' = `agnoactual'
	}
	
	// Vector
	if (length("`vrv'") == 0) {
		tempvar vrv
		gen `vrv' = `rv'
	}
	if (length("`vrp'") == 0) {
		tempvar vrp
		gen `vrp' = `rp'
	}
	
	// Agno vector
	if (length("`vagnovector'") == 0) {
		tempvar vagnovector
		gen `vagnovector' = `agnovector'
	}
	
	// Fecha de siniestro
	if (length("`vfsiniestro'") == 0) {
		tempvar vfsiniestro
		gen `vfsiniestro' = `fsiniestro'
	}
	
	// Variable de sexo: 1 es mujer 0 es hombre
	if length("`cotmujer'") == 0 {
		tempvar cotmujer
		gen `cotmujer' = 0
	}
		
	// Genera variable nueva
	if length("`replace'") != 0 cap drop `generate'
	qui gen `generate' = .
	
	if (`norp') {
		lab var `generate' "CNU RV para soltero sin hijos (tabla `tipotabla'`agnotabla'), tasa `=`rv'*100'% en el año `agnoactual'"
	}
	else {
		if (`rp'==-1e100) lab var `generate' "CNU RP para soltero sin hijos (tabla `tipotabla'`agnotabla'), vector `agnovector' en el año `agnoactual'"
		else lab var `generate' "CNU RP para soltero sin hijos (tabla `tipotabla'`agnotabla'), tasa `=`rp'*100'% en el año `agnoactual'"
	}
	
	#delimit ;
	mata: 
		st_store(., "`generate'", 
			cnu_2_1_vec(
				st_data(.,"`x'"),
				st_data(.,"`cotmujer'"),
				st_sdata(.,"`vtipotabla'"), // Tipo de tabla
				st_data(.,"`vagnovector'"),
				`norp',
				st_data(.,"`vrv'"),
				st_data(.,"`vrp'"),
				st_data(.,"`vagnotabla'"),
				st_data(.,"`vagnoactual'"),
				st_data(.,"`vfsiniestro'"),
				st_data(.,"`touse'"),
				1,
				"`dirtablas'",
				"`dirvectores'"
				)
			)
	;
	#delimit cr
	
	// En caso de que existan, muestra listado de observaciones con errores
	// (no se pudo calcular CNU)
	if length("`err_menor_20'") > 0 | length("`err_mayor_110'") > 0 | length("`err_vector'") > 0 {
		local nerr = 0
		di as error "ADVERTENCIA:" _newline
		if length("`err_menor_20'") > 0 di as text " (`++nerr') Los siguientes cotizantes (`nerr_menor_20') tienen menos de 20 años" _newline as result "`err_menor_20'..." _newline
		if length("`err_mayor_110'") > 0 di as text " (`++nerr') Los siguientes cotizantes (`nerr_mayor_110') tienen más de 110 años" _newline as result "`err_mayor_110'..." _newline
		if length("`err_vector'") > 0 di as text " (`++nerr') Para las siguientes observaciones (`nerr_vector') se intent{c o'} utilizar un vector inexistente" _newline as result "`err_vector'..." _newline
		di as error "Por lo que no fue posible calcular CNU para estas."
	}
	
	if (c(dp) == "period") qui format `generate' %9.6fc
	else qui format `generate' %9,6fc
	
end
