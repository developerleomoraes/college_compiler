%union {
  struct no {
    int place;
	char *code;
	int len;
  } node;
  int place;
}

%{
#include "analex.c"
#include "code.h"
%}

%token <place> NUM
%token <place> ID
%token EQ
%token NE
%token LE
%token GE
%token AND
%token OR
%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token SWITCH
%token CASE
%token BREAK
%token INT
%token VOID
%token FLOAT
%token MOD
%token INC
%token DEC
%token RETURN
%token PRINT
%token PRINTLN
%token READ

%type <node> statement_seq statement compound  
%type <node> Exp 

%left AND OR
%left '>' '<' NE EQ GE LE
%left '+' '-' 
%left '*' '/'
%start Prog
%%
Prog: statement_seq { print_cod($1.code); }
    ;

Funcao: Tipo_F ID '(' Declps ')' '{' Decls statement_seq '}'
	;

Declps: Ldeclps
	|
	;
	
Ldeclps: Tipo ID
	|Ldeclps ',' Tipo ID
	;
	
Decls: Decl Decls
	|
	;	
	
Decl: Tipo Vars ';'
	;
	
Vars: ID ',' Vars
	| ID
	;
	
Tipo: INT
	| FLOAT
	;
	
Tipo_F: VOID
	| Tipo
	|
	;

Args: Exp ',' Args
	|Exp
	|
	;
statement : 
    ID '=' Exp ';'   				  { atrib(&$$, $1, $3); }
    | IF '(' Exp ')' compound         { if_cmd(&$$,$3,$5);}
    | IF '(' Exp ')' compound ELSE compound   { if_cmd(&$$,$3,$5);}
    | WHILE '(' Exp ')' compound      { while_cmd(&$$,$3,$5);}
    | ID '(' params ')' ';'           {}
    | PRINT ID ';'    { print(&$$,$2); }
    | PRINTLN ID ';'  { println(&$$,$2); }
    | READ ID ';'     { read(&$$,$2); }	
  
Exp : Exp '+' Exp  { exp_ari(&$$, $1, $3, "add"); }
	| Exp '-' Exp  { exp_ari(&$$, $1, $3, "sub"); }
	| Exp '*' Exp  { exp_ari(&$$, $1, $3, "mul"); }
	| Exp '/' Exp  { exp_ari(&$$, $1, $3, "div"); }
	| Exp '>' Exp  { exp_rel(&$$,$1,$3,"bgt");}
	| Exp '<' Exp  { exp_rel(&$$,$1,$3,"blt");}
	| Exp GE Exp   { exp_rel(&$$,$1,$3,"bge");}
	| Exp LE Exp   { exp_rel(&$$,$1,$3,"ble");}
	| Exp EQ Exp   { exp_rel(&$$,$1,$3,"beq");}
	| Exp NE Exp   { exp_rel(&$$,$1,$3,"bne");}
	| Exp AND Exp  { exp_ari(&$$, $1, $3, "and"); }
	| Exp OR Exp   { exp_ari(&$$, $1, $3, "or"); }
	| '(' Exp ')'  { $$ =  $2; }
	| NUM		   { li(&$$,$1); }
	| ID           { create_cod(&$$.code); $$.place = $1;}
	; 

statement_seq:
	statement				   { create_cod(&$$.code); insert_cod(&$$.code,$1.code);}	
	| statement_seq statement  { create_cod(&$$.code); insert_cod(&$$.code,$1.code); insert_cod(&$$.code,$2.code);}

Atrib: ID '=' Exp ';'	{ printf("move $s%d, $t%d\n", $1, $3); }
     ;

compound:
	statement 					{create_cod(&$$.code);insert_cod(&$$.code,$1.code);}
	| '{' statement_seq '}'     {create_cod(&$$.code);insert_cod(&$$.code,$2.code);}
	;

params :
	Exp
	| Exp ',' params
	|
	;
     
If_Statement: IF '(' Exp ')' compound Else_Part
	;

Else_Part: ELSE compound
	|
	;
	
While_Statement : WHILE '(' Exp ')' compound
	;
	
Do_While_Statement: DO compound WHILE '(' Exp ')' ';'
	;
	
%%
main(int argc, char ** argv) {
	freopen("saida.asm","w",stdout);	
    printf(".text\n");
	yyin = fopen(argv[1],"r");
	yyparse();
}
