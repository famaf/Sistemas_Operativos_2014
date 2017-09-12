#include "types.h"
#include "defs.h"
#include "spinlock.h"

#define N 100

int sem[N];//stores the count of resources of each semaphore.
int init[N];//says if the semaphore is initialized or not.
struct spinlock locked;//variable that takes the lock and is called by 
                       //acquire, release and sleep.


//Initialize the two arrays in zero.
void
init_array(void)
{
  uint i;

  for(i = 0; i < N; i++)
  {
    sem[i] = 0;
    init[i] = 0;
  }
}

/*Open a named semaphore, and initialize it only if entered value
is greater than or equal to zero.*/
int
sys_sem_init(void)
{
  int semaphore;
  int value;

  if(argint(0, &semaphore) < 0 || semaphore < 0 ||semaphore > N)
    return -1;

  if(argint(1, &value) < 0)
    return -1;

  acquire(&locked);

  if(value >= 0)
    sem[semaphore] = value;

  init[semaphore] = 1;

  release(&locked);

  return 0;
}


//Frees one resource and wakes up all processes.
int
sys_sem_up(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0 || semaphore < 0 || semaphore > N)
    return -1;

  if(init[semaphore] == 0)
    return -1;

  acquire(&locked);

  sem[semaphore] = sem[semaphore] + 1;

  wakeup(sem);

  release(&locked);

  return 0;
}


/*Restarts the semaphore if it was initialized, and sets it to zero. 
Samely whit processes.*/
int
sys_sem_release(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0)
    return -1;

  if(init[semaphore] == 0)
    return -1;

  if(init[semaphore] == 1){
    init[semaphore] = 0;
  }
  if(sem[semaphore] > 0){
    sem[semaphore] = 0;
  }

  return 0;
}


/* Once we make up a semaphore, we wake up all the sleeping processes,
but with sem_down, one or many of them will take the available resource, and
the other processes will sleep again.
All this happens within the critical seccion.
*/
int
sys_sem_down(void)
{
  int semaphore;

  if(argint(0, &semaphore) < 0)
    return -1;

  acquire(&locked);

  while(sem[semaphore] == 0){
    sleep(sem, &locked);//there are not more resources in the semaphore so the
  }                     //processes will sleep.

  if(sem[semaphore] > 0){
  sem[semaphore] = sem[semaphore] - 1;//there are resources, so the processes
                                      //will take them.
  }

  release(&locked);

  return 0;
}
