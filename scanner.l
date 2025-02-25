/* definitions */

%{
#include<stdio.h>
#include "tokendef-1.h"

int scancol = 1;
int yycol = 1;
int scanlineno = 1;

char* yyerror;

void updateCol();
void countLines();
int processString();
%}
%option yylineno

newline         \n
whitespace      [ \t\r]+
integer         [1-9][0-9]*
integerlead0    0[0-9]+
character       '\\?.'
string         \"([^\"\\\n]|\\.)*\"
untermstring   \"([^\"\\\n]|\\.)*
multlnstring   \"([^\"\\]*(\\n)[^\"\\]*)*\"
comment         "//.*"
multlncomment   "/\*([^*]|\*+[^*/])*\*/"
untermcomment   "/\*([^*]|\*+[^*/])*"
identifier      [a-zA-Z_][a-zA-Z0-9_]*
illidentifier   [0-9][a-zA-Z_]+[a-zA-Z0-9_]*

%%

 /* rules */

 /* Keywords */
"if"           { return KWD_IF; }
"else"         { return KWD_ELSE; }
"while"        { return KWD_WHILE; }
"int"          { return KWD_INT; }
"string"       { return KWD_STRING; }
"char"         { return KWD_CHAR; }
"return"       { return KWD_RETURN; }
"void"         { return KWD_VOID; }

 /* Operators */
"+"            { return OPER_ADD; }
"-"            { return OPER_SUB; }
"*"            { return OPER_MUL; }
"/"            { return OPER_DIV; }
"<"            { return OPER_LT; }
">"            { return OPER_GT; }
">="           { return OPER_GTE; }
"<="           { return OPER_LTE; }
"=="           { return OPER_EQ; }
"!="           { return OPER_NEQ; }
"="            { return OPER_ASGN; }

 /* Identifiers */
{identifier}    { return ID; }
{illidentifier} { yyerror = "Illegal identifier"; return ERROR; }

 /* Constants */
{integer}       { return INTCONST; }
{integerlead0}  { yyerror = "Integers may not have leading zeros"; return ERROR; }
{character}     { updateCol(); return CHARCONST; }
{string}        { updateCol(); return processString(); }
{untermstring}  { updateCol(); yyerror = "Unterminated string"; return ERROR; }
{multlnstring}  { updateCol(); countLines(); yyerror = "String spans multiple lines"; return ERROR; }

 /* Comments */
{comment}       { /* Ignore */ }
{untermcomment} { yyerror = "Unterminated comment"; return ERROR; }
{multlncomment} { /* Ignore */ }

 /* Other */
{newline}       { countLines(); }
{whitespace}    { updateCol(); }
.               { return ILLEGAL_TOK; }

%%

/* user routines */

void updateCol(){
    yycol += yyleng;
}

void countLines(){
    scanlineno++;
    yycol = 1;
}

int processString(){
    return STRCONST;
}

int yywrap(){
	return 1;
}