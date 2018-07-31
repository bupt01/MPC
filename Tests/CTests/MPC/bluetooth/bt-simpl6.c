#include <stdio.h>
#include <pthread.h>
#include "crest.h"
#include "../assert.h"

int pendingIO;
int stoppingEvent;
int stopped, stoppingFlag;

void func1(int *input) {
    printf("func1.1)\n");
  
    if (stoppingFlag != 1) {
	printf("func1.2)\n");
  
	pendingIO++;
	
	printf("func1.3)\n");
  
        assert(stopped != 1);
	
	printf("func1.4)\n");
    }
    
    printf("func1.5)\n");

    pthread_exit(NULL);
}

void func2(int *input) {
    int status2 = 0;

    printf("func2.1)\n");
    
    int in = *input;
    
    printf("func2.2)\n");

    if (in == 1) {
	printf("func2.3)\n");
        
        if (stoppingFlag == 1) {
            status2 = -1;
        } else {
            pendingIO++;
            status2 = 0;
        }
        if (status2 == 0) {
            if (stopped == 1) {

            }
        }
        pendingIO--;
        if (pendingIO == 0)
            stoppingEvent = 1;
    } else {
        printf("func2.4)\n");
	
	stoppingFlag = 1;
	
	printf("func2.5)\n");
        
	pendingIO--;
	
	printf("func2.6)\n");
        
	if (pendingIO == 0) {
	    printf("func2.7)\n");
	    
            stoppingEvent = 1;
	    
	    printf("func2.8)\n");
	}
	
	printf("func2.9)\n");
	
        stopped = 1;
	
	printf("func2.10)\n");

    }
    
    printf("func2.11)\n");

    pthread_exit(NULL);
}

int main() {
  
    printf("main.1)\n");

    stoppingEvent = 0;
    stopped = 0;
    stoppingFlag = 0;
    pendingIO = 1;

    int input2;

    CREST_int(input2);

    CREST_shared_int(stoppingEvent);
    CREST_shared_int(stopped);
    CREST_shared_int(stoppingFlag);
    CREST_shared_int(pendingIO);

    pthread_t pt1;
    pthread_t pt2;

    printf("main.2)\n");
    pthread_create(&pt1, NULL, &func1, NULL);
    printf("main.3)\n");
    pthread_create(&pt2, NULL, &func2, &input2);
    printf("main.4)\n");

    pthread_exit(NULL);
}
