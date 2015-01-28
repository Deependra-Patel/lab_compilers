%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL



%%


translation_unit
	: function_definition
	| translation_unit function_definition
	;

function_definition
	: type_specifier fun_declarator compound_statement {std::cout<<"dldldl"<<$1<<counter_global;}
	;

type_specifier
	: VOID 
	| INT {$$ = counter_global; counter_global++; }
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
	: INT_CONSTANT
	| FLOAT_CONSTANT
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}' {
		$$ = counter_global++;
	 	std::cout<<"compound_statement"<<$$<<"->{{;statement_list"<<$2<<";}}\n";
	 	
	 }
    | '{' declaration_list statement_list '}'
	;

statement_list
	: statement 
	{
		$$ = 4;
		std::cout<<"statement_list->statement\n";
	}
	| statement_list statement
	{
		std::cout<<"statement_list->statement_list\n statement_list->statement\n";
	}	
	;

statement
   : compound_statement
   {
		std::cout<<"statement_list->statement_list\n statement_list->statement\n";   		

   }
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
	| unary_operator postfix_expression
	;

postfix_expression
	: primary_expression
	| IDENTIFIER '(' ')'
	| IDENTIFIER '(' expression_list ')'
	| l_expression INC_OP
	;

primary_expression
	: l_expression
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
   : '-'
   | '!'
   ;

selection_statement
    : IF '(' expression ')' statement ELSE statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| FOR '(' assignment_statement expression ';' assignment_statement ')' statement
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
