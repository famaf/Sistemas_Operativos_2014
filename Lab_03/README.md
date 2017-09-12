Lab 3: Implementación del scheduler con MLFQ
============================================

INTRODUCCIÓN
------------

>  Principalmente, para comenzar este proyecto tuvimos que conocer e investigar
>el funcionamiento del scheduler, que funcionaba con el método de *round robin*.
>Luego de esto, tuvimos que implementar una modificación del scheduler para que
>funcione con buffers circulares,utilizando el método de MLFQ, donde debíamos
>darle mayor prioridad a los procesos I/O bound y disminuir la prioridad de los
>procesos CPU bound.
>  Para lograr este objetivo, tuvimos que aprender mas sobre las funciones del
>archivo *proc.c*, donde además de *scheduler* se encuentran *pinit*,
>*userinit*, *fork*, *yield*, *wakeup1* y *kill*, donde en cada una tuvimos que
>reconocer que hacía con los procesos y modificarla para lograr la prioridad
>necesaria que debíamos darle a los procesos I/O bound.
>Para eso, hablaremos brevemente de estas funciones mencionadas anteriormente.

Pinit
-----

>  Esta función es la que se encarga de inicializar los buffers circulares,
>la cual es llamada desde *main* para ejecutarse.
>  La función que es llamada desde *pinit* es *cbuffer_init*, en la cual se
>inicializan los cbuffers, que guardan direcciones de memoria de punteros hacia
>estructuras del tipo *struct proc*, toman un tamaño de almacenamiento *NPROC*,
>un tamaño del elemento a colocar en el cbuffer y un arreglo que es el espacio
>físico donde viven los procesos.
>  En nuestro caso tuvimos que inicializar dos cbuffers.

Userinit
--------

>  Esta función, encargada de crear el primer proceso de usuario, ahora tiene
>que encolar el proceso en la cola de prioridad mas alta por ser este primer
>proceso un proceso I/O bound.

Fork
----

>  Es la función encargada de la creación de procesos, obteniendosé el proceso
>*hijo* del originario (padre). Son idénticos, solo diferenciados por PID.
>Cuando un proceso es creado, toma la prioridad mas alta, que luego es cambiada
>o mantenida, dependiendo del estado que tome el proceso posterior a su
>ejecución.
>  Es por esto, que declaramos el proceso hijo con prioridad 0 (la mas alta),
>y lo encolamos en el cbuffer de mayor prioridad, para que luego sea tomado por
>scheduler, y cambie o no su prioridad luego de su ejecución.

Yield
-----

>  En esta función, nos dimos cuenta que debíamos encolar los procesos de menor
>prioridad, es decir, los procesos CPU bound, ya que libera la cpu para una
>rueda de planificación completa; esto quiere decir que como los procesos
>CPU bound ocupan todo su quanto al ejecutarse, estos debían ser metidos al
>cbuffer de menos prioridad.
>  Una observación que nos ayudo a concretar esta idea fue que en la función
>*trap* en *trap.c*, hay una guarda donde dice que si el proceso esta en estado
>*RUNNING* y se le acaba por completo su quanto liberando la CPU en una
>interrupción, llama a la función *yield*.

Wakeup1
-------

>  Al saber que los procesos de mayor prioridad podían, en la mayoría de sus
>ejecuciones, no completar por completo su quanto, estos cambiaban de estado
>*RUNNABLE* al estado *SLEEPING*, es decir, se bloqueaban y se dormían en un
>canal.
>  Así esta función se encarga de despertar los procesos dormidos, por lo que
>los procesos tomados se encolan en la cola de mayor prioridad.

Kill
----

>  Al momento de matar un proceso, necesita despertarlo si es que esta dormido,
>por lo que se realiza el mismo procedimiento que en *wakeup1*,
>encolando este proceso en el buffer de mayor prioridad.



Scheduler: "Round Robin"
------------------------

>  La manera en la que funcionaba el viejo scheduler que utilizaba el método de
>*round robin*, se caracterizaba de la siguiente manera.
>Para hacer que un proceso que duerma pueda ser planificable, mediante la
>función *wakeup1*, la cual recorre uno por uno cada proceso de la tabla de
>procesos preguntando si el proceso tomado está en estado *SLEEPING* y si está
>durmiendo en *chan*. Si esto se cumple, la función cambia el estado del proceso
>poniéndolo en *RUNNABLE*, es decir, permitir de esta manera que pueda ser
>planificable para el scheduler.
>  La acción de ejecutar un proceso que es planificable, es llevado a cabo por
>la función *scheduler*. Esta recorre permanentemente la tabla de procesos, en
>busca de procesos planificables o que puedan ejecutarse, es decir, si encuentra
>alguno que no lo es, sigue buscando, y en caso contrario, setea el proceso en
>la variable *proc*, indicando que es el proceso actual el que se tomó, cambia
>la página de la tabla de procesos con la función *swtchuvm*, pone el estado del
>proceso en *RUNNING* y pone a correr el mismo con la función *swtch*, dándole
>un quanto a cada proceso que escoja sin importar que tipo de proceso sea.
>  En el caso en el que un proceso haya agotado por completo su tiempo de
>procesador disponible o todo el quanto, la función *yield* se encarga de
>replanificarlo, avisando de esta forma que su tiempo termino y entrega el
>el recurso para que sea utilizado por otro proceso.
>Esta función abandona la CPU para una ronda completa de planificación.
>Pone el proceso en *RUNNABLE* y llama a la función *sched*, la cual llama a
>*swtch* que guarda el contexto actual y lo cambia al contexto del planificador
>para permitir que se ponga a correr.
>  Por último, la acción de bloquear un proceso que espera entrada/salida es
>llevada a cabo por la función *sleep*. La idea de esta función, es poner los
>procesos en estado *SLEEPING* y llamar a *sched* para liberar el procesador y
>así la función *wakeup*, busca los procesos dormidos en la tabla de procesos
>realizando la tarea anteriormente explicada. En conclusión, *sleep* sólo duerme
>procesos que no terminan de utilizar por completo el uso permitido de CPU que
>se les asigna, por lo que los manda a dormir a *chan*, para no perder tiempo
>aprovechable en el que podrían trabajar y avanzar otros procesos.


Scheduler: "MLFQ"
-----------------

>  La nueva implementación del *scheduler* tiene como objetivo dar mayor
>prioridad a los procesos I/O bound mediante la utilización de colas de
>prioridades o buffers circulares (implementados por la cátedra).
>Entonces daremos una explicación similar al viejo scheduler, pero ahora con el
>nuevo implementado.
>  Ahora *wakeup1* que es llamada por *wakeup* realiza la misma acción
>anteriormente explicada pero con la diferencia de que a cada proceso que toma y
>pone en estado *RUNNABLE*, lo encola en el cbuffer *cb0*(el de mayor prioridad)
>mediante la función *cbuffer_write*.
>  El replanificar un proceso que agotó su quanto completo, también incluye la
>participación de la función *yield*, pero en este caso, el proceso tomado se
>encola en la cola de menor prioridad *cb1*, indicando que es un proceso
>CPU bound.
>  La función *sleep* sigue haciendo la misma tarea que antes, ya que solo toma
>los procesos y los duerme en *chan* para luego ser despertados por *wakeup*
>para que sean planificados. Entonces ésta no encola ni desencola procesos en
>los cbuffers, por lo que no fue modificada.
>  Por último, el *scheduler* se encarga de ejecutar el proceso ya planificable,
>pero ya no recorriendo la tabla de procesos, debido a que ahora no le importa
>el orden de la tabla para darle el tiempo a cada proceso como aparece en la
>misma, sino que se fija si los cbuffers están vacíos o no, respetando el orden
>de prioridad. En caso de que el cbuffer *cb0* no esté vacío, desencola el
>proceso por medio de la función *cbuffer_read*;
>pero si está vacío, entonces pregunta si el cbuffer *cb1*(menor prioridad) está
> o no vacío y realiza la misma acción anterior.
>En el caso en que ambas colas estén vacías, sólo continúa.
>Ahora, al proceso que le tocó ser desencolado, se pone en ejecución por medio
>de las funciones que antes explicamos que son también utilizadas por el viejo
>scheduler.


Starvation
----------

>A diferencia de la planificación *round robin*, *MLFQ* tiene este aspecto
>negativo de inanición (starvation), lo que puede hacer que existan procesos
>que nunca lleguen a ejecutarse, debido a que siempre existe un proceso de
>mayor prioridad.
>Si tengo un proceso I/O bound, siempre se va a ejecutar antes que un CPU bound,
>por lo que si el buffer de procesos I/O bound nunca se vacía, nunca se ejecuta
>el proceso CPU bound, produciendose así starvation.
>Esto en *round robin* no ocurre ya que ejecuta los procesos uno por uno, según
>el orden en el que estén en la tabla de procesos, asegurándose así la ejecución
>de todos.


Ejecuciones de *frutaflops* y *verduiops*
-----------------------------------------

### Ejemplo 1

      $ frutaflops &
      $ verduiops
      5 301 VerduIOPS
      5 288 VerduIOPS
      5 320 VerduIOPS
      4 17284 FrutaFLOPS
      5 288 VerduIOPS
      5 301 VerduIOPS
      5 310 VerduIOPS
      5 310 VerduIOPS
      5 305 VerduIOPS
      5 296 VerduIOPS
      5 330 VerduIOPS
      4 13357 FrutaFLOPS
      5 296 VerduIOPS
      5 310 VerduIOPS
      5 288 VerduIOPS
      5 292 VerduIOPS
      5 301 VerduIOPS
      5 280 VerduIOPS
      5 296 VerduIOPS
      4 13706 FrutaFLOPS
      5 296 VerduIOPS
      5 292 VerduIOPS
      5 305 VerduIOPS
      5 310 VerduIOPS
      5 301 VerduIOPS
      5 292 VerduIOPS
      5 296 VerduIOPS
      4 13357 FrutaFLOPS
      5 230 VerduIOPS

>En este caso, ejecutamos primero *frutaflops* y antes de que tome un proceso,
>ejecutamos el *verduiops* y funciona como se esperaba.

### Ejemplo 2

      $ frutaflops &
      $ verdui4 30393 FrutaFLOPS
      ops4 33825 FrutaFLOPS
      4 27715 FrutaFLOPS

      5 284 VerduIOPS
      5 320 VerduIOPS
      5 325 VerduIOPS
      5 320 VerduIOPS
      5 296 VerduIOPS
      4 15572 FrutaFLOPS
      5 284 VerduIOPS
      5 305 VerduIOPS
      5 288 VerduIOPS
      5 320 VerduIOPS
      5 301 VerduIOPS
      5 292 VerduIOPS
      4 15015 FrutaFLOPS
      5 288 VerduIOPS
      5 280 VerduIOPS
      5 288 VerduIOPS
      5 280 VerduIOPS
      5 273 VerduIOPS
      4 17772 FrutaFLOPS
      5 259 VerduIOPS
      5 320 VerduIOPS
      5 320 VerduIOPS
      5 269 VerduIOPS
      5 284 VerduIOPS
      5 305 VerduIOPS
      5 325 VerduIOPS
      4 14364 FrutaFLOPS
      5 296 VerduIOPS
      5 305 VerduIOPS
      5 301 VerduIOPS
      5 305 VerduIOPS
      5 305 VerduIOPS
      5 301 VerduIOPS
      4 15196 FrutaFLOPS
      5 305 VerduIOPS
      5 305 VerduIOPS
      5 325 VerduIOPS

>Ahora ejecutamos nuevamente *frutaflops* pero esperamos que se ejecuten algunos
>procesos y luego ejecutamos *verduiops* y funciona correctamente.

### Ejemplo 3

      $ verduiops &
      $ frutaflops
      4 211 VerduIOPS
      4 249 VerduIOPS
      4 292 VerduIOPS
      4 296 VerduIOPS
      4 296 VerduIOPS
      5 21254 FrutaFLOPS
      4 273 VerduIOPS
      4 296 VerduIOPS
      4 301 VerduIOPS
      4 273 VerduIOPS
      4 276 VerduIOPS
      5 20627 FrutaFLOPS
      4 284 VerduIOPS
      4 265 VerduIOPS
      4 301 VerduIOPS
      4 276 VerduIOPS
      5 18893 FrutaFLOPS
      4 284 VerduIOPS
      4 288 VerduIOPS
      4 280 VerduIOPS
      4 280 VerduIOPS
      5 21183 FrutaFLOPS
      4 292 VerduIOPS
      4 315 VerduIOPS
      4 280 VerduIOPS
      4 288 VerduIOPS
      4 284 VerduIOPS
      5 20971 FrutaFLOPS
      4 292 VerduIOPS
      4 288 VerduIOPS
      4 288 VerduIOPS
      4 310 VerduIOPS
      5 18396 FrutaFLOPS
      4 269 VerduIOPS
      4 276 VerduIOPS

>Ahora ejecutamos *verduiops* y se ejecuta un proceso I/O bound y luego
>ejecutamos *frutaflops* y por lo que se ve no funciona correctamente.


      $ verduiops &
      $ frutaflops

      4 175 VerduIOPS
      4 259 VerduIOPS
      4 347 VerduIOPS
      4 335 VerduIOPS
      4 315 VerduIOPS
      4 325 VerduIOPS
      4 325 VerduIOPS
      4 347 VerduIOPS
      4 305 VerduIOPS
      4 320 VerduIOPS
      5 12029 FrutaFLOPS
      4 273 VerduIOPS
      4 301 VerduIOPS
      4 310 VerduIOPS
      4 305 VerduIOPS
      4 320 VerduIOPS
      4 301 VerduIOPS
      4 330 VerduIOPS
      4 320 VerduIOPS
      5 11295 FrutaFLOPS
      4 320 VerduIOPS
      4 320 VerduIOPS
      4 335 VerduIOPS
      4 330 VerduIOPS
      4 325 VerduIOPS
      4 341 VerduIOPS
      4 310 VerduIOPS
      4 335 VerduIOPS
      4 330 VerduIOPS
      5 10979 FrutaFLOPS
      4 330 VerduIOPS
      4 325 VerduIOPS

>Y en este caso hicimos exactamente lo mismo pero evidentemente ahora funciona
>correctamente.
>Esto nos da a pensar que puede ser el procesador la manera en que elije ejecutar
>los procesos y en un momento funciona adecuadamente y en otras ocasiones no tan
>bien.

### Ejemplo 4

      $ verduiops &
      4 176 VerduIOPS
      4 184 VerduIOPS
      4 176 VerduIOPS
      frutaflops
      4 193 VerduIOPS
      4 232 VerduIOPS
      4 301 VerduIOPS
      4 315 VerduIOPS
      4 335 VerduIOPS
      4 284 VerduIOPS
      4 301 VerduIOPS
      4 284 VerduIOPS
      5 14734 FrutaFLOPS
      4 269 VerduIOPS
      4 296 VerduIOPS
      4 301 VerduIOPS
      4 296 VerduIOPS
      4 288 VerduIOPS
      4 296 VerduIOPS
      4 325 VerduIOPS
      5 14074 FrutaFLOPS
      4 330 VerduIOPS
      4 310 VerduIOPS
      4 320 VerduIOPS
      4 296 VerduIOPS
      4 335 VerduIOPS
      4 301 VerduIOPS
      4 305 VerduIOPS
      4 310 VerduIOPS
      5 12813 FrutaFLOPS
      4 280 VerduIOPS
      4 296 VerduIOPS
      4 284 VerduIOPS
      4 330 VerduIOPS
      4 310 VerduIOPS
      4 292 VerduIOPS
      4 288 VerduIOPS
      5 12312 FrutaFLOPS
      4 315 VerduIOPS
      4 310 VerduIOPS

>En este último caso, ejecutamos *verduiops* y dejamos que se ejecuten varios
>procesos I/O bound y luego ejecutamos *frutaflops* y funciona correctamente.
>Pero había otra veces durante la realización de este laboratorio cuando probamos
>exactamente de la misma manera los programas *verduiops* y *frutaflops* y no
>funcionaba como esperábamos.


Errores durante el proceso de desarrollo del laboratorio
--------------------------------------------------------
>  Unos de los errores que tuvimos fue que en la función fork() poníamos unos
>'if' que en sus respectivas guardas preguntaban la prioridad del proceso que
>se creaba para poder colocarlo en el buffer que corresponda, pero después nos
>dimos cuenta que cuando se crea un proceso siempre se coloca en la cola de
>mayor prioridad, sin importar el tipo de proceso que sea (I/O bound ó CPU bound).
>  Otros de los errores que nos ocurrió fue que al principio del desarrollo del
>proyecto habíamos echo que el nuevo planificador recorriera la tabla de procesos
>y gracias a nuestra ayudante que nos dijo que eso estaba mal, pudimos solucionarlo
>a tiempo, sino posiblemente a futuro nos hubiera complicado mas.
>  Otros de los errores que surgieron, fue el del famoso 'panic', cuando
>compilábamos el xv6 nos aparecía un error de "panic: acquire" el cual creemos
>que ocurría porque en una función adquiríamos el bloqueo, el cual no era
>requerido. Otro error de 'panic' era el "panic: trap" que la verdad todavía no
>sabemos exactamente porque ocurría, así que lo que hicimos fue comparar el código
>original con el que estábamos modificando, y unas lineas nos dimos cuenta
>(con ayuda de nuestra ayudante) que habíamos borrado unas lineas que no había
>que borrar, así que rearmamos esa parte del código de nuevo, y logro compilar
>y funcionar todo.


Apreciación del Laboratorio
---------------------------

>  En general el laboratorio nos pareció muy desafiante, proponía algo muy
>interesante que es cambiar el planificador de un sistema operativo !!!, al
>principio nos costo empezar a trabajar, pero gracias a las preguntas que les
>hicimos a los profesores, a nuestro ayudante alumno, y discusiones con compañeros
>para poder entre todos sacarnos las dudas que teníamos, pudimos comenzar a
>entender mejor las cosas y empezar a desarrollar el nuevo planificador.
>  Por otra parte nos ayudo bastante para poder entender lo que veíamos en la
>parte teórica de la materia, es un tema bastante interesante las distintas 
>políticas hay para los planificadores, ojala pudiéramos implementar otras para
>ver las diferencias que existen entre ellas en la practica.


Links que usamos como referencia:
---------------------------------

* http://es.wikipedia.org/wiki/Planificaci%C3%B3n_mediante_colas_multinivel
* http://es.wikipedia.org/wiki/Buffer_circular
* http://es.slideshare.net/Romelestevez/inf-324-01-03-planificadores
* Libro de Sistemas Operativos Modernos 3° edicion, Andrew S. Tanenbaum
