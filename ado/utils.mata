////////////////////////////////////////////////////////////////////////////////
// FUNCIONES ADICIONALES (UTILS)
////////////////////////////////////////////////////////////////////////////////

mata:

// NOMBRE     : cnu_save_tab_mort
// DESCRIPCION: Exporta (guarda) tablas de mortalidad desde mata a un archivo binario
// RESULTADO  : VOID
// DETALLES   : 
//  Las tablas se almacenan en archivos sin extension en la carpeta plus con la
//  siguiente estructura de nombre:
//    plus/c/cnu_tabmor_[tipo][agno][genero]
//  , adicionalmente si el usuario lo desea, puede incluir un nombre alternativo
//  al final del nombre completo
//    plus/c/cnu_tabmor_[tipo][agno][genero][altname]
//  de esta forma podra utilizar sus propias tablas de mortalidad

void cnu_save_tab_mort(
	real matrix tabla,    // Tabla a guardar
	real scalar agno,     // Agno de la tabla
	string scalar genero, // Genero (h: Hombre, m: Mujer)
	string scalar tipo,   // Tipo de tabla (rv: Afiliado, mi: Con discapacidad, b: Beneficiario
   |string scalar path,   // (OPCIONAL) Directorio donde guardar el archvo (por defecto PERSONAL)
	real scalar repl,     // (OPCIONAL) Dicotomica (1 si desea reemplazar existente) (por defecto 0)
	string scalar altname // (OPCIONAL) Nombre alternativo
	) 
	{
	
	real scalar fh, ncols, nrows
	string scalar fullpath
	
	// Verificando altname
	if (altname==J(1,1,"")) altname = "";

	// Verificamos path
	if (path == J(1, 1, "")) path = c("sysdir_plus")+"c"+c("dirsep")
	
	// Verificamos repl(replace)
	if (repl == J(1, 1, .)) repl = 0
	
	// Verifica dimensiones de la tabla
	if ((ncols = cols(tabla)) != 3) {
		errprintf("La tabla no tiene 3 columnas ('Edad', 'Qx' y 'Factor'), tiene %g.\n", ncols)
		_error(601)
	}
	/*if ((nrows = rows(tabla)) != 211) {
		errprintf("La tabla no tiene 211 filas (rango de edades entre 0 y 210), tiene %g.\n", nrows)
		exit()
	}*/
	
	// Verifica que tipo de tabla sea correcta
	/*if (!regexm(tipo,"^(rv|mi|b)$")) {
		errprintf("Tipo de tabla '%s' no permitido. Solo rv, mi o b estan permitidos\n", tipo)
		_error(601)
	}*/
		
	// Verifica que sexo haya sido bien especificado
	if (!regexm(genero, "^(h|m)$")) {
		errprintf("Genero '%s' no permitido. Solo h o m estan permitidos\n", genero)
		_error(601)
	}

	fullpath = (path+"cnu_tabmor_"+tipo+strofreal(agno)+genero+altname)

	// Chequea existencia
	if (fileexists(fullpath) & !repl) {
		errprintf("El archivo %s ya existe, especifique la opcion 'replace'.\n", fullpath)
		_error(601)
	}
	else if (fileexists(fullpath) & repl) unlink(fullpath)

	fh = _fopen(fullpath, "rw")
	
	// En el caso de error
	if (fh != 0) {
		errprintf("Ha ocurrido un error al tratar de crear el archivo %s\n(error %f)\n", fullpath,fh)
		_error(601)
	}
	
	// Guardando y cerrando
	fputmatrix(fh, tabla)
	fclose(fh)
	
	sprintf("Se ha guardado la tabla en %s.",fullpath)
}

// NOMBRE     : cnu_get_tab_mort
// DESCRIPCION: Importa tablas de mortalidad a MATA
// RESULTADO  : tabla de mortalidad

real matrix cnu_get_tab_mort( 
	real   scalar agno,   // Agno de la tabla
	string scalar genero, // Genero (h: Hombre, m: Mujer)
	string scalar tipo,   // Tipo de tabla (rv: Afiliado, mi: Con discapacidad, b: Beneficiario
   |string scalar path,   // (OPCIONAL) Directorio donde guardar el archvo (por defecto PERSONAL)
    string scalar altname
	) 
	{
	
	string scalar fullpath
	real scalar fh
	real matrix x
	
	// Verificamos path
	if (path == J(1, 1, "")) path = c("sysdir_plus")+"c"+c("dirsep")
	else if (!direxists(path)) _error(1,"El directorio -"+path+"-no fue encontrado")
	
	/* // Verifica que tipo de tabla sea correcta
	if (!regexm(tipo,"^(rv|mi|b)$")) {
		errprintf("Tipo de tabla '%s' no permitido. Solo rv, mi o b estan permitidos\n", tipo)
		_error(601)
	} */
		
	// Verifica que sexo haya sido bien especificado
	if (!regexm(genero, "^(h|m)$")) {
		errprintf("Genero '%s' no permitido. Solo h o m estan permitidos\n", genero)
		_error(601)
	}
	
	fullpath = (path+"cnu_tabmor_"+tipo+strofreal(agno)+genero+altname)

	// Chequea existencia
	if (!fileexists(fullpath)) {
		errprintf("La tabla %s no existe\n", fullpath)
		_error(601)
	}

	// Abre archivo y lee tabla de moralidad
	fh = _fopen(fullpath, "rw")
	x = fgetmatrix(fh)
	fclose(fh)
	
	return(x)
}


// NOMBRE     : cnu_save_vec_tasas
// DESCRIPCION: Exporta (guarda) vectores de tasas en archivos binarios
// RESULTADO  : VOID
// DETALLES   :
//  Los vectores se almacenan en archivos sin extension en la carpeta plus con la
//  siguiente estructura de nombre:
//    plus/c/cnu_vec[agno]
//  , adicionalmente si el usuario lo desea, puede incluir un nombre alternativo
//  al final del nombre completo
//    plus/c/cnu_vec[agno][altname]
//  de esta forma podra utilizar sus propios vectores de tasas.

void cnu_save_vec_tasas(
	real matrix tabla,    // Tabla (vector) a exportar
	real scalar agno,     // Agno de la tabla
   |string scalar path,   // (OPCIONAL) Directorio donde guardar el archvo (por defecto PERSONAL)
	real scalar repl,     // (OPCIONAL) Dicotomica (1 si desea reemplazar existente) (por defecto 0)
	string scalar altname
	) 
	{
	
	real scalar fh, ncols, nrows
	string scalar fullpath
	
	// Verificamos path
	if (path == J(1, 1, "")) path = c("sysdir_plus")+"c"+c("dirsep")
	
	// Verificamos repl(replace)
	if (repl == J(1, 1, .)) repl = 0
	
	// Verifica dimensiones de la tabla
	if ((ncols = cols(tabla)) != 2) {
		errprintf("La tabla no tiene 2 columnas ('Agno' y 'Tasa'), tiene %g.\n", ncols)
		_error(601)
	}
	if ((nrows = rows(tabla)) != 191) {
		errprintf("La tabla no tiene 191 filas (rango de edades entre 1 y 191), tiene %g.\n", nrows)
		_error(601)
	}
	
	fullpath = (path+"cnu_vec"+strofreal(agno)+altname)

	// Chequea existencia
	if (fileexists(fullpath) & !repl) {
		errprintf("El archivo %s ya existe, especifique la opcion 'replace'.\n", fullpath)
		_error(601)
	}
	else if (fileexists(fullpath) & repl) unlink(fullpath)

	fh = _fopen(fullpath, "rw")
	
	// En el caso de error
	if (fh != 0) {
		errprintf("Ha ocurrido un error al tratar de crear el archivo %s\n(error %f)\n", fullpath,fh)
		_error(601)
	}
	
	// Guardando y cerrando
	fputmatrix(fh, tabla)
	fclose(fh)
	
	sprintf("Se ha guardado la tabla (vector) en %s.",fullpath)
}

// NOMBRE     : cnu_get_tab_mort
// DESCRIPCION: Importa vector de tasas a MATA
// RESULTADO  : Vector de tasas

real matrix cnu_get_vec_tasas(
	real scalar agno,     // Agno del vector
   |string scalar path,   // (OPCIONAL) Directorio donde guardar el archvo (por defecto PERSONAL)
    string scalar altname
	) 
	{
	
	string scalar fullpath
	real scalar fh
	real matrix x
	
	// Verificamos path
	if (path == J(1, 1, "")) path = c("sysdir_plus")+"c"+c("dirsep")
		
	fullpath = (path+"cnu_vec"+strofreal(agno)+altname)

	// Chequea existencia
	if (!fileexists(fullpath)) {
		errprintf("La tabla (vector de tasas) %s no existe\n", fullpath)
		_error(601)
	}

	// Abre archivo y lee tabla de moralidad
	fh = _fopen(fullpath, "rw")
	x = fgetmatrix(fh)
	fclose(fh)
	
	return(x)
}


// NOMBRE     : cnu_mejorar_tabla
// DESCRIPCION: Aplica mejoramiento a tablas de mortalidad
// RESULTADO  : Tabla de mortalidad ajustada (vector)

real colvector cnu_mejorar_tabla(
	real colvector edades,
	real colvector qx,        // Valor Qx (Mortalidad)
	real colvector aa,        // Valor AA (Factor de mejoramiento)
	real scalar agno_qx,      // Agno de la tabla
	real scalar agno_actual,  // Agno de calculo
	real scalar edad          // Edad del individuo
	)
	{
	
	real scalar difagnos
	
	difagnos = agno_actual - agno_qx
	
	return(qx :* (1 :- aa):^(difagnos :+ edades :- edad))
}


// NOMBRE     : cnu_which_tab_mort
// DESCRIPCION: Determina que agno de tabla de mortalidad debe usar el individuo
// RESULTADO  : Agno correspondiente de la tabla a utilizar (scalar)

real scalar cnu_which_tab_mort(
	real scalar fsiniestro,
	string scalar tipo
	)
	{
	
	// Verifica que tipo de tabla sea correcta
	if (!regexm(tipo,"^(rv|mi|b)$")) {
		errprintf("Tipo de tabla '%s' no permitido. Solo rv, mi o b estan permitidos\n", tipo)
		_error(601)
	}
	
	// Si es que es para afiliado
	if (tipo == "rv") {
		if (fsiniestro <= 20050131) {
			return(1985)
		}
		else if (fsiniestro <= 20100630) {
			return(2004)
		}
		else {
			return(2009)
		}
	} // Si es que es para persona invalidez
	else if (tipo == "mi") {
		if (fsiniestro <= 20080131) {
			return(1985)
		}
		else {
			return(2006)
		}
	} // Si es que es para beneficiario
	else {
		if (fsiniestro <= 20080131) {
			return(1985)
		}
		else {
			return(2006)
		}
	}
}


// NOMBRE     : export_tab
// DESCRIPCION: Exporta matrices a texto plano para ser generadas desde mata
// RESULTADO  : VOID

void export_tab(
	real matrix tabla,      // Tabla a exportar
   |string scalar filename, // (opcional) Nombre de archivo a exportar
    string scalar mode,     // (opcional) Modo de conexion (a = append, w = write)
    string scalar tabname   // (opcional) Nombre de la tabla
	)
	{
	
	// Variables definition
	real scalar ncols, nrows, i, j, fh
	string colvector stringtab
	
	if (mode == J(1,1,"")) mode = "w"
	if (tabname == J(1,1,"")) tabname = "x"
	
	ncols = cols(tabla)
	nrows = rows(tabla)
	stringtab = J(nrows,1,"")
	
	for(i=1; i<=nrows; i++) {
		for(j=1; j<=ncols; j++) {
			if (j==1 & i==1) { // First cell
				stringtab[i] = sprintf("(%f ,",tabla[i,j])
			}
			else if (j==ncols & i==nrows) { // Last cell
				stringtab[i] = stringtab[i] + sprintf("%f)",tabla[i,j])
			}
			else if (j==ncols & i !=nrows) { // Last cell of row
				stringtab[i] = stringtab[i] + sprintf("%f \",tabla[i,j])
			}
			else { // Middle cell
				stringtab[i] = stringtab[i] + sprintf("%f, ",tabla[i,j])
			}
		}
	}

	// Returning
	if (filename==J(1,1,"")) {
		printf("%s = \n", tabname)
		for(i=1;i<=nrows;i++) {
			printf("\t%s\n", stringtab[i])
		}
	}
	else {
		fh = fopen(filename, mode)
		fput(fh, sprintf("%s = \n", tabname))
		for(i=1;i<=nrows;i++) {
			fput(fh, sprintf("\t%s",stringtab[i]))
		}
		fclose(fh)
	}
}

void cnu_import_plain_tab_mort(
	string scalar fname,
	real scalar agno,
	string scalar genero,
	string scalar tipo,
   |string scalar path,
	real scalar repl,
	string scalar sep,
	string scalar altname
	)
{
	real matrix tabla;
	string scalar line;
	
	if (sep==J(1,1,"")) sep=";";
	
	/* Verifica que exista el archivo */
	if(!fileexists(fname)) _error(1)
	
	/* Leyendo tabla */
	tabla = strtoreal(mm_insheet(fname,sep));

	/* Guardandola */
	cnu_save_tab_mort(tabla, agno, genero, tipo, path, repl, altname)
	
	return
}

/* Importa vector de tasas */
void cnu_import_plain_vec(
	string scalar fname,
	real scalar agno,
   |string scalar path,
	real scalar repl,
	string scalar sep,
	string scalar altname
	)
{
	real matrix tabla;
	string scalar line;
	
	if (sep==J(1,1,"")) sep=";";
	
	/* Verifica que exista el archivo */
	if(!fileexists(fname)) _error(1)
	
	/* Leyendo vector */
	tabla = strtoreal(mm_insheet(fname,sep));

	/* Guardandola */
	cnu_save_vec_tasas(tabla, agno, path, repl, altname);
	
	return
}
end
