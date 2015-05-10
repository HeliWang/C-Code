#include "tree2list.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>
#include <limits.h>

/*struct node {
    int val;
    struct node* left;
    struct node* right;
};*/

// tree2list(root) takes a binary search tree - root-  and 
// rearranges the internal pointers to make a circular doubly linked list
// out of the tree nodes. The list should be arranged so that the nodes
// are in increasing order. The function returns a pointer to the
// beginning of new list (pointer to the node which includes the minimum value).
// if root==NULL the furnction returns NULL 
// time: O(n), where n is the number of nodes in root.
struct node *tree2list(struct node *root) {
  if(root == NULL) return NULL;
  struct node *left = tree2list(root->left);
  struct node *right = tree2list(root->right);
  root->left = root;
  root->right = root;
    
    
  if (left==NULL) left = root;
    else if (root != NULL) {
     struct node *left_left = left->left;
     struct node *root_left = root->left;
     left_left->right = root;
     root->left = left;
     root_left->right = left;
     left->left = root_left;
    }
 
    if (left==NULL) left = right;
    else if (right != NULL) {
     struct node *left_left2 = left->left;
     struct node *right_left = right->left;
     left_left2->right = right;
     right->left = left;
     right_left->right = left;
     left->left = right_left;
    }
    
  return (left);
}
