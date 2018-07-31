#include <stdio.h>
#include <pthread.h>
#include "crest.h"
#include "../assert.h"

int pendingIO;
int stoppingEvent;
int stopped , stoppingFlag;
int status1,status2;
pthread_mutex_t mutex;

void func1(int *input){
	
	int in = *input;
	
	if(in == 1){
            printf("in ADD!\n");
	    if(stoppingFlag==1){
	        status1 = -1;
		}
	    else{
                pthread_mutex_lock(&mutex);
		pendingIO++;
                pthread_mutex_unlock(&mutex);    
		status1 = 0;
	    }
	    if (status1==0) { 
               assert(stopped != 1);
	       /*if (stopped==1){
	           printf("Errrorr\n");
		       //assert(0);
	       }*/
	        printf("do actual work\n");
	    }
                
            pthread_mutex_lock(&mutex);    
	    pendingIO--;
            pthread_mutex_unlock(&mutex);
		
            pthread_mutex_lock(&mutex);
            if(pendingIO==0){
                stoppingEvent = 1;
                pthread_mutex_unlock(&mutex);
            }
            else
                pthread_mutex_unlock(&mutex);
	}
	else{
		printf("in STOP!\n");
		stoppingFlag = 1;
                pthread_mutex_lock(&mutex);
		pendingIO--;
                pthread_mutex_unlock(&mutex);
                
                pthread_mutex_lock(&mutex);
		if (pendingIO == 0){
			stoppingEvent=1;
                        pthread_mutex_unlock(&mutex);
                }
                else
                        pthread_mutex_unlock(&mutex);
                stopped = 1;
		
	}
	
	pthread_exit(NULL);
}

void func2(int *input){
	
	int in = *input;
	
	if(in == 1){
            printf("in ADD!\n");
	    if(stoppingFlag==1){
	        status1 = -1;
		}
	    else{
                pthread_mutex_lock(&mutex);
		pendingIO++;
                pthread_mutex_unlock(&mutex);    
		status1 = 0;
	    }
	    if (status1==0) { 
               assert(stopped != 1);
	       /*if (stopped==1){
	           printf("Errrorr\n");
		       //assert(0);
	       }*/
	        printf("do actual work\n");
	    }
                
            pthread_mutex_lock(&mutex);    
	    pendingIO--;
            pthread_mutex_unlock(&mutex);
		
            pthread_mutex_lock(&mutex);
            if(pendingIO==0){
                stoppingEvent = 1;
                pthread_mutex_unlock(&mutex);
            }
            else
                pthread_mutex_unlock(&mutex);
	}
	else{
		printf("in STOP!\n");
		stoppingFlag = 1;
                pthread_mutex_lock(&mutex);
		pendingIO--;
                pthread_mutex_unlock(&mutex);
                
                pthread_mutex_lock(&mutex);
		if (pendingIO == 0){
			stoppingEvent=1;
                        pthread_mutex_unlock(&mutex);
                }
                else
                        pthread_mutex_unlock(&mutex);
                stopped = 1;
		
	}
	
	pthread_exit(NULL);
}

int main(){

	stoppingEvent = 0;
	stopped = 0;
	stoppingFlag = 0;
	pendingIO = 1; 

        int input1, input2;
        pthread_mutex_init(&(mutex), NULL);

	printf("in main\n");
	CREST_int(input1);
	CREST_int(input2);

        CREST_shared_int(stoppingEvent);
	CREST_shared_int(stopped);
	CREST_shared_int(stoppingFlag);
	CREST_shared_int(pendingIO);
	
	pthread_t pt1;
	pthread_t pt2;

	pthread_create( &pt1, NULL, &func1, &input1 );
  	pthread_create( &pt2, NULL, &func2, &input2 );
	
	//pthread_join(pt1, NULL); 
	//pthread_join(pt2, NULL); 

	pthread_exit(NULL);

	return 0;
}
