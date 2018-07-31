#include <stdio.h>
#include <pthread.h>
#include "crest.h"

int pendingIO;
int stoppingEvent;
int stopped , stoppingFlag;
int status1,status2;

void func1(int *input){
	
	pendingIO--;
	if (pendingIO == 0) {
		stoppingEvent=1;
	}
	
	pthread_exit(NULL);
}

void func2(int *input){
	
	int in = *input;
	
	if(in == 1){
		if(stoppingFlag==1){
	        	status2 = -1;
		}
		else {
			pendingIO++;
			status2 = 0;
		}
		
		if (status2==0) {
			if (stopped==1){
			}
		}
		pendingIO--;
	}
	
	pthread_exit(NULL);
}

int main(){

	stoppingEvent = 0;
	stopped = 0;
	stoppingFlag = 0;
	pendingIO = 1; 

       int input1, input2;

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
	
	return 0;
}
