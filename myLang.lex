
/* ********************************************************************* */

/* The code between the brackets below will be included verbatim at the
 * top of the C file flex creates.  This includes any needed include
 * files and a few declarations...
 */

%{
#include<stdio.h>
#include<stdlib.h>


/* Included to allow information about tokens from Bison file to propagate to here */
#include "myLang.tab.h" // Leave commented out until Milestone Two

 
void printer(char*);  // Forward declaration of printing function


%}


/* After the verbatim code, we may declare names that correspond to
 * common patterns that will show up in the rules.  A lot may be
 * done here, but I typically keep this simple, and let the rules
 * handle everything else 
 */

digit	[0-9]
alpha	[a-zA-Z]


/* Below the %% are the "rules" for the lexical analyzer.  They are 
 * a sequence of regular expressions on the left, and a fragment
 * of C code on the right.  The code may do anything you like, but
 * any procedures you need for it should be declared at the bottom 
 * of the file.
 */
%%

 /* Comments */
"//".*                          { printer("Line Comment"); }
"/*"([^*]|("*"[^/]))*"*/"       { printer("Multi-Line Comment"); }

 /* Control Flow Keywords */
"if"                   { printer("If Keyword"); return IF; }
"else"                 { printer("Else Keyword"); return ELSE; }
"for"                  { printer("For Keyword"); return FOR; }
"do"                   { printer("Do Keyword"); return DO; }
"while"                { printer("While Keyword"); return WHILE; }
"return"               { printer("Return Keyword"); return RET; }

 /* Data Type Keywords */
"int"                  { printer("Int Keyword"); return INT_KWD; }
"float"                { printer("Float Keyword"); return FLOAT_KWD; }
"string"               { printer("String Keyword"); return STRING_KWD; }
"bool"                 { printer("Bool Keyword"); return BOOL_KWD; }
"void"                 { printer("Void Keyword"); return VOID_KWD; }

 /* Data Type Literals (Except Strings) */
-?{digit}+                      { printer("Integer"); return INT_LIT; }
-?{digit}+(f|(\.{digit}+f?))    { printer("Float"); return FLOAT_LIT; } /* Also accepts number ending with 'f' */
\"[^"]*\"                       { printer("String"); return STRING_LIT; }
("true")|("false")                { printer("Bool"); return BOOL_LIT; }

 /* Identifiers */
({alpha}|_)({alpha}|{digit}|_)*	{ printer("Identifier"); return IDENT; }

 /* Operators */
"="                     { printer("Equals"); return EQUALS; }
"+"                     { printer("Plus"); return PLUS; }
"-"                     { printer("Minus"); return MINUS; }
"*"                     { printer("Times"); return TIMES; }
"/"                     { printer("Divide"); return DIVIDE; }
"("                     { printer("LParen"); return LPAREN; }
")"                     { printer("RParen"); return RPAREN; }

 /* Comparison Operators */
"<"                     { printer("Less Than"); return LESS; }
">"                     { printer("Greater Than"); return GREATER; }
"<="                    { printer("Less or Equal"); return LEQ; }
">="                    { printer("Greater or Equal"); return GEQ; }
"=="                    { printer("Equivalent"); return EQUIV; }
"!="                    { printer("Not Equivalent"); return NEQUIV; }

 /* Boolean Logic */
"||"                    { printer("Or"); return OR; }
"&&"                    { printer("And"); return AND; }
"!"                     { printer("Not"); return NOT; }

 /* Program Structure */
","                     { printer("Comma"); return COMMA; }
"{"                     { printer("LBrace"); return LBRACE; }
"}"                     { printer("RBrace"); return RBRACE; }
";"                     { printer("Semicolon"); return SCOL; }

[ \t\n]+		;  /*when see whitespace, do nothing*/


%%

/* this section contains any procedures you might want to declare, anything
 * that the C fragments above might need.  Like the section at the top,
 * the code you put here will be included, verbatim.
 */

void printer(char* str)
{
  printf("      Recognized %s: %s\n", str, yytext);
}

