all: bison

lex:
	flex myLang.lex
	mkdir -p build
	gcc -o build/lexer lex.yy.c -ll

bison:
	bison -d myLang.y
	flex -o myLang.lex.c myLang.lex
	bison -d myLang.y
	gcc -o build/myLang myLang.lex.c myLang.tab.c -ll -lm
