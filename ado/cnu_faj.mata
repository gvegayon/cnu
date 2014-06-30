mata mata clear
mata
real colvector function cnu_proy_cnu(
	real scalar x,              // Edad del afiliado
	real scalar y,              // Edad del conyuge
	real scalar cotmujer,       // Escalar binario (1 si el cotizante es mujer)
	real scalar conymujer,      // Escalar binario (1 si el cotizante es mujer)
	string scalar tipo_tm_cot,  // Tipo de tabla de mortalidad (rv, mi, b)
	string scalar tipo_tm_cony, // Tipo de tabla de mortalidad (rv, mi, b)
	real scalar agnovec,        // Agno del vector
	real colvector rp,          // Tasa RP a utilizar
	real scalar agnotabla,      // Agno de la tabla de mortalidad del cotizante
	real scalar agnotablabenef, // Agno de la tabla de mortalidad del cotizante
	real scalar agnoactual,     // Agno actual (de calculo)
	real scalar fsiniestro,     // Fecha en que ocurre el siniestro (se utiliza para asignar la tabla)
  | real scalar stepprint,
	string scalar path_tm,      // Directorio donde buscar las tablas de mortalidad
	string scalar path_v	
	) {

	// Proyectando CNU
	real colvector cnu, xs, agnosa
	real scalar n
	
	xs     = x::110
	n      = length(xs)
	agnosa = agnoactual::(agnoactual + n-1)
	
	cnu = cnu_2_1_vec(
		xs, J(n,1,cotmujer), J(n,1,tipo_tm_cot), J(n,1,agnovec), 0, J(n,1,-1e100),
		rp, J(n,1,agnotabla), agnosa,J(n,1,fsiniestro), J(n,1,1), stepprint,
		path_tm, path_v
		)

	// Si es que tiene conyuge
	if (y != .) 
	{
		real colvector ys
		ys  = y::(y+n-1)
			
		cnu = cnu + editmissing(cnu_2_2_vec(
				xs, ys, J(n,1,cotmujer), J(n,1,conymujer),
				J(n,1,tipo_tm_cot), J(n,1,tipo_tm_cony),
				J(n,1,agnovec), 0, J(n,1,-1e100), rp,
				J(n,1,agnotabla), J(n,1,agnotablabenef),
				agnosa,J(n,1,fsiniestro), J(n,1,1), path_tm, path_v
			),0)
		
	}			
	return(cnu)
	
}
real scalar function cnu_faj_fun_obj(
	real scalar faj,
	real scalar x,
	real colvector cnu,
	real colvector rp_a,
	|real scalar edadm,
	real scalar saldo,
	real scalar pcent,
	real scalar rp0
) {
	if (edadm == J(1,1,.)) edadm = 98.00
	if (saldo == J(1,1,.)) saldo =  1.00
	if (pcent == J(1,1,.)) pcent =  0.30
	if (rp0   == J(1,1,.)) rp0   = saldo/cnu[1]
	
	real scalar suma, t, pens_t, saldo_t
	suma    = 0
	saldo_t = saldo
	for(t=0;t<=edadm-x;t++)
	{
		pens_t  = saldo_t/cnu[t+1]
		saldo_t = saldo_t - pens_t
		suma = suma + (pens_t - max(((1-faj)*pens_t,pcent*rp0)))/(1+rp_a[t+1])^(t + 1)
	}
	
	return(suma)
}

/**moxygen
 * @brief Calcula el factor de ajuste
 * @param cnu   Vector columna. Trayectoria del CNU
 * @param rp_a  Vector columna. Tasa de interes anual RP.
 * @param edadm Escalar. Edad hasta la que cubre el FAJ
 * @param saldo Escalar. Saldo al momento del retiro
 * @param pref  Escalar. % de referencia
 */
 
real scalar function cnu_faj(
	real scalar x,
	real colvector cnu,
	real colvector rp_a,
	|real scalar edadm,
	real scalar saldo,
	real scalar pcent,
	real scalar rp0,
	real scalar criter,
	real scalar maxiter
	) {
	
	// Importantes en blanco
	if (criter  == J(1,1,.)) criter = 1e-10
	if (maxiter == J(1,1,.)) maxiter = 100
	
	// Resolucion a traves de una busqueda binaria
	// Alcanza una prescision de 1e-10 en ~ 50 pasos
	real scalar faj1, faj2, val1, val2
	real scalar minr, maxr, rango
	
	minr = 0
	maxr = 1
	rango = maxr-minr
	real scalar niter
	niter = 0
	while ((rango > criter) & (++niter < maxiter))
	{
		faj1 = minr + rango/3
		faj2 = minr + rango/3*2
		
		val1 = abs(cnu_faj_fun_obj(faj1,x,cnu,rp_a,edadm,saldo,pcent,rp0))
		val2 = abs(cnu_faj_fun_obj(faj2,x,cnu,rp_a,edadm,saldo,pcent,rp0))
		
		if (val1 < val2) maxr = faj2
		else             minr = faj1
		
		rango = maxr-minr
	}
	
	if (val1 < val2) return(faj1)
	else return(faj2)
}
	
// Proyecta el CNU
cnu  = cnu_proy_cnu(65,67,0,1,"rv","b",2013,J(110-65+1,1,.03),2009,2006,2014,0)
rp_a = J(110-65+1,1,.03)
fajs = J(100,1,.5):*(.5/100:*(1::100))

for(i=1;i<=length(fajs);i++) {
	printf("%5.4fc %9.5fc\n",fajs[i],cnu_faj_fun_obj(fajs[i],65,cnu,rp_a))
}

cnu_faj(65, cnu, rp_a)
	/*real scalar faj,
	real scalar x,
	real colvector cnu,
	real colvector rp_a,
	|real scalar edadm,
	real scalar saldo,
	real scalar pcent,
	real scalar rp0*/
end
