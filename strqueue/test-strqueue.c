#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include "strqueue.h"

int main (void){
    StrQueue c = create_StrQueue();
    sq_add_back(c,"test1\n");
    char* temp = sq_remove_front(c);
    printf("%s", temp);
    free (temp);
    destroy_StrQueue(c);
    // otuput:test1
}