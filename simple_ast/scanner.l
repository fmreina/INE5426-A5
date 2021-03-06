%{
#include <string>
#include "ast.h"
#include "parser.h"
extern int yylineno;
void yyerror(const char* s, ...);
%}

%option noyywrap nodefault yylineno

digs [0-9]+
str [a-z]+

%%

[ \t]           ; //ignores spaces
{digs}          {yylval.integer = std::atoi(yytext); return T_INT;}
"+"             {return T_PLUS;}
"*"		{return T_TIMES;}
"="		{return T_ASSIGN;}
","		{return T_COMMA; }
"def"		{return T_DEF;}
{str}		{yylval.string = strdup(yytext); return T_VAR;}
\n              {return T_NL;}
.               {yyerror("Unknown token! %c\n", *yytext);} /*complains about every unknown character*/

%%

void yyerror(const char *s, ...){
    va_list ap;
    va_start(ap, s);
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::vfprintf(stderr, s, ap);
}
