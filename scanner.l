/* definitions */

%{
#include<stdio.h>
#include "tokendef-1.h"

int scancol = 1;
int yycol = 1;
int scanlineno = 1;
int temp_col;

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
string         \"([^\"\\\n]|\\[btnr'\"\\])*\"
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
"if"           { temp_col = yycol; yycol += 2; return KWD_IF; }
"else"         { temp_col = yycol; yycol += 4; return KWD_ELSE; }
"while"        { temp_col = yycol; yycol += 5; return KWD_WHILE; }
"int"          { temp_col = yycol; yycol += 3; return KWD_INT; }
"string"       { temp_col = yycol; yycol += 6; return KWD_STRING; }
"char"         { temp_col = yycol; yycol += 4; return KWD_CHAR; }
"return"       { temp_col = yycol; yycol += 6; return KWD_RETURN; }
"void"         { temp_col = yycol; yycol += 4; return KWD_VOID; }

 /* Operators */
"+"            { updateCol(); return OPER_ADD; }
"-"            { updateCol(); return OPER_SUB; }
"*"            { updateCol(); return OPER_MUL; }
"/"            { updateCol(); return OPER_DIV; }
"<"            { updateCol(); return OPER_LT; }
">"            { updateCol(); return OPER_GT; }
">="           { temp_col = yycol; yycol += 2; return OPER_GTE; }
"<="           { temp_col = yycol; yycol += 2; return OPER_LTE; }
"=="           { temp_col = yycol; yycol += 2; return OPER_EQ; }
"!="           { temp_col = yycol; yycol += 2; return OPER_NEQ; }
"="            { updateCol(); return OPER_ASGN; }

 /* Identifiers */
{identifier}    { temp_col = yycol; updateCol(); return ID; }
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
{whitespace}    { yycol += yyleng; }
.               { return ILLEGAL_TOK; }

"("            { updateCol(); return LPAREN; }
")"            { updateCol(); return RPAREN; }
";"            { updateCol(); return SEMICLN; }

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