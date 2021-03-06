{smcl}
{* *! version 0.14.7.11 11jul2014}{...}
{cmd:help cnu}
{hline}

{title:Title}

{phang}
{bf:cnu} {hline 2} Calculador del Capital Necesario Unitario (CNU) utilizado en
el c{c a'}lculo de pensiones

{title:Syntax}

{phang}
CNU para afiliado soltero.

{p 8 17 2}
{cmdab:cnu_afil} {help varname:x}
, {opt g:enerate}({help newvar})
[{opt r:eplace}
{opt t:abla}({help strings:string})
{opt vt:abla}({help varname})
{opt cotm:ujer}({help varname})
{opt agnov:ector}({it:#entero})
{opt vagnov:ector}({help varname})
{opt agnoa:ctual}({it:#entero})
{opt vagnoa:ctual}({help varname})
{opt f:siniestro}({it:#entero})
{opt vf:siniestro}({help varname})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt vrv}({help varname})
{opt vrp}({help varname})
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]
{p_end}

{p 8 17 2}
{cmdab:cnu_afili} {help integer:x} [
, {opt t:abla}({help strings:string})
{opt cotm:ujer}({it:#entero})
{opt agnov:ector}({it:#entero})
{opt agnoa:ctual}({it:#entero})
{opt f:siniestro}({it:#entero})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt pasos}
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]


{phang}
CNU para c{c o'}nyuge sin hijos.

{p 8 17 2}
{cmdab:cnu_cnyg_s_h} {help varname:x} {help varname:y}
, {opt g:enerate}({help newvar})
[{opt r:eplace}
{opt t:abla}({help strings:string})
{opt vt:abla}({help varname})
{opt tablab:enef}({help strings:string})
{opt vtablab:enef}({help varname})
{opt cotm:ujer}({help varname})
{opt conym:ujer}({help varname})
{opt agnov:ector}({it:#entero})
{opt vagnov:ector}({help varname})
{opt agnoa:ctual}({it:#entero})
{opt vagnoa:ctual}({help varname})
{opt f:siniestro}({it:#entero})
{opt vf:siniestro}({help varname})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt vrv}({help varname})
{opt vrp}({help varname})
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]
{p_end}

{p 8 17 2}
{cmdab:cnu_cnyg_s_hi} {help integer:x} {help integer:y}
[ ,{opt t:abla}({help strings:string})
{opt tablab:enef}({help strings:string})
{opt cotm:ujer}({it:#entero})
{opt conym:ujer}({it:#entero})
{opt agnov:ector}({it:#entero})
{opt agnoa:ctual}({it:#entero})
{opt f:siniestro}({it:#entero})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt pasos}
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]


{phang}
CNU pensi{c o'}n de sobrevivencia para c{c o'}nyuge sin hijos.

{p 8 17 2}
{cmdab:cnu_sobr_cnyg_s_h} {help varname:y}
, {opt g:enerate}({help newvar})
[{opt r:eplace}
{opt tablab:enef}({help strings:string})
{opt vtablab:enef}({help varname})
{opt conym:ujer}({help varname})
{opt agnov:ector}({it:#entero})
{opt vagnov:ector}({help varname})
{opt agnoa:ctual}({it:#entero})
{opt vagnoa:ctual}({help varname})
{opt f:siniestro}({it:#entero})
{opt vf:siniestro}({help varname})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt vrv}({help varname})
{opt vrp}({help varname})
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]
{p_end}

{p 8 17 2}
{cmdab:cnu_sobr_cnyg_s_hi} {help integer:y} [
, {opt tablab:enef}({help strings:string})
{opt conym:ujer}({it:#entero})
{opt agnov:ector}({it:#entero})
{opt agnoa:ctual}({it:#entero})
{opt f:siniestro}({it:#entero})
{opt norp}
{opt rv}({it:#real})
{opt rp}({it:#real})
{opt pasos}
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]


{phang}
Factor de Ajuste para Retiros Programados.

{p 8 17 2}
{cmdab:cnu_faj} {help varname:x} [{help varname:y}]
, {opt g:enerate}({help newvar})
[{opt r:eplace}
{opt edadm:axima}({it:#entero})
{opt vedadm:axima}({help varname})
{opt saldo}({it:#real})
{opt vsaldo}({help varname})
{opt pcent}({it:#real})
{opt vpcent}({help varname})
{opt rp0}({it:#real})
{opt vrp0}({help varname})
{opt cri:ter}({it:#real})
{opt maxi:ter}({it:#real})
{opt t:abla}({help strings:string})
{opt vt:abla}({help varname})
{opt tablab:enef}({help strings:string})
{opt vtablab:enef}({help varname})
{opt cotm:ujer}({help varname})
{opt conym:ujer}({help varname})
{opt agnov:ector}({it:#entero})
{opt vagnov:ector}({help varname})
{opt agnoa:ctual}({it:#entero})
{opt vagnoa:ctual}({help varname})
{opt f:siniestro}({it:#entero})
{opt vf:siniestro}({help varname})
{opt rp}({it:#real})
{opt vrp}({help varname})
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]
{p_end}

{p 8 17 2}
{cmdab:cnu_faji} {help integer:x} [ {help integer:y}
, {opt edadm:axima}({it:#entero})
{opt saldo}({it:#real})
{opt pcent}({it:#real})
{opt rp0}({it:#real})
{opt cri:ter}({it:#real})
{opt maxi:ter}({it:#real})
{opt t:abla}({help strings:string})
{opt tablab:enef}({help strings:string})
{opt cotm:ujer}({it:#entero})
{opt conym:ujer}({it:#entero})
{opt agnov:ector}({it:#entero})
{opt agnoa:ctual}({it:#entero})
{opt f:siniestro}({it:#entero})
{opt rp}({it:#real})
{opt pasos}
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]


{phang}
Proyecci{c o'}n de Retiro Programado (FAJ opcional).

{p 8 17 2}
{cmdab:cnu_proy_pensi} {help integer:x} [ {help integer:y} ]
, [
{opt g:enerate}({help newvarlist})
{opt cotm:ujer}({it:#entero})
{opt conym:ujer}({it:#entero})
{opt t:abla}({help strings:string})
{opt tablab:enef}({help strings:string})
{opt s:aldo}({it:#real})
{opt agnov:ector}({it:#entero})
{opt rp}({it:#real})
{opt agnoa:ctual}({it:#entero})
{opt f:siniestro}({it:#entero})
faj
{opt edadm:axima}({it:#entero})
{opt pcent}({it:#real})
{opt rp0}({it:#real})
{opt cri:ter}({it:#real})
{opt maxi:ter}({it:#real})
{opt dirt:ablas}({help strings:string})
{opt dirv:ectores}({help strings:string})]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{cmd:x, y}}Edad del afiliado y del c{c o'}nyuge respectivamente. 
Dependiendo si es c{c a'}lculo vectorial o escalar, ambos ser{c a'}n una 
{help varname:variable} o un {help integer:escalar} respectivamente.{p_end}

{syntab:Opciones Gen{c e'}ricas}
{synopt:{opt g:enerate}}Nombre de la variable a crear que contendr{c a'} el CNU.{p_end}
{synopt:{opt r:eplace}}En el caso de existir, reemplaza la variable especificada
en el argumento {opt g:enerate}.{p_end}
{synopt:{opt t:abla}}Nombre de la tabla de mortalidad a usar. Por defecto utiliza
la tabla rv2009.{p_end}
{synopt:{opt vt:abla}}Nombre de variable que contiene la tabla de mortalidad a usar. Por defecto utiliza
la tabla rv2009.{p_end}
{synopt:{opt cotm:ujer}}Variable dicot{c o'}mica. Contiene el sexo del cotizante
y es igual a 1 si es mujer y a 0 en el caso contrario.{p_end}
{synopt:{opt agnov:ector}}Entero. A{c n~}o del vector de c{c a'}lculo de Retiro
Programado.{p_end}
{synopt:{opt vagnov:ector}}Nombre de la variable que contiene el a{c n~}o del 
vector de c{c a'}lculo de Retiro Programado.{p_end}
{synopt:{opt agnoa:ctual}}Entero. A{c n~}o de c{c a'}lculo. Se utiliza para ajustar
las tablas de mortalidad. Por defecto corresponde al a{c n~}o del Sistema Operativo
(OS).{p_end}
{synopt:{opt vagnoa:ctual}}Nombre de la variable que contiene el a{c n~}o de 
c{c a'}lculo. Se utiliza para ajustar las tablas de mortalidad.{p_end}
{synopt:{opt f:siniestro}}Fecha de ocurrencia del siniestro {it:YYYYMMDD}.{p_end}
{synopt:{opt vf:siniestro}}Variable que contiene la fecha de ocurrencia del siniestro {it:YYYYMMDD}.{p_end}
{synopt:{opt norp}} (OPCION EN DESUSO) Desactiva el c{c a'}lculo de retiro programado (cual es el 
c{c a'}lculo por defecto).{p_end}
{synopt:{opt rv}}Real. Especifica el valor de la tasa para c{c a'}lculo de renta
vitalicia.{p_end}
{synopt:{opt rp}}Real. Especifica el valor de la tasa para c{c a'}lculo de retiro
programado.{p_end}
{synopt:{opt vrv}}Nombre de la variable que contiene la tasa para c{c a'}lculo de 
renta vitalicia.{p_end}
{synopt:{opt vrp}}Nombre de la variable que contiene la tasa para c{c a'}lculo de 
retiro programado.{p_end}
{synopt:{opt pasos}}Activa la impresi{c o'}n en pantalla de los pasos de calculo
(periodo a periodo) del CNU.{p_end}
{synopt:{opt dirt:ablas}}En el caso de que el usuario cuente con tablas personalizadas,
esta opci{c o'}n le permite indicar al comando donde debe buscar dichas tablas.{p_end}
{synopt:{opt dirv:ectores}}Al igual que las tablas, el usuario tambi{c e'}n puede
utilizar tablas distintas a las cargadas con el m{c o'}dulo.{p_end}

{syntab:C{c a'}lculo del CNU para beneficiario}
{synopt:{opt tablab:enef}}Nombre de la tabla de mortalidad a usar para los
beneficiarios no inv{c a'}lidos. Por defecto utiliza la tabla b2006.{p_end}
{synopt:{opt vtablab:enef}}Nombre de la variable que contiene la tabla de mortalidad a usar para los
beneficiarios no inv{c a'}lidos.{p_end}
{synopt:{opt conym:ujer}}Variable dicot{c o'}mica. Contiene el sexo del c{c o'}nyuge
y es igual a 1 si es mujer y a 0 en el caso contrario.{p_end}

{syntab:C{c a'}lculo del factor de ajuste (FAJ)}
{synopt:{opt edadm:axima}}Entero. Edad hasta la que el FAJ asegurar{c a'}
la pensi{c o'}n del afiliado. Por defecto se fija en 98.{p_end}
{synopt:{opt vedadm:axima}}Nombre de la variable que indica hasta que edad el FAJ asegurar{c a'}
la pensi{c o'}n del afiliado.{p_end}
{synopt:{opt saldo}}Real. Saldo del afiliado al momento del retiro. Por
defecto en 1, es decir, el FAJ se calcula en funci{c o'}n de %.{p_end}
{synopt:{opt vsaldo}}Nombre de la variable que contiene el saldo del afiliado al momento del retiro. Por
defecto en 1, es decir, el FAJ se calcula en funci{c o'}n de %.{p_end}
{synopt:{opt pcent}}Real. Porcentaje a cubrir de la primera pensi{c o'}n.
Por defecto se encuentra fijo en .3.{p_end}
{synopt:{opt vpcent}}Nombre de la variable que indica el porcentaje a cubrir de
la primera pensi{c o'}n.{p_end}
{synopt:{opt rp0}}Real. Pemsi{c o'}n de referencia. Por defecto calcula
como funci{c o'}n del saldo inicial y del CNU para el periodo 1.{p_end}
{synopt:{opt cri:ter}}Real. Precisi{c o'}n al momento de buscar el FAJ
{c o'}ptimo. Por defecto est{c a'} fijado en 1e-6.{p_end}
{synopt:{opt maxi:ter}}Entero. M{c a'}ximo n{c u'}mero de iteraciones
al momento de buscar el FAJ {c o'}ptimo. Por defecto est{c a'} fijo en 100.{p_end}

{syntab:Proyecci{c o'}n de pensiones}
{synopt:{opt faj}}Si activado, la pensi{c o'}n calculada incluir{c a'} FAJ.
Por defecto desactivado.{p_end}
{synopt:{opt g:enerate}}Nombre de las variables que se generar{c a'}n
(ver detalles).{p_end}

{synoptline}
{p2colreset}{...}

{title:Description}

{pstd}
{cmd:cnu_afil} Calcula el CNU para un afiliado soltero (o casado, el mismo aplica
para ambos [revisar la normativa vigente]) en forma vectorial (varias observaciones).
{cmd:cnu_afili} realiza el mismo c{c a'}lculo pero para s{c o'}lo un individuo
(c{c a'}lculo inmediato, ver {help ttesti}).
{p_end}

{pstd}
{cmd:cnu_cnyg_s_h} Calcula el CNU  para el c{c o'}nyuge sin hijos de
forma vectorial (varias observaciones). {cmd:cnu_cnyg_s_hi} lo hace de forma
inmediata para s{c o'}lo una observaci{c o'}n. El resultado de cualquiera de los
dos se debe sumar al de {cmd:cnu_afil} para calcular el CNU total que se utilizar{c a'}
en el c{c a'}lculo de la pensi{c o'}n.
{p_end}

{pstd}
{cmd:cnu_sobr_cnyg_s_h} Calcula el CNU de un c{c o'}nyuge sin hijos 
para una pensi{c o'}n de sobrevivencia de forma vectorial (varias observaciones). 
{cmd:cnu_sobr_cnyg_s_hi} lo hace de forma inmediata para s{c o'}lo una observaci{c o'}n.
{p_end}

{pstd}
{cmd:cnu_faj} Calcula el Factor de Ajuste para Retiros Programados ya sea con o sin
c{c o'}nyuge de forma vectorial (varias observaciones). {cmd:cnu_faji} lo hace de
forma inmediata. Las opciones {opt criter} y {opt maxiter} son utilizadas para ajustar
el proceso de optimizaci{c o'}n que ejecuta el comando para encontrar el FAJ
{c o'}ptimo; el cual es resuelto utilizando un {c a'}rbol de b{c u'}squeda binaria.
{p_end}

{pstd}
En el caso del comando {cmd:cnu_proy_pensi}, luego de realizar los c{c a'}lculos
se requiere de un listado con el nombre de las variables resultantes que ser{c a'}n
guardadas en el set de datos actual, esto se hace a trav{c e'}s del comando {help svmat}.
{p_end}

{pstd}
Las opciones {opt fsiniestro} y {opt vfsiniestro} se puede utilizar en el caso de que
el usuario requiera asignar las tablas de mortalidad de manera din{c a'}mica a cada
una de las observaciones utilizando como referencia las fechas de vigencia de cada
tabla de mortalidad seg{c u'}n la normativa.
{p_end}

{pstd}
Las opciones {opt vtabla}, {opt vtablabenef}, {opt vagnovector}, {opt vagnoactual},
{opt vrv} y {vfsiniestro} pueden ser utilizadas en el caso de que, por ejemplo, se
requiera calcular CNU con vectores diferentes para cada uno de los individuos; o
que el a{c n~}o actual tambi{c e'}n sea diferente entre observaciones; o que al
calcular una Renta Vitalicia se requiera aplicar una distinta tasa para cada observaci{c o'}n
de la base de datos.
{p_end}

{title:Tablas y vectores disponibles}

{dlgtab:Tablas de mortalidad}

{pstd}Por motivos de eficiencia en velocidad, las tablas se almacenan como archivos
binarios en la carpeta {ccl sysdir_plus}c bajo la siguiente modalidad:

        {it:{ccl sysdir_plus}c/cnu_tabmor_}{bf:[{it:tipo}][{it:a{c n~}o}][{it:g{c e'}nero}]}
	
{pstd}
as{c i'}, por ejemplo, la tabla de mortalidad RV para hombres del 85' se encuentra
bajo el siguiente nombre

        {it:{ccl sysdir_plus}c/}{bf:cnu_tabmor_rv1985h}
		
{pstd} En el caso de que el usuario desee a{c n~}adir una tabla nueva u importar
desde el archivo binario, el m{c o'}dulo cuenta con dos funciones para tales acciones:
(1) {cmd:cnu_save_tab_mort} (permite generar tus propias tablas); y (2)
{cmd:cnu_get_tab_mort} (permite importar tablas a Mata). Ambas funciones se
llaman desde mata, {it:i.e} utilizando el prefijo {cmd:mata:}. Las funciones
se definen como sigue.{p_end}

{pstd}
{bf:{ul:Syntax}}{p_end}

{p 8 8 2}
{it:void}{bind:          }
{cmd:cnu_save_tab_mort(}{it:tabla}, {it:agno}, {it:genero}, {it:tipo} {cmd:[}, {it:path}, {it:replace}{cmd:])}{p_end}

{p 8 8 2}
{it:real colvector}
{cmd:cnu_get_tab_mort(}{it:agno}, {it:genero}, {it:tipo} {cmd:[}, {it:path}{cmd:])}{p_end}


{pstd}
donde

           {it:tabla}:  {it:real matrix}   contiene la tabla de mortalidad
		   
            {it:agno}:  {it:real scalar}   contiene el n{c u'}mero del a{c n~}o de la tabla

          {it:genero}:  {it:string scalar} contiene {cmd:"h"} (hombre) o {cmd:"m"} (mujer)

            {it:tipo}:  {it:string scalar} contiene {cmd:"rv"} (RV), {cmd:"b"} (beneficiario) o {cmd:"mi"} (invalidez)

            {it:path}:  {it:string scalar} (Opcional) contiene la direcci{c o'}n de la tabla (archivo binario)
			
         {it:replace}:  {it:real scalar}   (Opcional) es 1 si se desea reemplazar la tabla existente ({cmd:mt_cnu_save_tab_mort})


{pstd}
Actualmente el comando cuenta con las siguientes tablas de mortalidad pre-cargadas:{p_end}

{synoptset 19 tabbed}{...}
{synopthdr:Tabla}
{synoptline}
{syntab:Archivo}
{synopt :{opt cnu_tabmor_rv1985h}}RV de 1985 para afiliados hombres{p_end}
{synopt :{opt cnu_tabmor_rv1985m}}RV de 1985 para afiliados mujeres{p_end}
{synopt :{opt cnu_tabmor_rv2004h}}RV de 2004 para afiliados hombres{p_end}
{synopt :{opt cnu_tabmor_rv2004m}}RV de 2004 para afiliados mujeres{p_end}
{synopt :{opt cnu_tabmor_rv2009h}}RV de 2009 para afiliados hombres{p_end}
{synopt :{opt cnu_tabmor_rv2009m}}RV de 2009 para afiliados mujeres{p_end}
{synopt :{opt cnu_tabmor_b1985h}}B de 1985 para beneficiarios hombres{p_end}
{synopt :{opt cnu_tabmor_b1985m}}B de 1985 para beneficiarios mujeres{p_end}
{synopt :{opt cnu_tabmor_b2006h}}B de 2006 para beneficiarios hombres{p_end}
{synopt :{opt cnu_tabmor_b2006m}}B de 2006 para beneficiarios mujeres{p_end}
{synopt :{opt cnu_tabmor_mi1985h}}MI de 1985 para personas con discapacidad hombres{p_end}
{synopt :{opt cnu_tabmor_mi1985m}}MI de 1985 para personas con discapacidad mujeres{p_end}
{synopt :{opt cnu_tabmor_mi2006h}}MI de 2006 para personas con discapacidad hombres{p_end}
{synopt :{opt cnu_tabmor_mi2006m}}MI de 2006 para personas con discapacidad mujeres{p_end}
{synoptline}
{p2colreset}{...}


{dlgtab:Vectores de tasas}

{pstd}Al igual que las tablas de mortalidad, los vectores almacenan como archivos
binarios en la carpeta {ccl sysdir_plus}c bajo la siguiente modalidad:

        {it:{ccl sysdir_plus}c/cnu_}{bf:{it:vec}[{it:a{c n~}o}]}
	
{pstd}
as{c i'}, por ejemplo, el vector de tasas del a{c n~}o 2013 se encuentra
bajo el siguiente nombre

        {it:{ccl sysdir_plus}c/cnu_}{bf:vec2013}
		
{pstd} En el caso de que el usuario desee a{c n~}adir un nuevo vector o importar
desde el archivo binario, el m{c o'}dulo cuenta con dos funciones para tales acciones:
(1) {cmd:cnu_save_vec_tasas} (permite generar tus propios vectores); y (2)
{cmd:cnu_get_vec_tasas} (permite importar vectores a Mata). Al igual que en el
caso de las tablas de mortalidad, ambas funciones se llaman desde mata, {it:i.e}
utilizando el prefijo {cmd:mata:}. Las funciones se definen como sigue.{p_end}

{pstd}
{bf:{ul:Syntax}}{p_end}

{p 8 8 2}
{it:void}{bind:          }
{cmd:cnu_save_vec_tasas(}{it:tabla}, {it:agno} {cmd:[}, {it:path}, {it:replace}{cmd:])}{p_end}

{p 8 8 2}
{it:real colvector}
{cmd:cnu_get_vec_tasas(}{it:agno} {cmd:[}, {it:path}{cmd:])}{p_end}


{pstd}
donde

           {it:tabla}:  {it:real matrix}   contiene el vector de tasas
		   
            {it:agno}:  {it:real scalar}   contiene el n{c u'}mero del a{c n~}o del vector

            {it:path}:  {it:string scalar} (Opcional) contiene la direcci{c o'}n del vector (archivo binario)
			
         {it:replace}:  {it:real scalar}   (Opcional) es 1 si se desea reemplazar el vector existente ({cmd:mt_cnu_save_vec_tasas})


{pstd}
Actualmente el comando cuenta con los siguientes vectores de tasas pre-cargadas:{p_end}

{synoptset 19 tabbed}{...}
{synopthdr:Vector}
{synoptline}
{syntab:Archivo}
{synopt :{opt cnu_vec2009}}Vector de tasas del 2009{p_end}
{synopt :{opt cnu_vec2010}}Vector de tasas del 2010{p_end}
{synopt :{opt cnu_vec2011}}Vector de tasas del 2011{p_end}
{synopt :{opt cnu_vec2012}}Vector de tasas del 2012{p_end}
{synopt :{opt cnu_vec2013}}Vector de tasas del 2013{p_end}
{synoptline}
{p2colreset}{...}

{title:Ejemplos}
{dlgtab:Forma vectorial} 

{pstd}CNU de Retiro Programado para afiliado soltero{p_end}
{phang2}{cmd:. cnu_afil edad_afiliado, g(cnu_soltero)}
{p_end}

{pstd}CNU de Retiro Programado para afiliado soltero con vector 2011 calculado
en el a{c n~}o 2011{p_end}
{phang2}{cmd:. cnu_afil edad_afiliado, g(cnu_soltero2011)  agnoa(2011) agnov(2011)}
{p_end}

{pstd}CNU de Retiro Programado para c{c o'}nyuge (sin hijos) de afiliado con
vector 2011 calculado en el a{c n~}o 2011. El resultado lo adicionamos a {cmd:cnu_soltero2011}
para obtener el CNU total.{p_end}
{phang2}{cmd:. cnu_cnyg_s_h edad_afiliado edad_conyuge, g(cnu_conyuge2011) agnoa(2011) agnov(2011)}{p_end}
{phang2}{cmd:. gen cnu2011 = cnu_soltero2011 + cnu_conyuge2011}{p_end}

{pstd}Simulando como cambiar{c i'}a el CNU de Retiro Programado para un mismo 
afiliado a medida que envejece. Utilizaremos la opci{c o'}n {opt vagnoa:ctual}
con la variable {cmd:tiempo} (contiene a{c n~}os).{p_end}
{phang2}{cmd:. cnu_afil edad_afiliado , g(evol_cnu) vagnoa(tiempo) agnov(2011)}{p_end}

{dlgtab:Forma escalar} 

{pstd}CNU de Retiro Programado para afiliado soltero con 65 a{c n~}os{p_end}
{phang2}{cmd:. cnu_afili 65}{p_end}
{phang2}{it:   ({stata cnu_afili 65:click para ejecutar})}{p_end}
{txt}
{phang2}CNU para RP sin conyuge sin hijos (tabla rv2009) y vector 2013 en el a{c n~}o 2013{p_end}
{phang2}13.016880{p_end}{txt}

{pstd}CNU de Retiro Programado (con tasa) para afiliado soltero con 65 a{c n~}os{p_end}
{phang2}{cmd:. cnu_afili 65, rp(.0366)}{p_end}
{phang2}{it:   ({stata cnu_afili 65, rp(0.0366):click para ejecutar})}{p_end}
{txt}
{phang2}CNU RP para soltero sin hijos (tabla rv2009), tasa 3.66% en el a�o 2014{p_end}
{phang2}13.377540{p_end}{txt}


{pstd}CNU de Retiro Programado para afiliado soltero con 65 a{c n~}os con vector 2011 calculado
en el a{c n~}o 2011{p_end}
{phang2}{cmd:. cnu_afili 65, agnoa(2011) agnov(2011)}{p_end}
{phang2}{it:   ({stata cnu_afili 65, agnoa(2011) agnov(2011):click para ejecutar})}{p_end}
{txt}
{phang2}CNU para RP sin conyuge sin hijos (tabla rv2009) y vector 2011 en el a{c ~n}o 2011{p_end}
{phang2}12.862230{p_end}
{txt}

{pstd}CNU de Retiro Programado para c{c o'}nyuge (sin hijos) de afiliado con vector 
2011 calculado en el a{c n~}o 2011.{p_end}
{phang2}{cmd:. cnu_cnyg_s_hi 65 63, agnoa(2011) agnov(2011)}{p_end}
{phang2}{it:   ({stata cnu_cnyg_s_hi 65 63, agnoa(2011) agnov(2011):click para ejecutar})}{p_end}
{txt}
{phang2}CNU para RP con conyuge sin hijos (tabla rv2009) y vector 2011 en el a{c ~n}o 2011{p_end}
{phang2}2.231859{p_end}
{txt}


{pstd}FAJ para afiliado soltero de 65 con RP de 3%.{p_end}
{phang2}{cmd:. cnu_faji 65, rp(.03)}{p_end}
{phang2}{it:   ({stata cnu_faji 65, rp(.03):click para ejecutar})}{p_end}
{txt}
{phang2}FAJ para afiliado soltero (tabla 2009rv) tasa .03 en 2014.{p_end}
{phang2}0.066178{p_end}
{txt}

{pstd}FAJ para afiliado de 65 con conyuge de 62 con vector del 2013.{p_end}
{phang2}{cmd:. cnu_faji 65 62, agnov(2013) rp(.03)}{p_end}
{phang2}{it:   ({stata cnu_faji 65 62, agnov(2013) rp(.03):click para ejecutar})}{p_end}
{txt}
{phang2}FAJ para afiliado con conyuge (tabla rv2009 b2006) tasa .03 en 2014.{p_end}
{phang2}0.013094{p_end}
{txt}

{title:Author}

{pstd}
George Vega Yon, Superindentencia de Pensiones. {browse "mailto:gvega@spensiones.cl"}
{p_end}
{pstd}
Eugenio Salvo Cifuentes, Superindentencia de Pensiones. {browse "mailto:esalvo@spensiones.cl"} (colaborador)
{p_end}
{pstd}
Jorge Miranda Pinto, Superindentencia de Pensiones. {browse "mailto:jmiranda@spensiones.cl"} (colaborador)
{p_end}

{title:References}

{pstd}
Compendio de la Superintendencia de Pensiones (Libro III Beneficios Previsionales), Anexo N 7 (Capitales necesarios) {browse "http://www.spensiones.cl/compendio/577/w3-propertyvalue-3262.html"}
{p_end}

{title:C{c o'}digo de fuente {cmd:mata}}

{pstd}
Todas las rutinas para calcular CNU fueron programadas en {cmd:mata} y posteriormente
compiladas en el archivo {cmd:lcnu.mlib}. Por este motivo, a diferencia de los archivos
ado, el c{c o'}digo contenido en {cmd:lcnu.mlib} no puede ser observado de manera diracta
por lo que se ha puesto a disposici{c o'}n del usuario el archivo de ayuda {cmd:{help cnu_source:cnu_source.hlp}},
el cual contiene una copia del c{c o'}digo de fuente de las rutinas en el archivo mlib.

{pstd}
Puede acceder a secciones del c{c o'}digo de fuente siguiendo los siguientes links:

{pstd}
{bf:C{c a'}lculo del CNU ({it:cnu_1_1.mata}, {it:cnu_2_1.mata} y {it:cnu_2_2.mata})}

        CNU de sobrevivencia para c{c o'}nyuge sin hijos {bf:cnu_1_1.mata} ({help cnu_source##cnu_1_1:escalar}), ({help cnu_source##cnu_1_1_vec:vectorial})
        CNU de c{c o'}nyuge sin hijos {bf:cnu_2_1.mata} ({help cnu_source##cnu_2_1:escalar}), ({help cnu_source##cnu_2_1_vec:vectorial})
        CNU de afiliado soltero sin hijos {bf:cnu_2_2.mata} ({help cnu_source##cnu_2_2:escalar}), ({help cnu_source##cnu_2_2_vec:vectorial})

{pstd}
{bf:Funciones utilitarias ({it:utils.mata})}
 
        Guardar tabla de mortalidad en archivo binario {help cnu_source##cnu_save_tab_mort:cnu_save_tab_mort()}
        Cargar (en mata) tabla de mortalidad {help cnu_source##cnu_get_tab_mort:cnu_get_tab_mort()}
        Guardar vector de tasas en archivo binario {help cnu_source##cnu_save_vec_tasas:cnu_save_vec_tasas()}
        Cargar (en mata) vector de tasas {help cnu_source##cnu_get_vec_tasas:cnu_get_vec_tasas()}
        Mejoramiento de tablas de mortalidad {help cnu_source##cnu_mejorar_tabla:cnu_mejorar_tabla()}
        Determinar qu{c e'} a{c n~}o de tabla le corresponde {help cnu_source##cnu_which_tab_mort:cnu_which_tab_mort()}
        Exportar matriz de mata a archivo de texto plano {help cnu_source##export_tab:export_tab()}
