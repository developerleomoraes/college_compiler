%{
#include "sint.h"
#include <stdio.h>
#include "tabSimbolos.h"
int line = 1;
%}
%%
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"do"                    { return DO; }
"for"                   { return FOR; }
"switch"                { return SWITCH; }
"case"                  { return CASE; }
"break"                 { return BREAK; }
"int"                   { return INT; }
"float"'		        { return FLOAT; }
"void"			        { return VOID; }
">="                    { return GE; }
"<="                    { return LE; }
"=="                    { return EQ; }
"!="                    { return NE; }
"&&"                    { return AND; }
"||"                    { return OR; }
"%"                     { return MOD; }
"++"                    { return INC; }
"--"                    { return DEC; }
"return"		        { return RETURN; }
">"                     { return '>'; }
"<"                     { return '<'; }
"="                     { return '='; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
";"                     { return ';'; }
"("                     { return '('; }
")"                     { return ')'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
"["                     { return '['; }
"]"                     { return ']'; }
","                     { return ','; }
[0-9]+("."[0-9]+)?      { yylval = insere(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval = insere(yytext); return ID; }
\ 	{ ; }
\n                      { line++; }
\t                      { ; }
"//".*\n                { }
.                       { yyerror("illegal token!"); }

%%
#ifndef yywrap
yywrap() { return 1; }
#endif

int yyerror(char *s) { 
  fprintf(stderr, "%s na linha %d\n",s,line); 
}
