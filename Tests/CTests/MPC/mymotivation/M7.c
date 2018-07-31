#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h>

int x=0;
int y=0;
int num;

pthread_mutex_t lock;

// T1
void *testT1() {
	int i; klee_make_symbolic(&i, sizeof(i), "i");
	x = 2;
	y = 5;
	if (i == 3) {
		x++;
		pthread_mutex_lock(&lock);
		y--;
		pthread_mutex_unlock(&lock);
	}
}

// T3
void *testT3() {
	x = 5;
	y = 0;
	if (x == 108) {
		if (y == 2)
		  assert(0);
	}
}

// T2
void *testT2() {
	x = 100;
	int j, m; klee_make_symbolic(&j, sizeof(j), "j");  
	if (j > 2)
	    return ;
	while (j-- > 0) {
		pthread_mutex_lock(&lock);
		y++;
		pthread_mutex_unlock(&lock);
	}
}

void *f0() {
	int k0; klee_make_symbolic(&k0, sizeof(k0), "k0"); 
	if (k0 == 3)
	  x++;  
}

void *f1() {
	int k1; klee_make_symbolic(&k1, sizeof(k1), "k1"); 
	if (k1 == 3)
	  x++;  
}

void *f2() {
	int k2; klee_make_symbolic(&k2, sizeof(k2), "k2"); 
	if (k2 == 3)
	  x++;  
}

void *f3() {
	int k3; klee_make_symbolic(&k3, sizeof(k3), "k3"); 
	if (k3 == 3)
	  x++;  
}

void *f4() {
	int k4; klee_make_symbolic(&k4, sizeof(k4), "k4"); 
	if (k4 == 3)
	  x++;  
}

void *f5() {
	int k5; klee_make_symbolic(&k5, sizeof(k5), "k5"); 
	if (k5 == 3)
	  x++;  
}

void *f6() {
	int k6; klee_make_symbolic(&k6, sizeof(k6), "k6"); 
	if (k6 == 3)
	  x++;  
}

void *f7() {
	int k7; klee_make_symbolic(&k7, sizeof(k7), "k7"); 
	if (k7 == 3)
	  x++;  
}

void *f8() {
	int k8; klee_make_symbolic(&k8, sizeof(k8), "k8"); 
	if (k8 == 3)
	  x++;  
}

void *f9() {
	int k9; klee_make_symbolic(&k9, sizeof(k9), "k9"); 
	if (k9 == 3)
	  x++;  
}

int main(int argc, char const *argv[])
{
  pthread_t t[13]; klee_make_symbolic(&x, sizeof(x), "shared*x"); klee_make_symbolic(&y, sizeof(y), "shared*y"); x = 0, y = 0;

  pthread_create(&t[0], NULL, testT1, NULL);
  pthread_create(&t[1], NULL, testT2, NULL);
  pthread_create(&t[2], NULL, testT3, NULL);
  pthread_create(&t[3], NULL, f0, NULL);
  pthread_create(&t[4], NULL, f1, NULL);
  pthread_create(&t[5], NULL, f2, NULL);
  pthread_create(&t[6], NULL, f3, NULL);
  pthread_create(&t[7], NULL, f4, NULL);
  pthread_create(&t[8], NULL, f5, NULL);
  pthread_create(&t[9], NULL, f6, NULL);
  /*pthread_create(&t[10], NULL, f7, NULL); // M8
  pthread_create(&t[11], NULL, f8, NULL);
  /*pthread_create(&t[12], NULL, f9, NULL);*/
 
  pthread_join(t[0], NULL);
  pthread_join(t[1], NULL);
  pthread_join(t[2], NULL);
  pthread_join(t[3], NULL);
  pthread_join(t[4], NULL);
  pthread_join(t[5], NULL);
  pthread_join(t[6], NULL);
  pthread_join(t[7], NULL);
  pthread_join(t[8], NULL);
  pthread_join(t[9], NULL);
  /*pthread_join(t[10], NULL);  // M8
  pthread_join(t[11], NULL);
  /*pthread_join(t[12], NULL);*/

  return 0;
}


