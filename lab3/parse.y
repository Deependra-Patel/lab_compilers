%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL

/* %polymorphic INT: int; TEXT: std::string; IF: If*; */
/* %type <TEXT> unary_operator */
/* %type <IF> selection_statement */
%polymorphic expAst : ExpAst* ; stmtAst : StmtAst*; Int : int; Float : float; String : string;

%type <expAst> expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression postfix_expression primary_expression l_expression constant_expression expression_list unary_operator
%type <stmtAst> selection_statement iteration_statement assignment_statement translation_unit function_definition compound_statement statement statement_list
%type <Int> INT_CONSTANT
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL IDENTIFIER
%%


translation_unit
	: function_definition 
	| translation_unit function_definition 
        ;

function_definition
	: type_specifier fun_declarator compound_statement 
	;

type_specifier
	: VOID 	
    | INT  {std::cout<<"hello";} 
	| FLOAT 
    ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' 
    | IDENTIFIER '(' ')' 
	;

parameter_list
	: parameter_declaration 
	| parameter_list ',' parameter_declaration 
	;

parameter_declaration
	: type_specifier declarator 
    ;

declarator
	: IDENTIFIER 
	| declarator '[' constant_expression ']' 
        ;

constant_expression 
    : INT_CONSTANT {std::cout<<"hi hi";}
	| FLOAT_CONSTANT 
	;

compound_statement
	: '{' '}' 
	| '{' statement_list '}' 
    | '{' declaration_list statement_list '}' 
	;

statement_list
	: statement		
    | statement_list statement	
	;

statement
    : '{' statement_list '}'  //a solution to the local decl problem
	| selection_statement	
	| iteration_statement	
	| assignment_statement	
    | RETURN expression ';'	
	;

assignment_statement
	: ';' 								
	|  l_expression '=' expression ';'	
	;

expression
	: logical_and_expression 
	| expression OR_OP logical_and_expression
	;

logical_and_expression
    : equality_expression
	| logical_and_expression AND_OP equality_expression 
	;

equality_expression
	: relational_expression 
        | equality_expression EQ_OP relational_expression 	
	| equality_expression NE_OP relational_expression
	;
relational_expression
	: additive_expression
        | relational_expression '<' additive_expression 
	| relational_expression '>' additive_expression 
	| relational_expression LE_OP additive_expression 
        | relational_expression GE_OP additive_expression 
	;

additive_expression 
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression 
	| additive_expression '-' multiplicative_expression 
	;

multiplicative_expression
	: unary_expression
	| multiplicative_expression '*' unary_expression 
	| multiplicative_expression '/' unary_expression 
	;
unary_expression
	: postfix_expression  				
	| unary_operator postfix_expression{
	  std::cout<<"unary";	  
	  std::cout<<$1;

 } 
	;

postfix_expression
	: primary_expression
    | IDENTIFIER '(' ')'
	| IDENTIFIER '(' expression_list ')' 
	| l_expression INC_OP
	;

primary_expression
	: l_expression
        | l_expression '=' expression // added this production
	| INT_CONSTANT
	| FLOAT_CONSTANT
        | STRING_LITERAL
	| '(' expression ')' 	
	;

l_expression
    : IDENTIFIER
	| l_expression '[' expression ']'	
	;
expression_list
    : expression
	| expression_list ',' expression
	;
unary_operator
: '-'{
 }
| '!' {
  /* $$ = "!"; */
  } 	
	;

selection_statement
: IF '(' expression ')' statement ELSE statement{
  $<stmtAst>$ = new If();
 } 
	;

iteration_statement
: WHILE '(' expression ')' statement {
  // $$ = new While($3, $5);
 }	
    | FOR '(' expression ';' expression ';' expression ')' statement  //modified this production
{
	  //	$$ = new For($3, $5, $7, $9);
	}
        ;

declaration_list
    : declaration					
	| declaration_list declaration
	;

declaration
: type_specifier declarator_list';'
	;

declarator_list
	: declarator
	| declarator_list ',' declarator 
	;
