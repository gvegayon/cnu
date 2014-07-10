clear all
set obs 40
gen edad = 50 + _n-1

cnu_faj edad, gen(faj) replace

tsset edad
tsline faj
