#include <stdlib.h>
#include <pthread.h>
#include <stdio.h>
#define true 1
#define false 0

typedef struct node {
	int value;
	struct node* next;
} node_t;

typedef struct {
	struct node* head;
	struct node* tail;
} queue_t;

pthread_mutex_t lock;
queue_t queue;
void init_queue(queue_t *q, int num_threads);
void enqueue(queue_t *q, unsigned int val);
int dequeue(queue_t *q, unsigned int *retVal);

void init_queue(queue_t *q, int num_threads) {
	struct node *newnode=malloc(sizeof (struct node)); klee_make_symbolic(newnode, sizeof(struct node), "shared*newnode");
	newnode->value = 0;

	newnode->next = NULL;
	q->head = newnode;
	
	q->tail = newnode;
}

int atomic_compare_exchange_strong(struct node** node1, 
			struct node** node2, struct node* valNode) {
	
	pthread_mutex_lock(&lock);
	if (*node1 == *node2) {
		*node1 = valNode;  
		pthread_mutex_unlock(&lock);
		return 1;
	}
	pthread_mutex_unlock(&lock);
	return 0;

}

void enqueue(queue_t *q, unsigned int val) {
	struct node *tail;//=malloc(sizeof (struct node)); klee_make_symbolic(&tail, sizeof(struct node*), "entail");
	struct node *next;//=malloc(sizeof (struct node)); klee_make_symbolic(&next, sizeof(struct node*), "ennext");
	struct node *qtail;//=malloc(sizeof (struct node));klee_make_symbolic(&qtail, sizeof(struct node*), "enqtail");
	struct node *new_tailptr;//=malloc(sizeof (struct node));klee_make_symbolic(new_tailptr, sizeof(struct node), "ennewtailptr");
	struct node * node_ptr = malloc(sizeof(struct node));klee_make_symbolic(node_ptr, sizeof(struct node), "shared*node_ptr");
	
	node_ptr->value = val; 
	node_ptr->next = NULL;
	
	while (true) {
		tail = q->tail;
		next = tail->next;
		qtail = q->tail;

		if (tail == qtail) {
			
			if (next == NULL) {
				if (atomic_compare_exchange_strong(&tail->next, &next, node_ptr))
					break;
			}
		}
		new_tailptr = tail->next;
		atomic_compare_exchange_strong(&q->tail, & tail, new_tailptr);
	}
	atomic_compare_exchange_strong(&q->tail, & tail, node_ptr);
}

int dequeue(queue_t *q, unsigned int *retVal) {
	struct node* head;//=malloc(sizeof (struct node));klee_make_symbolic(&head, sizeof(struct node*), "dehead");
	struct node* tail;//=malloc(sizeof (struct node));klee_make_symbolic(&tail, sizeof(struct node*), "detail");
	struct node* next;//=malloc(sizeof (struct node));klee_make_symbolic(&next, sizeof(struct node*), "denext");

	while (true) {
		head = q->head;
		tail = q->tail;
		next = head->next;
		
		if (q->head == head) {
			if (head == tail) {

				if (next == NULL) {
					return false; // NULL
				}
				atomic_compare_exchange_strong(&q->tail, & tail, next);
			} else {
				*retVal = next->value;
				if (atomic_compare_exchange_strong(&q->head,& head, next)) {
					return true;
				}
			}
		}
	}
}

static void *e(void *param)
{
	int i, k1; klee_make_symbolic(&k1, sizeof(k1), "k1");
    if (k1>5) return ;
	for(i=0; i<k1; i++)
		enqueue(&queue, 1);
}

static void *d(void *param) {
	int val,i, k2; klee_make_symbolic(&k2, sizeof(k2), "k2");
    if (k2>5) return ;
	for(i=0; i<k2; i++) {
		dequeue(&queue, &val);
	}
}

int main(int argc, char **argv)
{
	// MODEL_ASSERT(queue);

	pthread_t t[2]; klee_make_symbolic(&queue, sizeof(queue_t), "shared*queue");
	
	init_queue(&queue, 2);

	pthread_create(&t[0], NULL, e, NULL);
	pthread_create(&t[1], NULL, d, NULL);

	pthread_join(t[0], NULL);
	pthread_join(t[1], NULL);

	return 0;
}
