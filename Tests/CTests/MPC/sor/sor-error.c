/* 
 * File:   main.cpp
 * Author: razavi
 *
 * Created on October 3, 2012, 10:19 AM
 */

#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "crest.h"
#include "../assert.h"

#define nthreads 2

int sync[nthreads];

int num_iterations;

void* SOR(void* identifier) {
    int p;
    //int id = *((int*) (identifier));
    
    int id = (int)identifier;

    for (p = 0; p < 2 * num_iterations; p++) {
	
        // Signal this thread has done iteration
        sync[id]++;
	
        // Wait for neighbours;
        if (id > 0) {
            //add assertion 
            //while (sync[id-1] < sync[id]) ;
            fprintf(stderr, "a)\n");
            assert(!(sync[id - 1] < sync[id]));
            fprintf(stderr, "b)\n");
        }

        /*if (id < nthreads - 1) {
            //add assertion
            //while (sync[id+1] < sync[id]) ;
            fprintf(stderr, "c)\n");
            assert(!(sync[id + 1] < sync[id]));
	    fprintf(stderr, "d)\n");
        }*/

    }
    
    pthread_exit(NULL);
}

void* SOR2(void* identifier) {
    int p;
    //int id = *((int*) (identifier));
    int id = (int)identifier;

    for (p = 0; p < 2 * num_iterations; p++) {
	
        // Signal this thread has done iteration
        sync[id]++;
	
        // Wait for neighbours;
        if (id > 0) {
            //add assertion 
            //while (sync[id-1] < sync[id]) ;
            fprintf(stderr, "a)\n");
            assert(!(sync[id - 1] < sync[id]));
            fprintf(stderr, "b)\n");
        }

        /*if (id < nthreads - 1) {
            //add assertion
            //while (sync[id+1] < sync[id]) ;
            fprintf(stderr, "c)\n");
            assert(!(sync[id + 1] < sync[id]));
	    fprintf(stderr, "d)\n");
        }*/

    }
    
    pthread_exit(NULL);
}

int main(int argc, char** argv) {
    int i, j;

    num_iterations = 2;

    pthread_t t[nthreads];

    for (i = 0; i < nthreads; i++) {
        CREST_shared_int(sync[i]);
	sync[i] = 0;
    }

    //int j1 = 0;
    pthread_create(&t[0], 0, SOR, (void*)0);
    //int j2 = 1;
    pthread_create(&t[1], 0, SOR2, (void*)1);

    /*for (j = 0; j < nthreads; j++) {
        pthread_create(&t[j], 0, SOR, (void*) (&j));
    }*/

    pthread_exit(NULL);
}

