*! vers 1.13.11 08nov2013
*! auth: George G. Vega
*! 2.1 Afiliado pensionado

cap program drop cnu_cnyg_s_hi
program def cnu_cnyg_s_hi, rclass

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
			NORP
			RV(real 0.032)
			PASOS
			]
	;
	#delimit cr
	
	// Chequeando que existan las tablas
	// cnu_install_tabs
	
	return clear
	
	tokenize `z'
	local x `1'
	local y `2'
	
	// Verifica si desea imprimir los pasos de calculo en pantalla
	if (length("`pasos'") > 0) local pasos = 1
	else local pasos = 0
	
	// Verifica si calcula RP
	if (length("`norp'") > 0) local norp = 1
	else local norp = 0
	
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
		st_local("generate", strofreal( 
			cnu_2_2(
				`x',
				`y',
				`cotmujer',
				`conymujer',
				"`tipotabla'",
				"`tipotablabenef'",
				`agnovector',
				`rv',
				`norp',
				`agnotabla',
				`agnotablabenef',
				`agnoactual',
				`fsiniestro',
				`pasos',
				"`dirtablas'",
				"`dirvectores'"
				)
			)
		)
	;
	#delimit cr

	if (`norp') local etiqueta = "CNU RV para conyuge sin hijos (tablas `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef'), tasa `=`rv'*100'% en el a{c n~}o `agnoactual'"
	else local etiqueta = "CNU RP para conyuge sin hijos (tablas `tipotabla'`agnotabla' `tipotablabenef'`agnotablabenef'), vector `agnovector' en el a{c n~}o `agnoactual'"
	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local tip_cnu = "`etiqueta'"
	return scalar cnu = `generate'
	
end
