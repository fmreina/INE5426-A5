%{
#include "ast.h"
#include "st.h"
ST::SymbolTable symtab;  /* main symbol table */
AST::Block *programRoot; /* the root node of our program AST:: */
extern int yylex();
extern void yyerror(const char* s, ...);
%}

/* yylval == %union
 * union informs the different ways we can store data
 */
%union {
    int integer;
    AST::Node *node;
    AST::Block *block;
	const char *string;
}

/* token defines our terminal symbols (tokens).
 */
%token <integer> T_INT
%token <string> T_VAR
%token T_PLUS T_NL T_COMMA
%token T_TIMES
%token T_DEF T_ASSIGN


/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line varlist
%type <block> lines program

/* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
%left T_PLUS
%left T_TIMES
%nonassoc error

/* Starting rule 
 */
%start program

%%

program : lines { programRoot = $1; }
        ;
        
lines   : line { $$ = new AST::Block(); if($1 != NULL)$$->lines.push_back($1); }
        | lines line { if($2 != NULL) $1->lines.push_back($2); }
	| lines error T_NL { yyerrok; } 
        ;

line    : T_NL { $$ = NULL; } /*nothing here to be used */
        | expr T_NL /*$$ = $1 when nothing is said*/
	| T_DEF varlist T_NL { $$ = $2; }
	| T_VAR T_ASSIGN expr {  AST::Node* node = symtab.assignVariable($1);
                                $$ = new AST::BinOp(node,AST::assign,$3); }
        ;

expr    : T_INT { $$ = new AST::Integer($1); }
	| T_VAR { $$ = symtab.useVariable($1); }
        | expr T_PLUS expr { $$ = new AST::BinOp($1,AST::plus,$3); }
	| expr T_TIMES expr { $$ = new AST::BinOp($1,AST::times,$3); }
        ;

varlist : T_VAR { $$ = symtab.newVariable($1, NULL); }
	| varlist T_COMMA T_VAR { $$ = symtab.newVariable($3, $1);}
	;

%%

