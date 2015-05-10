#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include "strqueue.h"

struct node {
    char* data;
    struct node *next;
};

struct strqueue {
    struct node *front;
    struct node *rear;
    int n; // number of item
};

// create_StrQueue(): creates a new StrQueue
//   effects: allocates a struct strqueue on the heap,
//            caller must call destroy_StrQueue
//   time: O(1)
StrQueue create_StrQueue(void){
    StrQueue s = malloc(sizeof(struct strqueue));
    s->front = NULL;    s->rear = NULL;
    s->n = 0;
    return s;
}


// destroy_StrQueue(sq): frees the memory occupied by sq
//     and frees every string still in the queue
//   requires:  sq is a valid StrQueue (not NULL)
//   effects: frees the memory occupied by sq and frees every string in sq,
//            sq is no longer valid
//   time: O(n), where n is sq_length(sq)
void destroy_StrQueue(StrQueue sq){
    assert(sq);
    while (sq->n != 0){
        free(sq_remove_front(sq));
    }
    free(sq);
}

// sq_add_back(sq, str): makes a copy of str and places it at the
//     end of the queue
//   requires:  sq is a valid StrQueue (not NULL)
//         str is not NULL.
//   effects: sq length increased by 1
//         a copy of str is now at the end of sq
//   time: O(n), where n is strlen(str)
void sq_add_back(StrQueue sq, const char *str){
    assert(str);
    assert(sq);
    struct node *new = malloc(sizeof(struct node));
    new->data = malloc(sizeof(char) * (strlen (str)+1));
    strcpy(new->data,str);
    new->next = NULL;

    if (sq->n == 0) sq->front = new;
    else if (sq->n == 1){
        sq->front->next = new;
        sq->rear = new;
    }
    else{
        sq->rear->next = new;
        sq->rear = new;
    }
    sq->n++;
}


// sq_remove_front(sq): returns the string that was first in the queue 
//     or NULL if empty
//   requires:  sq is a valid StrQueue (not NULL)
//   effects: if sq is empty, returns NULL 
//         otherwise, returns the first string (caller must free)
//         and sq length decreased by 1
//   time: O(1)
char *sq_remove_front(StrQueue sq){
    assert(sq);
    if (sq->n == 0) return(NULL);
    char *rtdata = sq->front->data;
    struct node *temp = sq->front;
    sq->front = sq->front->next;
    free(temp);
    sq->n--;
    if (sq->n == 0)  sq->rear = NULL;
    return rtdata;
}


// sq_length(sq) returns the number of items in the queue.
//   requires:  sq is a valid StrQueue (not NULL)
//   time: O(1)
int sq_length(StrQueue sq){
    return sq->n;
}

