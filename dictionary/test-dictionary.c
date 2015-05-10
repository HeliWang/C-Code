#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <stdio.h>
#include <limits.h>
#include "dictionary.h"

// a comparison function for integers
int compare_ints(const void *a, const void *b) {
    const int *ia = a;
    const int *ib = b;
    if (*ia < *ib) { return -1; }
    if (*ia > *ib) { return 1; }
    return 0;
}

void free1(void *c) {
    free(c);
}

void free2(void *c) {
    free(c);
}

void next(Dictionary c, int k, int v) {
    int *newk = malloc(sizeof(int));
    int *newv = malloc(sizeof(int));
    *newk = k; *newv = v;
    insert(c,newk,newv);
    return;
}
    
int *MakeNumPointer(int v) {
    int *newv = malloc(sizeof(int));
    *newv = v;
    return(newv);
}
   
int main(void) {
   Dictionary c = create_Dictionary(compare_ints,free1,free2);
   next(c,1,2);
   next(c,2,2);
   next(c,3,2);
   next(c,7,2);
   next(c,7,3);
   next(c,7,INT_MIN);
   next(c,11,INT_MAX);   
   next(c,INT_MAX,11);   
   int *n7 = MakeNumPointer(7);
   int *n11 = MakeNumPointer(11);
   int *nINT_MAX = MakeNumPointer(INT_MAX);
   int *result7 =lookup(c, n7);
   int *result11= lookup(c, n11);
   int *resultINT_MAX= lookup(c, nINT_MAX);
   assert(*result7 == INT_MIN);
   assert(*result11 == INT_MAX);
   assert(*resultINT_MAX == 11);
   free (nINT_MAX); free (n11); free (n7); 
   destroy_Dictionary(c);
}