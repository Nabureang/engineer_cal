%option noyywrap nodefault yylineno
%{
#include "engin_cal.h"
#include "engin_cal.tab.h"
%}

EXP([Ee][-+]?[0-9]+)

%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" 	{ return yytext[0]; }
[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }
\n	{ return EOL; }
"//".*	{}
[ \t]	{}
"\^" { return '^'; }
"sin" { return 's'; }
"asin" { return 'S'; } 
"cos"  { return 'c'; }
"acos" { return 'C'; }
"tan" { return 't'; }
"atan" { return 'T'; }
"log" { return 'l'; }
"ln"  { return 'L'; }
.	{ yyerror("Mystery character %c\n", *yytext); }
%%


