
/* ********************************************************************* */

/* The code between the brackets below will be included verbatim at the
 * top of the C file flex creates.  This includes any needed include
 * files and a few declarations...
 */

%{
#include<stdio.h>
#include<stdlib.h>

/* 
// Included to allow information about tokens from Bison file to propagate to here 
#include "example1.tab.h" // Leave commented out until Milestone Two
*/
 
void printer(char*);  // Forward declaration of printing function


%}


/* After the verbatim code, we may declare names that correspond to
 * common patterns that will show up in the rules.  A lot may be
 * done here, but I typically keep this simple, and let the rules
 * handle everything else 
 */

digit	[0-9]
alpha	[a-z,A-Z]
wspace [\t\n" "]


/* Below the %% are the "rules" for the lexical analyzer.  They are 
 * a sequence of regular expressions on the left, and a fragment
 * of C code on the right.  The code may do anything you like, but
 * any procedures you need for it should be declared at the bottom 
 * of the file.
 */
%%

({alpha}|_)({alpha}|{digit}|_)*	{ printer("Identifier"); }
-?{digit}+                      { printer("Integer"); }
-?{digit}+(f|(\.{digit}+f?))    { printer("Float"); } /* Also accepts number ending with 'f' */

 /* Operators */
"="                     { printer("Equals"); }
"+"                     { printer("Plus"); }
"-"                     { printer("Minus"); }
"*"                     { printer("Times"); }
"/"                     { printer("Divide"); }
"("                     { printer("LParen"); }
")"                     { printer("RParen"); }

 /* Control Flow Keywords */
"if"                   { printer("If Statement"); }
"else"                 { printer("Else Statement"); }
"for"                  { printer("For Loop"); }
"do"                   { printer("Do Loop"); }
"while"                { printer("While Clause/Loop"); }

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

