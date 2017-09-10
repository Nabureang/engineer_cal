#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include "engin_cal.h"

struct ast *newast(int nodetype, struct ast *l, struct ast *r)
{
	struct ast *a = malloc(sizeof(struct ast));

	if(!a)
	{
		yyerror("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->l = l;
	a->r = r;
	return a;
}

struct ast *newnum(double d)
{
	struct numval *a = malloc(sizeof(struct numval));

	if(!a)
	{
		yyerror("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (struct ast *)a;
}

double eval(struct ast *a)
{
	double v;
	double v1;
	switch(a->nodetype)
	{
		case 'K' : v = ((struct numval *)a)->number; break;
		
		case '+' : v = eval(a->l) + eval(a->r); break;
		case '-' : v = eval(a->l) - eval(a->r); break;
		case '*' : v = eval(a->l) * eval(a->r); break;
		case '/' : v = eval(a->l) / eval(a->r); break;
		case '^' : v = pow(eval(a->l), eval(a->r)); break;
		case '|' : v = eval(a->l); if(v < 0) v = -v; break;
		case 'M' : v = -eval(a->l);  break;
		case 's' : v = sin(eval(a->l)); break;
		case 'S' : v = asin(eval(a->l)); break; //asin
		case 'c' : v = cos(eval(a->l)); break;
		case 'C' : v = acos(eval(a->l)); break; //acos
		case 't' : v = tan(eval(a->l)); break;
		case 'T' : v = atan(eval(a->l)); break; //atan
		case 'l' : v = log10(eval(a->l)); break; //log
		case 'L' : v = log(eval(a->l)); break; //ln
		default : printf("internal error : bad ndoe %c\n", a->nodetype);
	}
	return v;
}

void treefree(struct ast *a)
{
	switch(a->nodetype)
	{
		case '+' :
		case '-' :
		case '*' :
		case '/' :
		case '^' :
			treefree(a->r);
		case '|' :  //숫자 하나 free
		case 'M' :
		case 's' :
		case 'S' : 
		case 'c' : 
		case 'C' : 
		case 't' : 
		case 'T' : 
		case 'l' :
		case 'L' :
			treefree(a->l);
		case 'K' :
			free(a);
			break;
		default : printf("internal error : free bad node %c\n", a->nodetype);
	}
}

void yyerror(char *s, ...)
{
	va_list ap;
	va_start(ap, s);

	fprintf(stderr, "%d: error: ", yylineno);
	vfprintf(stderr, s, ap);
	fprintf(stderr, "\n");
}

int main()
{
	sin(5);
	printf("> ");
	return yyparse();
}
		
		
