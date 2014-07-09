*! vers 1.14.6.27 27jun2014
*! auth: George G. Vega
*! 2.1 Afiliado pensionado

cap program drop cnu_faj
program def cnu_faj, rclass
	
	version 10.0

	#delimit ;
	syntax 
		varlist(min=1 max=2 numeric) [if] [in] , Generate(name) [
			EDADMaxima(integer 98)
			VEDADMaxima(varname)
			saldo(real 1)
			vsaldo(varname)
			pcent(real 0.3)
			vpcent(varname)
			rp0(real 0.0)
			vrp0(varname)
			CRIter(real 1e-6)
			MAXIter(integer 100)
			Replace 
			Tabla(string)
			DIRTablas(string) 
			DIRVectores(string)
			VTabla(varname)
			TABLABenef(string)
			VTABLABenef(varname)
			COTMujer(varname) 
			CONYMujer(varname) 
			AGNOVector(integer 2013)
			VAGNOVector(varname)
			AGNOActual(integer 0)
			VAGNOActual(varname)
			Fsiniestro(integer 0)
			VFsiniestro(varname)
			NORP
			RP(real -1e100)
			VRP(varname)
			]
	;
	#delimit cr
	
	// Chequeando que parallel este instalado
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
	
	if ("`2'" != "") local y `2'
	else {
		tempvar y
		qui gen `y' = .
	}
	
	// Marca segun if
	marksample touse
	
	// Verifica si calcula RP
	if ("`norp'"!="") di as result "La opci{c 'o}n -norp- ya no est{c 'a} disponible. CNU determina esto autom{c 'a}ticamente."
	local norp = 1
	
	// Selecciona tabla afiliado
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
	
	// Selecciona tabla beneficiario
	tempvar vagnotablabenef vtipotablabenef
	if (length("`vtablabenef'") == 0) {
		if length("`tablabenef'") == 0 {
			local agnotablabenef = 2006
			local tipotablabenef = "b"
		}
		else {
			local agnotablabenef = regexr("`tablabenef'", "[a-zA-Z]*", "")
			local tipotablabenef = regexr("`tablabenef'", "[0-9]+", "")
		}
		gen `vagnotablabenef' = `agnotablabenef'
		gen `vtipotablabenef' = "`tipotablabenef'"
	}
	else {
		gen `vagnotablabenef' = regexs(2) if regexm(`vtablabenef', "^([a-zA-Z]+)([0-9]*)")
		gen `vtipotablabenef' = regexs(1) if regexm(`vtablabenef', "^([a-zA-Z]+)([0-9]*)")
		qui destring `vagnotablabenef', replace force
	}

	// Saldo
	if ("`vsaldo'"=="") {
		tempvar vsaldo
		gen double `vsaldo' = `saldo'
	}
	
	// Pension de referencia
	if ("`vrp0'"=="") {
		tempvar vrp0
		gen double `vrp0' = `rp0'
	}
	
	// Porcentaje
	if ("`vpcent'"=="") {
		tempvar vpcent
		gen double `vpcent' = `pcent'
	}
	
	// Edad maxima
	if ("`vedadmaxima'"=="") {
		tempvar vedadmaxima
		gen double `vedadmaxima' = `edadmaxima'
	}
	
	// Agno actual
	if length("`vagnoactual'") == 0 {
		tempvar vagnoactual
		if `agnoactual' == 0 local agnoactual = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")
		gen `vagnoactual' = `agnoactual'
	}
	
	// Vector
	if (length("`vrp'") == 0) {
		tempvar vrp
		gen double `vrp' = `rp'
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
	
	// Variable de sexo: 1 es mujer 0 es hombre
	if length("`conymujer'") == 0 {
		tempvar conymujer
		gen `conymujer' = 0
	}
	
	// Genera variable nueva
	if length("`replace'") != 0 cap drop `generate'
	qui gen `generate' = .
	
	if (`rp' == -1e100) lab var `generate' "CNU RP para conyuge sin hijos (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef'), vector `agnovector' en año `agnoactual'"
	else lab var `generate' "CNU RP para conyuge sin hijos (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef'), tasa `=`rp'*100'% en año `agnoactual'"
	
	#delimit ;
	mata: 
		st_store(., "`generate'", 
			cnu_faj_vec(
				st_data(.,"`vedadmaxima'"),
				st_data(.,"`vsaldo'"),
				st_data(.,"`vpcent'"),
				st_data(.,"`vrp0'"),
				st_data(.,"`x'"),
				st_data(.,"`y'"),
				st_data(.,"`cotmujer'"),
				st_data(.,"`conymujer'"),
				st_sdata(.,"`vtipotabla'"),
				st_sdata(.,"`vtipotablabenef'"),
				st_data(.,"`vagnovector'"),
				st_data(.,"`vrp'"),
				st_data(.,"`vagnotabla'"),
				st_data(.,"`vagnotablabenef'"),
				st_data(.,"`vagnoactual'"),
				st_data(.,"`vfsiniestro'"),
				st_data(.,"`touse'"),
				0,
				`criter',
				`maxiter',
				"`dirtablas'",
				"`dirvectores'"
				)
			)
	;
	#delimit cr
	
	if length("`err_menor_20_cot'") > 0 | length("`err_menor_20_cony'") > 0 | length("`err_mayor_110_cot'") > 0 | length("`err_mayor_110_cony'") > 0 | length("`err_vector'") > 0 {
		local nerr = 0
		di as error "ADVERTENCIA:" _newline
		if length("`err_menor_20_cot'") > 0 di as text " (`++nerr') Los siguientes cotizantes (`nerr_menor_20_cot') tienen menos de 20 a{c n~}os" _newline as result "`err_menor_20_cot'..." _newline
		if length("`err_menor_20_cony'") > 0 di as text " (`++nerr') Los siguientes conyuges (`nerr_menor_20_cony') tienen menos de 20 a{c n~}os" _newline as result "`err_menor_20_cony'..." _newline
		if length("`err_mayor_110_cot'") > 0 di as text " (`++nerr') Los siguientes cotizantes (`nerr_mayor_110_cot') tienen más de 110 a{c n~}os" _newline as result "`err_mayor_110_cot'..." _newline
		if length("`err_mayor_110_cony'") > 0 di as text " (`++nerr') Los siguientes conyuges (`nerr_mayor_110_cony') tienen más de 110 a{c n~}os" _newline as result "`err_mayor_110_cony'..." _newline
		if length("`err_vector'") > 0 di as text " (`++nerr') Para las siguientes observaciones (`nerr_vector') se intent{c o'} utilizar un vector inexistente" _newline as result "`err_vector'..." _newline
		di as error "Por lo que no fue posible calcular CNU para estas."
	}
	
	if (c(dp) == "period") qui format `generate' %9.6fc
	else qui format `generate' %9,6fc
	
end

