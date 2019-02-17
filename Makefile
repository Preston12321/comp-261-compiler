all: lex

lex:
	flex myLang.lex
	gcc -o build/lexer lex.yy.c -ll
