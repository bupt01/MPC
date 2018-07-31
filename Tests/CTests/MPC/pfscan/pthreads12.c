#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#define NUM_THREADS 3

#include "crest.h"
#include "../assert.h"

int x, y;

void *thread_1(void *threadid)
{
  x = 0;
  y = 0;
  
  assert(x == y);
  
  pthread_exit(NULL);
}

void *thread_2(void *threadid)
{
  x = 1;
  y = 1;
  
  pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  pthread_t t1, t2;
  
  CREST_shared_int(x);
  CREST_shared_int(y);

  pthread_create(&t1, NULL, thread_1, (void *)NULL);
  pthread_create(&t2, NULL, thread_2, (void *)NULL);
  
  /* Last thing that main() should do */
  pthread_exit(NULL);
}

