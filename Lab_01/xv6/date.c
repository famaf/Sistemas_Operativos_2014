#include "types.h"
#include "stat.h"
#include "user.h"

//funcion que imprime la cantidad de segundos actualizados desde the epoch
//cada vez que ingresemos el comando date por consola.

int
main(int argc, char *argv[])
{
  int seconds = 0;

  seconds = gettimeofday();
  printf(1, "%d\n", seconds);

  exit();
}
