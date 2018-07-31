/*
 * Dekker's algorithm, implemented on pthreads
 *
 * To use as a test to see if/when we can make
 * memory consistency play games with us in 
 * practice. 
 *
 */ 

#include <assert.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#undef PRINT_PROGRESS 

static volatile int flag1 = 0;
static volatile int flag2 = 0;
static volatile int turn  = 1;
static volatile int gSharedCounter = 0;
int gLoopCount;
int gOnePercent;
int times1, times2;

void dekker1( ) {
    flag1 = 1;
    turn  = 2;
    times1 = 30;
    while(times1-- && (flag2 ==  1) && (turn == 2)) ;
    // Critical section
    gSharedCounter++;
    // Let the other task run
    flag1 = 0;
}

void dekker2(void) {
    flag2 = 1;
    turn = 1;
    times2 = 30;
    while(times2-- && (flag1 ==  1) && (turn == 1)) ;
    // critical section
    gSharedCounter++;        
    // leave critical section
    flag2 = 0;
}

//
// Tasks, as a level of indirection
//
void *task1(void *arg) {
    int i,j;
    printf("Starting task1\n");
    // Do the dekker very many times
#ifdef PRINT_PROGRESS
    for(i=0;i<100;i++) {
        printf("[One] at %d%%\n",i);
        for(j=gOnePercent;j>0;j--) {
            dekker1();
        }
    }
#else
    // Simple basic loop
    for(i=gLoopCount;i>0;i--) {
        dekker1();
    }
#endif

}

void *task2(void *arg) {
    int i,j;
    printf("Starting task2\n");
#ifdef PRINT_PROGRESS
    for(i=0;i<100;i++) {
        printf("[Two] at %d%%\n",i);
        for(j=gOnePercent;j>0;j--) {
            dekker2();
        }
    }
#else
    for(i=gLoopCount;i>0;i--) {
        dekker2();
    }
#endif
}

int
main(int argc, char ** argv)
{
    pthread_t      dekker_thread_1;
    pthread_t      dekker_thread_2;
    int            result;
    int            expected_sum;

    int loopCount = 1;
    gLoopCount  = loopCount;
    gOnePercent = loopCount/100;
    expected_sum = 2*loopCount;

    klee_make_symbolic(&flag1, sizeof(flag1), "shared*flag1");
    klee_make_symbolic(&flag2, sizeof(flag2), "shared*flag2");
    klee_make_symbolic(&turn, sizeof(turn), "shared*turn");
    klee_make_symbolic(&gSharedCounter, sizeof(gSharedCounter), "shared*gSharedCounter");
    

    /* Start the threads */
    pthread_create(&dekker_thread_1, NULL, task1, NULL);
    pthread_create(&dekker_thread_2, NULL, task2, NULL);

    /* Wait for the threads to end */
    pthread_join(dekker_thread_1, NULL);

    pthread_join(dekker_thread_2, NULL);
    printf("Both threads terminated\n");
}

