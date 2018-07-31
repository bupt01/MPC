#include <pthread.h>

#include "crest.h"
#include "../../../include/concrest_assert.h"

int x = 1;
int done = 0;

void* Thread1(void* param) {
//  x = 1;
  done = 1;
  x = 1;
  x = 0;
    
  pthread_exit(NULL);
}

void* Thread2(void* param) {
  if (done) {
    assert(x);
  }

  pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  pthread_t thread1, thread2;
  
  CREST_shared_int(x);
  CREST_shared_int(done);

  pthread_create(&thread1, NULL, Thread1, NULL);
  pthread_create(&thread2, NULL, Thread2, NULL);
  
  pthread_exit(NULL);
}

