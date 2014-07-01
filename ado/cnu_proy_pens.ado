*! vers 1.14.7 1jul2014
*! auth: George G. Vega
*! Genera una trayectoria de pension 

cap program drop cnu_proy_pens
program def cnu_proy_pens, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=z id="x e y") [ ,
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
			PASOS
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

	#delimit ;
	mata: 
		st_matrix("mimat", 
			cnu_proy_pens(
				`x', `y', `cotmujer', `conymujer', "`tipotabla'",
				"`tipotablabenef'", `agnovector', `rp', `agnotabla',
				`agnotablabenef', `agnoactual', `fsiniestro', `pasos',
				"`dirtablas'","`dirvectores'"
			)
		) ;
	#delimit cr
	
	if (`y' == .) local etiqueta = "Trayectoria de pension para afiliado soltero tasa `rp'"
	else          local etiqueta = "Trayectoria de pension para afiliado con conyuge, tasa `rp'"
	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local cmd = `"cnu_proy_pens `0'"'
	return local descrip = "`etiqueta'"
	return matrix pens mimat
	
end

cnu_proy_pens 65
