// Your Name
// CS136, Winter 2015
// Assignment 8, Problem 2
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>

int main(void) {

    
struct dyn_array {
  int *data;
  int len ;
  int max ;
};
    
struct dyn_array da = {NULL, 0, 0};
    
    int ch;
    
    while (1){
        int returns = scanf("%d", &ch);
        
        
        if (da.len == da.max) {
    if (da.max == 0) {
      da.max = 1;
      da.data = malloc(sizeof(int));
    } else {
      da.max *= 2;
     da.data = realloc(da.data, sizeof(int) * da.max); }
  }
        
        
        if (returns == 0 || returns == EOF){
        
            for (int i = 0; i < (da.len); ++i){ // pay attention to here 
                //  (int i = 0; i <= (da.len); ++i) is not good!!
              if(da.data[i] < da.data[da.len - 1])
                  printf ("%d\n", da.data[i]);
            }
              free(da.data);
        return(0);
        }
    

  da.data[da.len] = ch;
  da.len++;
     
}
    
    
}
