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

pthread_mutex_t mutex;

int Gtotal = 0;
int sync[nthreads];

int omega;
//int** G;
int G[5][5];

int num_iterations = 1;
int M = 5, N = 5;

/*void RandomMatrix(int M, int N) {
    int k, j;
    G = (int**) malloc(M * sizeof (int*));
    for (k = 0; k < M; k++) {
        G[k] = (int*) malloc(N * sizeof (int));
        for (j = 0; j < N; j++) {
	    G[k][j] = j % 2;
        }
    }
}*/

void RandomMatrix(int M, int N) {
  G[0][0] = 1;
  G[0][1] = 1;
  G[0][2] = 1;
  G[0][3] = 1;
  G[0][4] = 1;

  G[1][0] = 1;
  G[1][1] = 0;
  G[1][2] = 0;
  G[1][3] = 0;
  G[1][4] = 1;

  G[2][0] = 1;
  G[2][1] = 0;
  G[2][2] = 0;
  G[2][3] = 0;
  G[2][4] = 1;

  G[3][0] = 1;
  G[3][1] = 0;
  G[3][2] = 0;
  G[3][3] = 0;
  G[3][4] = 1;

  G[4][0] = 1;
  G[4][1] = 1;
  G[4][2] = 1;
  G[4][3] = 1;
  G[4][4] = 1;
}

void initSync() {
    int i;
    for (i = 0; i < nthreads; i++) {
        CREST_shared_int(sync[i]);
	sync[i] = 0;
    }
}

void* SOR(void* identifier) {
    int p, i, j;
    //int id = *((int*) (identifier));
    int id = (int)identifier;
    
    int omega_over_four = 1;
    int one_minus_omega = 1;

    // update interior points
    int Mm1 = M - 1;
    int Nm1 = N - 1;

    int ilow, iupper, slice, tslice, ttslice;

    tslice = (Mm1) / 2;
    ttslice = (tslice + nthreads - 1) / nthreads;
    slice = ttslice * 2;

    ilow = id * slice + 1;
    iupper = ((id + 1) * slice) + 1;
    if (iupper > Mm1)
        iupper = Mm1 + 1;

    if (id == (nthreads - 1))
        iupper = Mm1 + 1;

    for (p = 0; p < 2 * num_iterations; p++) {

        for (i = ilow + (p % 2); i < iupper; i = i + 2) {

            if (i == 1) {

                for (j = 1; j < Nm1; j = j + 2) {
                     pthread_mutex_lock(&mutex);   
		     G[i][j] = omega_over_four * (G[i - 1][j] + G[i + 1][j] + G[i][j - 1] + G[i][j + 1]) + one_minus_omega * G[i][j];
                     pthread_mutex_unlock(&mutex);   
                }

            } else if (i == Mm1) {
                int j_0;

                for (j_0 = 1; j_0 < Nm1; j_0 = j_0 + 2) {

                    if ((j_0 + 1) != Nm1) {
                        pthread_mutex_lock(&mutex);   
                        G[i - 1][j_0 + 1] = omega_over_four * (G[i - 2][j_0 + 1] + G[i][j_0 + 1] + G[i - 1][j_0] + G[i - 1][j_0 + 2])
                                + one_minus_omega * G[i - 1][j_0 + 1];
                        pthread_mutex_unlock(&mutex);   

                    }

                }


            } else {
                int j_3;

                for (j_3 = 1; j_3 < Nm1; j_3 = j_3 + 2) {
		  
		    pthread_mutex_lock(&mutex);
                    G[i][j_3] = omega_over_four * (G[i - 1][j_3] + G[i + 1][j_3] + G[i][j_3 - 1] + G[i][j_3 + 1])
                            + one_minus_omega * G[i][j_3];
		    pthread_mutex_unlock(&mutex);

                    if ((j_3 + 1) != Nm1) {
	
			pthread_mutex_lock(&mutex);
                        G[i - 1][j_3 + 1] = omega_over_four * (G[i - 2][j_3 + 1] + G[i][j_3 + 1] + G[i - 1][j_3] + G[i - 1][j_3 + 2])
                                + one_minus_omega * G[i - 1][j_3 + 1];
			pthread_mutex_unlock(&mutex);

                    }

                }

            }


        }


        // Signal this thread has done iteration
        sync[id]++;

        // Wait for neighbours;
        //bug is introduced by removing this barrier
        
        if (id > 0) {
            //add assertion 
            //while (sync[id-1] < sync[id]) ;
            assert(!(sync[id - 1] < sync[id]));
        }

         
        if (id < nthreads - 1) {
            //add assertion
            //while (sync[id+1] < sync[id]) ;
            //assert(!(sync[id + 1] < sync[id]));
            if(sync[id+1] < sync[id]) ;
        }
        
        
    }
    
    //assert(G[0][0] ==  G[M-1][0]);
    assert(sync[0] == sync[1]);
    assert(G[1][1] == G[3][1]);
    
    pthread_exit(NULL);
}

int main(int argc, char** argv) {
    int j;

    //inputs 
    //CREST_int(num_iterations);
    //CREST_int(M);
    //CREST_int(N);    

    //assert(M > 2 && M < 7);
    //assert(M == 4);
    //assert(N > 0 && N < 7);
    //assert(N == 4);
    //assert(num_iterations > 0 && num_iterations < 4);

    RandomMatrix(M, N);

    int k;
    for(k = 0; k < M; k++) {
        for (j = 0; j < N; j++) {
            //if(j==0 || j==1 || j==(N-1))
		if(j == 0 || j == 1 || j == 2)
                CREST_shared_int(G[k][j]);
        }
    }
    
    pthread_mutex_init(&(mutex), NULL);

    int Mm1 = M - 1;
    int Nm1 = N - 1;

    pthread_t t[nthreads];

    initSync();


    for (j = 0; j < nthreads; j++) {
        //pthread_create(&t[j], 0, SOR, (void*) (&j));
        pthread_create(&t[j], 0, SOR, (void*)j);
    }

    pthread_exit(NULL);

    /*for (int j = 0; j < nthreads; j++) {
        pthread_join(t[j], 0);
    }
	
	
    for (int m = 1; m < Nm1; m++) {
        for (int n = 1; n < Nm1; n++) {
                Gtotal += G[m][n];
        }
    }
   
    return 0;*/
}

