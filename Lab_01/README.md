Lab1: Manejo del RTC
====================

  Primera Parte
  -------------

### Lectura del RTC

  En primera instancia queriamos saber **como** leer informacion del RTC,
siendo necesario utilizar las funciones *inb* y *outb* de la libreria *x86.h*,
donde el valor retornado esta en formato BCD, por lo que fue necesaria la
implementacion de la funcion *bcd_to_binary()*.

  Para eso definimos dos varibles que indiquen los digitos 1 y 2, 
tal que al digito 1, le hacemos una mascara AND con el numero 15
(1111 en binario) y luego al digito 2, lo desplazamos 4 bits hacia la derecha
y aplicamos exactamente la misma mascara que al digito 1.
  Finalmente se hace 1° digito + (10 * 2°digito) y obtenemos el valor necesario.


#### Ejemplo

valor en BCD: 20
valor que interpreta la maquina : 0010 0000
mascara:
  0001 0100 (20 binario)
& 0000 1111 (15 binario)
	---------
  0000 0100 = 4

  0001 0100 >> 4 = 0000 0001

    0000 0001
  & 0000 1111
    ---------
    0000 0001 = 1

  0001 * 10 = 1010

   0100
 + 1010
	------
   1110 = 14 

  Ademas, debiamos ver **cuando** poder leer informacion del RTC,
por lo que necesitamos ver un bit llamado UIP(update in progress), 
que se encuentra en la posicion 0x0A del registro A de la RAM del RTC.
La funcion *UIP_status()*, retorna 1 o 0, segun si la actualizacion esta
o no en proceso respectivamente.

  Una vez obtenido el registro A, se realiza una máscara AND entre este
y el numero hexadecimal 80, obteniendo el valor del ultimo bit,
seguido de 7 ceros, es por esto que desplazamos 7 lugares a la derecha
y nos quedamos con el valor del bit de UIP.

Representado de otra forma es:

     x x x x x x x x (Registro A)
   & 1 0 0 0 0 0 0 0 (80 hex)
     _______________
     x 0 0 0 0 0 0 0 (Resultado)

     x 0 0 0 0 0 0 0 >> 7 = x (valor de UIP)


### Obtención y conversión de datos

Conociendo este valor, en la implementación de *rtc_read()*,
podemos realizar la espera ocupada para que lea los datos en el momento
donde no se esten actualizando.

  Los datos de tiempo que necesitamos en nuetro caso seran años, meses,
dias, horas, minutos y segundos; ellos estan almacenados en direcciones
de memoria especificas, por lo que hicimos una funcion *rtc_data()* 
llamada desde *rtc_read()*, que escribe la direccion de memoria 
en un puerto y luego la lee, almacenando el valor que habia en ella, 
en una variable; despues de esto le aplicamos la funcion *bcd_to_binary()*.

  Esta funcion *rtc_data()* necesita ser llamada por cada dato que necesitamos,
es decir desde *rtc_read()* se llama seis veces.

  Una vez guardados cada valor en distintas variables, se aplica la funcion
*mktime* que toma todos estos valores y retorna el valor equivalente 
expresado en segundos desde the epoch. Dicha funcion fue extraida de
*http://lxr.free-electrons.com/source/kernel/time.c#L306*, donde se encuentran
funciones de time.c del kernel de linux.

  Teniendo este resultado expresado en segundos, se implementa la funcion *rtc_init()*,
que consiste en guardar en una variable, el valor devuelto por *rtc_read()*.

  Como paso final, en el momento de inicio, se muestra por pantalla este valor obtenido,
indicando los segundos pasados desde the epoch hasta el momento de inicio del sistema.



  Segunda Parte
  -------------

  Decidimos implementar la syscall *gettimeofday* de forma relativa a uptime.
Lo primero que hacemos es declarar una variable global boottime en *main.c*
que luego toma el valor devuelto por *rtc_init()* que es la cantidad de segundos
que transcurrieron desde the epoch (1 de Enero de 1970 0:00hs) al momento
de inicio del sistema. 

Despues decidimos que la llamada a sistema *gettimeofday* sea la numero 22, 
por lo que en *syscall.h* definimos *SYS_gettimeofday 22*.

	Ademas como la varible boottime necesita ser usada en otros archivos, 
en *defs.h* la seteamos como *extern* para que pueda ser llama en cualquier 
archivo donde se incluya la libreria *defs.h*.

	Para saber el camino que debia tomar la syscall *gettimeofday*, hacemos un
seguimiento de la syscall *uptime*.

	Implementamos la syscall *sys_gettimeofday* en *sysproc.c*, que devuelve los
segundos desde the epoch que hay en el momento en que se hace la syscall, 
obtenidos de la suma entre boottime y
el tiempo que lleva encendido el sistema (ticks/100).

	En *syscall.c* agregamos la llamada a *sys_gettimeofday*, al igual que *sys_uptime*,
y agregamos la funcion *gettimeofday()* en *user.h* para el userspace.

	Se agrega a la lista de syscalls la syscall *gettimeofday* en *usys.S*.
Para poder hacer la funcion de usuario que me permita imprimir por pantalla
la cantidad de segundos actualizados desde the epoch, creamos un nuevo archivo
*date.c* en el que llama a la funcion *gettimeofday()* almacenando su valor en una
variable seconds que es mostrada en stdout.

Por ultimo, en el Makefile se agrega el nuevo comando *date* de userspace
que permite ver la cantidad de segundos desde the epoch, cuando se llama
al comando date.


  Extras
  ------
### Imprimir por consola "UIP"

  Cuando se implemento *rtc_read()* fue necesario hacer una espera ocupada 
mientras se actualizan los valores.

  Ahora se genera un aviso por pantalla si la funcion es llamada mientras se estan actualizando valores,
y se expresa mediante el mensaje "UIP".

  Se observa que es dificil lograr que la funcion sea llamada justo en el instante en que se esten 
actualizando los valores ya que son periodos de tiempo muy cortos, por eso no seria comun que este mensaje 
fuera visto en pantalla, pero si se da el caso, se avisa mientras se realiza la espera ocupada 
y terminan de actualizarse los valores.


### Implementacion modular definiendo time.{c,h}

  Para esta implementacion, definimos dos archivos, ellos son *time.c* y *time.h*,
donde en el primer archivo, definimos todas las funciones como locales, excepto 
dos de ellas, que se definieron solo su estructura en *time.h*, es decir como 
funciones publicas; ellas son *rtc_init()* y *sys_gettimeofday()*. Para ello en
*main.c* incluimos *time.h* para utilizar las funciones.

  Tambien, tuvimos que llamar a las variables globales ticks y boottime con extern
en *time.h* porque si incluiamos *defs.h* nos tiraba un error de compilacion que no pudimos
solucionar.
