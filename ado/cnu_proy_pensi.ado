*! vers 1.14.7 1jul2014
*! auth: George G. Vega
*! Genera una trayectoria de pension 

cap program drop cnu_proy_pensi
program def cnu_proy_pensi, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=z id="x e y") [,
			Replace
			Generate(namelist)
			COTMujer(integer 0) 
			CONYMujer(integer 1) 
			Tabla(string)
			TABLABenef(string)
			Saldo(real 0)
			AGNOVector(integer 2013)
			rp(real 0.03)
			AGNOActual(integer 0)
			Fsiniestro(integer 0)
			// -- variables FAJ --
			faj
			EDADMaxima(integer 98)
			pcent(real 0.3)
			rp0(real -1.0)
			CRIter(real 1e-6)
			MAXIter(integer 100)
			// -- Variables adicionales --
			DIRTablas(string) 
			DIRVectores(string)
			]
	;
	#delimit cr
	
	// Chequeando que existan las tablas
	// cnu_install_tabs
	
	return clear
	
	tokenize `z'
	local x `1'
	if ("`2'" != "") local y `2'
	else local y .
	
	// Verificando opcion de factor de ajuste
	if ("`faj'"=="") local faj 0
	else local faj 1
	
	// Verificando replace
	if ("`replace'" == "") local replace 0
	else local replace 1
	
	// Verifica opcion GEN
	if ("`generate'"!="") {
		local nnew: word count `generate'
		if (`nnew'!=3 & !`faj') {
			di as error "Variables especificadas en -generate- (`nnew') incorrectas" as text ""
			di as text "(Se requieren 3)"
			error 197
		}
		else if (`nnew'!=5 & !`faj') {
			di as error "Variables especificadas en -generate- (`nnew') incorrectas" as text ""
			di as text "(Se requieren 5)"
			error 197
		}
		else {
			foreach v of local generate {
				cap confirm var `v', exact
				if (!_rc & `replace') qui drop `v'
				else if (!_rc & !`replace') {
					di as error "La variable -`v'- ya existe." as text ""
					di as text "Utilice la opcion -replace-"
					error 110
				}
			}
		}
	}
	
	if (`rp0' == -1.0) local rp0 .
		
	// Chequea RP0
	if (`saldo' == 0) local saldo 1
	
	// Selecciona tabla cotizante
	if length("`tabla'") == 0 {
		local agnotabla = 2009
		local tipotabla = "rv"
	}
	else {
		local agnotabla = regexr("`tabla'", "^[a-zA-Z]+", "")
		local tipotabla = regexr("`tabla'", "[0-9]+$", "")
	}
	
	// Selecciona tabla beneficiario
	if length("`tablabenef'") == 0 {
		local agnotablabenef = 2006
		local tipotablabenef = "b"
	}
	else {
		local agnotablabenef = regexr("`tablabenef'", "^[a-zA-Z]+", "")
		local tipotablabenef = regexr("`tablabenef'", "[0-9]+$", "")
	}
	
	// Agno actual
	if `agnoactual' == 0 local agnoactual = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")	
	
	// Proyectando pension utilizando el programa en mata -cnu_proy_pens-.
	// Se guarda como una matriz.
	tempname mimat
	
	#delimit ;
	mata: 
		st_matrix("`mimat'", 
			((`x'::110), cnu_proy_pens(
				`x', `y', `cotmujer', `conymujer', "`tipotabla'",
				"`tipotablabenef'", `saldo', `agnovector', `rp', `agnotabla',
				`agnotablabenef', `agnoactual', `fsiniestro', `faj', `edadmaxima',
				`pcent', `rp0', `criter', `maxiter', 
				"`dirtablas'","`dirvectores'"
			))
		) ;
	#delimit cr

	if (`faj') local confaj " con FAJ"
	
	if      (`y' == . & `rp' != .) local etiqueta = "Trayectoria de pension`confaj' para afiliado soltero (tabla `agnotabla'`tipotabla') tasa `rp' en `agnoactual'."
	else if (`y' == . & `rp' == .) local etiqueta = "Trayectoria de pension`confaj' para afiliado soltero (tabla `agnotabla'`tipotabla') vector `agnovec' en `agnoactual'."
	else if (`y' != . & `rp' != .) local etiqueta = "Trayectoria de pension`confaj' para afiliado con conyuge (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef') tasa `rp' en `agnoactual'."
	else if (`y' != . & `rp' == .) local etiqueta = "Trayectoria de pension`confaj' para afiliado con conyuge (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef') vector `agnovec' en `agnoactual'."

	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	
	return local cmd = `"cnu_proy_pensi `0'"'
	return local descrip = "`etiqueta'"

	// Checking if needs to be exported
	if ("`generate'" != "") {

		local nvar : word count `generate'
		if      ((`nvar' == 5) &  `faj') {
			matrix colnames `mimat' = `generate'
			qui svmat `mimat', names(col)
			tokenize `generate'
			lab var `1' "Edad"
			lab var `2' "Saldo"
			lab var `3' "Factor de Ajuste"
			lab var `4' "Saldo de Reserva"
			lab var `5' "Pension con FAJ"
		}
		else if ((`nvar' == 3) & !`faj') {
			matrix colnames `mimat' = `generate'
			qui svmat `mimat', names(col)
			tokenize `generate'
			lab var `1' "Edad"
			lab var `2' "Saldo"
			lab var `3' "Pension"
		}
		else error 1
		
		exit
	}
	
	if (!`faj') matrix colnames `mimat' = edad_afil saldo pension
	else matrix colnames `mimat' = edad_afil saldo faj saldo_cr pension
	
	return matrix pens `mimat'
	
	display "({stata mat list r(pens):ver matriz})"
	
end

