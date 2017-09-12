Lab 4: Permisos
===============

INTRODUCCIÓN
------------

> Para comenzar este laboratorio fue necesario comprender como se definían los
>archivos, que era un inodo, su relación con los archivos, y como debían
>manejarse cuando estaban en memoria y cuando estaban en disco.
> Además de poder establecer los permisos, fue necesario entender la
>sincronización de estos entre memoria y disco, para que estos permisos se
>cumplan y puedan modificarse guardando su configuración.

Añadir permisos a inodos
------------------------

> Como primer paso del proyecto, era necesario tener un lugar donde almacenar
>esos 3 permisos que íbamos a otorgar a cada archivo.
> Lo que se hizo fue sacarle 3 bits al campo minor de la estructura *dinode*,
>resultando el campo minor con 13 bits de los 16 que tenía originalmente,
>y esos 3 faltantes, se otorgaban a un nuevo campo en la estructura llamado
>*permissions*.
> Luego se vio que existía una estructura de inodos en memoria, por lo que a la
>estructura *inode* se le realizó el mismo procedimiento que a la estructura
>*dinode* que descubrimos ahí que eran los inodos en disco.
>  A estos 3 bits del campo *permissions*, se los asociarán en distintas funciones
>del file system, tendrán asociados los 3 bits reales de permisos, los cuales son
>definidos en el archivo *types.h* donde se encuentran los bits de lectura,
>escritura y ejecución, de tal manera que se acomodan y leen en el siguiente
>orden:
>      Ejemplo: para el numero en binario '110', le corresponde '1' al bit de
>lectura, '1' al bit de escritura y '0' al bit de ejecución. En otras palabras,
>los permisos se ven como *RWX*.

### Sincronización entre cache en memoria y disco

> Al momento de bloquear un inodo, se lee el inodo del disco si es necesario,
>por lo que los permisos debían ser uno de los campos que necesitaba leer,
>es por eso que en la función *ilock(inode)*, se guardan los permisos del inodo
>que hay en disco, en el inodo que se va a copiar en memoria.
> Para completar la sincronización, al momento de copiar el inodo de memoria
>al disco, también se deben almacenar los permisos, es por eso que en la función
>*iupdate(inode)* se almacena el campo de permisos.

Implementar chmod
-----------------

### Implementación syscall chmod

> Luego de leer la explicación sobre inodos en fs.c, se implementó la syscall
>chmod, donde se siguió el procedimiento para modificar los permisos de inodo,
>siendo necesario marcar el inicio de la operación, el bloqueo previo del inodo,
>y luego de modificarlo, actualizarlo en disco y desbloquearlo, para finalmente,
>marcar en fin de la operación.
> En principio se analizan los posibles casos de errores al momento de tomar los
>argumentos necesarios, o que estos estén fuera de rango.
> Luego, marcamos el inicio de la operación a través de *begin_op()*,
>pudiendo ahora realizar los cambios en la estructura.
> A través de la función *namei(path)*, obteníamos el inodo propio del archivo,
>siendo necesario su bloqueo mediante *ilock(inode)*, siendo posible en este
>momento establecer los nuevos permisos otorgados, sobrescribiendo los permisos
>anteriores.
> Para finalizar, se actualiza el inodo en disco (*iupdate(inode)*), y se
>desbloquea con *iunlock(inode)*, quedando como último paso marcar el fin de la
>operación mediante *end_op()*.

### Implementación programa de usuario chmod

>  Luego de implementar la función *sys_chmod()*, comenzamos con la implementación
>de la función de usuario *chmod()*. Es esta la que me permitirá cambiar los
>permisos de otros programas de usuario.
>  Como en proyectos anteriores a la hora de implementar alguna función de usuario,
>esta interactúa con la syscall a través de otros archivos como *user.h* y *usys.S*.
>  Esta función toma como parámetros los *permisos*, los cuales deben ser números
>comprendidos entre '0' y '7', ya que en binario van desde '000' a '111', y otro
>parámetro que es la ruta al archivo al que quiero modificarle los permisos.
>  La manera de ejecutar este programa de usuario en la consola es:
>$ chmod (numero del 0 al 7) (archivo).

Hacer cumplir los permisos
--------------------------

>  Principalmente, tuvimos que añadir permisos en el inodo una vez que este es
>creado, con la función *ialloc()*, donde a cada inodo se le da permisos de
>lectura, escritura y ejecución.
>  Para hacer cumplir los permisos, hicimos unas pequeñas modificaciones en las
>funciones como *fileread()* donde seteamos el permiso de lectura, la cual implica
>revisar si el archivo tiene tal permiso, y en caso de no tenerlo hacer *return -1*
>Para la función *filewrite()*, seteamos el permiso de escritura de igual manera
>que en el caso de lectura. Por último, seteamos el permiso de ejecución en la
>función *exec()*, donde hicimos exactamente lo mismo, solo que en caso que el
>archivo no tenga tal permiso, se copia el inodo modificado al disco y luego se
>desbloquea para retornar el *error*.
>  Otro error (quizá el mas tonto), fue que a la hora de hacer el programa de
>usuario del *chmod* fue que al llamar a la syscall pasamos al revés los argumentos,
>otra cosa que nos ocurrió en esa función de usuario fue que al principio no usamos
>la función *atoi* nos tiraba un error que no pudimos identificar, pero luego de un
>tiempito nuestro ayudante alumno nos dijo donde ocurría el fallo, y también nos
>dijo que usáramos dicha función para poder solucionar el error de tipo.

Testchmod
---------
>  Una vez terminada la implementación, corrimos el programa testchmod, donde se
>presentaron errores que se explicarán en el siguiente ítem, pero podemos dar una
>breve explicación de los 5 tests que el programa chmod debía pasar.
>  El test numero 1, tira error en caso de que no pueda leer.
>  El test numero 2, tira error en caso que tenga permiso de lectura cuando no
>debía tenerlo.
>  El test numero 3, da error en caso que no pueda crear un nuevo archivo.
>  El test numero 4, da error en caso que no pueda escribir o leer el nuevo archivo
>creado.
>  Por último, el test 5, da error en el caso que se podía sobrescribir sobre
>el archivo nuevo sin antes tener seteado el permiso de escritura.

Errores durante el proceso de desarrollo del laboratorio
--------------------------------------------------------
> Uno de los errores que tuvimos a la hora de probar el sistemas de archivos es que
>nos habíamos olvidado de darle los permisos de ejecución a la consola, el chmod
>("todo es un archivo" eslogan de UNIX) y al shell, por lo cual al compilar el
>xv6 nos tiraba errores, los cuales pudimos solucionar gracias a nuestro ayudante
>alumno y a las charlas que teníamos con nuestros compañeros (a los cuales les
>pasaba lo mismo).
> Otro error durante el desarrollo del laboratorio, fue el de que a la hora de
>probar el sistema de archivo se nos quedaba tildado;
>este error se debía a que en algunas funciones nos habíamos olvidado de poner
>la función *end_op()* la cual se encarga, básicamente, de terminar una operación,
>así que lo que hicimos fue detectar donde podía llegar a ser el lugar donde faltaba
>esta función y agregarla, luego de agregarla probamos de nuevo el sistema de archivos
>y logro funcionar.
>  Otro de los errores, esta vez durante son del *testchmod*, el primer test que
>nos fallo fue el "test 4" el cual decía que no se podían leer ni escribir el 
>archivo sin tener los permisos, así que lo que hicimos fue modificar el 
>*filewrite* y *fileread* de forma adecuada para solucionar ese problema.
>  Otro de los test que nos fallo fue el test 5, el cual decía que no se puede
>sobrescribir un archivo sin tener permisos de escritura, así que lo que hicimos
>fue modificar la syscall *open* de manera tal que pasara este solucionar este 
>problema.
>  Otro de los test que nos fallo fue el numero 3, el cual nos tiraba un error
>cada vez que queríamos ejecutar el programa de usuario *testchmod* (previamente
>ya lo habíamos ejecutado una vez), para esto consultamos con nuestro ayudante alumno
>y nos explico que el *testchmod* no estaba muy bien implementado y que no era un
>error nuestro, para que esto no ocurriera, una vez que ejecutamos el programa de
>usuario, y si después queríamos hacerlo de nuevo, previamente teníamos que hacer
>un "make clean" para que esto no ocurriera.


Apreciación del Laboratorio
---------------------------
>  En general el laboratorio nos pareció muy desafiante, proponía algo muy
>interesante implementar (o mejor dicho, mejorar) un sistema de archivos, al
>principio nos costo empezar a trabajar, pero gracias a las
>preguntas que les hicimos a nuestro ayudante alumno, y discusiones con compañeros
>sobre funciones, e interpretación de lo que hace xv6, lectura de links, 
>investigación en internet etc. Logramos entre todos sacarnos las dudas que 
>teníamos y por suerte, logramos entender lo que teníamos que hacer, por lo cual
>pudimos comenzar a empezar a implementar los permisos del sistema de archivos.
>  Es un tema interesante lo de los permisos, además sabemos que lo que implementamos
>es muy básico, a lo que tienen otros sistemas te archivos, como son los permisos
>para un grupo de trabajo y para el resto de personas (que no tengan nada que ver
>con los archivos que se trabajan en la computadora).


Links usados como referencia
----------------------------
* http://es.wikipedia.org/wiki/Sistema_de_archivos
* http://es.wikipedia.org/wiki/Permisos_de_acceso_a_archivos
* http://en.wikipedia.org/wiki/Flag_field
* http://man7.org/linux/man-pages/man2/fchmod.2.html
* http://es.wikipedia.org/wiki/Inodo
* http://en.wikipedia.org/wiki/Bit_field
