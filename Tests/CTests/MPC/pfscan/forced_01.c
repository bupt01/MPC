#include <pthread.h>
#include <stdlib.h>

#include "crest.h"
#include "../assert.h"

/*

NOTE: Since we do not block forced interferences at the moment, we encounter the bug immediatelly.

*/

int x, y, z;

void *thread_1(void *threadid)
{
  x = 1;
  y = 2;
  z = 3;
  
  pthread_exit(NULL);
}

void *thread_2(void *threadid)
{
  if (z == 3) {
    if (y == 2) {
      assert(x != 1);
    }
  }
  
  pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  pthread_t t1, t2;
  
  CREST_shared_int(x);
  CREST_shared_int(y);
  CREST_shared_int(z);

  pthread_create(&t1, NULL, thread_1, (void *)NULL);
  pthread_create(&t2, NULL, thread_2, (void *)NULL);
  
  /* Last thing that main() should do */
  pthread_exit(NULL);
}

