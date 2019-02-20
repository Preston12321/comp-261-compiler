all: lex

lex:
	flex myLang.lex
	mkdir -p build
	gcc -o build/lexer lex.yy.c -ll
