
#include <pthread.h>
int _seq;
int _data;

pthread_mutex_t lock;
int atomic_compare_exchange_strong(int* val1, 
			int val2, int newVal) {
	
	pthread_mutex_lock(&lock);
	if (*val1 == val2) {
		*val1 = newVal;  
		pthread_mutex_unlock(&lock);
		return 1;
	}
	pthread_mutex_unlock(&lock);
	return 0;

}

void seqlock_init() {
	_seq=0;
	_data=0;
}

int seqlock_read() {
	int old_seq = _seq;
	
	int c0 = (old_seq % 2 == 1);
	if (!c0) {
		int res = _data;
		int seq = _seq;
		
		int c1;
		c1 = seq == old_seq;
		if (c1) { // relaxed
			return res;
		}
	}
	return -1;
}

int seqlock_write(int new_data) {
	int old_seq = _seq;
	int c2 = (old_seq % 2 == 1);
	if (!c2) {
		int new_seq = old_seq + 1;
		if (atomic_compare_exchange_strong(&_seq, old_seq, new_seq)) {
			_data = new_data;
			pthread_mutex_lock(&lock);
			_seq = _seq + 1;
			pthread_mutex_unlock(&lock);

			return 1;
		}
	}
	return 0;
}

void *a() {
	int i, k1; klee_make_symbolic(&k1, sizeof(k1), "k1");
    if (k1>3) return ;
	for(i=0;i<k1;i++)
		seqlock_write(3);
}

void *b() {
	int i, k2; klee_make_symbolic(&k2, sizeof(k2), "k2");
    if (k2>3) return ;
	for(i=0;i<k2;i++) {
		int r1 = seqlock_read();
	}
}

void *c() {
	int i, k3; klee_make_symbolic(&k3, sizeof(k3), "k3");
    if (k3>3) return ;
	for(i=0;i<k3;i++) {
		int r1 = seqlock_read();
	}
}

static void i() {
	seqlock_init();
}

int main(int argc, char **argv) {
	pthread_t t[3]; klee_make_symbolic(&_seq, sizeof(_seq), "shared*seq"); klee_make_symbolic(&_data, sizeof(_data), "shared*data");
	
	seqlock_init();

	pthread_create(&t[0], NULL, a, NULL);
	pthread_create(&t[1], NULL, b, NULL);
	pthread_create(&t[2], NULL, c, NULL);

	pthread_join(t[0], NULL);
	pthread_join(t[1], NULL);
	pthread_join(t[2], NULL);

	return 0;
}
