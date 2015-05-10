// spellcheck.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdbool.h>

#include "dictionary.h"
#include "file2strqueue.h"

// for convenience: this is how you represent an apostrophe (')
const char apostrophe = '\'';

// a simple void * wrapper for strcmp
int strcmp_wrapper(const void *a, const void *b) {
    assert(a);
    assert(b);
    const char *str_a = a;
    const char *str_b = b;
    return strcmp(str_a, str_b);
}

// Because the Dictionary ADT uses key/value pairs,
// and for the wordlist dictionary, we only need keys
// we can use the VALID pointer for every value
int valid = 1;
void *VALID = &valid;

// but we don't want our Dictionary ADT free-ing VALID,
// so we need a function that does not free anything
// (to pass to the create_Dictionary function)
void do_nothing(void *p) {
    return;
}

int main(void) {
    // create the wordlist dictionary
    Dictionary wordlist = create_Dictionary(strcmp_wrapper, free, do_nothing);

    // read in the words from the file to a string queue
    StrQueue sq = file2StrQueue("wordlist.txt");

    // for each word in the queue, insert it into the dictionary
    while (sq_length(sq)) {
        char *word = sq_remove_front(sq);   // remove word from queue
        insert(wordlist, word, VALID);      // insert it to Dictionary (with the value of VALID)
    }
    // now lookup(wordlist, my_word) will either return VALID or NULL
    destroy_StrQueue(sq);   // you can now re-use this sq pointer if you want.
    sq = NULL;
    /////////////////
    Dictionary autocorrect = create_Dictionary(strcmp_wrapper, free, free);
    sq = file2StrQueue("autocorrect.txt");
    while (sq_length(sq)) {
        char *word_key = sq_remove_front(sq);   
        char *word_val = sq_remove_front(sq);  
        insert(autocorrect, word_key, word_val);       
    }
    destroy_StrQueue(sq);    
    sq = NULL;
    ///////////////// 
    sq = file2StrQueue(NULL);
    int time = 0;
    bool isletter = true;
    int strlenth = 0;
    char *word_key;
    while (sq_length(sq)) {
        word_key = sq_remove_front(sq);
        time++;
        isletter = true;
        strlenth = strlen(word_key);
        for (int i = 0; i< strlenth;i++) {
            if (word_key[i] != apostrophe && 
                (!(('a' <= word_key[i] &&  'z' >= word_key[i]) ||
                   ('A' <= word_key[i] &&  'Z' >= word_key[i])))){
                isletter = false;
                break;
            }
        }
        if (isletter == false) printf("_%s_", word_key);
        else {
            char *word_key_lowercase = strdup(word_key);
            for (int i = 0; i< strlenth;i++) {
                if ('A' <= word_key[i] &&  'Z' >= word_key[i]){
                    word_key_lowercase[i] = word_key_lowercase[i] - 'A' + 'a';
                }
            }
            if (lookup(wordlist, word_key_lowercase) != NULL)   printf("%s", word_key);
            else {
                char *lookup_result = lookup(autocorrect, word_key);
                if (lookup_result != NULL) printf("*%s*", lookup_result);
                else printf("[%s]", word_key);

            }
            free(word_key_lowercase);
        }

        if (time == 10 || sq_length(sq)==0) {printf("\n"); time = 0;} else printf(" "); 
     free (word_key);
    }
    destroy_StrQueue(sq);    
    sq = NULL;
    ////////////////
    // don't forget to free your memory
    destroy_Dictionary(wordlist);
    destroy_Dictionary(autocorrect);
}
