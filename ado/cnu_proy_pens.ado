*! vers 1.14.7 1jul2014
*! auth: George G. Vega
*! Genera una trayectoria de pension 

cap program drop cnu_proy_pensi
program def cnu_proy_pensi, rclass

	version 10.0

	#delimit ;
	syntax 
		anything(name=z id="x e y") [ ,
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
			PASOS
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
	
	// Verifica si desea imprimir los pasos de calculo en pantalla
	if (length("`pasos'") > 0) local pasos = 1
	else local pasos = 0
	
	if (`rp0' == -1.0) local rp0 .
	
	if ("`faj'"=="") local faj 0
	else local faj 1
	
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
				`pcent', `rp0', `criter', `maxiter', `pasos',
				"`dirtablas'","`dirvectores'"
			))
		) ;
	#delimit cr

	if (`y' == .) local etiqueta = "Trayectoria de pension para afiliado soltero tasa `rp'"
	else          local etiqueta = "Trayectoria de pension para afiliado con conyuge, tasa `rp'"
	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	
	return local cmd = `"cnu_proy_pens `0'"'
	return local descrip = "`etiqueta'"

	// Checking if needs to be exported
	if ("`generate'" != "") {

		local nvar : word count `generate'
		if      ((`nvar' == 5) &  `faj') {
			matrix colnames `mimat' = `generate'
			svmat `mimat', names(col)
			tokenize `generate'
			lab var `1' "Edad"
			lab var `2' "Saldo"
			lab var `3' "Factor de Ajuste"
			lab var `4' "Saldo de Reserva"
			lab var `5' "Pension con FAJ"
		}
		else if ((`nvar' == 3) & !`faj') {
			matrix colnames `mimat' = `generate'
			svmat `mimat', names(col)
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
	
end

clear
cnu_proy_pensi 65, faj gen(edad_afil saldo_confaj faj saldo_faj pens_faj)
drop edad_afil saldo_confaj
cnu_proy_pensi 65, gen(edad_afil saldo pens)

foreach v of varlist saldo_f pens_f {
	qui replace `v' = 0 if `v' == .
}

local m = saldo[1]
replace saldo      = saldo     /`m'
replace saldo_faj  = saldo_faj/`m'

local m = pens[1]
replace pens   = pens/`m'
replace pens_f = pens_f/`m'


tsset edad
tsline pens* saldo*, ytitle(% de la 1ra pension o del saldo inicial) ///
	scheme(s2mono) xtitle(Edad) xlab(65(5)110) ///
	title(Trayectoria de la Pensi{c o'}n) ///
	note(Nota: Tasa del 30% para un hombre soltero que se retira a los ///
	65 a{c n~}os de edad)

//mat list r(pens)
