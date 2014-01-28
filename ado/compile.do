clear all
program drop _all
mata mata clear
set more off
set trace off
set matastrict on

cd I:\george\comandos_paquetes_librerias\stata\cnu\ado\

/* Compilando rutinas y agregandolas a mlib */
mata mata mlib create lcnu, replace
do cnu_1_1.mata
do cnu_2_1.mata
do cnu_2_2.mata
do utils.mata
mata mata mlib add lcnu *()

/* Creando documentacion */
do ../../dev_tools/build_source_hlp.mata
mata build_source_hlp(dir(".","files","*.mata"), "cnu_source.hlp", 1)

/* Creando checksum */
mata st_global("ayuda",invtokens(dir(".","files","*.hlp")'))
mata st_global("ados",invtokens(dir(".","files","*.ado")'))
mata st_global("tablas",invtokens(dir(".","files","cnu_tabmor*")'))
mata st_global("vectores",invtokens(dir(".","files","cnu_vec*")'))

foreach g in ayuda ados tablas vectores {
	foreach f of global `g' {
		checksum `f', save replace
	}
}
checksum lcnu.mlib, save replace


/* Instalando */
cap net from ~/Documents/programas/stata_super
cap net from ~/../investigacion/george/comandos_paquetes_librerias/stata
cap net from I:\george\comandos_paquetes_librerias\stata\

net install cnu, replace force
mata mata mlib query

/* Empacando */
!zip cnu_0.13checksum.zip $ayuda $ados $tablas $vectores lcnu.mlib *.sum
!zip cnu_0.13.zip $ayuda $ados $tablas $vectores lcnu.mlib
