DIR=~/cnu/ado
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/stata12/
cnu:
	stata-mp -b do compile.do
	cp -u -r ~/cnu ~/../investigacion/george/comandos_paquetes_librerias/stata

clean:
	rm -f compile.log
	rm -f *.sum

