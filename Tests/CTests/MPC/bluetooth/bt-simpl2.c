#include <pthread.h>
#include <stdio.h>
#include "crest.h"
#include "../assert.h"

int pendingIO;
int stoppingFlag;

void func1(int* input1) 
{  
    if (stoppingFlag != 1) 
    {
        pendingIO++;
    }

    pendingIO--; // value is important!

    pthread_exit(NULL);
}

void func2(int* input2) 
{
    pendingIO--;
    
    assert(pendingIO == 0);
    
    pthread_exit(NULL);
}

int main() 
{  
    stoppingFlag = 0;
    pendingIO = 1;

    CREST_shared_int(stoppingFlag);
    CREST_shared_int(pendingIO);

    pthread_t pt1;
    pthread_t pt2;

    pthread_create(&pt1, NULL, &func1, NULL);
    pthread_create(&pt2, NULL, &func2, NULL);

    pthread_exit(NULL);
}
