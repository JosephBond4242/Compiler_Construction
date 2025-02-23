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

newline         \n
whitespace      [ \t]+
integer         [1-9][0-9]*
integerlead0    0[0-9]+
character       \'[^\\\n]\'
string          \"([^\\\n\"]|\\.)*\"
multlnstring    \"([^\\\"]|\\.)*\n([^\\\"]|\\.)*\"
untermstring    \"([^\\\n\"]|\\.)*

comment         //.*
multlncomment   /\*([^*]|(\*+[^*/]))*\*+/
untermcomment   /\*([^*]|(\*+[^*/]))*

identifier      [a-zA-Z_][a-zA-Z0-9_]*
illidentifier   [0-9][a-zA-Z_][a-zA-Z0-9_]*

yylineno = 1;

%%

/* Keywords */
"if"         { updateCol(); return KWD_IF; }
"else"       { updateCol(); return KWD_ELSE; }
"while"      { updateCol(); return KWD_WHILE; }
"int"        { updateCol(); return KWD_INT; }
"string"     { updateCol(); return KWD_STRING; }
"char"       { updateCol(); return KWD_CHAR; }
"return"     { updateCol(); return KWD_RETURN; }
"void"       { updateCol(); return KWD_VOID; }

/* Operators */
"+"          { updateCol(); return OPER_ADD; }
"-"          { updateCol(); return OPER_SUB; }
"*"          { updateCol(); return OPER_MUL; }
"/"          { updateCol(); return OPER_DIV; }
"<"          { updateCol(); return OPER_LT; }
">"          { updateCol(); return OPER_GT; }
">="         { updateCol(); return OPER_GTE; }
"<="        { updateCol(); return OPER_LTE; }
"=="        { updateCol(); return OPER_EQ; }
"!="        { updateCol(); return OPER_NEQ; }
"="         { updateCol(); return OPER_ASGN; }

/* Identifiers */
{identifier}    { updateCol(); return ID; }
{illidentifier} { updateCol(); yyerror = "Illegal identifier"; return ERROR; }

/* Constants */
{integer}       { updateCol(); return INTCONST; }
{integerlead0}  { updateCol(); yyerror = "Integers may not have leading zeros"; return ERROR; }
{character}     { updateCol(); return CHARCONST; }
{string}        { updateCol(); return processString(); }
{untermstring}  { updateCol(); yyerror = "Unterminated string"; return ERROR; }
{multlnstring}  { updateCol(); countLines(); yyerror = "String spans multiple lines"; return ERROR; }

/* Comments */
{comment}       { updateCol(); }
{untermcomment} { updateCol(); yyerror = "Unterminated comment"; return ERROR; }
{multlncomment} { updateCol(); }

/* Other */
{newline}       { countLines(); }
{whitespace}    { updateCol(); }
.               { return ILLEGAL_TOK; }

%%

/* user routines */

void updateCol() {
    yycol += yyleng;
}

void countLines() {
    yylineno++;
    yycol = 1;
}

int processString() {
    updateCol();
    return STRCONST;
}
