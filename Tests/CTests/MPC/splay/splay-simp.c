#include <stdio.h>
#include <string.h>		/* for strdup */
#include <stdlib.h>		/* for free */
#include <errno.h>
#include "crest.h"
#include "../assert.h"

pthread_mutex_t mutex, mutex_2;
int opCount = 0;
int lastInsert;

void * thread_routine(void* arg)
{
  int id = (int)arg;
  int tmp;

      printf("thread %d \n", id);

      pthread_mutex_lock(&mutex);
      if(opCount==1);
      pthread_mutex_unlock(&mutex); 

      pthread_mutex_lock(&mutex);
      opCount++;
      pthread_mutex_unlock(&mutex); 

      pthread_mutex_lock(&mutex_2);
      lastInsert = id; 
      pthread_mutex_unlock(&mutex_2);

      pthread_mutex_lock(&mutex); 
      tmp = opCount;
      pthread_mutex_unlock(&mutex);
      if(tmp==3){
	pthread_mutex_lock(&mutex_2);
        tmp = lastInsert;
        pthread_mutex_unlock(&mutex_2);
        if(tmp!= id);
      }
     

      pthread_mutex_lock(&mutex); 
      tmp = opCount;
      pthread_mutex_unlock(&mutex);
      if(tmp==4){
	pthread_mutex_lock(&mutex_2);
	tmp = lastInsert;
	pthread_mutex_unlock(&mutex_2);
        if(tmp!= id);
      }

      pthread_mutex_lock(&mutex);
      opCount++;
      pthread_mutex_unlock(&mutex); 


      pthread_mutex_lock(&mutex);
      opCount++;
      pthread_mutex_unlock(&mutex);


      pthread_exit(NULL);
 
}


int
main ()
{
  pthread_t t1, t2, t3;



  pthread_mutex_init(&(mutex), NULL);
  pthread_mutex_init(&(mutex_2), NULL);
  CREST_shared_int(opCount);
  CREST_shared_int(lastInsert);

  printf("in main \n");
  pthread_create(&t1, NULL, thread_routine, (void*)1);
  pthread_create(&t2, NULL, thread_routine, (void*)2);

  pthread_exit(NULL);
  return 0;
}
