*! vers 1.13.11 08nov2013
*! auth: George G. Vega
*! Calcula CNU para Afiliado pensionado (Segun punto 2.1 del anexo de la circular
*! 1626)

cap program drop cnu_sobr_cnyg_s_hi
program def cnu_sobr_cnyg_s_hi, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=y id="edad del conyuge") [ ,
			TABLABenef(string)
			DIRTablas(string) 
			DIRVectores(string)			
			CONYMujer(integer 0) 
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
	
	// Verifica si desea imprimir los pasos de calculo en pantalla
	if (length("`pasos'") > 0) local pasos = 1
	else local pasos = 0
	
	// Verifica si calcula RP
	if (length("`norp'") > 0) local norp = 1
	else local norp = 0
	
	// Selecciona tabla
	if length("`tablabenef'") == 0 {
		local agnotabla = 2006
		local tipotabla = "b"
	}
	else  {
		local agnotabla = regexr("`tablabenef'", "^[a-zA-Z]+", "")
		local tipotabla = regexr("`tablabenef'", "[0-9]+$", "")
	}
	
	// Agno actual
	if `agnoactual' == 0 local agnoactual = regexr(c(current_date), "[0-9]* [a-zA-Z]* ","")
		
	#delimit ;
	mata: 
		st_local("generate" , 
			strofreal(
				cnu_1_1(
					`y',
					`conymujer',
					"`tipotabla'",
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

	if (`norp') local etiqueta = "CNU sobrev RV para conyuge sin hijos (tabla `tipotabla'`agnotabla'), tasa `=`rv'*100'% en el a{c n~}o `agnoactual'"
	else local etiqueta = "CNU sobrev RP para conyuge sin hijos (tabla `tipotabla'`agnotabla'), vector `agnovector' en el a{c n~}o `agnoactual'"
		
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local tip_cnu = "`etiqueta'"
	return scalar cnu = `generate'
	
end
