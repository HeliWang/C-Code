#include "trinary.h"
#include <stdbool.h>
#include <stdio.h>
#include <assert.h>

// Heli Wang
// CS136, Winter 2015
// Assignment 7, Problem 7

// see header file
void trinary_search(int *a, int n, int v) {
    assert (a);
    int total_comparison = 0;
    int low = 0;
    int high = n-1;
    while (low <= high){

        int diff = high - low; 
        if (diff < 4){
            for (int pos = low; pos <= high; pos++){
                printf ("Checking if %d is equal to %d\n", v, a[pos]);
                total_comparison++;
                if (a[pos] == v){
                    printf ("Search successful\n");
                    printf ("%d is located at index %d\n", v, pos);
                    printf ("A total of %d comparisons were made\n", total_comparison);
                    return;
                }
            }
            printf ("Search not successful\n");
            printf ("A total of %d comparisons were made\n", total_comparison);
            return;
        }
        int ind2 = low + diff - (diff-1)/3;
        int ind1 = ind2 - 1 - (diff-1)/3 - (diff-1)%3/2;

        printf ("Checking if %d is equal to %d\n", v, a[ind1]);
        total_comparison++;
        if (a[ind1] == v){
            printf ("Search successful\n");
            printf ("%d is located at index %d\n", v, ind1);
            printf ("A total of %d comparisons were made\n", total_comparison);
            return;
        } 
        printf ("Checking if %d is less than %d\n", v, a[ind1]);
        total_comparison++;
        if (v < a[ind1]){
            high = ind1-1;
            continue;
        }

        printf ("Checking if %d is equal to %d\n", v, a[ind2]);
        total_comparison++;
        if (a[ind2] == v){
            printf ("Search successful\n");
            printf ("%d is located at index %d\n", v, ind2);
            printf ("A total of %d comparisons were made\n", total_comparison);
            return;
        }

        printf ("Checking if %d is less than %d\n", v, a[ind2]);
        total_comparison++;
        if (v < a[ind2]){
            low = ind1+1;
            high = ind2-1;
            continue;
        }

        if (v > a[ind2]){
            low = ind2+1;
            continue;
        }

    }
    printf ("Search not successful\n");
    printf ("A total of %d comparisons were made\n", total_comparison);
    return;
}

/*
int main (void){
    int a[19] = {6,12,18,22,29,37,38,41,51,53,55,67,73,75,77,81,86,88,94};
    trinary_search(a, 19, 99);
}*/