//extern void __VERIFIER_assume(int);
extern void __VERIFIER_error() __attribute__ ((__noreturn__));

/* Testcase from Threader's distribution. For details see:
   http://www.model.in.tum.de/~popeea/research/threader
*/

#include <pthread.h>
#include <assert.h>
//#define assert(e) if (!(e)) ERROR: __VERIFIER_error();

int flag1 = 0, flag2 = 0; // boolean flags
int turn; // integer variable to hold the ID of the thread whose turn is it
int x; // boolean variable to test mutual exclusion

void *p0() {
  flag1 = 1;
  while (flag2 >= 1) {
    if (turn != 0) {
      flag1 = 0;
      while (turn != 0) {};
      flag1 = 1;
    }
  }
  // begin: critical section
  x = 0;
  assert(x<=0);
  // end: critical section
  turn = 1;
  flag1 = 0;
}

void *p1() {
  flag2 = 1;
  while (flag1 >= 1) {
    if (turn != 1) {
      flag2 = 0;
      while (turn != 1) {};
      flag2 = 1;
    }
  }
  // begin: critical section
  x = 1;
  assert(x>=1);
  // end: critical section
  turn = 0;
  flag2 = 0;
}

void *p0l() {
	if (turn) turn = 0; else turn = 1;/*int i;
	for (i = 0; i< 1; i++)
	  p0();*/
}

void *p1l() {
	if (turn) turn = 0; else turn = 1;/*int j;
	for (j = 0; j < 1; j++)
	   p1();*/
}

int main() {
  pthread_t t[2]; int k; klee_make_symbolic(&k, sizeof(k), "k"); klee_make_symbolic(&flag1, sizeof(flag1), "flag1");klee_make_symbolic(&flag2, sizeof(flag2), "flag2");klee_make_symbolic(&x, sizeof(x), "x");klee_make_symbolic(&turn, sizeof(turn), "turn"); k=0;flag1=flag2=0; //turn=0;
  if (k) turn = 0; else turn = 1;//assume(0<=turn && turn<=1);
  //if (0<=turn && turn<=1) {
  pthread_create(&t[0], NULL, p0, NULL);
  pthread_create(&t[1], NULL, p1, NULL);

  pthread_join(t[0], NULL);
  int i = 0;
  pthread_join(t[1], NULL);
  //}
  return 0;
}
