#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <pthread.h>
//#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
//#include <pthread.h>
//#include <unistd.h>
#include <time.h>
#include <fcntl.h>

#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>

#include <netinet/in.h>

#include <arpa/inet.h>

//#include <signal.h>
//#include <pthread.h>

#include <assert.h>


/****************************************************************************
 *
 *  Data.h
 *
 ****************************************************************************/

#ifndef DATA_H
#define DATA_H

#include <pthread.h>
#include <netinet/in.h>


/****************************************************************************
 *
 *  Defs.h
 *
 ****************************************************************************/

#ifndef DEFS_H
#define DEFS_H


enum
{
  GETREQSIZ = 256,
  GETRECVSIZ = 8192,
  HEADREQSIZ = 512,
  MAXURLSIZ = 1024,
  MAXHOSTSIZ = 1024,
  MAXIPSIZ = 16,
  MAXBUFSIZ = 512,
  MAXTHREADS = 25,
  HTTPPORT = 80,
  UNKNOWNREQ = 2,
  FTPREQ = 21,
  PROTO_HTTP = 0xFF,
  PROTO_FTP = 0x00,
  STAT_OK = 0xFF,		/* Download completed successfully      */
  STAT_INT = 0x0F,		/* ^C caught, download interrupted      */
  STAT_ERR = 0x00		/* Download finished with error         */
};


#define	PROGVERSION  "EnderUNIX Aget v0.4"
#define	HEADREQ  "HEAD %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\n\r\n"
#define	GETREQ  "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\nRange: bytes=%ld-\r\nConnection: close\r\n\r\n"

#endif
typedef struct request
{
  char host[MAXHOSTSIZ];	/* Remote host  */
  char url[MAXURLSIZ];		/* URL          */
  char file[MAXBUFSIZ];		/* file name    */
  char lfile[MAXBUFSIZ];	/* if local file name is specified      */
  char ip[MAXIPSIZ];		/* Remote IP    */
  char username[MAXBUFSIZ];
  char password[MAXBUFSIZ];
  int port;
  int clength;			/* Content-length       */
  unsigned char proto;		/* Protocol             */
} request;


typedef struct thread_data
{
  struct sockaddr_in sin;
  char getstr[GETREQSIZ];
  long soffset;			/* Start offset         */
  long foffset;			/* Finish offset        */
  long offset;			/* Current Offset       */
  long clength;			/* Content Length       */
  int fd;
  pthread_t tid;		/* Thread ID            */
  unsigned char status;		/* thread exit status   */
} thread_data;

#endif




/************************************************************************************
 *
 *   Download.c
 *
 ************************************************************************************/


#define _XOPEN_SOURCE 500


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <netdb.h>
#include <time.h>
#include <signal.h>
#include <pthread.h>

#include <netinet/in.h>

#include <sys/types.h>

#include <arpa/inet.h>

#include <sys/socket.h>


sigset_t signal_set;

int bwritten = 0;
//pthread_mutex_t bwritten_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t bwritten_mutex;


char *fullurl;
int nthreads = 2; 
int fsuggested = 0;

struct request *req;		/* Download jobs                */
struct thread_data *wthread;	/* Worker Threads               */

#if 1 //niloo
#include <errno.h>
#else
extern int errno;
#endif


handleHttpRetcode (char *rbuf)
{

  if ((strstr (rbuf, "HTTP/1.1 416")) != NULL)
    {
      printf
	("Server returned HTTP/1.1 416 - Requested Range Not Satisfiable\n");
      exit (1);
    }
  else if ((strstr (rbuf, "HTTP/1.1 403")) != NULL)
    {
      printf ("<Server returned HTTP/1.1 403 - Permission Denied\n");
      exit (1);
    }
  else if ((strstr (rbuf, "HTTP/1.1 404")) != NULL)
    {
      printf ("<Server returned HTTP/1.1 404 - File Not Found\n");
      exit (1);
    }
}


void *
http_get (void *arg)
{
  struct thread_data *td;
  int sd;
  char *rbuf, *s;
  int dr, dw, i;
  long foffset;
  pthread_t tid;
  //tid = pthread_self ();

  /* Block out all signals        */
  pthread_sigmask (SIG_BLOCK, &signal_set, NULL);

  /* Set Cancellation Type to Asynchronous        */
  pthread_setcanceltype (PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

  td = (struct thread_data *) arg;

  foffset = td->foffset;

  rbuf = (char *) calloc (GETRECVSIZ, sizeof (char));


  if ((sd = socket (AF_INET, SOCK_STREAM, 0)) == -1)
    {
      //printf ("<THREAD #%ld> socket creation failed: %s", tid, strerror (errno));
      pthread_exit ((void *) 1);
    }

  if ((connect
       (sd, (const struct sockaddr *) &td->sin,
	sizeof (struct sockaddr))) == -1)
    {
      //printf ("<THREAD #%ld> connection failed: %s", tid, strerror (errno));
      pthread_exit ((void *) 1);
    }

  if ((send (sd, td->getstr, strlen (td->getstr), 0)) == -1)
    {
      //printf ("<THREAD #%ld> send failed: %s", tid, strerror (errno));
      pthread_exit ((void *) 1);
    }

  printf("sbuf: %s\n", td->getstr);
  if ((dr = recv (sd, rbuf, GETRECVSIZ, 0)) == -1)
    {
      //printf ("<THREAD #%ld> recv failed: %s", tid, strerror (errno));
      pthread_exit ((void *) 1);
    }

  printf("rbuf: %d %s\n", dr, rbuf);
  handleHttpRetcode (rbuf);
  printf("rbuff: %d %s\n", dr, rbuf);


  if ((strstr (rbuf, "HTTP/1.1 206")) == NULL)
    {
      printf ("Something unhandled happened, shutting down...\n");
      exit (1);
    }

  s = rbuf;
  i = 0;
  while (1)
    {
      if (*s == '\n' && *(s - 1) == '\r' && *(s - 2) == '\n'
	  && *(s - 3) == '\r')
	{
	  s++;
	  i++;
	  break;
	}
      s++;
      i++;
    }
  td->offset = td->soffset;

  if ((dr - i) > foffset)
    dw = pwrite (td->fd, s, (foffset - i), td->soffset);
  else
    dw = pwrite (td->fd, s, (dr - i), td->soffset);
  td->offset = td->soffset + dw;

  int prev_bwritten;
 
  pthread_mutex_lock (&bwritten_mutex);
  bwritten += dw;
  pthread_mutex_unlock (&bwritten_mutex);
  prev_bwritten = bwritten;


  while (td->offset < foffset)
    {
      memset (rbuf, GETRECVSIZ, 0);
      // Andreas Holzer: I replaced 0 by MSG_WAITALL to make the behavior deterministic when replaying a run which was constructed from observations of previous runs.
      //dr = recv (sd, rbuf, GETRECVSIZ, 0);
      dr = recv (sd, rbuf, GETRECVSIZ, MSG_WAITALL);
	  printf("dr: %d\n", dr);
      if ((td->offset + dr) > foffset)
	dw = pwrite (td->fd, rbuf, foffset - td->offset, td->offset);
      else
	dw = pwrite (td->fd, rbuf, dr, td->offset);
      td->offset += dw;
	  //printf("rec: %s\n", rbuf);

      pthread_mutex_lock (&bwritten_mutex);
      bwritten += dw;
      pthread_mutex_unlock (&bwritten_mutex);

      assert((prev_bwritten + dw) == bwritten);
      
      /*if((prev_bwritten + dw) != bwritten){
		        printf("error\n");
                //assert(0);
      }*/
      prev_bwritten = bwritten;
      //updateProgressBar (bwritten, td->clength);
    }

  if (td->offset == td->foffset)
    td->status = STAT_OK;	/* Tell thet download is OK.    */

  close (sd);

  pthread_exit(NULL);
  //return NULL;
}

int
calc_offset (int total, int part, int nthreads)
{
  return (part * (total / nthreads));
}

void http_head_req (struct request *req)
{
  struct sockaddr_in sin;
  struct hostent *he;
  int sd;
  char *sbuf;
  char *rbuf;
  char *tok;
  char *s;
  int clength;


  sbuf = (char *) calloc (HEADREQSIZ + strlen (req->url), sizeof (char));
  rbuf = (char *) calloc (HEADREQSIZ, sizeof (char));

  /*if ((he = gethostbyname (req->host)) == NULL)
    {
      printf("Error: Cannot resolve hostname for %s: %s\n",
	   req->host, hstrerror (h_errno));
      exit (1);
    }
  printf("he: %d, %s\n", he, he->h_addr);
  strncpy (req->ip, inet_ntoa (*(struct in_addr *) he->h_addr), MAXIPSIZ);
  printf("ip: %s\n", req->ip);*/
  strncpy(req->ip, "45.249.110.23", MAXIPSIZ);
  //req->ip = "45.249.110.23";

  bzero (&sin, sizeof (sin));
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = inet_addr (req->ip);
  sin.sin_port = htons (req->port);

  if ((sd = socket (AF_INET, SOCK_STREAM, 0)) == -1)
    {
      printf("Socket creation failed for Head Request: %s\n", strerror (errno));
      exit (1);
    }
  if ((connect (sd, (const struct sockaddr *) &sin, sizeof (sin))) == -1)
    {
      printf("Connection failed for Head Request: %s\n", strerror (errno));
      exit (1);
    }
  printf("Head-Request Connection established\n");

  sprintf (sbuf, HEADREQ, req->url, req->host, PROGVERSION);
  if ((send (sd, sbuf, strlen (sbuf), 0)) == -1)
    {
      printf("send failed for Head Request: %s\n", strerror (errno));
      exit (1);
    }

  printf("sbuf1: %s\n", sbuf);
  if ((recv (sd, rbuf, HEADREQSIZ, 0)) == -1)
    {
      printf("recv failed for Head Request: %s\n", strerror (errno));
      exit (1);
    }

  printf("rbuf1: %s\n", rbuf);
  handleHttpRetcode (rbuf);

  tok = strtok (rbuf, "\r\n");
  printf("tok: %s\n", tok);
  if ((strstr (tok, "HTTP/1.1 200")) != NULL)
    {
      while ((tok = strtok (NULL, "\r\n")) != NULL)
	{
	  if ((strstr (tok, "Content-Length")) != NULL)
	    {
	      s = (tok + strlen ("Content-Length: "));
	      clength = atoi (s);
	      req->clength = clength;
	    }
	}
    }
  free (sbuf);
  free (rbuf);


  //req->clength = 5;
  printf("end of head_req: %d\n", req->clength);

  return;
}

void
usage ()
{
  fprintf (stderr, "usage: aget [options] url\n");
  fprintf (stderr, "\toptions:\n");
  fprintf (stderr, "\t\t-p port number\n");
  fprintf (stderr, "\t\t-l local file name\n");
  fprintf (stderr, "\t\t-f force using suggested number of threads\n");
  fprintf (stderr, "\t\t-h this screen\n");
  fprintf (stderr, "\t\t-v version info\n");
  fprintf (stderr, "\n");
  fprintf (stderr, "http//www.enderunix.org/aget/\n");
}

/* reverse a given string	*/
void
revstr (char *str)
{
  char *p, *s;
  int i;
  int size;

  if ((size = strlen (str)) == 0)
    return;
  p = (char *) calloc (size/*niloo*/+1, sizeof (char));
  s = p;
  for (i = size; i >/*= niloo*/ 0; i--, s++)
    *s = *(str + i - 1);
  *s = '\0';
  memset (str, 0, size);
  strncpy (str, p, size);
  free (p);
}

void
parse_url (char *url, struct request *req)
{
  char *s;
  int i, j, k;

  i = j = k = 0;
  s = url;
  if ((strncmp (url, "ftp://", 6)) == 0)
    {
      printf ("Error: Currently Aget doesn't support FTP requests...\n");
      exit (1);
    }
  else if ((strncmp (url, "http://", 7)) != 0)
    {
      printf ("Error: URL should be of the form http://...\n");
      exit (1);
    }

  if (req->port == 0)
    {
      req->port = 80;
      req->proto = PROTO_HTTP;
    }


  s = url + 7;			/* Jump pass http:// part       */
  for (i = 0; *s != '/'; i++, s++)
    {
      if (i > MAXHOSTSIZ)
	{
	  printf ("Error: Cannot get hostname from URL...\n");
	  exit (1);
	}
      if (*s == ':')
	{			/* If user/pass is supplied like; http://murat:12345@x.y.com/url.html */
	  while (*s != '/')
	    {
	      req->username[j++] = *--s;
	      i--;
	    }
	  req->username[--j] = '\0';
	  revstr (req->username);
	  while (1)
	    {
	      if (*s == ':')
		{
		  while (*s != '@')
		    {
		      if (k > MAXBUFSIZ)
			{
			  printf ("Error: Cannot get password from URL...\n");
			  exit (1);
			}
		      req->password[k++] = *++s;
		    }
		  break;
		}
	      s++;
	    }
	  req->password[--k] = '\0';
	}
      req->host[i] = *s;
    }
  req->host[i] = '\0';
  for (i = 0; *s != '\0'; i++, s++)
    {
      if (i > MAXURLSIZ)
	{
	  printf ("Error: Cannot get remote file name from URL...\n");
	  exit (1);
	}
      req->url[i] = *s;
    }
  req->url[i] = '\0';
  --s;
  for (i = 0; *s != '/'; i++, s--)
    {
      if (i > MAXBUFSIZ)
	{
	  printf ("Error: Cannot get local file name from URL...\n");
	  exit (1);
	}
      req->file[i] = *s;
    }
  req->file[i] = '\0';
  revstr (req->file);

}


int  main (int argc, char **argv)
{
 
  extern char *optarg;
  extern int optind;
  int c, error = 0, ret;
  
  //CREST_shared_int(bwritten);
  klee_make_symbolic(&bwritten, sizeof(bwritten), "shared*bwritten");

  // Andi
  pthread_mutex_init(&bwritten_mutex, NULL);


  /* Allocate heap for download request   
   * struct request stores all the information that might be
   * of interest
   */
  req = (struct request *) calloc (1, sizeof (struct request));


  /* Only some signals will be emitted    */
  sigemptyset (&signal_set);
  sigaddset (&signal_set, SIGINT);
  sigaddset (&signal_set, SIGALRM);
  
  /* Block out all signals        */
  pthread_sigmask (SIG_BLOCK, &signal_set, NULL);
  

//niloo
/*
  while (!error && (c = getopt (argc, argv, "p:l:hfv")) != -1){
    switch (c){
    case 'p':   req->port = atoi(optarg);  break;
    case 'f':   fsuggested = 1;  break;
    case 'l':   strncpy (req->lfile, optarg, MAXBUFSIZ);  break;
    case 'h':
	  printf ("%s\n", PROGVERSION);
	  usage ();
	  exit (0);
	  break;
    case 'v':
	  printf ("%s\nby Murat BALABAN <murat@enderunix.org>\n",
		  PROGVERSION);
	  exit (0);
	  break;
    default:
	  error = 1;
	  usage ();
	  exit (1);
	  break;
	}
  }

    if (error){
       usage ();
       exit (1);
     }

    if (fsuggested == 1 && nthreads == 0) {
      printf ("\nERROR: -f and -n should be used together!, exiting...\n\n");
      usage ();
      exit (1);
    }

    if (argc == 2)		
        fullurl = strdup (argv[1]);
    else if (optind < argc)
      if (argc > 2)
          fullurl = strdup (argv[optind]);
      else
      {
	usage ();
	exit (1);
      }
      else if (optind == argc)
     {
        usage ();
        exit (1);
     }

*/
     //fullurl = "http://www.nec-labs.com/~ivancic/bugs/bugs.htm";
	 fullurl = "http://www.sample-videos.com/text/Sample-text-file-10kb.txt";
		
     //fullurl = "http://www.mercola.com/";
     parse_url (fullurl, req);





///////////////////////////////////////////
  int i, fd, nok = 0;
  long soffset, foffset;
  char *fmt;

  if (req->proto == PROTO_HTTP)
    http_head_req (req);

  wthread = (struct thread_data *) malloc (nthreads * sizeof (struct thread_data));

  printf("Downloading %s (%d bytes) from site %s(%s:%d). Number of Threads: %d\n",
       req->url, req->clength, req->host, req->ip, req->port, nthreads);

  if (strlen (req->lfile) != 0)
    {
      if ((fd = open (req->lfile, O_CREAT | O_RDWR, S_IRWXU)) == -1)
	{
	  printf ("get: cannot open file %s for writing: %s\n",
		   req->lfile, strerror (errno));
	  exit (1);
	}

    }
  else
    {
      printf("open req->file\n");

      if ((fd = open ("y"/*req->file*/, O_CREAT | O_RDWR, S_IRWXU)) == -1)
	{
	  printf ("get: cannot open file %s for writing: %s\n",
		   req->lfile, strerror (errno));
	  exit (1);
	}
    }


  printf("req->clength: %d\n", req->clength);

  /*if ((lseek (fd, req->clength - 1, SEEK_SET)) == -1)
    {
      printf ("get: couldn't lseek:  %s\n", strerror (errno));
      exit (1);
    }

  if ((write (fd, "0", 1)) == -1)
    {
      printf ("get: couldn't allocate space for download file: %s\n",
	       strerror (errno));
      exit (1);
    }*/

  fmt = (char *) calloc (GETREQSIZ - 2, sizeof (char));
  printf("req: %d, %d\n", req->clength, foffset);
  for (i = 0; i < nthreads; i++)
    {
      soffset = calc_offset (req->clength, i, nthreads);
      foffset = calc_offset (req->clength, i + 1, nthreads);
      wthread[i].soffset = soffset;
      wthread[i].foffset = (i == nthreads - 1 ? req->clength : foffset);
      wthread[i].sin.sin_family = AF_INET;
      wthread[i].sin.sin_addr.s_addr = inet_addr (req->ip);
      wthread[i].sin.sin_port = htons (req->port);
      wthread[i].fd = dup (fd);
      wthread[i].clength = req->clength;
      snprintf (fmt, GETREQSIZ, GETREQ, req->url, req->host, PROGVERSION,
		soffset);
      strncpy (wthread[i].getstr, fmt, GETREQSIZ);
      pthread_create (&(wthread[i].tid), NULL, http_get, &(wthread[i]));
    }
    free (fmt);


  /* Wait for all of the threads to finish... 
   * 
   * TODO: If a thread fails, restart that!
   */
  /*for (i = 0; i < nthreads; i++)
    {
      pthread_join (wthread[i].tid, NULL);
      if (wthread[i].status == STAT_OK)
	nok++;
    }*/


  printf("Done!!!\n");

  //close (fd);

  return 0;
}
