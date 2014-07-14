*! vers 1.14.7 1jul2014
*! auth: George G. Vega
*! Factor de Ajuste (FAJ)

cap program drop cnu_faji
program def cnu_faji, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=z id="x e y") [ ,
			EDADMaxima(integer 98)
			saldo(real 1)
			pcent(real 0.3)
			rp0(real 0.0)
			CRIter(real 1e-6)
			MAXIter(integer 100)
			Tabla(string)
			DIRTablas(string) 
			DIRVectores(string)
			TABLABenef(string)
			COTMujer(integer 0) 
			CONYMujer(integer 1) 
			AGNOVector(integer 2013)
			AGNOActual(integer 0)
			Fsiniestro(integer 0)
			RP(real 0.03)
			PASOS debug
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
	
	// Verifica si desea imprimir los pasos de calculo en pantalla
	if (length("`pasos'") > 0) local pasos = 1
	else local pasos = 0
	
	// Chequea RP0
	if (`rp0' == 0) local rp0 .
	
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

	*if ("`debug'"!="") set trace on
	#delimit ;
	mata: 
		st_local("generate", strofreal(
			cnu_faj(
				`x', 
				cnu_proy_cnu(
					`x', `y', `cotmujer', `conymujer', "`tipotabla'",
					"`tipotablabenef'", `agnovector', 0, J(110-`x'+1,1,-1e100),
					J(110-`x'+1,1,`rp'), `agnotabla', `agnotablabenef',
					`agnoactual', `fsiniestro', `pasos', "`dirtablas'",
					"`dirvectores'"
				), /* Eligiendo vector correspondiente (si corresponde) */
				(`rp' != . ? J(110-`x'+1,1,`rp') : cnu_get_vec_tasas(`agnovector', "`dirvectores'")),
				`edadmaxima',
				`saldo',
				`pcent',
				`rp0',
				`criter',
				`maxiter'
			)
		)) ;
	#delimit cr
	*if ("`debug'"!="") set trace off

	if      (`y' == . & `rp' != .) local etiqueta = "FAJ para afiliado soltero (tabla `agnotabla'`tipotabla') tasa `rp' en `agnoactual'."
	else if (`y' == . & `rp' == .) local etiqueta = "FAJ para afiliado soltero (tabla `agnotabla'`tipotabla') vector `agnovec' en `agnoactual'."
	else if (`y' != . & `rp' != .) local etiqueta = "FAJ para afiliado con conyuge (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef') tasa `rp' en `agnoactual'."
	else if (`y' != . & `rp' == .) local etiqueta = "FAJ para afiliado con conyuge (tabla `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef') vector `agnovec' en `agnoactual'."
	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local cmd = `"cnu_faji `0'"'
	return local descrip = "`etiqueta'"
	return scalar faj = `generate'
	
end


