# cnu : Modulo de Stata para el calculo de CNU

El modulo `cnu`, escrito fundamentalmente en MATA, permite el calculo de Capitales
Necesarios Unitarios (CNU) utilizado para el calculo de pensiones en el sistema
chileno.

Actualmente el modulo implementa las formulas de CNU para pension de vejez para
afiliado y conyuge sin hijos, y para pension de sobrevivencia para conyuge sin
hijos.

## Instalacion

### Instalacion desde ggvega.com

La copia en ggvega.com se encuentra actualizada dos veces al dia. Para acceder
a esta copia basta con entrar el comando `net install` desde Stata como sigue:

```
. net install cnu, from(https://cdn.rawgit.com/gvegayon/cnu/a31056b6) replace
. mata mata mlib query
```

### Instalacion desde repositorio

Para instalar debe seguir los siguientes pasos:
1. Descargar los archivos (ya sea utilizando Git o descargandolo desde
[aqui](https://github.com/gvegayon/cnu/archive/master.zip)

2. Extraer los archivos en ZIP en, por ejemplo, C:/

3. Copiar todos los archivos ADO HLP y STHLP en su carpeta PERSONAL/c de Stata

4. Copiar el archivo `lcnu.mlib` en su carpeta PERSONAL/l de Stata

5. Copiar los archivos `cnu_tabmor...` y `cnu_vec...` en su carpeta PERSONAL/c de Stata

## Autor

George G. Vega Yon

Superintendencia de Pensiones

gvega en spensiones cl

gvegayon en caltech edu


