%{
	#include "symtab.c"
	#include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern FILE *yyin;
	
    extern int lineNumber;
    extern int yylex();
    void yyerror(char* msg);
	int errNum = 0;
%}

/* YYSTYPE union */
%union {
	int int_val;
	list_t* symtab_item;
	char* string;
}

%token<int_val> LET IN END IF THEN ELSE FI WHILE DO READ WRITE SKIP INTEGER
%token<int_val> ADDOP SUBOP MULOP DIVOP KAPPAOP LESS GREATER EQUALS 
%token<int_val> SEMICOLON COLON LPAREN RPAREN COMMA DOT ICONST HEXCONST QUESTION 
%token<int_val> LCURL RCURL FOR
%token<symtab_item> ID

%left COMMA
%right EQUALS
%left LESS GREATER
%left ADDOP SUBOP
%left MULOP DIVOP
%left KAPPAOP
%left LPAREN RPAREN

%start program

%%

program : LET declarations IN command_Sequence END;

declarations :  INTEGER id_seq ID DOT 								
			| /* empty */;
	
id_seq :  id_seq ID COMMA 
		| ID COMMA														
		| /* empty */;

command_Sequence : command_Sequence command SEMICOLON | /* empty */;

command : SKIP
		| assign
		| if_statement
		| while_statement
		| READ ID
		| WRITE expression
		| ternary
		| do_while_statement
		| for_statement
;

assign: ID COLON EQUALS expression;

if_statement : IF expression THEN command_Sequence endif FI;

endif : ELSE command_Sequence | /* empty */ ; 

ternary: expression QUESTION command COLON command;

while_statement : WHILE expression DO command_Sequence END;

do_while_statement: DO LCURL command_Sequence RCURL WHILE expression;

for_statement: FOR LPAREN assign SEMICOLON expression SEMICOLON assign RPAREN command_Sequence END;

expression :
		constant
		| ID				
		| LPAREN expression RPAREN
		| expression ADDOP expression
		| expression SUBOP expression
		| expression MULOP expression
		| expression DIVOP expression
		| expression KAPPAOP expression
		| expression EQUALS expression
		| expression LESS expression
		| expression GREATER expression
;

constant : ICONST | HEXCONST;
%%

void yyerror (char* msg)
{
  printf("Error at line %d: %s \n", lineNumber, msg);
  //exit(1);
  errNum += 1;
}


int main (int argc, char *argv[]){

	// initialize symbol table
	init_hash_table();

	// parsing
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
	
	if(errNum == 0){
		printf("Parsing completed successfully");
	}
	else {
		printf("Found %d errors", errNum);
	}
    
    //return flag;
}