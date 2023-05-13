#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h>
int x[4];
pthread_mutex_t l_1;
pthread_mutex_t l_2;
pthread_mutex_t l_3;

void *thread_1_2() { 
     int i; klee_make_symbolic(&i, sizeof(i), "i");//= getInput(); 
     if (i == 0) { 
        pthread_mutex_lock(&l_1); 
        pthread_mutex_lock(&l_2); 
        int x1 = x[1]; 
        x[2] += 1; 
        int x2 = x[1]; 
        assert(x1 == x2); 
        pthread_mutex_unlock(&l_2); 
        pthread_mutex_unlock(&l_1);
     } 
} 
void *thread_2_3() { 
    //int j;klee_make_symbolic(&j, sizeof(j), "j");// getInput(); 
    //if (j == 0) { 
        pthread_mutex_lock(&l_2); 
        pthread_mutex_lock(&l_1); 
        int x1 = x[2];
         x[3] += 1; 
         int x2 = x[2]; 
         assert(x1 == x2); 
         pthread_mutex_unlock(&l_1); 
         pthread_mutex_unlock(&l_2); 
    // }
}
/*
void *thread_3_1() { 
    int inp_3;klee_make_symbolic(&inp_3, sizeof(inp_3), "inp_3");// = getInput(); 
    if (inp_3 == 0) { 
        pthread_mutex_lock(&l_3); 
        pthread_mutex_lock(&l_1); 
       // int x1 = x[3];
         //x[1] += 1; 
         //int x2 = x[3]; 
         //assert(x1 == x2); 
         pthread_mutex_unlock(&l_1); 
         pthread_mutex_unlock(&l_3); 
     }
}*/
int main(int argc, char const *argv[])
{
  pthread_t t[13];
  klee_make_symbolic(x, sizeof(x),"shared*x");
  pthread_create(&t[0], NULL, thread_1_2, NULL);
  pthread_create(&t[1], NULL, thread_2_3, NULL);
  //pthread_create(&t[2], NULL, thread_3_1, NULL);

 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
 
 
 
  pthread_join(t[0], NULL);
  pthread_join(t[1], NULL);
  //pthread_join(t[2], NULL);
  /*
  pthread_join(t[3], NULL);
  pthread_join(t[4], NULL);
  pthread_join(t[5], NULL);
  pthread_join(t[6], NULL);
  pthread_join(t[7], NULL);
  pthread_join(t[8], NULL);
  pthread_join(t[9], NULL);
  pthread_join(t[10], NULL);  // M8
  pthread_join(t[11], NULL);
  /*pthread_join(t[12], NULL);*/

  return 0;
}