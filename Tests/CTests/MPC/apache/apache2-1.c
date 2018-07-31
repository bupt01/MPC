#include <pthread.h>
#include <stdio.h>
#include "crest.h"
#include "../assert.h"

#define APR_SUCCESS 0
#define APR_RFC822_DATE_LEN 8 
#define free my_free

typedef int apr_status_t;
typedef int apr_size_t;
typedef int apr_off_t;

typedef struct {
    char* hdr;
    char* val;
} cache_header_tbl_t;

typedef struct mem_cache_object{
    //cache_type_e type;
    apr_size_t num_header_out;
    apr_size_t num_subprocess_env;
    apr_size_t num_notes;
    cache_header_tbl_t *header_out;
    cache_header_tbl_t *subprocess_env;
    cache_header_tbl_t *notes;
    apr_size_t cleanup;
    apr_size_t refcount;
    apr_size_t m_len;
    void *m;
}mem_cache_object_t;

/* cache info information */
typedef struct cache_info{
    char *content_type;
    char *etag;
    char *lastmods;         /* last modified of cache entity */
    char *filename;   
    char lastmod_str[APR_RFC822_DATE_LEN];
    apr_size_t len;
    const char *im;         /* If-Match header value */
    const char *inm;         /* If-None-Match header value */

}cache_info_t;

typedef struct cache_object {
    char *key;
    //cache_object_t *next;
    cache_info_t info;
    void *vobj;         /* Opaque portion (specific to the cache implementation) of the cache object */
    apr_size_t count;   /* Number of body bytes written to the cache so far */
    int complete;
    apr_size_t refcount;
    apr_size_t cleanup;
}cache_object_t;


typedef struct mem_cache_conf{
    void * lock;
    apr_size_t cache_size;
    apr_size_t object_cnt;

  
    apr_size_t min_cache_object_size;   
    apr_size_t max_cache_object_size;   
    apr_size_t max_cache_size;          
    apr_size_t max_object_cnt;

    
    apr_off_t max_streaming_buffer_size;
}mem_cache_conf_t;


int input1,input2;
cache_object_t __obj ;

cache_object_t* sh_obj;
mem_cache_conf_t __sconf;
mem_cache_conf_t* sconf;

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
        free(mobj);
    }
}

apr_status_t decrement_refcount(void *arg) 
{


    // added by fengqin
    int cnt;
    int pid = getpid();

    cache_object_t * obj = (cache_object_t *) arg;

	    if (!obj->complete) {

		mem_cache_object_t *mobj = (mem_cache_object_t *) obj->vobj;
	
	       /* If obj->complete is not set, the cache update failed and the
	       * object needs to be removed from the cache then cleaned up.
	       */
		if (sconf->lock) {
		    printf("lock acquired\n"); 
		}
		/* Remember, objects marked for cleanup are, by design, already
		 * removed from the cache. remove_url() could have already
		 * removed the object from the cache (and set obj->cleanup)
		 */
		if (!obj->cleanup) {
		    sconf->object_cnt--;
		    sconf->cache_size -= mobj->m_len;
		    obj->cleanup = 1;
		}
		if (sconf->lock) {
		    printf("lock released\n");
		}

	    }


	    cnt = apr_atomic_dec(&obj->refcount);

	    if (!obj->refcount) {
		assert(cnt == obj->refcount);

		if (obj->cleanup) {
		    cleanup_cache_object(obj);
		}
	    }

	      pthread_exit(NULL);

}

void my_free(void *p){
  if ( p ) memset(p,0,1); //fill in one byte of 0 
}


mem_cache_object_t __vobj;
int main(int argc, char **argv)
{
  printf("main started!\n");

  pthread_t  t2,t3;
  
  CREST_int(input1);
  CREST_int(input2);
  
  sh_obj = &__obj ; 
  sh_obj->count=10;   
  sh_obj->complete=input1;
  sh_obj->refcount=input2;
  sh_obj->cleanup=0;
  sh_obj->vobj = &__vobj; 
  __vobj.m_len = 1;  
  
  CREST_shared_int(sh_obj->count);
  CREST_shared_int(sh_obj->complete);
  CREST_shared_int(sh_obj->refcount);
  CREST_shared_int(sh_obj->cleanup);

  
  sconf = & __sconf;
  sconf->object_cnt = 10;
  sconf->cache_size = 10;


  printf("initialization done!\n");
  printf("complete: %d\n", input1);
  printf("refcount: %d\n", input2);

  int arg;

  printf("starting thread 1\n");
  pthread_create(&t2, 0, decrement_refcount, sh_obj);
  printf("starting thread 2\n");
  pthread_create(&t3, 0, decrement_refcount, sh_obj);

  //pthread_join(t2, 0);
  //pthread_join(t3, 0);
  
  printf("after join!\n");

  pthread_exit(NULL);
}
