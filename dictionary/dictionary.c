#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include <stdio.h>
#include <limits.h>
#include "dictionary.h"

struct bstnode {
    void *key;
    void *value;
    struct bstnode *left;
    struct bstnode *right;
};

struct dictionary {
    struct bstnode *root;
    CompareFunction key_compare;
    FreeFunction free_k; //to free keys and
    FreeFunction free_v; //to free values
};
    
// create_Dictionary(comp_k, free_k, free_v) creates a new Dictionary
//     that uses the comp_k function to compare keys
//     the free_k function to free keys and
//     the free_v function to free values
//   requires:  comp_k, free_k and free_v are valid (non-NULL) function pointers
//   effects: allocates a struct dictionary on the heap,
//            caller must call destroy_Dictionary
//   time: O(1)
//   NOTE: comp_k(a,b) follows the strcmp(a,b) return convention
Dictionary create_Dictionary(CompareFunction comp_k, FreeFunction free_k, FreeFunction free_v){
    assert(comp_k);
    assert(free_k);
    assert(free_v);
    struct dictionary *newdict = malloc(sizeof(struct dictionary));
    newdict->root = NULL;
    newdict->key_compare = comp_k;
    newdict->free_k = free_k;
    newdict->free_v = free_v;
    return (newdict);
}

// destroy_Dictionary(dict): Frees all memory allocated for dict, 
//     and frees the memory for every key and every value
//   requires:  dict is a valid Dictionary (not NULL)
//   effects: dict is no longer valid
//   time: O(n * f), where n is the number of items in Dictionary, 
//         f is time to free key & value
void destroy_node(struct bstnode *node,FreeFunction free_k, FreeFunction free_v){
        if (NULL == node) {return;}
        free_k(node->key);
        free_v(node->value);
        destroy_node(node->left,free_k,free_v);
        destroy_node(node->right,free_k,free_v);
        free(node);
}

void destroy_Dictionary(Dictionary dict){
   assert(dict);
   if (dict->root != NULL) {
  destroy_node(dict->root,dict->free_k,dict->free_v);
   }
   free(dict);
}
 


// insert(dict, k, v): insert the key/value pair k/v into the dictionary.
//     the client should not modify or free k or v after insert.
//     if the key k already exists, the previous value will be freed
//     and the value for k will be replaced with v.
//   requires:  dict, k, and v are valid (not NULL)
//   effects: it will add the (k,v) pair into the dictionary
//            if k already existed, the previous value will be freed
//   time: O(h * c + f), where h is height of underlying BST, 
//         c is time to compare two keys,
//         and f is the time to free the previous value (if necessary)
// from course note
struct bstnode *make_bstnode(void *k, void *v, struct bstnode *l,struct bstnode *r) {
    struct bstnode *new = malloc(sizeof(struct bstnode)); 
    new->key = k;
    new->value = v;
    new->left = l;
    new->right = r;
    return new;
}

void bst_insert(void *k, void *v,struct bstnode **ptr_root,CompareFunction key_compare) {
    struct bstnode *t = *ptr_root;
    if (t == NULL) { 
      *ptr_root = make_bstnode(k, v, NULL, NULL);
       return;
    } else if (key_compare(t->key,k) == 0) {
       free(t->value);
       t->value = v;
      if (t->key != k){free (t->key);t->key = k;}
       return;
    } else if (key_compare(t->key,k) > 0) {
      return (bst_insert(k,v, &(t->left), key_compare));
    } else {
      return (bst_insert(k,v, &(t->right), key_compare));
    }
}

void insert(Dictionary dict, void *k, void *v){
    assert(dict);
    assert(k);
    assert(v);
    bst_insert (k,v, &(dict->root),dict->key_compare);
}

// lookup(dict, k): returns the value associated with key k, if such
//     a value exists.  Otherwise, returns NULL.
//   requires:  dict and k are valid (not NULL)
//   time: O(h * c), where h is height of underlying BST, 
//         c is time to compare two keys
// from my A9 code
void *search(struct bstnode *t, void *k,CompareFunction key_compare){
  if(t == NULL) return NULL;
  if(key_compare(t->key,k)==0) return t->value;
  if(key_compare(t->key,k)>0) return (search(t->left, k,key_compare));
  return (search(t->right, k,key_compare)); 
}

void *lookup(Dictionary dict, void *k){
    assert(dict);
    assert(k);
    return (search (dict->root,k,dict->key_compare));
}


