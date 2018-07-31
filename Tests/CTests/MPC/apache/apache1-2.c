#include <stdio.h>
#include <pthread.h>
#include "crest.h"

void foo(void* arg)
{
    char* str = (char*) malloc(sizeof(char));
    
    char strs[1];
    strs[0] = 'a';
    
    memcpy(str, &strs, sizeof(char));
    
    printf("%c\n", *str);
    
    pthread_exit(NULL);
}

int main()
{
  pthread_t  t2;
  int i;
  
  pthread_create(&t2, NULL, foo, NULL);
  
  if (i == 0) { // We need this if-statement to have some coverage goals!
  }
  
  pthread_exit(NULL);
}
