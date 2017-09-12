#include "types.h"
#include "stat.h"
#include "user.h"

#define N 128

static float a[N][N];
static float b[N][N];
static float c[N][N];

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      a[y][x] = y - x;
      b[y][x] = x - y;
      c[y][x] = 0.0f;
    }
  }
}

static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      for (k = 0; k < N; ++k) {
        c[y][x] += beta * a[y][k] * b[k][x];
      }
    }
  }
}

int
main(int argc, char *argv[])
{
  int pid = getpid();
  float beta = 1.0f;

  init();
  for (;;) {
    int start = gettimeofday();
    smm(beta);
    beta = -beta;
    int end = gettimeofday();
    long elapsed = (long) end - (long) start;
    long ops = 3 * N * N * N;

    printf(1, "%d %d FrutaFLOPS\n", pid, (int) (ops / elapsed));
  }

  printf(1, "%f\n", c[0][0]);
  exit();
}
