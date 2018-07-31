#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>


#define APR_SUCCESS 0
#define APR_RFC822_DATE_LEN 8 
#define free my_free
#define MAX_INDEX   20
#define CACHE_HASH_KEY_STRING     (-1)
#define left(i) (2*(i))
#define right(i) ((2*(i))+1)
#define parent(i) ((i)/2)

#define CACHE_TYPE_FILE  1
#define CACHE_TYPE_HEAP  2
#define CACHE_TYPE_MMAP  3

typedef int apr_status_t;
typedef int apr_size_t;
typedef int apr_off_t;
typedef int apr_ssize_t;
typedef int apr_int32_t;
typedef int apr_uint32_t;
typedef int apr_int64_t;
typedef int apr_os_file_t;
typedef apr_int64_t apr_time_t;
typedef apr_int64_t  apr_interval_time_t;
typedef pthread_t    apr_os_thread_t;
typedef struct apr_file_t apr_file_t;
typedef struct cache_object_t  cache_object_t;
typedef struct apr_thread_mutex_t apr_thread_mutex_t;
typedef struct apr_pool_t apr_pool_t;
typedef struct apr_memnode_t apr_memnode_t;
typedef struct cache_cache_t cache_cache_t;
typedef struct cache_hash_t cache_hash_t;
typedef struct apr_hash_t apr_hash_t;
typedef struct apr_hash_index_t apr_hash_index_t;
typedef struct apr_hash_entry_t apr_hash_entry_t;
typedef struct cache_hash_entry_t cache_hash_entry_t;
typedef struct cache_hash_index_t cache_hash_index_t;
typedef struct cleanup_t cleanup_t;
typedef struct apr_allocator_t apr_allocator_t;
typedef struct cache_pqueue_t cache_pqueue_t;
typedef long (*cache_pqueue_get_priority)(void *a);
typedef void cache_cache_inc_frequency(void*a);
typedef apr_size_t cache_cache_get_size(void*a);
typedef const char* cache_cache_get_key(void *a);
typedef void cache_cache_free(void *a);
typedef long (*cache_pqueue_set_priority)(long queue_clock, void *a);
typedef int (*apr_abortfunc_t)(int retcode);
typedef apr_ssize_t (*cache_pqueue_getpos)(void *a);
typedef void (*cache_pqueue_setpos)(void *a, apr_ssize_t pos);


struct cleanup_t {
    struct cleanup_t *next;
    const void *data;
    apr_status_t (*plain_cleanup_fn)(void *data);
    apr_status_t (*child_cleanup_fn)(void *data);
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

/*
typedef enum {
    CACHE_TYPE_FILE = 1,
    CACHE_TYPE_HEAP,
    CACHE_TYPE_MMAP
} cache_type_e;
*/

struct apr_thread_mutex_t {
    apr_pool_t *pool;
    pthread_mutex_t mutex;
    apr_os_thread_t owner;
    int owner_ref;
    char nested; /* a boolean */
};

typedef struct {
    char* hdr;
    char* val;
} cache_header_tbl_t;

typedef struct mem_cache_object{
	//niloo
    //cache_type_e type;
    int type;
    apr_size_t num_header_out;
    apr_size_t num_subprocess_env;
    apr_size_t num_notes;
    apr_size_t num_req_hdrs;
    cache_header_tbl_t *header_out;
    cache_header_tbl_t *subprocess_env;
    cache_header_tbl_t *notes;
    cache_header_tbl_t *req_hdrs;
    apr_size_t m_len;
    void *m;
    apr_os_file_t fd;
    apr_int32_t flags;  /* File open flags */
    long priority;      /**< the priority of this entry */
    long total_refs;          /**< total number of references this entry has had */

    apr_ssize_t pos;


}mem_cache_object_t;

/* cache info information */
typedef struct cache_info{
    char *content_type;
    char *etag;
    char *lastmods;         /* last modified of cache entity */
    char *filename;   
    apr_time_t date;
    apr_time_t lastmod;
    char lastmod_str[APR_RFC822_DATE_LEN];
    apr_time_t expire;
    apr_time_t request_time;
    apr_time_t response_time;
    apr_size_t len;
    apr_time_t ims;    /*  If-Modified_Since header value    */
    apr_time_t ius;    /*  If-UnModified_Since header value    */
    const char *im;         /* If-Match header value */
    const char *inm;         /* If-None-Match header value */

}cache_info_t;



typedef struct cache_object {
    char *key;
    cache_object_t *next;
    cache_info_t info;
    void *vobj;         /* Opaque portion (specific to the cache implementation) of the cache object */
    apr_size_t count;   /* Number of body bytes written to the cache so far */
    int complete;
    apr_size_t refcount;
    apr_size_t cleanup;
}cache_object_t;

struct cache_hash_entry_t {
    cache_hash_entry_t	*next;
    unsigned int	 hash;
    const void		*key;
    apr_ssize_t		 klen;
    const void		*val;
};

struct cache_hash_index_t {
    cache_hash_t	 *ht;
    cache_hash_entry_t   *this, *next;
    int                  index;
};

struct cache_hash_t {
    cache_hash_entry_t   **array;
    cache_hash_index_t     iterator;  /* For cache_hash_first(NULL, ...) */
    int                  count, max;
};



struct cache_pqueue_t
{
    apr_ssize_t size;
    apr_ssize_t avail;
    apr_ssize_t step;
    cache_pqueue_get_priority pri;
    cache_pqueue_getpos get;
    cache_pqueue_setpos set;
    void **d;
};

struct cache_cache_t  {
    int             max_entries;
    apr_size_t      max_size;
    apr_size_t      current_size;
    int             total_purges;
    long            queue_clock;
    cache_hash_t   *ht;
    cache_pqueue_t *pq;
    cache_pqueue_set_priority set_pri;
    cache_pqueue_get_priority get_pri;
    cache_cache_inc_frequency *inc_entry;
    cache_cache_get_size *size_entry;
    cache_cache_get_key *key_entry;
    cache_cache_free *free_entry;
};

typedef struct mem_cache_conf{
    apr_thread_mutex_t *lock;
    cache_cache_t *cache_cache;
    apr_size_t cache_size;
    apr_size_t object_cnt;

  
    apr_size_t min_cache_object_size;   
    apr_size_t max_cache_object_size;   
    apr_size_t max_cache_size;          
    apr_size_t max_object_cnt;
    cache_pqueue_set_priority cache_remove_algorithm;
    
    apr_off_t max_streaming_buffer_size;
}mem_cache_conf_t;


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



int apr_atomic_dec(int* x){
     (*x)--; 
     return *x; 
}

void cleanup_cache_object(cache_object_t *obj)
{
    mem_cache_object_t *mobj = obj->vobj;

    /* TODO:
     * We desperately need a more efficient way of allocating objects. We're
     * making way too many malloc calls to create a fully populated 
     * cache object...
     */

    /* Cleanup the cache_object_t */
    if (obj->key) {
        free(obj->key);
    }
    if (obj->info.content_type) {
        free(obj->info.content_type);
    }
    if (obj->info.etag) {
        free(obj->info.etag);
    }
    if (obj->info.lastmods) {
        free(obj->info.lastmods);
    }
    if (obj->info.filename) {
        free(obj->info.filename);
    }
    free(obj);
    
    /* Cleanup the mem_cache_object_t */
    if (mobj) {
        
        if (mobj->type == CACHE_TYPE_HEAP && mobj->m) {
            free(mobj->m);
        }
       
        if (mobj->type == CACHE_TYPE_FILE && mobj->fd) {
            close(mobj->fd);
        }
         
        if (mobj->header_out) {
            if (mobj->header_out[0].hdr) 
                free(mobj->header_out[0].hdr);
            free(mobj->header_out);
        }
        if (mobj->subprocess_env) {
            if (mobj->subprocess_env[0].hdr) 
                free(mobj->subprocess_env[0].hdr);
            free(mobj->subprocess_env);
        }
        if (mobj->notes) {
            if (mobj->notes[0].hdr) 
                free(mobj->notes[0].hdr);
            free(mobj->notes);
        }
  
        if (mobj->req_hdrs) {
            if (mobj->req_hdrs[0].hdr)
                free(mobj->req_hdrs[0].hdr);
            free(mobj->req_hdrs);
        }
     
        free(mobj);
    }
}

static void cache_pq_bubble_up(cache_pqueue_t *q, apr_ssize_t i)
{
    apr_ssize_t parent_node;
    void *moving_node = q->d[i];
    long moving_pri = q->pri(moving_node);

    for (parent_node = parent(i);
         ((i > 1) && (q->pri(q->d[parent_node]) < moving_pri));
         i = parent_node, parent_node = parent(i))
    {
        q->d[i] = q->d[parent_node];
        q->set(q->d[i], i);
    }

    q->d[i] = moving_node;
    q->set(moving_node, i);
}

static apr_ssize_t maxchild(cache_pqueue_t *q, apr_ssize_t i)
{
    apr_ssize_t child_node = left(i);

    if (child_node >= q->size)
        return 0;

    if ((child_node+1 < q->size) &&
        (q->pri(q->d[child_node+1]) > q->pri(q->d[child_node])))
    {
        child_node++; /* use right child instead of left */
    }

    return child_node;
}

static void cache_pq_percolate_down(cache_pqueue_t *q, apr_ssize_t i)
{
    apr_ssize_t child_node;
    void *moving_node = q->d[i];
    long moving_pri = q->pri(moving_node);

    while ((child_node = maxchild(q, i)) &&
           (moving_pri < q->pri(q->d[child_node])))
    {
        q->d[i] = q->d[child_node];
        q->set(q->d[i], i);
        i = child_node;
    }

    q->d[i] = moving_node;
    q->set(moving_node, i);
}

apr_status_t cache_pq_remove(cache_pqueue_t *q, void *d)
{
    apr_ssize_t posn = q->get(d);
    printf("posn:%d \n",posn );
    q->d[posn] = q->d[--q->size];
    if (q->pri(q->d[posn]) > q->pri(d)){
        printf("before cache_pq_bubble_up\n");   
        cache_pq_bubble_up(q, posn);
        printf("after cache_pq_bubble_up\n");
    }        
    else{
	    printf("before cache_pq_percolate_down\n");
        cache_pq_percolate_down(q, posn);
        printf("after cache_pq_percolate_down\n");
	}
    return APR_SUCCESS;
}

cache_hash_entry_t **find_entry(cache_hash_t *ht,
                                       const void *key,
                                       apr_ssize_t klen,
                                       const void *val)
{
    cache_hash_entry_t **hep, *he;
    const unsigned char *p;
    const unsigned char *tmp_p;
    unsigned int hash;
    apr_ssize_t i;
    
    tmp_p = (const unsigned char*)key;

    hash = 0;
    if (klen == CACHE_HASH_KEY_STRING) {
        for (p = key; *p; p++) {
            hash = hash * 33 + *p;
        }
        klen = p - tmp_p;//(const unsigned char *)key;
    }
    else {
        for (p = key, i = klen; i; i--, p++) {
            hash = hash * 33 + *p;
        }
    }
    
    /* scan linked list */
 
    for (hep = &ht->array[hash % ht->max], he = *hep;
	 he;
	 hep = &he->next, he = *hep) {
	if (he->hash == hash &&
	    he->klen == klen &&
	    memcmp(he->key, key, klen) == 0)
	    break;
    }
  
    if (he || !val)
	return hep;
    /* add a new entry for non-NULL values */
    he = malloc(sizeof(*he));
    if (!he) {
        return NULL;
    }
    he->next = NULL;
    he->hash = hash;
    he->key  = key;
    he->klen = klen;
    he->val  = val;
    *hep = he;
    ht->count++;
    return hep;
}


void * cache_hash_set(cache_hash_t *ht,
                                     const void *key,
                                     apr_ssize_t klen,
                                     const void *val)
{
    cache_hash_entry_t **hep, *tmp;
    const void *tval;
    hep = find_entry(ht, key, klen, val);
    /* If hep == NULL, then the malloc() in find_entry failed */
    if (hep && *hep) {
        if (!val) {
            /* delete entry */
            tval = (*hep)->val;
            tmp = *hep;
            *hep = (*hep)->next;
            free(tmp);
            --ht->count;
        }
        else {
            /* replace entry */
            tval = (*hep)->val;
            (*hep)->val = val;
        }
        /* Return the object just removed from the cache to let the 
         * caller clean it up. Cast the constness away upon return.
         */
        return (void *) tval;
    }
    /* else key not present and val==NULL */
    return NULL;
}


apr_status_t cache_remove(cache_cache_t *c, void *entry)
{
    apr_size_t entry_size = c->size_entry(entry);
    apr_status_t rc;
    printf("before pq_remove\n");
    rc = cache_pq_remove(c->pq, entry);
    printf("after pq_remove\n");
    if (rc != APR_SUCCESS)
        return rc;

    printf("before hash_set\n");     
    cache_hash_set(c->ht, c->key_entry(entry), CACHE_HASH_KEY_STRING, NULL);
    printf("after hash_set\n");
    c->current_size -= entry_size;

    return APR_SUCCESS;
}

long memcache_get_priority(void*a)
{
    cache_object_t *obj = (cache_object_t *)a;
    mem_cache_object_t *mobj = obj->vobj;

    return  mobj->priority;
}
void memcache_inc_frequency(void*a)
{
    cache_object_t *obj = (cache_object_t *)a;
    mem_cache_object_t *mobj = obj->vobj;

    mobj->total_refs++;
    mobj->priority = 0;
}

void memcache_set_pos(void *a, apr_ssize_t pos)
{
    cache_object_t *obj = (cache_object_t *)a;
    mem_cache_object_t *mobj = obj->vobj;
    mobj->pos = pos;
}


apr_ssize_t memcache_get_pos(void *a)
{
    cache_object_t *obj = (cache_object_t *)a;
    mem_cache_object_t *mobj = obj->vobj;
    return mobj->pos;
}

apr_size_t memcache_cache_get_size(void*a)
{
    cache_object_t *obj = (cache_object_t *)a;
    mem_cache_object_t *mobj = obj->vobj;
    return mobj->m_len;
}

const char* memcache_cache_get_key(void*a)
{
    cache_object_t *obj = (cache_object_t *)a;
    return obj->key;
}

 void memcache_cache_free(void*a)
{
    cache_object_t *obj = (cache_object_t *)a;

    obj->refcount++;

    obj->cleanup = 1;

    obj->refcount--;
    if (!obj->refcount) {
        cleanup_cache_object(obj);
    }

}

cache_hash_entry_t **alloc_array(cache_hash_t *ht, int max)
{
   return calloc(1, sizeof(*ht->array) * (max + 1));
}

cache_hash_t * cache_hash_make(apr_size_t size)
{
    cache_hash_t *ht;
    ht = malloc(sizeof(cache_hash_t));
    if (!ht) {
        return NULL;
    }
    ht->count = 0;
    ht->max = size;
    ht->array = alloc_array(ht, ht->max);
    if (!ht->array) {
        free(ht);
        return NULL;
    }
    return ht;
}

cache_pqueue_t *cache_pq_init(apr_ssize_t n,
                              cache_pqueue_get_priority pri,
                              cache_pqueue_getpos get,
                              cache_pqueue_setpos set)
{
    cache_pqueue_t *q;

    if (!(q = malloc(sizeof(cache_pqueue_t)))) {
        return NULL;
    }

    /* Need to allocate n+1 elements since element 0 isn't used. */
    if (!(q->d = malloc(sizeof(void*) * (n+1)))) {
        free(q);
        return NULL;
    }
    q->avail = q->step = (n+1);  /* see comment above about n+1 */
    q->pri = pri;
    q->size = 1;
    q->get = get;
    q->set = set;
    return q;
}

cache_cache_t * cache_init(int max_entries,
                                         apr_size_t max_size,
                                         cache_pqueue_get_priority get_pri,
                                         cache_pqueue_set_priority set_pri,
                                         cache_pqueue_getpos get_pos,
                                         cache_pqueue_setpos set_pos,
                                         cache_cache_inc_frequency *inc_entry,
                                         cache_cache_get_size *size_entry,
                                         cache_cache_get_key* key_entry,
                                         cache_cache_free *free_entry)
{
    cache_cache_t *tmp;
    tmp = malloc(sizeof(cache_cache_t));
    tmp->max_entries = max_entries;
    tmp->max_size = max_size;
    tmp->current_size = 0;
    tmp->total_purges = 0;
    tmp->queue_clock = 0;
    tmp->get_pri = get_pri;
    tmp->set_pri = set_pri;
    tmp->inc_entry = inc_entry;
    tmp->size_entry = size_entry;
    tmp->key_entry = key_entry;
    tmp->free_entry = free_entry;

    tmp->ht = cache_hash_make(max_entries);
    tmp->pq = cache_pq_init(max_entries, get_pri, get_pos, set_pos);

    return tmp;
}

//function parameters
typedef struct {
  cache_object_t* obj; 
  mem_cache_conf_t* sconf;
} s_param;


apr_status_t decrement_refcount(s_param *arg) 
{

	mem_cache_conf_t* sconf = arg->sconf; 
	 

    // added by fengqin
    int cnt;
    int pid = getpid();

    cache_object_t * obj = arg->obj;

    if(obj){ 
	    if (!obj->complete) {

			mem_cache_object_t *mobj = (mem_cache_object_t *) obj->vobj;
		
		       /* If obj->complete is not set, the cache update failed and the
		       * object needs to be removed from the cache then cleaned up.
		       */
			if (sconf->lock) {
			    printf("lock acquired\n"); 
			    apr_thread_mutex_lock(sconf->lock);
			}
			/* Remember, objects marked for cleanup are, by design, already
			 * removed from the cache. remove_url() could have already
			 * removed the object from the cache (and set obj->cleanup)
			 */
			if (!obj->cleanup) {
				printf("before remove\n");
			    cache_remove(sconf->cache_cache, obj);
			    printf("after remove\n");
			    sconf->object_cnt--;
			    sconf->cache_size -= mobj->m_len;
			    obj->cleanup = 1;
			}
			if (sconf->lock) {
			    printf("lock released\n");
			    apr_thread_mutex_unlock(sconf->lock);
			}
	
		}
	
	
		cnt = apr_atomic_dec(&obj->refcount);
	    if (!obj->refcount) {
			assert(cnt == obj->refcount);
			//if(cnt !=obj->refcount)
		 	//   printf("OOOOPS!\n");      
	
			if (obj->cleanup) {
			    cleanup_cache_object(obj);
			}
		}

    }  
    
    pthread_exit(NULL);
    return APR_SUCCESS;

}

void my_free(void *p){
  if ( p ) memset(p,0,1); //fill in one byte of 0 
}

int input1,input2,input3;
cache_object_t __obj ;

cache_object_t* sh_obj;
mem_cache_conf_t __sconf;
mem_cache_conf_t* sconf;
mem_cache_object_t __vobj;

int main(int argc, char **argv)
{

  pthread_t  t2,t3;
  
  sh_obj = &__obj ; 

  sh_obj->count=1;   
  sh_obj->complete=input1;
  sh_obj->refcount=input2;
  sh_obj->cleanup=input3;
 
  sh_obj->key = (char*)malloc(sizeof(char));
  *(sh_obj->key)='1';
  sh_obj->vobj = &__vobj; 
  __vobj.m_len = 1;  
  
  sconf = & __sconf;
  sconf->max_object_cnt = 10;
  sconf->max_cache_size  = 10;
  sconf->object_cnt = 0;
  sconf->cache_size = 0;
  sconf->lock = (apr_thread_mutex_t*)malloc(sizeof(apr_thread_mutex_t));
  pthread_mutex_init(&(sconf->lock->mutex), NULL);
  printf("before cache init!\n");
  sconf->cache_cache = cache_init(sconf->max_object_cnt,
                                    sconf->max_cache_size,                                   
                                    memcache_get_priority,
                                    sconf->cache_remove_algorithm,
                                    memcache_get_pos,
                                    memcache_set_pos,
                                    memcache_inc_frequency,
                                    memcache_cache_get_size,
                                    memcache_cache_get_key,
                                    memcache_cache_free);
  printf("after cache init!\n");                                  
  sconf->cache_cache->pq->d = &sh_obj;
                                    
  printf("initialization done!\n");
  printf("complete: %d\n", input1);
  printf("refcount: %d\n", input2);
  printf("cleanup: %d\n", input3);

  s_param param;
  param.obj = sh_obj;
  param.sconf = sconf;



  pthread_create(&t2, 0, decrement_refcount, &param);
  pthread_create(&t3, 0, decrement_refcount, &param);

  //pthread_join(t2, 0);
  //pthread_join(t3, 0);
  
  printf("after join!\n");

  return 0;
}
