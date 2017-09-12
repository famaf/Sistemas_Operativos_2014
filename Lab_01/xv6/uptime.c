#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int hora = uptime();

  printf(1, "%d\n", hora);

  exit();
}
