%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
    #include "parser.tab.h"
    extern FILE *yyin;
	
	int lineNumber = 1;
	//int colNumber = 0;
	
	void print(char* token_type);
	void yyerror();
%}

%x ML_COMMENT

alpha [a-zA-Z]
digit [0-9]

ID [a-zA-Z][a-zA-Z_0-9]*
ICONST [1-9][0-9]*|"0"
HEXCONST 0[xX][0-9a-fA-F]+
IDSEC [a-zA-Z][a-zA-Z_0-9]*

%%
	
"//".* 				{}

"/*"				{ BEGIN(ML_COMMENT);}

<ML_COMMENT>"*/" 	{ BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"	{ lineNumber += 1; }

"LET"				{ yylval.string = strdup(yytext); return LET;}
"IN"				{ yylval.string = strdup(yytext); return IN;}
"END"				{ yylval.string = strdup(yytext); return END;}
"IF"				{ yylval.string = strdup(yytext); return IF;}
"THEN"				{ yylval.string = strdup(yytext); return THEN;}
"FI"				{ yylval.string = strdup(yytext); return FI;}
"ELSE"				{ yylval.string = strdup(yytext); return ELSE;}
"WHILE"				{ yylval.string = strdup(yytext); return WHILE;}
"DO"				{ yylval.string = strdup(yytext); return DO;}
"READ"				{ yylval.string = strdup(yytext); return READ;}
"WRITE"				{ yylval.string = strdup(yytext); return WRITE;}
"SKIP"				{ yylval.string = strdup(yytext); return SKIP;}
"INTEGER"			{ yylval.string = strdup(yytext); return INTEGER;}
"FOR"				{ yylval.string = strdup(yytext); return FOR;}

"+"					{ yylval.string = strdup(yytext); return ADDOP;}
"-"					{ yylval.string = strdup(yytext); return SUBOP;}
"*"					{ yylval.string = strdup(yytext); return MULOP;}
"/"					{ yylval.string = strdup(yytext); return DIVOP;}
"^"					{ yylval.string = strdup(yytext); return KAPPAOP;}
"<"					{ yylval.string = strdup(yytext); return LESS;}
">"					{ yylval.string = strdup(yytext); return GREATER;}
"="					{ yylval.string = strdup(yytext); return EQUALS;}
";"					{ yylval.string = strdup(yytext); return SEMICOLON;}
":"					{ yylval.string = strdup(yytext); return COLON;}
"("					{ yylval.string = strdup(yytext); return LPAREN;}
")"					{ yylval.string = strdup(yytext); return RPAREN;}
","					{ yylval.string = strdup(yytext); return COMMA;}
"."					{ yylval.string = strdup(yytext); return DOT;}
"?"					{ yylval.string = strdup(yytext); return QUESTION;}
"{"					{ yylval.string = strdup(yytext); return LCURL;}
"}"					{ yylval.string = strdup(yytext); return RCURL;}

{ID}				{ 	// inserting the ID in the symbol table
						insert(yytext, strlen(yytext),UNDEF, lineNumber); 
						yylval.symtab_item = lookup(yytext);
						return ID;
					}

{ICONST}			{ yylval.int_val = atoi(yytext); return ICONST;}

{HEXCONST}			{
						int temp;
						char str[20];
						
						sscanf(yytext, "%x", &temp);
						sprintf(str, "%d", temp);
						sscanf(str, "%d", &yylval.int_val);
						return HEXCONST;
					}

"\n"				{ lineNumber += 1;}

[ \t\r\f]+			{}

.					{ yyerror("Unrecognized character");}

%%