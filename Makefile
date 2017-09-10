engin_cal : engin_cal.l engin_cal.y engin_cal.h
	bison -d engin_cal.y
	flex -o engin_cal.lex.c engin_cal.l
	gcc -o engin_cal engin_cal.tab.c engin_cal.lex.c engin_cal.c -lm

clean : 
	rm engin_cal.tab.* engin_cal.lex.c engin_cal
