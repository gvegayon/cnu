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
			rp0(integer 0)
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
		st_local("generate", strofreal(
			cnu_faj(
				`x', 
				cnu_proy_cnu(
					`x', `y', `cotmujer', `conymujer', "`tipotabla'",
					"`tipotablabenef'", `agnovector', 0, J(110-`x'+1,1,-1e100),
					J(110-`x'+1,1,`rp'), `agnotabla', `agnotablabenef',
					`agnoactual', `fsiniestro', `pasos', "`dirtablas'",
					"`dirvectores'"
				),
				J(110-`x'+1,1,`rp'),
				`edadmaxima',
				`saldo',
				`pcent',
				`rp0',
				`criter',
				`maxiter'
			)
		)) ;
	#delimit cr
	
	if (`y' == .) local etiqueta = "FAJ para afiliado soltero tasa `rp'"
	else          local etiqueta = "FAJ para afiliado con conyuge, tasa `rp'"
	
	if (c(dp) == "period") local fmt %9.6fc
	else local fmt %9,6fc
	
	di "`etiqueta'"
	di `fmt' `generate'
	
	return local cmd = `"cnu_faji `0'"'
	return local descrip = "`etiqueta'"
	return scalar faj = `generate'
	
end

// Ejercicio proyectando pension
clear

local maxm 98
local tasa .03
local mini .3

set obs `=`maxm'-65 + 1'
gen edad = 65 + _n - 1
gen agnoa = 2014 - 1 + _n
cnu_afil edad, vagnoa(agnoa) gen(cnu) rp(`tasa')

// FAJ
cnu_faji 65 
gen faj = r(faj)

// Pension agno a ango
gen saldo     = 1 in 1
gen pension   = saldo/cnu*(1-faj) in 1
gen saldo_faj = saldo/cnu*faj in 1
replace saldo = (saldo - pension - saldo_f)*(1+`tasa') in 1

local mini    = `mini'*saldo[1]/cnu[1]
di `mini'
local activo = 0

// Pension con faj
forval i=2/`=c(N)' {

	quietly {
	
		// Monto de pension
		if (!`activo') {
			replace pension   = saldo[_n-1]/cnu*(1-faj) in `i'
			
			if (pension[`i'] < `mini') {
				replace pension = `mini' if _n >= `i'
				replace saldo_f = 0 if _n >= `i'
				local activo = 1
			}
		}

		// Ajuste de saldos
		if (!`activo') {
			replace saldo_faj = (saldo_faj[_n-1] + saldo[_n-1]/cnu*faj)*(1+`tasa') in `i'
			replace saldo     = (saldo[_n-1] - pension - saldo[_n-1]/cnu*faj)*(1+`tasa') in `i'
		}
		else {
			replace saldo = (saldo[_n-1] - pension + saldo_f[_n-1])*(1+`tasa') in `i'
		}

	}
	di "pens:`=pension[`i']' mini:`mini'"
}
 
lab var pension "% Pension ref (FAJ)"

cnu_proy_pens 65
mat def pension_pcent_sinfaj = r(pens)
svmat pension_pcent_sinfaj

lab var pension_pcent_sinfaj "% Pension ref (sin FAJ)"

local pens = pension_pcent_sinfaj[1]
replace pension = pension/`pens'
replace pension_pcent_sinfaj = pension_pcent_sinfaj/`pens'

tsset edad
tsline pension*, ylab(0(.10)1)

