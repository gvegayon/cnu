*! vers 1.13.11 08nov2013
*! auth: George G. Vega
*! 2.1 Afiliado pensionado
*! Calcula CNU para Afiliado pensionado (Segun punto 2.1 del anexo de la circular 
*! 1626)

cap program drop cnu_afili
program def cnu_afili, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=x id="edad del afiliado") [ ,
			Tabla(string)
			DIRTablas(string) 
			DIRVectores(string)
			COTMujer(integer 0) 
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
	// cap cnu_install_tabs
	
	return clear
	
	// Verifica si desea imprimir los pasos de calculo en pantalla
	if (length("`pasos'") > 0) local pasos = 1
	else local pasos = 0
	
	// Verifica si calcula RP
	if (length("`norp'") > 0) local norp = 1
	else local norp = 0
	
	// Selecciona tabla
	if length("`tabla'") == 0 {
		local agnotabla = 2009
		local tipotabla = "rv"
	}
	else {
		local agnotabla = regexr("`tabla'", "^[a-zA-Z]+", "")
		local tipotabla = regexr("`tabla'", "[0-9]+$", "")
	}
	
	// Agno actual
	if `agnoactual' == 0 local agnoactual = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")
		
	if (`norp') local etiqueta = "CNU RV para soltero sin hijos (tabla `tipotabla'`agnotabla'), tasa `=`rv'*100'% en el a{c n~}o `agnoactual'"
	else local etiqueta = "CNU RP para soltero sin hijos (tabla `tipotabla'`agnotabla'), vector `agnovector' en el a{c n~}o `agnoactual'"
	
	#delimit ;
	mata: 
		st_local("generate" , 
			strofreal(
				cnu_2_1(
					`x',
					`cotmujer',
					"`tipotabla'", // Tipo de tabla
					`agnovector',
					`rv',
					`norp',
					`agnotabla',
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
		
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local tip_cnu = "`etiqueta'"
	return scalar cnu = `generate'
	
end
