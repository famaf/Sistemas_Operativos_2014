#include "types.h"
#include "user.h"
#define SEM_BARRIER 0

int
main(int argc, char *argv[])
{
  int i;
  sem_init(SEM_BARRIER, -1);
  sem_down(SEM_BARRIER);
  for(i = 1; i < argc; i++)
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
}

