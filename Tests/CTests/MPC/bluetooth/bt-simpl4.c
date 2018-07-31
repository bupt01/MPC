#include <pthread.h>
#include "crest.h"
#include "../assert.h"

int stopped, stoppingFlag;

void func1(int *input) {
    if (stoppingFlag != 1) {
	assert(stopped != 1);
    }

    pthread_exit(NULL);
}

void func2(int *input) {
    stoppingFlag = 1;

    stopped = 1;

    pthread_exit(NULL);
}

int main() {

    stopped = 0;
    stoppingFlag = 0;

    CREST_shared_int(stopped);
    CREST_shared_int(stoppingFlag);

    pthread_t pt1;
    pthread_t pt2;

    pthread_create(&pt1, NULL, &func1, NULL);
    pthread_create(&pt2, NULL, &func2, NULL);

    pthread_exit(NULL);
}
