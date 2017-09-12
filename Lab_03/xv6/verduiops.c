#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define N 1024
#define TIMES 10

static char path[] = "verduiops0";
static char data[N];


static void rw(int fd) {
  write(fd, data, N);
  read(fd, data, N);
}

int
main(int argc, char *argv[])
{
  int fd, i;
  int pid = getpid();

  memset(data, 'a', sizeof(data));

  for(;;) {
    int start = gettimeofday();
    fd = open(path, O_CREATE | O_RDWR);
    for(i = 0; i < TIMES; ++i) {
      rw(fd);
    }
    close(fd);
    int end = gettimeofday();
    long elapsed = (long) end - (long) start;
    long bytes = 2 * N * TIMES;

    printf(1, "\t\t\t%d %d VerduIOPS\n", pid, (int) (bytes / elapsed));
  }
  
  exit();
}
