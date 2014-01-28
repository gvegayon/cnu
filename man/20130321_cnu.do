/* correr con 
cd I:\george\comandos_paquetes_librerias\stata\cnu\man
texdoc do 20130321_cnu.do, replace init(20130321_cnu.tex) close
texify 20130321_cnu.tex
*/

clear all

/*tex
\documentclass[letterpaper, 11pt]{article}

\usepackage{stata} % Requiere instalacion manual, "findit sjlatex"

\usepackage[margin=2.5cm]{geometry}

\usepackage{tabularx, booktabs}
\usepackage{float}
\usepackage[pagebackref]{hyperref}
\usepackage{graphicx, geometry}
\usepackage{setspace}
\setlength{\parskip}{0.25cm}
\usepackage{apacite}
\usepackage{amsmath}
\usepackage[spanish]{babel}

\title{Nota t\'ecnica \\[2cm] Capital Necesario Unitario (CNU):\\ C\'alculo e Introducci\'on
del M\'odulo de Stata {\tt cnu}}

\author{George Vega
\thanks{Analista de Investigaci\'on, \href{mailto:gvega@spensiones.cl}{gvega@spensiones.cl}.
El autor agradece los comentarios del equipo del Departamento de Investigaci\'on
de la Divisi\'on de Estudios. Cualquier error es de responsabilidad del autor.}
\\Divisi\'on de Estudios\\Superintendencia de Pensiones}

\date{Enero 2014}

\begin{document}

\maketitle

\begin{abstract}
La siguiente nota t\'ecnica describe en detalle c\'omo calcular el capital que
necesita un afiliado del sistema de pensiones para financiar una unidad de 
pensi\'on, el Capital Necesario Unitario (CNU). En \'este, se detalla el tratamiento
de las Tablas de Mortalidad en cuanto a su mejoramiento (ajuste) y al c\'alculo
del n\'umero de sobrevivientes. Adem\'as se detalla la f\'ormula de c\'alculo del
CNU para tres casos: (1) Afiliado soltero sin hijos; (2) C\'onyuge sin hijos; y (3)
Pensi\'on de sobrevivencia para c\'onyuge sin hijos. El documento finaliza con
la introducci\'on y ejemplos de uso del m\'odulo de Stata {\tt cnu}, el cual fue
desarrollado por la Divisi\'on de Estudios y testeado en conjunto con la Divisi\'on
de Administraci\'on Interna e Inform\'atica (autores del equivalente en lenguaje
{\tt C}), que tiene por objetivo permitir realizar c\'alculos masivo de CNU.
\end{abstract}

\clearpage

\tableofcontents

\section{Introducci\'on}

El Capital Necesario Unitario (CNU) se utiliza para calcular el monto del pago de
pensiones. En particular, el monto que un afiliado recibir\'a como pensi\'on mensual
se determina dividiendo su saldo total de ahorro previsional por doce veces el CNU
($Saldo/(CNU\times 12)$). El Capital Necesario se determina en base a (1) las
expectativas de vida del afiliado y sus beneficiarios, y (2) las expectativas de
rentabilidad de los Fondos de Pensiones.

Las expectativas de vida del afiliado y sus beneficiarios se calculan en base a las 
Tablas de Mortalidad publicadas en conjunto por la Superintendencia de Valores y
Seguros (SVS) y la Superintendencia de Pensiones (SP).\footnote{Un registro 
hist\'orico de las Tablas de Mortalidad puede encontrarlo en el Compendio de Normas
del Sistema de pensiones (\citeNP{compIIIcapX})} Estas son permanentemente evaluadas
en cuanto a la medida en la que se ajustan a la mortalidad efectiva de la poblaci\'on.

Por su parte, en el caso del Retiro Programado, hasta diciembre de 2013, las expectativas
de rentabilidad de los Fondos de Pensiones se materializaban a trav\'es del Vector
de Tasas de Inter\'es (Vector de Tasas), el cual a contar de enero del 2014 
fue reemplazado por un tasa \'unica, la cual es revisada trimestralmente. 
Al igual que las Tablas de Mortalidad,
estas tasas (vector y tasa \'unica) son calculadas por la Superintendencia de Valores y Seguros
y la Superintencia de Pensiones, y publicadas por la
SP.\footnote{La tasa vigente se encuentra publicada en el Centro de 
Estad\'isticas de la Superintendencia de Pensiones. Puede acceder aqu\'i 
\url{http://www.spensiones.cl/safpstats/stats/.menu.selector.php?_mscfg=tasas_descto_interes}}
A de las tasas mencionadas y las Tablas de Mortalidad, la tasa que se utiliza
para el c\'alculo de una Renta Vitalicia no es \'unica, m\'as a\'un, la determinan
las Compa\~nias Aseguradoras que ofrecen las Rentas Vitalicias; la oferta promedio
es publicada mes a mes en el Centro de Esta\'isticas
de la SP.\footnote{
Puede revisar las tasas medias en el siquiente link:
\url{http://www.spensiones.cl/safpstats/stats/.menu.selector.php?_url=/tasas/tirenvit.php&_msid=3&_mscfg=tasas_descto_interes}}

Las f\'ormulas utilizadas para el c\'alculo del CNU, aunque matem\'aticamente
sencillas, pueden ser dif\'iciles de implementar, sobre todo cuando tomamos en
cuenta que las Tablas de Mortalidad incorporan factores de ajuste que, en t\'erminos
sencillos, se utilizan durante todo el proceso de c\'alculo. Motivado por esto
\'ultimo punto, la Superintendencia de Pensiones ha desarrollado el m\'odulo
\texttt{cnu}; una extensi\'on del paquete estad\'istico Stata ideada para
investigadores que permite calcular Capitales Necesarios de manera sencilla y
eficiente. El m\'odulo cuenta con todas las Tablas de Mortalidad del Sistema y
todos los Vectores de Tasas de Inter\'es publicados a la fecha, adem\'as de una
amplia gama de opciones para poder calcular Capitales Necesarios tanto de manera
escalar (uno a uno) como vectorial (c\'alculos masivos). Herramientas como \'esta 
son fundamentales para la investigaci\'on y an\'alisis del sistema de pensiones.


El documento se desarrolla como sigue: En la primera secci\'on se explica como
se utilizan las Tablas de Mortalidad en la f\'ormula del CNU, desarrollando paso
a paso el c\'alculo de las expectativas de vida y su ajuste usando los factores
que esta provee. En la siguiente secci\'on se desarrollan las f\'ormulas de 
c\'alculo de tres tipos de CNU, para afiliado soltero sin hijos, para 
c\'onyuge sin hijos y de sobrevivencia para c\'onyuge sin hijos. El
documento finaliza con una descripci\'on detallada del m\'odulo {\tt cnu}, 
junto con algunos ejemplos que muestran en detalle los pasos de c\'alculo.

\section{Tablas de mortalidad}

Las tablas de mortalidad describen la mortalidad de una poblaci\'on en particular
mostrando la probabilidad de que un individuo de edad $x$ muera antes de cumplir la edad $x+1$, $q$. 
Estas se utilizan para (1) c\'alculo de pensi\'on por Retiro Programado (RP), y (2)
c\'alculo de reservas t\'ecnicas para Renta Vitalicia (RV).
En el caso del sistema de pensiones
chileno, tales tablas han sido elaboradas para seis grupos, distinguiendo entre
g\'eneros: (1-2) afiliados, (3-4) beneficiarios e (5-6) inv\'alidos;
denominadas como las tablas RV, B y MI respectivamente tanto para hombres como para
mujeres; todas construidas en base de los afiliados pensionados y sus
beneficiarios. Motivo por el cual no representan las expectativas de vida de toda
la poblaci\'on.

Bajo la responsabilidad de la Superintendencia de Valores y Seguros 
y de esta Superintendencia, despu\'es de la reforma del 2008 las tablas de mortalidad
son revisadas anualmente donde, dependiendo de su adecuaci\'on a la longevidad
de los pensionados y sus beneficiarios, pueden ser prorrogadas o reemplazadas por tablas nuevas.

Considerando que la mortalidad de la poblaci\'on es cambiante en el tiempo (tabla
de mortalidad din\'amica) la probabilidad de muerte a la edad $x$ ($q_x$) se puede ajustar utilizando el factor
de mejoramiento correspondiente a cada edad $x$, $AA_x$. En t\'erminos concretos,
la probabilidad de muerte mejorada $q_x'$, en el a\~no $t_j$ (que luego consideraremos como a\~no
de jubilaci\'on) para la tabla del a\~no $t_m$ se puede escribir como

\begin{equation*}
q_x' = q_x \times (1 - AA_x)^{(t_j - t_m)}
\end{equation*}

Considerando que el c\'alculo del $CNU$ depende los $t$ a\~nos transcurridos desde el
a\~no de jubilaci\'on, la mortalidad mejorada $t$ a\~nos despu\'es de la edad
de jubilaci\'on se describe como

\begin{equation}\label{eq:mejoramiento}
q_{x+t}' = q_{x+t} \times (1 - AA_{x+t})^{(t_j - t_m + t)}
\end{equation}

Tomemos como ejemplo una mujer que se
jubila por vejez el a\~no 2013 a los 60 a\~nos de edad, para la cual utilizaremos la tabla
RV 2009 M. El valor de $q_{60}$ se deber\'a ajustar como sigue

\begin{equation*}
\begin{array}{rl}
q_{60}' & = q_{60} \times (1 - AA_{60})^{(2013 - 2009 + 0)} \\
q_{60}' & = q_{60} \times (1 - AA_{60})^{4}
\end{array}
\end{equation*}

\noindent de la misma manera $q_{61}'$, $q_{62}'$, $q_{63}'$, $\dots$, $q_{T}'$ se ajustan como sigue

\begin{equation*}
\begin{array}{rl}
q_{61}' & = q_{61} \times (1 - AA_{61})^{5} \\
q_{62}' & = q_{62} \times (1 - AA_{62})^{6} \\
q_{63}' & = q_{63} \times (1 - AA_{63})^{7} \\
\vdots \\
q_{x+T}' & = q_{x+T} \times (1 - AA_{x+T})^{2013 - 2009 + T} 
\end{array}
\end{equation*}

\noindent con lo que se explicita que el \emph{envejecimiento} de la tabla 
se aplica de manera progresiva. Los c\'alculos correspondientes a este ejercicio
se muestran en el siguiente cuadro:

\begin{table}[H]
\centering
\caption{Ejemplo de c\'alculo de mejoramiento\label{eq:ejemplo_mejoramiento}}
\begin{tabular}{lccrl}
\toprule
$x$ & $q_{x}$ & $AA_{x}$ & $q_{x} \times (1 - AA_{x})^{[(t_j - t_m) + t]}=$&$q_{x}'$ \\
\midrule
tex*/
mata 
/* Rescatando valores */
tabmort = (cnu_get_tab_mort(2009,"m","rv"))[60..63,.]
edades = tabmort[.,1]
qx = tabmort[.,2]
aa = tabmort[.,3]

/* Mejorando tabla */
tabmej = cnu_mejorar_tabla(edades, qx, aa, 2009, 2013, 60)

tabla = edades, qx, aa, tabmej

for(i=1;i<=rows(tabla);i++) {
	linea = sprintf("%g & $%8.6f$ & $%6.4f$ & $ %8.6f \\times (1 - %6.4f)^{(2013 -2009 +%g)} $ & $%8.6f$ \\\\", tabla[i,1], tabla[i,2], tabla[i,3], tabla[i,2], tabla[i,3], i-1, tabla[i,4])
	linea
	stata("tex "+linea)
}
end


/*tex
\bottomrule
%\multicolumn{5}{l}{Nota: Moralidad para afiliada calculada a los 60, 61 y 62 a\~nos.}
\end{tabular}
\end{table}

\noindent tales valores ajustados--\'ultima columna de la tabla--ser\'an utilizados
en el c\'alculo de la probabilidad de sobrevida en el Cuadro \ref{eq:ejemplo_sobrevida}.

En la siguiente secci\'on revisaremos c\'omo la mortalidad bruta mejorada se
incorpora en el c\'alculo del n\'umero de sobrevivientes $l$.

\subsection{N\'umero de sobrevivientes}

El n\'umero de individuos sobrevivientes a la edad $x$, $l_x$, se calcula
utilizando las tablas de mortalidad, en particular

\begin{equation}\label{eq:prop_de_sobrevivientes}
l_x = l_{x - 1} \times (1 - q_{x-1})
\end{equation}

Tomando un ejemplo de \citeA[p.~2]{edwards1997}, dada una poblaci\'on de $1000$
individuos de 65 a\~nos de edad, y las mortalidades descritas en la siguiente
tabla, el n\'umero de sobrevivientes deber\'ia evolucionar seg\'un el siguiente
esquema:

\begin{table}[H]
\centering
\caption{Ejemplo de c\'alculo de sobrevivientes}
\begin{tabular}{lcrl}
\toprule
$x$ & $q_x$& $l_{x-1}\times(1-q_{x-1})=$ & $l_x$ \\ \midrule
66 & $0.3$ & $1000 \times (1 - 0.2)=$ & $800$ \\
67 & $0.5$ & $800 \times (1 - 0.3)=$   & $560$ \\
68 & $1.0$ & $560 \times (1 - 0.5)=$   & $280$ \\ \bottomrule
\end{tabular}
\end{table}

Al momento de calcular Capitales Necesarios, si consideramos el n\'umero
de sobrevivientes iniciales como igual a 1, el n\'umero de
sobrevivientes se puede entender como la probabilidad de sobrevida que tiene un
individuo de edad $x$, $t$ a\~nos despu\'es de su jubilaci\'on. De esta forma,
lo que escribimos en la ecuaci\'on \ref{eq:prop_de_sobrevivientes} puede reescribirse
como

\begin{equation*}
\begin{array}{rl}
l_{x+1} & = l_{x}\times(1 - q_{x}') \\
l_{x+2} & = l_{x}\times(1 - q_{x}')\times(1 - q_{x+1}') \\
\vdots \\
l_{x+t} & = l_{x}\times(1 - q_{x}')\times(1 - q_{x+1}') \times \dots \times (1 - q_{x + t}')
\end{array}
\end{equation*}

\noindent lo que se puede resumir como

\begin{equation}
l_{x+t} = l_{x} \times \prod_{i=1}^{t}{(1 - q_{x + i}')}
\end{equation}

%\noindent donde $q_{x-1+t}'$ corresponde a la probabilidad bruta de muerte ajustada
%de un individuo de edad $x$, $t$ a\~nos despu\'es de su jubilaci\'on.

Continuando con el \hyperref[eq:ejemplo_mejoramiento]{ejemplo de mejoramiento},
utilizando los valores de $q'$ all\'i calculados, calcularemos los primeros tres
valores de $l_{x+t}$ ($l_{61}$, $l_{62}$ y $l_{63}$):

\begin{table}[H]
\centering
\caption{Ejemplo de c\'alculo de probabilidad de sobrevida\label{eq:ejemplo_sobrevida}}
\begin{tabular}{lccrl}
\toprule
$x$ & $q_{x-1}'$ & $l_{x-1}$ & $l_{x-1}\times(1 - q_{x-1}')=$ & $l_{x}$ \\
\midrule
60 & \multicolumn{3}{c}{\dots \footnotesize Se asume parte con $l_{60}= 1$ \dots} & 1 \\
tex*/

mata
l=1
for(i=2;i<=rows(tabla);i++) {
	if (l==1) linea = sprintf("%g & $%8.6f$ & $%g   $ & $%g    \\times (1 - %8.6f) =$ & $%8.6f$ \\\\ ", tabla[i,1], tabla[i-1,4], l, l, tabla[i-1,4], l*(1-tabla[i-1,4]))
	else      linea = sprintf("%g & $%8.6f$ & $%8.6f$ & $%8.6f \\times (1 - %8.6f) =$ & $%8.6f$ \\\\ ", tabla[i,1], tabla[i-1,4], l, l, tabla[i-1,4], l*(1-tabla[i-1,4]))
	l = l*(1-tabla[i-1,4])
	linea
	stata("tex "+linea)
}
end

/*tex
\bottomrule
\multicolumn{5}{l}{\footnotesize Nota: Los valores de $q_x'$ son resultado de lo calculado en el Cuadro \ref{eq:ejemplo_mejoramiento}}
\end{tabular}
\end{table}

\noindent Finalmente, para este caso la serie completa de $l_x$ se puede
apreciar en el \hyperref[sec:ej:cnu_afili]{primer ejemplo de uso del m\'odulo {\tt cnu}}
que se encuentra en la secci\'on \ref{sec:ej:cnu_afili}.

\subsection{Vigencia de las Tablas de Mortalidad}

A continuaci\'on se muestra un cuadro resumen que indica el periodo de vigencia
de las tablas de mortalidad:

\def\colwid{.25\linewidth}

\begin{table}[H]
\caption{Vigencia Tablas de Mortalidad\label{tab:cnu_vejez}}
\scalebox{.8}{
\begin{tabular}{m{.25\linewidth}<\raggedleft*{6}{m{.125\linewidth}<\centering}}
\toprule
& \multicolumn{2}{m{\colwid}<\centering}{Afiliado no Inv\'alido} & \multicolumn{2}{m{\colwid}<\centering}{Beneficiario no Inv\'alido} & \multicolumn{2}{m{\colwid}<\centering}{Inv\'alido} \\
\cmidrule(r){2-3} \cmidrule(r){4-5} \cmidrule(r){6-7}
Fecha del Siniestro         & Hombre    & Mujer     & Hombre   & Mujer     & Hombre    & Mujer  \\ \midrule
(;31-01-2005$]$             & RV 85 H   & RV 85 M   & B 85 H   & B 85 M    & MI 85 H   & MI 85 M \\
$[$01-02-2005;31-01-2008$]$ & RV 2004 H & RV 2004 M & B 85 H   & B 85 M    & MI 85 H   & MI 85 M \\
%$[$01-09-2007;16-01-2010$]$ & RV 2004 H & RV 2004 M & B 85 H   & B 85 M    & MI 85 H   & MI 85 M \\
$[$01-02-2008;30-06-2010$]$ & RV 2004 H & RV 2004 M & B 2006 H & B 2006 M  & MI 2006 H & MI 2006 M \\
$[$01-07-2010;)             & RV 2009 H & RV 2009 M & B 2006 H  & B 2006 M & MI 2006 H & MI 2006 M \\
\bottomrule
\multicolumn{7}{l}{\small Nota: Las tablas de invalidez aplican tanto para afiliados como para beneficiarios}
\end{tabular}}
\end{table}

Para obtener informaci\'on respecto al proceso de transici\'on entre tablas puede
revisar los siguientes cap\'itulos del Libro III del Compendio de Normas del Sistema
de Pensiones:

\begin{itemize}
\item Cap\'itulo II. Aplicaci\'on de la Tabla de mortalidad RV - 2004 \url{http://www.spensiones.cl/compendio/577/w3-propertyvalue-4347.html}
\item Cap\'itulo IV. Aplicaci\'on de las tablas de mortalidad B- 2006 Y MI-2006 \url{http://www.spensiones.cl/compendio/577/w3-propertyvalue-3537.html}
\item Cap\'itulo VI. Aplicaci\'on Tablas de mortalidad RV - 2009 en el c\'alculo de los Retiros Programados de pensionados por vejez \url{http://www.spensiones.cl/compendio/577/w3-propertyvalue-4349.html}
\end{itemize}

En el caso de pensi\'on de invalidez, para los beneficiarios aplican las mismas
tablas de invalidez que utilizan los afiliados inv\'alidos. 

Para m\'as informaci\'on acerca de la formalidad de las tablas de mortalidad
se recomienda ver \citeA{edwards1997}.

\section{Capitales Necesarios}

El capital necesario unitario es el capital que necesita el afiliado para financiar
una unidad de pensi\'on, tanto para \'el como para sus posibles beneficiarios. Es
la suma de los capitales necesarios para financiar las pensiones de referencia del
afiliado y sus beneficiarios.

\begin{equation*}
CNU = CNU_a + \sum{CNU_{b,j}}
\end{equation*}

\noindent donde $CNU_a$ corresponde al capital necesario del afiliado (f\'ormula
2.1) y $CNU_{b,j}$ al capital necesario del beneficiario $j$-\'esimo. De esto se
desprende que en el caso de que el individuo no cuente con beneficiarios, el valor
del $CNU$ total ser\'a igual al valor del $CNU_a$.

De acuerdo con la normativa vigente, los respectivos capitales necesarios unitarios
y el valor presente de la cuota mortuoria\footnote{Beneficio otorgado a quien conlleve
los gastos funerarios del afiliado, que corresponde a un retiro de 15UF (o menos,
dependiendo del caso) del saldo de la cuenta de capitalizaci\'on individual del
afiliado. Para m\'as informaci\'on ver \cite{compIIIcapII}} se determinar\'an
considerando (1) las edades actuariales (entero m\'as cercano a la edad expresada
como un n\'umero real) que el afiliado y sus beneficiarios ten\'ian a la fecha
del siniestro y (2) la tasa de inter\'es de actualizaci\'on vigente a la misma fecha,
que dependiendo del tipo de pensi\'on puede ser constante--rentas 
vitalicias--o un vector--retiros programados.

La fecha utilizada para el c\'alculo depende del tipo de pensi\'on que se est\'e
calculando. Para pensiones por vejez tal fecha corresponder\'a a la fecha
de la solicitud de tr\'amite. En el caso de las pensiones de invalidez, corresponder\'a
a la fecha en la que qued\'o ejecutoriado el segundo dictamen (o el dictamen \'unico), el cual determina
si se aprueba o rechaza el estado de invalidez del afiliado. Por \'ultimo, en el
caso de las pensiones de sobrevivencia, se utiliza la fecha de fallecimiento del 
afiliado.

Sobre la tasa de inter\'es, es importante considerar que en el caso del retiro
programado calculado con el vector de tasas, el cual se define para un per\'iodo limitado de
a\~nos, el \'ultimo valor de este se extender\'a en el n\'umero de per\'iodos que
sea necesario para calcular el $CNU$, el cual a su vez es determinado por el n\'umero
de a\~nos que indica la tabla de mortalidad correspondiente. Para entender mejor
este punto, se puede referir al ejemplo de la secci\'on \ref{sec:ej:cnu_afili} donde se
desarrolla paso a paso el caso completo del $CNU$ para una afiliada de 60 a\~nos.

A continuaci\'on se describen las f\'ormulas de c\'alculo de $CNU$ para afiliado
soltero sin hijos, c\'onyuge sin hijos y CNU para pensi\'on de sobrevivencia de
c\'onyuge sin hijos.

\subsection{Capital Necesario para afiliado soltero sin hijos (pensi\'on de vejez o invalidez)}
	
En el caso de un individuo soltero y sin hijos de edad $x$ que se jubila en el
a\~no $t_j$\footnote{Recordar que el a\~no de jubilaci\'on determina la tabla
de mortalidad que se utilizar\'a y el mejoramiento de la misma.}

\begin{equation}\label{eq:cnu_2_1_old}
CNU = \sum_{t=0}^{T}{\frac{\frac{l_{x+t}}{l_{x}}}{(1 + i_t)^t} - \frac{11}{24}}
\end{equation}

\noindent donde $T = 110 - x$, que corresponde al n\'umero de a\~nos que puede
recorrer el individuo en la tabla de mortalidad correspondiente\footnote{Punto
importante considerando que depende de la edad actual de individuo}.

De lo anterior se desprende que, dado que la probabilidad de sobrevivencia en
$t=0$ ($l_{x}$) es $1$, \ref{eq:cnu_2_1_old} puede reescribirse de la siguiente
manera

\begin{equation}\label{eq:cnu_2_1}
CNU = \sum_{t=0}^{T}{\frac{l_{x+t}}{(1 + i_t)^t} - \frac{11}{24}}
\end{equation}

El valor de $i_t$ depende de qu\'e tipo pensi\'on se est\'a calculando. En el caso
de una renta vitalicia, $i_t$ es una constante (que en la actualidad en promedio se acerca 
un a 3.2\% para Rentas Vitalicias de jubilaci\'on por vejez.); en el caso
de un retiro programado calculado con el vector de tasas, $i_t$ corresponde al
elemento $t$-\'esimo del vector de tasas utilizado para el c\'alculo de la pensi\'on.
Para los retiros programados calculados a partir de enero de 2014 $i_t$ corresponde
a la tasa \'unica informada por la Superintendencia de Pensiones.

\subsection{Capital Necesario para c\'onyuge sin hijos (pensi\'on de vejez o invalidez)}

En este caso, existen dos maneras equivalentes de calcular el $CNU$, la primera forma es:

\begin{equation*}
CNU = 0.6\times \left[\sum_{t=0}^T{\frac{l_{y + t}}{l_y\times (1 + i_t)^t}}-\sum_{t=0}^T{\frac{l_{x+t}\times l_{y+t}}{l_x \times l_y \times (1 + i_t)^t}}\right]
\end{equation*}

\noindent la cual es equivalente a

\begin{equation*}
CNU = 0.6\times \left[\sum_{t=0}^T{\frac{l_{y + t}}{l_y\times (1 + i_t)^t}}-\left( 1 - \frac{l_{x+t}}{l_x}\right)\right]
\end{equation*}

\noindent donde para ambas $y$ es la edad de la c\'onyuge del afiliado, $l_y$ es la probabilidad
de sobrevida del c\'onyuge y $T = 110 - y$.

Por \'ultimo, al igual que el $CNU$ para el afiliado, dejando $l_y$ y $l_x$ igual a
uno:

\begin{equation}\label{eq:cnu_2_2}
CNU = 0.6\times \left[\sum_{t=0}^T{\frac{l_{y + t}}{(1 + i_t)^t}}\times\left( 1 - l_{x+t}\right)\right]
\end{equation}

\subsection{Capital Necesario para c\'onyuge sin hijos (pensi\'on de sobrevivencia)}

Para este \'ultimo caso, $T=110-y$

\begin{equation*}
CNU = 0.6\left[\sum_{t=0}^{T}{\frac{l_{y+t}}{l_y \times (1 + i_t)^t} - \frac{11}{24}}\right]
\end{equation*}

\noindent que, aplicando las mismas consideraciones que en los casos anteriores,
puede ser reescrita como

\begin{equation}\label{eq:cnu_1_1}
CNU = 0.6\left[\sum_{t=0}^{T}{\frac{l_{y+t}}{(1 + i_t)^t} - \frac{11}{24}}\right]
\end{equation}

\pagebreak

\section{{\tt CNU} : M\'odulo de Stata para el c\'alculo masivo de Capitales Necesarios}

El m\'odulo {\tt CNU} ha sido escrito principalmente en {\tt mata} (lenguaje matricial
de {\tt stata}), y dise\~nado principalmente para realizar c\'alculo de $CNU$ en
forma masiva; en particular, al ser lenguaje compilado, el desempe\~no del m\'odulo
es notable permitiendo calcular $cnu$ para miles de observaciones de manera
simult\'anea en cuesti\'on de segundos. Sus principales caracter\'isticas son:

\begin{itemize}
\item Calcular $CNU$ de las ecuaciones \ref{eq:cnu_2_1}, \ref{eq:cnu_2_2} y \ref{eq:cnu_1_1},
tanto para hombres como para mujeres,
\item Calcular Rentas Vitalicias y Retiros programados,
\item Acceder a vectores de tasas precargados (todos los utilizados por el sistema),
\item Utilizar vectores de tasas definidos por el usuario,
\item Acceder a tablas de mortalidad precargadas (todas las utilizadas por el sistema),
\item Utilizar tablas de mortalidad definidas por el usuario, 
\item Asignar din\'amicamente tablas de mortalidad correspondientes (a trav\'es
de la variable {\tt fechasiniestro}),
\item Implementar las f\'ormulas de manera escalar (1 individuo) o vectorial
($n$ individuos) de manera eficiente (r\'apida),
\end{itemize}

En el caso de c\'alculos masivos, {\tt cnu} puede ser utilizado junto con el m\'odulo
{\tt parallel}. La integraci\'on con este \'ultimo permite disminuir los tiempos
de c\'alculo de manera sencilla sin mayor esfuerzo del usuario. Por este motivo
la versi\'on actual de {\tt cnu} requiere ser instalada en conjunto con {\tt parallel}

Para su instalaci\'on, {\tt cnu} se encuentra disponible en el \emph{Statistical Software
Components (SSC)} de Boston College y puede ser descargado por los usuarios de Stata
ingresando la siguiente linea de comando

\begin{verbatim}
 . ssc install parallel
 . ssc install cnu
 . mata mata mlib query
\end{verbatim}

Cualquier actualizaci\'on que sea realizada ser\'a puesta a disposici\'on de la
comunidad a trav\'es de este mismo medio. Una fuente alternativa de instalaci\'on
es la siguiente

\begin{verbatim}
 . net from http://software.ggvega.com/stata
 . net install parallel
 . net install cnu
 . mata mata mlib query
\end{verbatim}

A continuaci\'on se presentan algunos ejemplos de c\'alculo utilizando la implementaci\'on
escalar del m\'odulo, en los cuales, utilizando la opci\'on {\tt pasos} se muestran en 
detalle los pasos de c\'alculo de cada caso.

\subsection{$CNU$ para afiliado (pensi\'on de vejez)\label{sec:ej:cnu_afili}}

Los par\'ametros utilizados:
\begin{itemize}
\item afiliado mujer ({\tt cotm(1)})
\item retiro programado con vector del a\~no 2013 ({\tt agnovector(2013)})
\item 60 a\~nos de edad ({\tt 60})
\item calculado el 2013 ({\tt agnoactual(2013)})
\item Utilizando la tabla RV 2009 ({\tt tabla(rv2009)})
\end{itemize}

tex*/

texdoc stlog
cnu_afili 60, cotm(1) pasos agnoactual(2013) agnovector(2013) tabla(rv2009)
texdoc stlog close

/*tex

\subsection{$CNU$ para c\'onyuge sin hijos (pensi\'on de vejez)\label{sec:ej:cnu_cnyg_s_hi}}

Los par\'ametros utilizados:
\begin{itemize}
\item afiliado mujer ({\tt cotm(1)})
\item c\'onyuge hombre ({\tt conym(0)})
\item retiro programado con vector del a\~no 2013 ({\tt agnovector(2013})
\item afiliado de 60 a\~nos de edad ({\tt 60})
\item c\'onyuge de 65 a\~nos de edad ({\tt 65})
\item calculado el 2013 ({\tt agnoactual(2013)})
\item Utilizando la tabla RV 2009 para el afiliado ({\tt tabla(rv2009)})
\item Utilizando la tabla B 2006 para el c\'onyuge ({\tt tablab(b2006)})
\end{itemize}

tex*/

texdoc stlog
cnu_cnyg_s_hi 60 65, cotm(1) conym(0) pasos agnoactual(2013) agnovector(2013) tabla(rv2009) tablab(b2006)
texdoc stlog close

/*tex

\subsection{$CNU$ para c\'onyuge sin hijos (pensi\'on de sobrevivencia)\label{sec:ej:cnu_sobr_cnyg_s_hi}}

Los par\'ametros utilizados:
\begin{itemize}
\item c\'onyuge hombre ({\tt conym(0)})
\item retiro programado con vector del a\~no 2013 ({\tt agnovector(2013})
\item c\'onyuge de 65 a\~nos de edad ({\tt 65})
\item calculado el 2013 ({\tt agnoactual(2013)})
\item Utilizando la tabla B 2006 para el c\'onyuge ({\tt tablab(b2006)})
\end{itemize}

tex*/

texdoc stlog
cnu_sobr_cnyg_s_hi 65, conym(0) pasos agnoactual(2013) agnovector(2013) tablab(b2006)
texdoc stlog close

/*tex

\clearpage

% BIB
\nocite{compIIIcapI, compIIIcapX, pino2005}
\bibliographystyle{apacite}
\bibliography{bib}


\end{document}

tex*/

