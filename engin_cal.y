%{
#include <stdio.h>
#include <stdlib.h>
#include "engin_cal.h"
%}

%union
{
	struct ast *a;
	double d;
}


%token <d> NUMBER
%token EOL

%type <a> exp factor term func

%%
calclist :
	| calclist exp EOL {
		printf("= %4.4g\n", eval($2));
		treefree($2);
		printf("> ");
	}
	| calclist EOL { printf("> "); }
	;

exp : factor
	| exp '+' factor { $$ = newast('+', $1, $3); }
	| exp '-' factor { $$ = newast('-', $1, $3); }
	;

factor : func
	| factor '*' func { $$ = newast('*', $1, $3); }
	| factor '/' func { $$ = newast('/', $1, $3); }
	;

func : term
	| 's' '(' exp ')' { $$ = newast('s', $3, NULL);  }
	| 'S' '(' exp ')' { $$ = newast('S', $3, NULL);  } //asin
	| 'c' '(' exp ')' { $$ = newast('c', $3, NULL);  }
	| 'C' '(' exp ')' { $$ = newast('C', $3, NULL);  } //acos
	| 't' '(' exp ')' { $$ = newast('t', $3, NULL);  }
	| 'T' '(' exp ')' { $$ = newast('T', $3, NULL);  } //atan
	| 'l' '(' exp ')' { $$ = newast('l', $3, NULL);  } //log
	| 'L' '(' exp ')' { $$ = newast('L', $3, NULL);  } //ln
	;
term : NUMBER { $$ = newnum($1); }
	| '|' term { $$ = newast('|', $2, NULL); }
	| '(' exp ')' { $$ = $2; }
	| exp '^' exp { $$ = newast('^', $1, $3); } // a^b
	| '-' term { $$ = newast('M', $2, NULL); }
	;
%%




