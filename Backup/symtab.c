#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

void init_hash_table(){

	hash_table = malloc(SIZE * sizeof(list_t*));
	for(int i = 0; i < SIZE; i++){
        hash_table[i] = NULL;
	}
}

unsigned int hash(char* key){

    unsigned int hashVal = 0;
    for(;*key != '\0'; key++){
        hashVal += *key;
    }

    hashVal += key[0] % 11 + (key[0] << 3) - key[0];

    return hashVal % SIZE;
}

void insert(char* name, int type, int lineNumber){
    unsigned int hashval = hash(name);

    list_t* l = hash_table[hashval];

    while((l!=NULL) && (strcmp(name, l->st_name) != 0)) l = l->next;

    if( l == NULL){
        // variable not in the table
        l = (list_t*) malloc(sizeof(list_t));

        strcpy(l->st_name, name);
        l->st_type = type;
        l->lines = (RefList*) malloc(sizeof(RefList));
        l->lines->lineNumber = lineNumber;
        l->lines->next = NULL;
        l->next = hash_table[hashval];
        hash_table[hashval] = l;
    }
    else {
        // variable found in the table
        RefList* t = l->lines;
        while(t->next != NULL) t = t->next;
        t->next = (RefList*) malloc(sizeof(RefList));
        t->next->lineNumber = lineNumber;
        t->next->next = NULL;
    }
}

list_t* lookup(char* name){

    unsigned int hashval = hash(name);

    list_t* l = hash_table[hashval];

    while((l != NULL) && strcmp(name, l->st_name) != 0) l = l->next;

    return l;
}


