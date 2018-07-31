#include <pthread.h>
#include <stdio.h>

void* Thread1(void* param) {
    printf("thread1\n");
    pthread_exit(NULL);
}

int main(int argc, char* argv[]) 
{
  int x;
  
  pthread_t thread1;
  
  pthread_create(&thread1, NULL, Thread1, NULL);
  
  if (x > 10) {
    printf("a\n");
  }
  else {
    printf("b\n");
  }
  
  pthread_exit(NULL);
}


