/* ********************************************************************* */

/* The code between the %{ ... %} brackets below will be placed at the top
 * of the C file that bison creates.  It is a place to put includes and declarations
 * that are best done at the top of the file.
 */


%{

#include<stdio.h>
#include<stdlib.h>


void yyerror(const char* s) {
  fprintf(stderr, "%s\n", s);
};

int yylex();  // forward declaration of yylex, provided by flex

void parseprint(char*);  // forward declaration of printing function

%}

/* Next is the list of tokens this expects from the lexical analyzer.  We also specify
 * for tokens that are binary operations whether they are left-associative or right-associaive.
 * a left-associative operation is one where if we see a - b - c we prefer the interpretation
 * (a - b) - c over a - (b - c).
 */

%token IF
%token ELSE
%token FOR
%token DO
%token WHILE
%token RET

%token INT_KWD
%token FLOAT_KWD
%token STRING_KWD
%token BOOL_KWD
%token VOID_KWD

%token IDENT

%token INT_LIT
%token FLOAT_LIT
%token STRING_LIT
%token BOOL_LIT

%token EQUALS
%left PLUS
%left MINUS
%left TIMES
%left DIVIDE
%token LPAREN
%token RPAREN

%left LESS
%left GREATER
%left LEQ
%left GEQ
%left EQUIV
%left NEQUIV

%left OR
%left AND
%token NOT

%token LBRACE
%token RBRACE
%token SCOL
%token COMMA


%%

/* After the %% divider we put the grammar rules, which are similar to the CFG grammar rules we
 * will work with in class.  There are a few extra features, that just simplify the specification
 * of the grammar. The LHS of the rule is on the left, followed by a colon.  Then the RHS is to the right.
 * additional rules follow, one per line, with a semi-colon marking the end of a set of rules for a given LHS
 */

program:         good-code                        { parseprint("full program"); }
;
good-code:       code
|                function
|                good-code good-code
;
function-call:   IDENT argument-list
;
argument-list:   LPAREN RPAREN                    { parseprint("empty arg list"); }
|                LPAREN arguments RPAREN          { parseprint("arg list"); }
;
arguments:       expression
|                expression COMMA arguments
;
function:        data-type IDENT parameter-list block   { parseprint("function definition"); }
;
parameter-list:  LPAREN RPAREN                    { parseprint("empty param list"); }
|                LPAREN parameters RPAREN         { parseprint("param list"); }
;
parameters:      parameter
|                parameter COMMA parameters
;
parameter:       data-type IDENT
;
flow-block:      do-block                         { parseprint("do block"); }
|                for-block                        { parseprint("for block"); }
|                while-block                      { parseprint("while block"); }
|                if-block                         { parseprint("if block"); }
|                if-block else-block                   { parseprint("if (else) block"); }
;
do-block:        DO block WHILE condition SCOL
|                DO statement WHILE condition SCOL
;
for-block:       FOR LPAREN for-condition RPAREN block
|                FOR LPAREN for-condition RPAREN statement
;
for-condition:   SCOL SCOL
|                SCOL expression SCOL
|                SCOL expression SCOL action
|                initial SCOL expression SCOL
|                initial SCOL expression SCOL action
;
initial:         assign
|                declaration
;
while-block:     WHILE condition block
|                WHILE condition statement
;
if-block:        IF condition block
|                IF condition statement
;
else-block:      ELSE block
|                ELSE statement
;
condition:       LPAREN expression RPAREN   { parseprint("condition"); }
;
block:           LBRACE RBRACE              { parseprint("empty block"); }
|                LBRACE code RBRACE         { parseprint("block"); }
;
code:            statements
|                block
|                flow-block
|                code code
;
statements:      statement
|                statement statements
;
statement:       action SCOL
|                SCOL                        { parseprint("empty statement"); }
;
action:          assign                      { parseprint("assign statement"); }
|                declaration                 { parseprint("declaration statement"); }
|                function-call               { parseprint("function call statement"); }
|                return                      { parseprint("return statement"); }
;
return:          RET
|                RET expression
;
assign:          IDENT EQUALS expression    { parseprint("assign -> id = exp"); }
;
declaration:     data-type IDENT            { parseprint("declare -> id"); }
|                data-type assign           { parseprint("declare -> id = exp"); }
;
expression:      expression operator expression
|                expression compare expression
|                expression logic expression
|                NOT expression
|                condition
|                IDENT
|                literal
;
operator:        PLUS
|                MINUS
|                TIMES
|                DIVIDE
;
compare:         LESS
|                GREATER
|                LEQ
|                GEQ
|                EQUIV
|                NEQUIV
;
logic:           OR
|                AND
;
literal:         INT_LIT
|                FLOAT_LIT
|                STRING_LIT
|                BOOL_LIT
;
data-type:       INT_KWD                   { parseprint("int type"); }
|                FLOAT_KWD                 { parseprint("float type"); }
|                STRING_KWD                { parseprint("string type"); }
|                BOOL_KWD                  { parseprint("bool type"); }
;


%%

/* After the next %% divider, we put the code at the end.  I included a printing function, just in case, but
 * the biggest item here is a main to do the parsing. Bison builds a function called yyparse, which parses
 * input, calling the yylex function provided by Flex to get the next token.  If yyparse returns zero, then
 * the parse worked correctly to the end of input.  Other values indicate different problems with the parse.
 */


void parseprint(char* str)
{
  printf("             PARSED: %s\n", str);
}


int main() {
  fprintf(stderr, "Enter statements/expressions to parse:\n");
  int res = yyparse();
  if (res == 0)
    fprintf(stderr, "Successful parsing.\n");
  else if (res == 1)
    fprintf(stderr, "Parsing failed due to incorrect input.\n");
  else if (res == 2)
    fprintf(stderr, "Parsing failed due to lack of memory.\n");
  else
    fprintf(stderr, "Weird value: %d\n", res);
}


