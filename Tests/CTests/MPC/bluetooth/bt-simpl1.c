#include <pthread.h>
#include <stdio.h>
#include "crest.h"
#include "../assert.h"

int pendingIO;
int stopped, stoppingFlag;

void func1(int* input1) {
  
    int y;
  
    printf("func1\n");
    
    y = stoppingFlag;
    
    printf("y = %d\n", y);
    
    if (y != 1) {
        printf("a)\n");
        pendingIO++;
    }
    else {
        printf("b)\n");
	printf("y = %d\n", y);
    }
    
    if (stopped != 1) {
        
    }
    
    pendingIO--; // value is important!

    pthread_exit(NULL);
}

void func2(int* input2) {

    printf("func2\n");
  
    pendingIO--;
    
    if (pendingIO == 0) {
        
    }
    
    pthread_exit(NULL);
}

int main() {
  
    printf("main\n");

    stopped = 0;
    stoppingFlag = 0;
    pendingIO = 1;

    CREST_shared_int(stopped);
    CREST_shared_int(stoppingFlag);
    CREST_shared_int(pendingIO);

    pthread_t pt1;
    pthread_t pt2;

    pthread_create(&pt1, NULL, &func1, NULL);
    pthread_create(&pt2, NULL, &func2, NULL);

    pthread_exit(NULL);
}
