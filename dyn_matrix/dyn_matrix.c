#include "dyn_matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdbool.h>
struct matrix * new_matrix(int rows, int cols) {
    assert(rows > 0);
    assert(cols > 0);
    struct matrix *result = malloc(sizeof(struct matrix));
    result->nr = rows;
    result->nc = cols;
    int max = rows * cols;
    result->data = malloc(sizeof(int) * max);
    for (int i = 0; i < max; i++){
        (result->data) [i] = 0;
    }
    return result;
}

void free_matrix(struct matrix *m) {
    assert(m);
    free(m->data);
    free(m);
}


void resize_matrix(struct matrix *m, int new_rows, int new_cols) {
    assert(new_rows > 0);
    assert(new_cols > 0);
    assert(m);
    int *new_data = malloc(sizeof(int) * (new_rows * new_cols));
   
   for(int row=0; row < new_rows; row++) {
    for(int col=0; col < new_cols; col++) {
      new_data [row * new_cols + col] = 0;
     if (row < m->nr && col < m->nc)
      new_data [row * new_cols + col] = m->data[row * (m->nc) + col];
    }
   }
   free (m->data);
    m->nr = new_rows;
    m->nc = new_cols;
    m->data = new_data;   
}


struct matrix *mult_matrix(const struct matrix *m1, const struct matrix *m2) {
    assert(m1);
    assert(m2);
    if (m1->nc != m2->nr) return NULL;
    int new_rows = m1->nr;
    int new_cols = m2->nc;
    int *new_data = malloc(sizeof(int) * (new_rows * new_cols));
    for(int row=0; row < new_rows; row++) {
     for(int col=0; col < new_cols; col++) { 
         int product = 0;
         for(int i=0; i < m1->nc; i++){
           product += ((m1->data[row * (m1->nc) + i]) * (m2->data[i * (m2->nc) + col]));
         }
         new_data [row * new_cols + col] = product;
    }
   }
    
    struct matrix *result = malloc(sizeof(struct matrix));
    result->nr = new_rows;
    result->nc = new_cols;
    result->data = new_data;
    return (result);
}
 
struct matrix *add_matrix(const struct matrix *m1, const struct matrix *m2) {
    assert(m1);
    assert(m2);
    if (m1->nc != m2->nc || m1->nr != m2->nr) return NULL;
    int new_rows = m1->nr;
    int new_cols = m1->nc;
    int *new_data = malloc(sizeof(int) * (new_rows * new_cols));
    for(int row=0; row < new_rows; row++) {
     for(int col=0; col < new_cols; col++) { 
         new_data [row * new_cols + col] = m1->data[row * new_cols + col] + m2->data[row * new_cols + col];
    }
   }    
    struct matrix *result = malloc(sizeof(struct matrix));
    result->nr = new_rows;
    result->nc = new_cols;
    result->data = new_data;
    return (result);
}

void transpose_matrix(struct matrix *m) {
    assert(m);
    int new_rows = m->nc;
    int new_cols = m->nr;
    int *new_data = malloc(sizeof(int) * (new_rows * new_cols));
    for(int row=0; row < new_rows; row++) {
     for(int col=0; col < new_cols; col++) { 
         new_data [row * new_cols + col] = m->data[col * new_rows + row];
    }
   }
    free (m->data);
    m->nr = new_rows;
    m->nc = new_cols;
    m->data = new_data;
}

void set_matrix_cell(struct matrix *m, int i, int j, int v) {
    assert(i >= 0);
    assert(j >= 0);
    assert(i < m->nr);
    assert(j < m->nc);
    assert(m);
    m->data[i * m->nc + j] = v;
}

int get_matrix_cell(const struct matrix *m, int i, int j) {
    assert(i >= 0);
    assert(j >= 0);
    assert(i < m->nr);
    assert(j < m->nc);
    assert(m);
    return (m->data[i * m->nc + j]);
}


/*======================CAUTION===========================
            CS136 STAFF FUNCTIONS BEYOND THIS POINT
                  EDIT AT YOUR OWN PERIL
  ======================CAUTION==========================*/


// num_digits(a) returns the number of decimal digits in a, plus 1 if negative
static int num_digits(int a) {
  int digit_count = 1;
  if (a < 0) { 
    ++digit_count;
    a = -a;
  } 
  if (a < 10) {
    return digit_count;
  }

  while (a >= 10) {
    a /= 10;
    ++digit_count;
  }
  return digit_count;
}

// print_num(a,width) is mostly equivalent to printf("%{width}d",a)
//                    but it puts the minus sign before the padding spaces.
// requires: num_digits(a) <= width
// effects: exactly width characters are printed to the screen
static void print_num(int a, int width) {
  int need = num_digits(a);
  assert(need <= width);
  int i = 0;
  if (a < 0) { // line the minus signs up on the left.
    printf("-");
    a = -a;
  }
  for (; i < (width-need);++i) printf(" ");
  printf("%d",a);
}

// see interface file
void draw_matrix(const struct matrix *m) {
  assert(m);
  int biggest_digit = 0; 
  for (int i = 0; i < m->nr * m->nc; ++i) {
    int nd = num_digits(m->data[i]);
    if (nd > biggest_digit) {
      biggest_digit = nd;
    }
  }
  for (int row = 0; row < m->nr;++row) {
    for (int col = 0; col < m->nc;++col) {
      print_num(get_matrix_cell(m,row,col),biggest_digit);
      if (col == m->nc-1) {
        printf("\n");
      } else {
        printf(" ");
      }
    }
  }
}
