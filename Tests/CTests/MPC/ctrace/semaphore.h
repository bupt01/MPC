#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include <pthread.h>
#include <assert.h>

struct sem_t {
  unsigned value;
  pthread_mutex_t mutex;
};

typedef struct sem_t sem_t;


int sem_init(sem_t *sem, int pshared, unsigned int value);
int sem_wait(sem_t *sem);
int sem_post(sem_t *sem);
int sem_destroy(sem_t *sem);


int sem_init(sem_t *sem, int pshared, unsigned int value) {
  // pshared has to be 0 ...
  
  const pthread_mutexattr_t* attr = NULL;
  pthread_mutex_init(&(sem->mutex), attr);
  //sem->value = value;
  //CREST_shared_int(sem->value);
  unsigned vvalue;
  //klee_make_symbolic(&vvalue, sizeof(vvalue), "vvalue");
  sem->value = value;

  return 0;
}

int sem_wait(sem_t *sem) {
  pthread_mutex_lock(&(sem->mutex));
  assert(sem->value != 0);
  sem->value--;
  pthread_mutex_unlock(&(sem->mutex));
  
  return 0;
}

int sem_post(sem_t *sem) {
  pthread_mutex_lock(&(sem->mutex));
  sem->value++;
  pthread_mutex_unlock(&(sem->mutex));
  
  return 0;
}

int sem_destroy(sem_t *sem) {
  pthread_mutex_destroy(&(sem->mutex));
  
  return 0;
}


#endif // SEMAPHORE_H
