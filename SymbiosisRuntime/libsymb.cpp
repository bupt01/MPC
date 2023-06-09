#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string>
#include <map>
#include <vector>
#include <sstream>

#define __PTHREAD_MUTEX_SIZE__ 56

using namespace std;

FILE* outputFile;
pthread_mutex_t __symb_lock__;
struct _opaque_pthread_mutex_t {long __sig; char __opaque[__PTHREAD_MUTEX_SIZE__]; };
map<pthread_t, int> mapThreadToId;
map<int, vector<int> > threadTraces;
int idCounter;
int asrtThread;  //indicates the thread id that hit the assertion
int asrtPos; 	 //indicates the position in the trace corresponding to the assertion BB

void myBeforeMutexLock(_opaque_pthread_mutex_t *l){}

void myAfterMutexLock(_opaque_pthread_mutex_t *l){}

void __attribute__ ((constructor)) Symb_Constructor();
void __attribute__ ((destructor)) Symb_Destructor();

extern "C" {
    void myBasicBlockEntry(int bbid);
    void myPThreadCreate(pthread_t* ptid);
    void myAssert(int success);
}

void Symb_Constructor()
{
    //printf("--- CONSTRUCTOR\n");
    idCounter = 0;
    asrtPos = 0;
    asrtThread = 0;
    pthread_mutex_init(&__symb_lock__,NULL);
}

void Symb_Destructor()
{
    pthread_mutex_lock(&__symb_lock__);
    string configFile = getenv("SYMBTRACE");
    string filename;
    filename = configFile + ".ok";
    outputFile = fopen(filename.c_str(),"w");
    
    //print to file
    for(std::map<int,vector<int> >::iterator oit = threadTraces.begin(); oit != threadTraces.end();++oit)
    {
        int i = 0;
        for(i = 0; i < oit->second.size(); i++)
        {
            if(asrtThread == oit->first && i == asrtPos){
                fprintf(outputFile, "[%d %d]\n",oit->first, oit->second[i]);
            }
            else{
                fprintf(outputFile, "%d %d\n",oit->first, oit->second[i]);
            }
			//printf("ttttt: %d %d\n", oit->first, oit->second[i]);
        }
    }
    fclose(outputFile);
    pthread_mutex_unlock(&__symb_lock__);
}

//transforms an int into a string
string stringValueOf(int i)
{
    stringstream ss;
    ss << i;
    return ss.str();
}

//stores a trace file whenever the execution hits an assertion (either failing our correct)
void myAssert(int success)
{
    int tid = mapThreadToId[pthread_self()];
    asrtThread = tid;
    asrtPos = threadTraces[tid].size()-1;
    
    if(success == 0)
    {
        pthread_mutex_lock(&__symb_lock__);
        string configFile = getenv("SYMBTRACE");
        string filename;
        filename = configFile + ".fail";
        outputFile = fopen(filename.c_str(),"w");
        
        //print to file
        for(std::map<int,vector<int> >::iterator oit = threadTraces.begin(); oit != threadTraces.end();++oit)
        {
            int i = 0;
            for(i = 0; i < oit->second.size(); i++)
            {
                if(asrtThread == oit->first && i == asrtPos){
                    fprintf(outputFile, "[%d %d]\n",oit->first, oit->second[i]);
                }
                else{
                    fprintf(outputFile, "%d %d\n",oit->first, oit->second[i]);
                }
            }
        }
        fclose(outputFile);
        pthread_mutex_unlock(&__symb_lock__);
    }
}


void myBasicBlockEntry(int bbid)
{
    pthread_mutex_lock(&__symb_lock__);
    pthread_t ptid = pthread_self();
    int tid = -1;
    if(mapThreadToId.empty()){
        mapThreadToId[ptid] = 0;
        tid = 0;
        //printf("--- map is empty! tid = %d\n",tid);
    }
    else{
        if(mapThreadToId.count(ptid)==0){
            idCounter++; //updates the counter for the child thread
            tid = idCounter;
            mapThreadToId[ptid] = tid;
            //printf("--- map is empty for %d! tid = %d\n",ptid,tid);
        }
        else
            tid = mapThreadToId[ptid];
    }
    if(threadTraces[tid].size()>0){
        threadTraces[tid].push_back(bbid);
    }
    else{
        vector<int> trace;
        trace.push_back(bbid);
        threadTraces[tid] = trace;
    }
    //printf("--- ptid: %d tid: %d   BB: %d\n",ptid,tid, bbid);
    pthread_mutex_unlock(&__symb_lock__);
}

void myPThreadCreate(pthread_t* ptid)
{
    pthread_mutex_lock(&__symb_lock__);
    int tid = -1;
    
    //handle child thread
    if(mapThreadToId.count(*ptid)>0){
        tid = mapThreadToId[*ptid];
    }
    else{
        idCounter++; //updates the counter for the child thread
        tid = idCounter;
        mapThreadToId[*ptid] = tid;
    }
    //printf("=== PTID: %d   TID: %d\n",*ptid, tid);
    pthread_mutex_unlock(&__symb_lock__);
}
