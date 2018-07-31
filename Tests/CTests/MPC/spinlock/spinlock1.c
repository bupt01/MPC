
#include <pthread.h>

typedef struct rwlock {
	int lock;
} rwlock_t;

rwlock_t mylock;
pthread_mutex_t lock;

void lock_init(rwlock_t *lock) {
  lock->lock=0;
}

int write_trylock(rwlock_t *rw) {
  
  pthread_mutex_lock(&lock);
  if (rw->lock == 0) {
	 rw->lock = 1;  
	 pthread_mutex_unlock(&lock);
	 return 1;
  }
  pthread_mutex_unlock(&lock);
  return 0;
}


void write_unlock(rwlock_t *rw) {
  rw->lock=0;
}

void foo(rwlock_t *mylock) {
	int flag=write_trylock(mylock);
	if (flag) {
		write_unlock(mylock);
	}
}

void bar1(rwlock_t *mylock) 
{ 
	int i, k1; klee_make_symbolic(&k1, sizeof(k1), "k1");
    if (k1>5) return ;
	for(i=0;i<k1;i++) 
		foo(mylock);
}

void bar2(rwlock_t *mylock) 
{ 
	int i, k2; klee_make_symbolic(&k2, sizeof(k2), "k2");
    if (k2>5) return ;
	for(i=0;i<k2;i++) 
		foo(mylock);
}

void bar3(rwlock_t *mylock) 
{ 
	int i, k3; klee_make_symbolic(&k3, sizeof(k3), "k3");
    if (k3>5) return ;
	for(i=0;i<k3;i++) 
		foo(mylock);
}

void init() 
{
  lock_init(&mylock);
}
void *e()
{
  bar1(&mylock);
}
void *d()
{
  bar2(&mylock);
}
void *f()
{
  bar3(&mylock);
}


int main(int argc, char const *argv[]) {
	pthread_t t[3]; klee_make_symbolic(&mylock, sizeof(mylock), "shared*mylock");
  
	init();
	pthread_create(&t[0], NULL, e, NULL);
	pthread_create(&t[1], NULL, d, NULL);
	//pthread_create(&t[2], NULL, f, NULL);
	pthread_join(t[0], NULL);
	pthread_join(t[1], NULL);
	//pthread_join(t[2], NULL);
}
