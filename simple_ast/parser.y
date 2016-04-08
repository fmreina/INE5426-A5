%{
#include "ast.h"
AST::Block *programRoot; /* the root node of our program AST:: */
extern int yylex();
extern void yyerror(const char* s, ...);
%}

/* yylval == %union
 * union informs the different ways we can store data
 */
%union {
    int integer;
	char string[1000+1];
    AST::Node *node;
    AST::Block *block;
}

/* token defines our terminal symbols (tokens).
 */
%token <integer> T_INT
%token <string> T_VAR
%token T_PLUS T_NL T_TIMES


/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line
%type <block> lines program
//%type <string> str // use %type in case of making a new head of the grammar

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
        

lines   : line { $$ = new AST::Block(); $$->lines.push_back($1); }
        | lines line { if($2 != NULL) $1->lines.push_back($2); }
        ;

line    : T_NL { $$ = NULL; } /*nothing here to be used */
        | expr T_NL /*$$ = $1 when nothing is said*/
        ;

expr    : T_INT { $$ = new AST::Integer($1); }
        | expr T_PLUS expr { $$ = new AST::BinOp($1,AST::plus,$3); }
	| expr T_TIMES expr { $$ = new AST::BinOp($1,AST::times,$3); }
	| expr T_VAR expr { $$ = new AST::BinOp($1,AST::times,$3); }
        | expr error { yyerrok; $$ = $1; } /*just a point for error recovery*/
        ;

%%


