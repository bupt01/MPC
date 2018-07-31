#include <stdio.h>
#include <pthread.h>
#include <assert.h>

int pendingIO;
int stoppingEvent;
int stopped , stoppingFlag;
int status1,status2;

void func1(int *input){
	
	int in = *input;
	
	if(in == 1){
		printf("in ADD!\n");
	    if(stoppingFlag==1){
	        status1 = -1;
		}
	    else{
		    pendingIO++;
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
	    pendingIO--;
		if(pendingIO==0)
		    stoppingEvent = 1;
	}
	else{
		printf("in STOP!\n");
		stoppingFlag = 1;
		pendingIO--;
		if (pendingIO == 0)
			stoppingEvent=1;
		stopped = 1;
		
	}
	
	pthread_exit(NULL);
}

void func2(int *input){
	
	int in = *input;
	
	if(in == 1){
		printf("in ADD!\n");
	    if(stoppingFlag==1){
	        status2 = -1;
		}
	    else{
		    pendingIO++;
		    status2 = 0;
	    }
	    if (status2==0) {
	       if (stopped==1){
	           printf("Errrorr\n");
		       //assert(0);
	       }
	        printf("do actual work\n");
		}
	    pendingIO--;
		if(pendingIO==0)
		    stoppingEvent = 1;
	}
	else{
		printf("in STOP!\n");
		stoppingFlag = 1;
		pendingIO--;
		if (pendingIO == 0)
			stoppingEvent=1;
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

	printf("in main\n");
	
    
    klee_make_symbolic(&input1, sizeof(input1), "shared*input1");
	klee_make_symbolic(&input2, sizeof(input2), "shared*input2");
	





	klee_make_symbolic(&stoppingEvent, sizeof(stoppingEvent), "shared*stoppingEvent");
	klee_make_symbolic(&stopped, sizeof(stopped), "shared*stopped");
	klee_make_symbolic(&stoppingFlag, sizeof(stoppingFlag), "shared*stoppingFlag");
	klee_make_symbolic(&pendingIO, sizeof(pendingIO), "shared*pendingIO");

	pthread_t pt1;
	pthread_t pt2;

	pthread_create( &pt1, NULL, &func1, &input1 );
  	pthread_create( &pt2, NULL, &func2, &input2 );
	
	//pthread_join(pt1, NULL); 
	//pthread_join(pt2, NULL); 

	pthread_exit(NULL);

	return 0;
}
