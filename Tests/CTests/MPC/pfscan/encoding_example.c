#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "crest.h"
#include "../assert.h"

int x;

void* Thread1(void* arg) {
  x = 1;
  pthread_exit(NULL);
}

void* Thread2(void* arg) {
  x = 2;
  pthread_exit(NULL);
}

void* Thread3(void* arg) {
  assert(x == 0);
  pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  CREST_shared_int(x);

  pthread_t thread1;
  pthread_t thread2;
  pthread_t thread3;
  pthread_create(&thread1, NULL, Thread1, NULL);
  pthread_create(&thread2, NULL, Thread2, NULL);
  pthread_create(&thread3, NULL, Thread3, NULL);

  /* Last thing that main() should do */
  pthread_exit(NULL);
}

