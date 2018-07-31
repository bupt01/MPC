#include <pthread.h>
#include <stdio.h>
#include "crest.h"
#include "../assert.h"

#define APR_SUCCESS 0

typedef int apr_status_t;
typedef int apr_size_t;
typedef int apr_off_t;


struct apr_file_t {
  //   apr_pool_t *pool;
     int filedes;
     char *fname;
     //apr_int32_t flags;
     int flags;
     int eof_hit;
     int is_pipe;
     //apr_interval_time_t timeout;
     int timeout;
     int buffered;
     enum {BLK_UNKNOWN, BLK_OFF, BLK_ON } blocking;
     int ungetchar;    /* Last char provided by an unget op. (-1 = no char)*/
 
     /* if there is a timeout set, then this pollset is used */
     //apr_pollset_t *pollset;

     /* Stuff for buffered mode */
     char *buffer;
     apr_size_t bufpos;    /* Read/Write position in buffer */
     apr_size_t bufsize;   /* The buffer size */
     apr_off_t dataRead;   /* amount of valid data read into buffer */
     int direction;            /* buffer being used for 0 = read, 1 = write */
     apr_off_t filePtr;    /* position in file of handle */
 #if APR_HAS_THREADS
     //struct apr_thread_mutex_t *thlock;
 #endif
};

typedef struct {
    //apr_file_t *handle;
    apr_size_t outcnt;
    char outbuf[10];
} buffered_log;

//input
int LOG_BUFSIZE;

//shared var
buffered_log sh_buf;
//function parameters
typedef struct {
  void *handle;
  char **strs;
  int *strl;
  int nelts;
  apr_size_t len;
} s_param;




void flush_log(buffered_log *buf)
{
    if (buf->outcnt) {
        //apr_file_write(buf->handle, buf->outbuf, &buf->outcnt);
        buf->outcnt = 0;
        printf("flush_log!\n");
    }
}

apr_status_t ap_buffered_log_writer1(s_param* arg)

{
    void *handle = arg->handle;
    char **strs = arg->strs;
    int *strl = arg->strl;
    int nelts = arg->nelts;
    apr_size_t len = arg->len;

    char *str;
    char *s;
    int i;
    apr_status_t rv;
    buffered_log *buf = (buffered_log*)handle;


    if (len + buf->outcnt > LOG_BUFSIZE) {
        flush_log(buf);
    }
    if (len >= LOG_BUFSIZE) {
        printf("%d: len >= LOG_BUFSIZE\n",(long int)syscall(224));

        apr_size_t w;

        //str = apr_palloc(r->pool, len + 1);
        str = (char*) malloc(sizeof(char));
        for (i = 0, s = str; i < nelts; ++i) {
            printf("%d: here1\n", (long int)syscall(224)); 
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }
        w = len;
        //rv = apr_file_write(buf->handle, str, &w);
        
    }
    else {
        printf("%d: len < LOG_BUFSIZE\n",(long int)syscall(224));
        int exp_len = buf->outcnt + len; 
        for (i = 0, s = &buf->outbuf[buf->outcnt]; i < nelts; ++i) {
            printf("%d: here2\n", (long int)syscall(224)); 
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }

        printf("%d: before update\n",(long int)syscall(224));
        buf->outcnt += len;
        printf("%d: after update: %d\n",(long int)syscall(224), buf->outcnt); 
        printf("%d: before branch\n",(long int)syscall(224));   
	assert(buf->outcnt == exp_len);
        
        printf("%d: after branch\n",(long int)syscall(224));  
        rv = APR_SUCCESS;
    }

    pthread_exit(NULL);
    //return rv;
}

apr_status_t ap_buffered_log_writer2(s_param* arg)

{
    void *handle = arg->handle;
    char **strs = arg->strs;
    int *strl = arg->strl;
    int nelts = arg->nelts;
    apr_size_t len = arg->len;

    char *str;
    char *s;
    int i;
    apr_status_t rv;
    buffered_log *buf = (buffered_log*)handle;


    if (len + buf->outcnt > LOG_BUFSIZE) {
        flush_log(buf);
    }
    if (len >= LOG_BUFSIZE) {
        printf("%d: len >= LOG_BUFSIZE\n",(long int)syscall(224));

        apr_size_t w;

        //str = apr_palloc(r->pool, len + 1);
        str = (char*) malloc(sizeof(char));
        for (i = 0, s = str; i < nelts; ++i) {
            printf("%d: here1\n", (long int)syscall(224)); 
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }
        w = len;
        //rv = apr_file_write(buf->handle, str, &w);
        
    }
    else {
        printf("%d: len < LOG_BUFSIZE\n",(long int)syscall(224));
        int exp_cnt = buf->outcnt + len; 
        for (i = 0, s = &buf->outbuf[buf->outcnt]; i < nelts; ++i) {
            printf("%d: here2\n", (long int)syscall(224)); 
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }

        printf("%d: before update\n",(long int)syscall(224));
        buf->outcnt += len; 
        printf("%d: after update: %d\n",(long int)syscall(224), buf->outcnt); 
        printf("%d: before branch\n",(long int)syscall(224));  
	assert(buf->outcnt == exp_cnt);
        
        printf("%d: after branch\n",(long int)syscall(224));  
        rv = APR_SUCCESS;
    }

    pthread_exit(NULL);
    //return rv;
}

int main()
{
  pthread_t  t2,t3;
  int arg;

  sh_buf.outcnt=5;
  sh_buf.outbuf[0]='H';
  sh_buf.outbuf[1]='E';
  sh_buf.outbuf[1]='L';
  sh_buf.outbuf[1]='L';
  sh_buf.outbuf[1]='O';

  s_param param[2];  
  
  param[0].handle = &sh_buf;
  param[0].strs = (char**) malloc(sizeof(char*));
  param[0].strs[0] = (char*) malloc(sizeof(char));
  *(param[0].strs[0]) = 'S';
  param[0].strl = (int*) malloc(sizeof(int));
  *(param[0].strl) = 1;
  param[0].nelts = 1;
  param[0].len = 1;

  param[1].handle = &sh_buf;
  param[1].strs = (char**) malloc(sizeof(char*));
  param[1].strs[0] = (char*) malloc(sizeof(char));
  *(param[1].strs[0]) = 'R';
  param[1].strs[1] = (char*) malloc(sizeof(char));
  *(param[1].strs[1]) = 'Z';
/*  param[1].strs[2] = (char*) malloc(sizeof(char));
  *(param[1].strs[2]) = 'A';
  param[1].strs[3] = (char*) malloc(sizeof(char));
  *(param[1].strs[3]) = 'B';
  param[1].strs[4] = (char*) malloc(sizeof(char));
  *(param[1].strs[4]) = 'C';
*/
  param[1].strl = (int*) malloc(sizeof(int));
  param[1].strl[0] = 1;
  param[1].strl[1] = 1;
/*  param[1].strl[2] = 1;
  param[1].strl[3] = 1;
  param[1].strl[4] = 1;
  param[1].nelts = 5;
  param[1].len = 5;
*/

  param[1].nelts = 2;
  param[1].len = 2;

  CREST_int(LOG_BUFSIZE);
  CREST_shared_int(sh_buf.outcnt);
  CREST_shared_char(sh_buf.outbuf);


  printf("initialization done!\n");
  printf("input: %d\n", LOG_BUFSIZE);

  pthread_create(&t2, 0, ap_buffered_log_writer1, &param[0]);
  pthread_create(&t3, 0, ap_buffered_log_writer2, &param[1]);

  printf("after join!\n");
  
  //pthread_join(t2, 0);
  //pthread_join(t3, 0);

  pthread_exit(NULL);
}
