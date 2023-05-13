#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h>

int x;
pthread_mutex_t lock;

void *thread1() {
    int x1, x2; 
    x1 = x;
    x = 2;
    x = 3; 
    pthread_mutex_lock(&lock);
    x1 = x; 
    x2 = x; 
    pthread_mutex_unlock(&lock);
    assert(x1 == x2); 
    x1 = x; 
     x = 4; 
     x = 5; 
     x = 6; 
     x = 7; 
} 

void *thread2() { 
    int x1, x2; 
     x = 2; 
     x1 = x; 
     x2 = x; 
     x1 = x; 
    pthread_mutex_lock(&lock);
    x = 4; 
    pthread_mutex_unlock(&lock);
     x1 = x; 
     x2 = x; 
     x1 = x; 
    x2 = x; 
    x1 = x; 
}

int main(int argc, char const *argv[])
{
    pthread_t t[2];
    klee_make_symbolic(&x, sizeof(x), "shared*x");
    pthread_create(&t[0], NULL, thread1, NULL);
    pthread_create(&t[1], NULL, thread2, NULL);

    pthread_join(t[0], NULL);
    pthread_join(t[1], NULL);
    return 0;
}
