#include <pthread.h>

#define RW_LOCK_BIAS            1 //0x00100000
#define WRITE_LOCK_CMP          RW_LOCK_BIAS

/** Example implementation of linux rw lock along with 2 thread test
 *  driver... */

typedef union {
	int lock;
} rwlock_t;

pthread_mutex_t l;

int atomic_fetch_sub_explicit(int *lock, int val) {
	pthread_mutex_lock(&l);
	int previous = *lock;
	*lock = *lock - val;
	pthread_mutex_unlock(&l);
	return previous;
}

int atomic_fetch_add_explicit(int *lock, int val) {
	pthread_mutex_lock(&l);
	int previous = *lock;
	*lock = *lock + val;
	pthread_mutex_unlock(&l);
	return previous;
}

static inline int write_trylock(rwlock_t *rw)
{
	int priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS);
	if (priorvalue == RW_LOCK_BIAS)
		return 1;

	atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS);
	return 0;
}

static inline void write_unlock(rwlock_t *rw)
{
	atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS);
}

rwlock_t mylock;
int shareddata;

static void *a() {
	int i, k1;klee_make_symbolic(&k1, sizeof(k1), "k1");
    if (k1>5) return ;
	for(i = 0; i < k1; i++) {
		if (write_trylock(&mylock)) {
			write_unlock(&mylock);
		}
	}
}

static void *b() {
	int i, k2;klee_make_symbolic(&k2, sizeof(k2), "k2");
    if (k2>5) return ;
	for(i = 0; i < k2; i++) {
		if (write_trylock(&mylock)) {
			write_unlock(&mylock);
		}
	}
}

static void *c() {
	int i, k3;klee_make_symbolic(&k3, sizeof(k3), "k3");
	for(i = 0; i < k3; i++) {
		if (write_trylock(&mylock)) {
			write_unlock(&mylock);
		}
	}
}

int main(int argc, char *argv)
{
	pthread_t t[3];klee_make_symbolic(&mylock, sizeof(mylock), "shared*mylock");
	mylock.lock = RW_LOCK_BIAS;

	pthread_create(&t[0], NULL, a, NULL);
	pthread_create(&t[1], NULL, b, NULL);
	//pthread_create(&t[2], NULL, c, NULL);

	pthread_join(t[0], NULL);
	pthread_join(t[1], NULL);
	//pthread_join(t[2], NULL);

	return 0;
}
