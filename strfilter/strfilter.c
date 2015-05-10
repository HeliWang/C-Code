#include "strfilter.h"
#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <stdbool.h>

void strfilter(char s[], bool (*f)(char c)) {
    assert(f);
    assert(s);
    int length = 0;
    while (s[length]) {++length;}
 
    length = length+1;
    char *copytext = malloc(sizeof(char) * length);
    char *copytext_initial = copytext;
    char *copytext_initial2 = copytext;
    char *strSrc = s;

  
  while((*strSrc) != '\0'){
      if (f (*strSrc)) {
      *copytext = (*strSrc);
      copytext++;
      }
      strSrc++;
    }
    
 *copytext = '\0';
 while( (*s++ = *copytext_initial++) != '\0');
 free (copytext_initial2); // pay attention to change of change!
}

/*
bool is_vowel(char c) {
 return c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || 
   c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
}

int main(void) {
  char s[] = "hello, world!";
  strfilter(s,is_vowel);
//  printf ("%c", s[3]);
  assert(strcmp(s,"eoo") == 0); 
}
*/