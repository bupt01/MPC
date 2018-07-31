#include <pthread.h>

#include "crest.h"
#include "../assert.h"

int x;

void* Thread1(void* param) {
    assert(x != 5);
    pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  pthread_t thread1;

  CREST_int(x);
  CREST_shared_int(x);
  
  pthread_create(&thread1, NULL, Thread1, NULL);

  assert(x != 10);
  
  pthread_exit(NULL);
}


