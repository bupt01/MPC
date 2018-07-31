#include <pthread.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <assert.h>

#define APR_SUCCESS 0
#define MAX_INDEX   20
#define BOUNDARY_INDEX 12
#define BOUNDARY_SIZE (1 << BOUNDARY_INDEX)
#define APR_FILE_BUFSIZE 4096

#define APR_OS_START_ERROR     20000
#define APR_OS_ERRSPACE_SIZE 50000
#define APR_OS_START_STATUS    (APR_OS_START_ERROR + APR_OS_ERRSPACE_SIZE)
#define APR_OS_START_USERERR    (APR_OS_START_STATUS + APR_OS_ERRSPACE_SIZE)
#define APR_OS_START_USEERR     APR_OS_START_USERERR
#define APR_OS_START_CANONERR  (APR_OS_START_USERERR \
                                 + (APR_OS_ERRSPACE_SIZE * 10))
#define APR_OS_START_EAIERR    (APR_OS_START_CANONERR + APR_OS_ERRSPACE_SIZE)
#define APR_OS_START_SYSERR    (APR_OS_START_EAIERR + APR_OS_ERRSPACE_SIZE)
#define APR_ENOMEM         (APR_OS_START_CANONERR + 7)

/* APR_ALIGN() is only to be used to align on a power of 2 boundary */
#define APR_ALIGN(size, boundary) \
    (((size) + ((boundary) - 1)) & ~((boundary) - 1))

/** Default alignment */
#define APR_ALIGN_DEFAULT(size) APR_ALIGN(size, 8)

typedef int apr_status_t;
typedef int apr_size_t;
typedef int apr_off_t;
typedef int apr_int32_t;
typedef int apr_uint32_t;
typedef int apr_int64_t;
typedef int apr_int16_t;
typedef int pid_t;
typedef apr_int64_t  apr_interval_time_t;
typedef  int         apr_ssize_t;
typedef pthread_t    apr_os_thread_t;


typedef struct cleanup_t cleanup_t;


//typedef enum {
//    APR_KILL_NEVER,             /**< process is never sent any signals */
//    APR_KILL_ALWAYS,            /**< process is sent SIGKILL on apr_pool_t cleanup */
//    APR_KILL_AFTER_TIMEOUT,     /**< SIGTERM, wait 3 seconds, SIGKILL */
//   APR_JUST_WAIT,              /**< wait forever for the process to complete */
//    APR_KILL_ONLY_ONCE          /**< send SIGTERM and then wait */
//} apr_kill_conditions_e;


struct cleanup_t {
    struct cleanup_t *next;
    const void *data;
    apr_status_t (*plain_cleanup_fn)(void *data);
    apr_status_t (*child_cleanup_fn)(void *data);
};


typedef struct apr_pool_t apr_pool_t;
typedef struct apr_allocator_t apr_allocator_t;
typedef struct apr_file_t apr_file_t;
typedef struct apr_memnode_t apr_memnode_t;
typedef struct apr_hash_t apr_hash_t;
typedef struct apr_hash_entry_t apr_hash_entry_t;
typedef struct apr_hash_index_t apr_hash_index_t;
typedef struct apr_thread_mutex_t apr_thread_mutex_t;
typedef struct apr_pollset_t apr_pollset_t;
typedef struct apr_socket_t     apr_socket_t;
typedef int (*apr_abortfunc_t)(int retcode);


struct apr_thread_mutex_t {
    apr_pool_t *pool;
    pthread_mutex_t mutex;
    apr_os_thread_t owner;
    int owner_ref;
    char nested; /* a boolean */
};

struct apr_file_t {
    apr_pool_t *pool;
    int filedes;
    char *fname;
    apr_int32_t flags;
    int eof_hit;
    int is_pipe;
    apr_interval_time_t timeout;
    int buffered;
    //enum {BLK_UNKNOWN, BLK_OFF, BLK_ON } blocking;
    
    int ungetchar;    /* Last char provided by an unget op. (-1 = no char)*/

    /* Stuff for buffered mode */
    char *buffer;
    int bufpos;               /* Read/Write position in buffer */
    unsigned long dataRead;   /* amount of valid data read into buffer */
    int direction;            /* buffer being used for 0 = read, 1 = write */
    unsigned long filePtr;    /* position in file of handle */
//niloo    
//#if APR_HAS_THREADS
    struct apr_thread_mutex_t *thlock;
//#endif
};

typedef struct apr_proc_t {
    /** The process ID */
    pid_t pid;
    /** Parent's side of pipe to child's stdin */
    apr_file_t *in;
    /** Parent's side of pipe to child's stdout */
    apr_file_t *out;
    /** Parent's side of pipe to child's stdouterr */
    apr_file_t *err;
} apr_proc_t;

struct process_chain {
    /** The process ID */
    apr_proc_t *proc;
    //apr_kill_conditions_e kill_how;
    /** The next process in the list */
    struct process_chain *next;
};

struct apr_hash_entry_t {
    apr_hash_entry_t *next;
    unsigned int      hash;
    const void       *key;
    apr_ssize_t       klen;
    const void       *val;
};

struct apr_hash_index_t {
    apr_hash_t         *ht;
    apr_hash_entry_t   *this, *next;
    unsigned int        index;
};

struct apr_hash_t {
    apr_pool_t          *pool;
    apr_hash_entry_t   **array;
    apr_hash_index_t     iterator;  /* For apr_hash_first(NULL, ...) */
    unsigned int         count, max;
};


struct apr_pool_t {
    apr_pool_t           *parent;
    apr_pool_t           *child;
    apr_pool_t           *sibling;
    apr_pool_t          **ref;
    cleanup_t            *cleanups;
    apr_allocator_t      *allocator;
    struct process_chain *subprocesses;
    apr_abortfunc_t       abort_fn;
    apr_hash_t           *user_data;
    const char           *tag;

    apr_memnode_t        *active;
    apr_memnode_t        *self; /* The node containing the pool itself */
    char                 *self_first_avail;
};


struct apr_memnode_t {
    apr_memnode_t *next;            /**< next memnode */
    apr_memnode_t **ref;            /**< reference to self */
    apr_uint32_t   index;           /**< size */
    apr_uint32_t   free_index;      /**< how much free */
    char          *first_avail;     /**< pointer to first free memory */
    char          *endp;            /**< pointer to end of free memory */
};

struct apr_allocator_t {
    apr_uint32_t        max_index;
    apr_uint32_t        max_free_index;
    apr_uint32_t        current_free_index;
    apr_pool_t         *owner;
    apr_memnode_t      *free[MAX_INDEX];
};



//typedef enum { 
//    APR_NO_DESC,                /**< nothing here */
//    APR_POLL_SOCKET,            /**< descriptor refers to a socket */
//    APR_POLL_FILE,              /**< descriptor refers to a file */
//    APR_POLL_LASTDESC           /**< descriptor is the last one in the list */
//} apr_datatype_e ;



/** Union of either an APR file or socket. */
typedef union {
    apr_file_t *f;              /**< file */
    //niloo
    //apr_socket_t *s;            /**< socket */
} apr_descriptor;

/** @see apr_pollfd_t */
typedef struct apr_pollfd_t apr_pollfd_t;

/** Poll descriptor set. */
struct apr_pollfd_t {
    apr_pool_t *p;              /**< associated pool */
    //apr_datatype_e desc_type;   /**< descriptor type */
    apr_int16_t reqevents;      /**< requested events */
    apr_int16_t rtnevents;      /**< returned events */
    apr_descriptor desc;        /**< @see apr_descriptor */
    void *client_data;          /**< allows app to associate context */
};

struct apr_pollset_t {
    apr_uint32_t nelts;
    apr_uint32_t nalloc;
//#ifdef HAVE_POLL
//    struct pollfd *pollset;
//#else
    fd_set readset, writeset, exceptset;
    int maxfd;
//#endif
    apr_pollfd_t *query_set;
    apr_pollfd_t *result_set;
    apr_pool_t *pool;
//#ifdef NETWARE
//    int set_type;
//#endif
};

typedef struct {
    apr_file_t *handle;
    apr_size_t outcnt;
    char outbuf[10];
} buffered_log;

//input
int LOG_BUFSIZE;

//shared var
buffered_log sh_buf;



//function parameters
typedef struct {
  apr_pool_t *pool;	 
  void *handle;
  char **strs;
  int *strl;
  int nelts;
  apr_size_t len;
} s_param;


/*
void* apr_palloc(apr_pool_t *pool, apr_size_t size)
{
    apr_memnode_t *active, *node;
    void *mem;
    apr_uint32_t free_index;

    size = APR_ALIGN_DEFAULT(size);
    active = pool->active;

    // If the active node has enough bytes left, use it. 
    if (size < (apr_size_t)(active->endp - active->first_avail)) {
        mem = active->first_avail;
        active->first_avail += size;

        return mem;
    }

    node = active->next;
    if (size < (apr_size_t)(node->endp - node->first_avail)) {
        *node->ref = node->next;
        node->next->ref = node->ref;
    }
    else {
        if ((node = allocator_alloc(pool->allocator, size)) == NULL) {
            if (pool->abort_fn)
                pool->abort_fn(APR_ENOMEM);

            return NULL;
        }
    }

    node->free_index = 0;

    mem = node->first_avail;
    node->first_avail += size;

    node->ref = active->ref;
    *node->ref = node;
    node->next = active;
    active->ref = &node->next;

    pool->active = node;

    free_index = (APR_ALIGN(active->endp - active->first_avail + 1,
                            BOUNDARY_SIZE) - BOUNDARY_SIZE) >> BOUNDARY_INDEX;

    active->free_index = free_index;
    node = active->next;
    if (free_index >= node->free_index)
        return mem;

    do {
        node = node->next;
    }
    while (free_index < node->free_index);

    *active->ref = active->next;
    active->next->ref = active->ref;

    active->ref = node->ref;
    *active->ref = active;
    active->next = node;
    node->ref = &active->next;

    return mem;
}
*/

apr_status_t apr_file_flush(apr_file_t *thefile)
{
    if (thefile->buffered) {
        apr_int64_t written = 0;

        if (thefile->direction == 1 && thefile->bufpos) {
            do {
                written = write(thefile->filedes, thefile->buffer, thefile->bufpos);
            } while (written == (apr_int64_t)-1 && errno == EINTR);
            if (written == (apr_int64_t)-1) {
                return errno;
            }
            thefile->filePtr += written;
            thefile->bufpos = 0;
        }
    }

    return APR_SUCCESS; 
}

apr_status_t apr_thread_mutex_lock(apr_thread_mutex_t *mutex)
{
    apr_status_t rv;
    rv = pthread_mutex_lock(&mutex->mutex);
    return rv;
}

apr_status_t apr_thread_mutex_unlock(apr_thread_mutex_t *mutex)
{
    apr_status_t status;
    status = pthread_mutex_unlock(&mutex->mutex);
    return status;
}

apr_status_t apr_file_write(apr_file_t *thefile, const void *buf, apr_size_t *nbytes)
{
    printf("apr_file_write\n");
    apr_size_t rv;

    if (thefile->buffered) {
	char *pos = (char *)buf;
        int blocksize;
        int size = *nbytes;

//#if APR_HAS_THREADS
        if (thefile->thlock) {
            apr_thread_mutex_lock(thefile->thlock);
        }
//#endif

        if ( thefile->direction == 0 ) {
            /* Position file pointer for writing at the offset we are 
             * logically reading from
             */
            apr_int64_t offset = thefile->filePtr - thefile->dataRead + thefile->bufpos;
            if (offset != thefile->filePtr)
                lseek(thefile->filedes, offset, SEEK_SET);
            thefile->bufpos = 0;
            thefile->dataRead = 0;
            thefile->direction = 1;
        }

        rv = 0;
        while (rv == 0 && size > 0) {
            if (thefile->bufpos == APR_FILE_BUFSIZE)   /* write buffer is full*/
                apr_file_flush(thefile);

            blocksize = size > APR_FILE_BUFSIZE - thefile->bufpos ? 
                        APR_FILE_BUFSIZE - thefile->bufpos : size;
            memcpy(thefile->buffer + thefile->bufpos, pos, blocksize);                      
            thefile->bufpos += blocksize;
            pos += blocksize;
            size -= blocksize;
        }

//#if APR_HAS_THREADS
        if (thefile->thlock) {
            apr_thread_mutex_unlock(thefile->thlock);
        }
//#endif
        return rv;
    }
    else {
	do {
	    rv = write(thefile->filedes, buf, *nbytes);
        } while (rv == (apr_size_t)-1 && errno == EINTR);

	if (rv == (apr_size_t)-1) {
	    (*nbytes) = 0;
	    return errno;
        }
        *nbytes = rv;
	return APR_SUCCESS;
    }
}

void flush_log(buffered_log *buf)
{
    printf("flush_log\n");
    if (buf->outcnt && buf->handle != NULL) {
	apr_file_write(buf->handle, buf->outbuf, &buf->outcnt);
	buf->outcnt = 0;
	printf("flush_log!\n");
    }
}

apr_status_t ap_buffered_log_writer1(s_param* arg)

{
    printf("ap_buffered_log_writer1\n");
    apr_pool_t *p = arg->pool;
    void *handle = arg->handle;
    char **strs = arg->strs;
    int *strl = arg->strl;
    int nelts = arg->nelts;
    apr_size_t len = arg->len;
    
    //ORIGINAL: 
    char *str;
    char *s;
    int i;
    apr_status_t rv;
    buffered_log *buf = (buffered_log*)handle;
    printf("1.7\n");


    if (len + buf->outcnt > LOG_BUFSIZE) {
	printf("1.8\n");
        flush_log(buf);
    }
    if (len >= LOG_BUFSIZE) {
      printf("1.9\n");
        //printf("%d: len >= LOG_BUFSIZE\n",(long int)syscall(224));
        //printf("Thread %ld: len >= LOG_BUFSIZE\n", pthread_self());

        apr_size_t w;

        //str = apr_palloc(p, len + 1);
        //str = apr_palloc(r->pool, len + 1);  
        str = (char*) malloc(sizeof(char));
	//char str[1];
        for (i = 0, s = str; i < nelts; ++i) {
            //printf("%d: here1\n", (long int)syscall(224)); 
	    //printf("Thread %ld: here1\n", pthread_self());
	    memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }
        w = len;
        rv = apr_file_write(buf->handle, str, &w);
        
    }
    else {
        printf("1.10\n");
        //printf("%d: len < LOG_BUFSIZE\n",(long int)syscall(224));
	    //printf("Thread %ld: len < LOG_BUFSIZE\n", pthread_self());
        int exp_len = buf->outcnt + len; 
        for (i = 0, s = &buf->outbuf[buf->outcnt]; i < nelts; ++i) {
	        //printf("Thread %ld: here2\n", pthread_self());
            //printf("%d: here2\n", (long int)syscall(224)); 
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }

        //printf("%d: before update\n",(long int)syscall(224));
	//printf("Thread %ld: before update\n", pthread_self());
        buf->outcnt += len;
        //printf("%d: after update: %d\n",(long int)syscall(224), buf->outcnt); 
	//printf("Thread %ld: after update: %d\n", pthread_self(), buf->outcnt);
        //printf("%d: before branch\n",(long int)syscall(224));
	//printf("Thread %ld: before branch\n", pthread_self());
	assert(buf->outcnt == exp_len);
        
        //printf("%d: after branch\n",(long int)syscall(224));  
	//printf("Thread %ld: after branch\n", pthread_self());
        rv = APR_SUCCESS;
    }
    
    pthread_exit(NULL);
    return rv;
}

apr_status_t ap_buffered_log_writer2(s_param* arg)

{
    printf("ap_buffered_log_writer2\n");
    apr_pool_t *p = arg->pool;
	void *handle = arg->handle;
    char **strs = arg->strs;
    int *strl = arg->strl;
    int nelts = arg->nelts;
    apr_size_t len = arg->len;

    //ORIGINAL: 
    char *str;
    char *s;
    int i;
    apr_status_t rv;
    buffered_log *buf = (buffered_log*)handle;


    if (len + buf->outcnt > LOG_BUFSIZE) {
        flush_log(buf);
    }
    if (len >= LOG_BUFSIZE) {
        //printf("%d: len >= LOG_BUFSIZE\n",(long int)syscall(224));
	//printf("Thread %ld: len >= LOG_BUFSIZE\n", pthread_self());

        apr_size_t w;

        //str = apr_palloc(p, len + 1);
        //str = apr_palloc(r->pool, len + 1);
        str = (char*) malloc(sizeof(char));
	//char str[1];
        for (i = 0, s = str; i < nelts; ++i) {
            //printf("%d: here1\n", (long int)syscall(224)); 
	    //printf("Thread %ld: here1\n", pthread_self());
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }
        w = len;
        rv = apr_file_write(buf->handle, str, &w);
        
    }
    else {
        //printf("%d: len < LOG_BUFSIZE\n",(long int)syscall(224));
	    //printf("Thread %ld: len < LOG_BUFSIZE\n", pthread_self());
        int exp_cnt = buf->outcnt + len; 
        for (i = 0, s = &buf->outbuf[buf->outcnt]; i < nelts; ++i) {
            //printf("%d: here2\n", (long int)syscall(224)); 
	    //printf("Thread %ld: here2\n", pthread_self());
            memcpy(s, strs[i], strl[i]);
            s += strl[i];
        }

        //printf("%d: before update\n",(long int)syscall(224));
		//printf("Thread %ld: before update\n", pthread_self());
        buf->outcnt += len; 
        //printf("%d: after update: %d\n",(long int)syscall(224), buf->outcnt); 
		//printf("Thread %ld: after update\n", pthread_self());
        //printf("%d: before branch\n",(long int)syscall(224));  
		//printf("Thread %ld: before branch\n", pthread_self());
		assert(buf->outcnt == exp_cnt);

        //printf("%d: after branch\n",(long int)syscall(224));  
		//printf("Thread %ld: after branch\n", pthread_self());
        rv = APR_SUCCESS;
    }
    pthread_exit(NULL);
    return rv;
}

int main()
{
  pthread_t  t2,t3;
  int arg;

  apr_file_t * file = (apr_file_t *) malloc(sizeof(apr_file_t));
  file->pool = (apr_pool_t *) malloc(sizeof(apr_pool_t));  
  file->filedes = open("f.txt",O_RDWR);
  int buffered; 
  //CREST_int(buffered);
  printf("beffered: %d\n", buffered); 
  file->buffered = buffered;  
  
  file->buffer = (char *) malloc(sizeof(char)); 
  *(file->buffer) = 'a';
  file->bufpos = 0;               /* Read/Write position in buffer */
  file->dataRead = 0;   /* amount of valid data read into buffer */
  int direction;            /* buffer being used for 0 = read, 1 = write */
  //CREST_int(direction); 
  printf("direction: %d\n", direction);
  file->direction = direction;
  file->filePtr = 0;    /* position in file of handle */
  file->thlock = (apr_thread_mutex_t *)malloc(sizeof(apr_thread_mutex_t));
  pthread_mutex_init(&(file->thlock->mutex), NULL);
  
  sh_buf.handle = file;
  
    
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

  //CREST_int(LOG_BUFSIZE);
  //CREST_shared_int(sh_buf.outcnt);
  //CREST_shared_char(sh_buf.outbuf);

  printf("LOG_BUFSIZE: %d\n", LOG_BUFSIZE);

  pthread_create(&t2, 0, ap_buffered_log_writer1, &param[0]);
  pthread_create(&t3, 0, ap_buffered_log_writer2, &param[1]);

  printf("before join!\n");
  
  //pthread_join(t2, 0);
  //pthread_join(t3, 0);
  
  pthread_exit(0);
  return 0;
}
