#include "types.h"
#include "stat.h"
#include "user.h"

#define SEM_A 1 // Semaphore A
#define SEM_B 2 // Semaphore B

int
main(void)
{
  const uint N = 10;
  int i;
  int pid;

  pid = fork();

  if(sem_init(SEM_A, 1) == -1){ // Initialization of SEM_A
    printf(2, "ERROR\n"); // Print the error by STDERROR	
    exit(); // Exit if there is error
  }
  if(sem_init(SEM_B, 0) == -1){ // Initialization of SEM_B
    printf(2, "ERROR\n");// Print the error by STDERROR
    exit(); // Exit if there is error
  }

  for(i = 0; i < N; i++){
    if(pid == 0){
      sem_down(SEM_A); // P(SEM_A)
      printf(1, "ping\n");
      sem_up(SEM_B); // V(SEM_B)
    }
    if(pid > 0){
      sem_down(SEM_B); // P(SEM_B)
      printf(1, "pong\n");
      sem_up(SEM_A); // V(SEM_A)
    }
    if(pid < 0){
      printf(2, "ERROR\n"); // Print the error by STDERROR
      exit(); // Exit if there is error
    }
  }

  if (pid == wait()){
    sem_release(SEM_A); // Closed of SEM_A
    sem_release(SEM_B); // Closed of SEM_B
  }
    
  exit();
}
