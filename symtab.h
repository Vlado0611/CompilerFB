/* maximum hashtable size */

#define SIZE 221

// maximum token length
#define MAXTOKENLEN 32

// token types for the symbol table
#define UNDEF 0
#define INT_TYPE 1

typedef struct Param{
	int par_type;
	char param_name[MAXTOKENLEN];
	int value;
} Param;

// list of lineNumbers for each variable
typedef struct RefList{
	int lineNumber;
	struct RefList *next;
	int type;
} RefList;

// struct that represents a node
typedef struct list_t{
	char st_name[MAXTOKENLEN];
	int st_size;
	RefList *lines;
	int st_value;
	int st_type;
	struct list_t *next;
}list_t;

// hash table
static list_t **hash_table;

// functions
void init_hash_table(); // initializes the function
unsigned int hash(char* key); // hash function
void insert(char* name, int type, int lineNumber); // add entry
list_t* lookup(char *name); // search for entry
//void symtab_dump(FILE *of); // dump file
