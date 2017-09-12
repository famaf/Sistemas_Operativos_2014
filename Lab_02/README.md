Lab2: Semáforos
===============



INTRODUCCIÓN
------------

>  Para este proyecto, tuvimos que implementar 4 llamadas a sistemas para
>utilizar semáforos, método usado para la sincronización de
>procesos. Una vez implementadas, debíamos corroborar su funcionamiento,
>primero utilizando los programas *barrier* y por último, por medio de la
>implementación de un programa llamado *pingpong*.

>  Tuvimos que explorar e investigar acerca del funcionamiento de la funciones
>*acquire*, *release*, *sleep*, *argint* y *wakeup*, además de otras sumamente
>importantes como *wait* y *fork* utilizadas para la implementación del
>programa *pingpong*.

>  Un paso previo para el comienzo de este laboratorio fue buscar, leer,
>encontrar y entender los archivos que debimos modificar para la correcta
>compilación y funcionamiento de los programas; entre ellos se encuentran los
>archivos *syscall.c*, *syscall.h*, *defs.h*, *usys.S*, *main.c*, *Makefile*
>(comandos implementados para la prueba de los semáforos), *user.h* y nuevos
>archivos como *semaphore.c* (contiene el código fuente de las syscalls y la
>inicialización de los arreglos), *pingpong.c* y los programas dados por la
>cátedra para la prueba de semáforos (*barrier_init.c*, *barrier_echo.c* y
>*barrier_rise.c*).

>  Principalmente, tuvimos que decidir como realizar la implementación de los
> semáforos, es decir, que íbamos a utilizar.
> Así, decidimos definir dos arreglos, ellos son *sem*, en el cual cada celda
>del mismo guarda el valor o la cantidad de recursos de dicho semáforo,
>por ejemplo, sem[3] = 2, indica que el semáforo numero '3' tiene 2 recursos.
>El otro arreglo ,llamado *init*, indica si el semáforo
>ya está inicializado o no (si esta en '1' está inicializado, si esta en '0' no
>lo está). Y por último, decidimos definir un lock para todos los semáforos,
>es decir, una variable que guarde el bloqueo y que es llamada por las
>funciones *sleep*, *wakeup*, *release* y *acquire*.



SYSCALLS
--------

### syscall SEM_INIT

>  Es la syscall encargada de abrir y/o inicializar los semáforos.
>  Para saber que semáforo y que valor ponerle al inicio, al llamarla,
>se toma los dos argumentos necesarios para dicha inicialización, que en este
>caso son el nombre y el valor inicial, ambos expresados como int.
>   Para evitar un mal funcionamiento, se verifica que no haya errores al
>al momento de la lectura de los argumentos ingresados, además de que sean
>correctos, es decir que el nombre del semáforo esté en el rango permitido.
>  Una vez pasada la verificación de errores, se necesita saber si inicializar
>el semáforo en el valor ingresado o no, por lo que se ve si el valor es mayor
>o menor a cero. En el primer caso se inicializa al valor ingresado, de lo
>contrario, solo abrimos el semáforo. Luego esta apertura del semáforo se
>refleja cambiando el valor de inicialización de semáforos en el arreglo
>*init* indicandolo con un 1.
>  Finalmente se libera el *lock* que fue tomado en el momento siguiente a la
>lectura del valor ingresado.

### syscall SEM_RELEASE

>  Esta llamada a sistema(con su correspondiente programa de usuario), se
>encarga de tomar el/los semáforo/s y resetearlos nuevamente, es decir, si el
>semáforo posee recursos para dar a procesos, o ya se encuentra inicializado, lo
>único que hace es poner en '0' todos los valores correspondientes, o por así
>decirlo de otra forma, a los valores de los arreglos los vuelve '0'. Esta
>función es utilizada en el programa *pingpong*, una vez terminada la ejecución
>del mismo, se liberan o secretean los semáforos(convención o política en
>programas, es decir, si algo comienza debe cerrarse o terminar de algún modo).
>Vale aclarar que en esta syscall solo consideramos un caso de error, cuando
>quiero hacer release sobre un semáforo sin inicializar.

### syscall SEM_UP

>  Es la syscall encargada de avisar cuando un recurso fue liberado o dejado
>de utilizar.
>  En principio, se fija si existe algún error en la lectura del nombre del
>semáforo ingresado, además de ver si esta fuera del rango admitido.
>  También se fija de que no se aplique a un semáforo no abierto o inicializado.
>  Luego de esto, el *lock* es tomado con *acquire* y se realiza el aumento en
>uno del valor del semáforo en ese momento, reflejando la liberación de un
>recurso para que pueda ser utilizado por quien lo necesite.
>  Inmediatamente después, se despiertan todos los procesos, mediante la llamada
>a *wakeup*.
>  Ahora solo es necesario liberar el *lock* con *release*.
>Cabe aclarar que al despertar todos los procesos, es necesario dormir a los que
>no pueden ser corridos por alguna razón, acción realizada en *sys_sem_down*.


### syscall SEM_DOWN

>  El funcionamiento y la utilidad de esta llamada a sistema(con su
>correspondiente programa de usuario), es esencial.  Cuando el semáforo que esta
>siendo utilizado por los procesos, ya que requieren de la utilización de sus
>recursos, posee una 'N' cantidad de recursos para dar a los procesos, esta
>función lo que hace es brindar a cada proceso que lo requiere, un recurso de
>este semáforo, decrementando el valor del mismo en 1, cada vez que un proceso
>lo requiera.  En caso de que el semáforo se haya quedado sin recursos para
>dar, manda a los procesos a dormir en un espacio de memoria asignado por
>nosotros(la dirección del arreglo *sem*) por medio de la función
>*sleep*. Es así cuando una vez que se libere un recurso del semáforo
>(porque algún proceso dejó de utilizarlo), la función *wakeup*, utilizada en
>*sys_sem_up*, levanta o despierta todos los procesos dormidos, entre los cuales
>uno de ellos tomará el recurso liberado, pero todos los demás procesos deberán
>dormir nuevamente, entonces *sys_sem_down* se encarga realizarlo.
>  Así, se puede decir que trabaja en conjunto con *sys_sem_up*.



BARRIERS
--------

### BARRIER_INIT

>  Con el programa *barrier_init*, sólo se crea y se inicializa un semáforo
>para ser utilizado posteriormente por los programas *barrier_echo* y
>*barrier_rise*.

### BARRIER_ECHO

>  Este, toma el semáforo que ya se inicializó y permite la toma de recursos
>  del mismo.

### BARRIER_RISE

>  Este es el que se encarga de levantar o liberar un recurso tomado por el
>proceso y luego de esto, se imprime por pantalla el valor que se tomó con
>*barrier_echo*.



FUNCIONES UTILIZADAS EN LA IMPLEMENTACION DE LAS SYSCALLS
---------------------------------------------------------

### ACQUIRE

>  Esta función implementada en *spinlock.c*, permite la adquisición del
>bloqueo para permitir la exclusión mutua en la sección critica de un programa
>en ejecución, el cual trabaja en conjunto con la función *release*. Esto me
>garantiza que mientras un programa se encuentre ejecutando, ninguno otro podrá
>ejecutarse al mismo tiempo, sino que deberá esperar a que ese bloqueo sea
>liberado.

### RELEASE

>  Podemos decir que esta función, implementada en *spinlock.c*, y como se dijo
>antes, trabaja con estrecha relación con la función *acquire*, ya que es la que
>permite liberar el bloqueo que tomó anteriormente un programa para ejecutarse
>de manera tal que ninguno otro se ejecute mientras este estaba ejecutándose.
>El uso de *acquire* y *release* en los programas me garantiza la exclusión
>mutua.

### SLEEP

>  Esta función cumple la tarea de tomar una determinada cantidad de procesos
>que no disponen de recursos para su ejecución, por lo que libera el bloqueo y
>esa cantidad de procesos los manda a dormir a un canal, para que cuando vuelvan
>a despertar, adquiera nuevamente el bloqueo.

### WAKEUP

>  Se puede decir que esta función trabaja en estrecha relación con la función
>*sleep*. Esta se encarga de levantar todos los procesos dormidos en el canal
>y pone esos procesos en posibilidad de ejecución, es decir, de poder tomar
>recursos para poder ejecutarse. Esta tarea la hace luego de haber adquirido el
>bloqueo.

### ARGINT

>  Esta función, se encarga de leer una variable que se le pasa como parámetro,
>ver su valor y almacenarlo en memoria.
>  Trabaja llamando a la función *fetchint*, cuya funcionalidad es leer y
>almacenar el valor ingresado, retornando -1 en caso de error, o 0 si no hubo
>problemas. Es por esto que en este proyecto es utilizada de manera que se
>almacene el valor y además verifique errores, causa por la cual se compara si
>la llamada a esta funcion es menor a cero, acusando un error, siendo necesario
>retornar -1 en la funcion en la que se utiliza *argint*.



PRUEBA DE LOS PROGRAMAS CON BARRIERS
------------------------------------

>  Cuando probamos o corrimos ejemplos para la prueba de la implementación de
>los semáforos mediante los programas *barrier*, nos apareció de manera
>irregular **$** (suponemos que esto puede llegar a pasar porque como xv6
>trabaja multinúcleo, entonces uno de ellos se puede encargar de escribir
>el comando en el prompt, mientras que el otro se encarga de escribir los datos,
> por lo que puede suceder que los se ejecuten de manera simultanea).
>  Con una mayor frecuencia, al hacer un *barrier_rise*, el cual permite la
>ejecución del print que estaba encolado luego de haberse ejecutado
>*barrier_echo*, nos aparecía **zombie!**. Esto, es porque al hacer
>*barrier_rise*, se esta sacando de la cola el valor que primero se guardo en
>ella, la cual era del proceso padre; de esta manera, estamos matando al
>proceso padre antes que el proceso hijo, lo cual es la causa por la que la
>palabra **zombie!** aparece.



ALGUNOS EJEMPLOS DE ERROR DURANTE EL DESARROLLO DE LAS SYSCALLS
---------------------------------------------------------------

>  Acá vamos a nombrar algunos errores que nos fueron apareciendo a medida que
>íbamos haciendo las syscalls en la prueba de los semáforos con los barrier.
>  Algunos de ellos son:

### EJEMPLO 1

>$ barrier_init
>$ barrier_echo a &
>  (nos tiraba un dirección de memoria).
>  Esto sucedía porque estábamos considerando un caso de error que evidentemente
>estaba mal.

### ELEMPLO 2

>$ barrier_init
>$ barrier_echo a &
>$ barrier_echo b &
>$ barrier_echo c &
>$ barrier_rise
>$ a
>$ b
>$ c
>$ zombie!
>$ zombie!
>$ zombie!

>  Esto claramente no debía pasar, ya que el funcionamiento correcto sería que
>levante de a un recurso por cada *barrier_rise* que se hacía. Entonces supimos
>que el problema se encontraba en el *sys_sem_down* ya que estábamos levantando
>a todos los procesos dormidos pero sin poner a dormir a los que no pueden
>tomar recursos del semáforo.
> Esto se solucionó con un bucle *while* en el que manda a dormir los procesos
>mientras no haya recursos disponibles.



PROGRAMA PINGPONG
-----------------

>  Para este programa de usuario investigamos como usar la función fork,
>la cual básicamente se encarga de crear un proceso. Para entenderla bien,
>leímos su manpage '$ man fork' y varios links (puestos al final del informe).
>  Al hacer la llamada a la syscall fork, devuelve el PID (numero de proceso),
>para poder identificar cual es el proceso padre y cual el proceso hijo.
>  Daremos una breve explicación de como identificar los procesos padre e hijo,
>los cuales se encargarán de imprimir por stdout 'pong y 'ping'
>respectivamente.
>  Si el PID es mayor estricto a cero (> 0) estamos en el proceso padre,
>si el PID es igual a cero (= 0) estamos en el proceso hijo,
>y en caso de que el PID se menor estricto a cero (< 0) estamos ante un caso de
>error. Una vez que tenemos esto, solo queda colocar los semáforos de forma
>correcta para que el programa cumpla su cometido. En este punto tuvimos una
>serie de problemas los cuales nombraremos a continuación:

* Imprimir 'ping' N veces y después 'pong' N veces 
* Viceversa a lo anterior.
* Imprimir 'ping' una vez y tildarse la consola.
* etc...

>  La mayoria de estos problemas surgieron por inicializar o colocar mal los 
>semáforos.

>  Al final pudimos solucionar los problemas y hacer que imprima de forma
>correcta. 
>  Pero surgió otro problema el cual fue que después de cada ejecución se
>aparecía la advertencia 'zombie!'. Para solucionar este problema buscamos con
>el comando grep de donde provenía esta advertencia ($ grep zombie! *).
>  Logramos dar que esta advertencia se imprimía en el archivo init.c, así que
>leyendo el código de dicho archivo y preguntando a nuestro ayudante, pudimos
>dar que la advertencia se producía porque primero matábamos al proceso padre
>antes que al hijo. Para solucionar esto volvimos a leer el código del init.c y
>vimos que en una guarda (antes de imprimir la advertencia zombie!) había una
>función wait, así que lo que hicimos fue buscar donde estaba esta función y
>ver que hacía. Dicha función era una syscall y se encontraba definida en el
>archivo proc.c y lo que hacia era: "devolver el PID del proceso hijo",
>entonces al final del programa se agregó una guarda que usaba esta
>syscall para saber si nos encontrábamos al proceso hijo y si era así que lo
>eliminara primero, es decir, antes del padre. Finalmente probamos de
>nuevo el programa y ya no daba la advertencia zombie!.



ALGUNOS EJEMPLOS DE ERROR DURANTE EL DESARROLLO DEL PROGRAMA PINGPONG
---------------------------------------------------------------------

>  A medida que creíamos que pingpong funcionaba, fuimos probando este programa
>mediante el comando *pingpong* y nos daban errores en cuanto a como imprimía
>*ping* y *pong*.
>  Algunos ejemplos que podemos poner son:

### EJEMPLO 1

>$ pingpong
>ping
>..
>.
>.
>  Aca el programa se trababa ya que entraba con *pid == 0* y luego no salía, ya
>que no habíamos sincronizado de manera correcta los semáforos.

### EJEMPLO 2

>$ pingpong
>ping
>ping
>pong
>pong
>ping
>ping
>pong
>pong
>..
>.
>zombie!
>$

>  Esto nuevamente fue otro problema surgido de haber colocado mal semáforos
>para sincronizar los procesos.

### EJEMPLO 3

>$ pingpong
>ping
>pong
>ping
>pong
>ping
>pong
>..
>.
>zombie!
>$

>  Aca ya vimos que la sincronización estaba puesta de manera correcta, pero el
>problema era la sentencia *zombie!*, lo cual como se dijo anteriormente, se
>estaba matando al proceso padre antes que al proceso hijo, por lo que tuvimos
>que utilizar la funcion *wait* en una condición para saber si estábamos
>haciendo los *sem_release* correctos de los semáforos para el procesos hijo.



Apreciación del Lab
-------------------

>  El laboratorio en general nos pareció muy bueno, proponía cosas muy
>interesantes, al principio nos costo mucho empezar el laboratorio, pero al
>final pudimos entender mejor las cosas y empezar a desarrollar las syscalls
>y el programa pingpong, hubiera estado mejor un poco mas de explicación en el
>enunciado del laboratorio.
>  También nos sirvió para mejorar nuestra interpretación de varios archivos y
>funciones a la vez, con un nivel elevado a los proyectos anteriores.
>  Finalmente, se aclara cada vez mas la diferencia entre espacio de usuario y
>kernel, y el funcionamiento que existe detrás de la interacción en userspace.
>  Además sirve de introducción al trabajo de multiprocesos, administración
>y manejo de estos, para evitar problemas de sincronización y perdida de
>resultados u obtención valores no deseados.



Links que usamos como referencia:
---------------------------------

* http://es.wikipedia.org/wiki/Bloqueo_mutuo
* http://es.wikipedia.org/wiki/Proceso_zombie
* http://sopa.dis.ulpgc.es/ii-dso/leclinux/procesos/fork/LEC7_FORK.pdf
* http://es.wikipedia.org/wiki/Bifurcaci%C3%B3n_(sistema_operativo)
* http://es.wikipedia.org/wiki/Identificador_de_proceso
* http://www.programatium.com/manuales/c/21.htm
