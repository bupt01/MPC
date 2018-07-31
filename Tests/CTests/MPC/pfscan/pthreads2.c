#include <pthread.h>

#include "crest.h"
#include "../assert.h"

int x;

void* Thread1(void* param) {
    x = 0;
    assert(x == 0);
    pthread_exit(NULL);
}

void* Thread2(void* param) {
    x = 2;
    pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  pthread_t thread1, thread2;
  
  CREST_shared_int(x);
  
  pthread_create(&thread1, NULL, Thread1, NULL);
  pthread_create(&thread2, NULL, Thread2, NULL);
  
  pthread_exit(NULL);
}


