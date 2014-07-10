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
