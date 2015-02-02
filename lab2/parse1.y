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
	| INT
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
	{
		$$ = counter_global++;
		myfile << "additive_expression" << $$ << " [label=additive_expression];" << std::endl;
		myfile << "additive_expression" << $$ << " -> {multiplicative_expression" << $1 << "};" << std::endl;
	}
	| additive_expression '+' multiplicative_expression
	{
		$$ = counter_global++;
		myfile << "additive_expression" << $$ << " [label=additive_expression];" << std::endl;
		myfile << "\"+" << $$ << "\" [label=\"+\"];" << std::endl;
		myfile << "additive_expression" << $$ << " -> {additive_expression" << $$ << " ; \"+" << $$ << "\" ; multiplicative_expression" << $3 << "};" << std::endl;
	}
	| additive_expression '-' multiplicative_expression
	{
		$$ = counter_global++;
		myfile << "additive_expression" << $$ << " [label=additive_expression];" << std::endl;
		myfile << "\"-" << $$ << "\" [label=\"-\"];" << std::endl;
		myfile << "additive_expression" << $$ << " -> {additive_expression" << $$ << " ; \"-" << $$ << "\" ; multiplicative_expression" << $3 << "};" << std::endl;
	}
	;

multiplicative_expression
	: unary_expression
	{
		$$ = counter_global++;
		myfile << "multiplicative_expression" << $$ << " [label=multiplicative_expression];" << std::endl;
		myfile << "multiplicative_expression" << $$ << " -> {unary_expression" << $1 << "};" << std::endl;
	}
	| multiplicative_expression '*' unary_expression
	{
		$$ = counter_global++;
		myfile << "multiplicative_expression" << $$ << " [label=multiplicative_expression];" << std::endl;
		myfile << "\"*" << $$ << "\" [label=\"*\"];" << std::endl;
		myfile << "multiplicative_expression" << $$ << " -> {multiplicative_expression" << $1 << " ; \"*" << $$ << "\" ; unary_expression"<< $3 << "};" << std::endl;
	}
	| multiplicative_expression '/' unary_expression
	{
		$$ = counter_global++;
		myfile << "multiplicative_expression" << $$ << " [label=multiplicative_expression];" << std::endl;
		myfile << "\"/" << $$ << "\" [label=\"/\"];" << std::endl;
		myfile << "multiplicative_expression" << $$ << " -> {multiplicative_expression" << $1 << " ; \"/" << $$ << "\" ; unary_expression"<< $3 << "};" << std::endl;
	}
	;
unary_expression
	: postfix_expression
	{
		$$ = counter_global++;
		myfile << "unary_expression" << $$ << " [label=unary_expression];" << std::endl;
		myfile << "unary_expression" << $$ << " -> {postfix_expression" << $1 << "};" << std::endl;
	}
	| unary_operator postfix_expression
	{
		$$ = counter_global++;
		myfile << "unary_expression" << $$ << " [label=unary_expression];" << std::endl;
		myfile << "unary_expression" << $$ << " -> {unary_operator" << $1 << " ; postfix_expression" << $2 << "};" << std::endl;
	}
	;

postfix_expression
	: primary_expression
	{
		$$ = counter_global++;
		myfile << "postfix_expression" << $$ << " [label=postfix];" << std::endl;
		myfile << "postfix_expression" << $$ << " -> {primary_expression" << $1 << "};" << std::endl;
	}
	| IDENTIFIER '(' ')'
	{
		$$ = counter_global++;
		myfile << "postfix_expression" << $$ << " [label=postfix];" << std::endl;
		myfile << "IDENTIFIER" << $$ << " [label=IDENTIFIER];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "postfix_expression" << $$ << " -> {IDENTIFIER" << $$ << " ; \"(" << $$ << "\" ; \")" << $$ << "\"};" << std::endl;
	}
	| IDENTIFIER '(' expression_list ')'
	{
		$$ = counter_global++;
		myfile << "postfix_expression" << $$ << " [label=postfix];" << std::endl;
		myfile << "IDENTIFIER" << $$ << " [label=IDENTIFIER];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "postfix_expression" << $$ << " -> {IDENTIFIER" << $$ << " ; \"(" << $$ << "\" ; expression_list" << $3 << " ; \")" << $$ << "\"};" << std::endl;
	}
	| l_expression INC_OP
	{
		$$ = counter_global++;
		myfile << "postfix_expression" << $$ << " [label=postfix_expression];" << std::endl;
		myfile << "INC_OP" << $$ << " [label=INC_OP];" << std::endl;
		myfile << "postfix_expression" << $$ << " -> {l_expression" << $1 << " ; INC_OP" << $$ << "};" << std::endl;
	}
	;

primary_expression
	: l_expression
	{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "primary_expression" << $$ << " -> {l_expression" << $1 << "};" << std::endl;
	}
	| INT_CONSTANT
	{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "INT_CONSTANT" << $$ << " [label=INT_CONSTANT];" << std::endl;
		myfile << "primary_expression" << $$ << " -> {INT_CONSTANT" << $$ << "};" << std::endl;	
	}
	| FLOAT_CONSTANT
	{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "FLOAT_CONSTANT" << $$ << " [label=FLOAT_CONSTANT];" << std::endl;
		myfile << "primary_expression" << $$ << " -> {FLOAT_CONSTANT" << $$ << "};" << std::endl;
	}
    | STRING_LITERAL
	{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "FLOAT_CONSTANT" << $$ << " [label=FLOAT_CONSTANT];" << std::endl;
		myfile << "primary_expression" << $$ << " -> {FLOAT_CONSTANT" << $$ << "};" << std::endl;	
	}
	| '(' expression ')'
	{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "primary_expression" << $$ << " -> {\"(" << $$ << "\" ; expression" << $2 << " ; \")" << $$ << "\"};" << std::endl;	
	}
	;

l_expression
    : IDENTIFIER
	{
		$$ = counter_global++;
		myfile << "l_expression" << $$ << " [label=l_expression];" << std::endl;
		myfile << "IDENTIFIER" << $$ << " [label=IDENTIFIER];" << std::endl;
		myfile << "l_expression" << $$ << " -> {IDENTIFIER" << $$ << "};" << std::endl;
	}
	| l_expression '[' expression ']'
	{
		$$ = counter_global++;
		myfile << "l_expression" << $$ << " [label=l_expression];" << std::endl;
		myfile << "l_expression" << $1 << " [label=l_expression];" << std::endl;
		myfile << "\"[" << $$ << "\" [label=\"[\"];" << std::endl;
		myfile << "expression" << $3 << " [label=expression];" << std::endl;
		myfile << "\"]" << $$ << "\" [label=\"]\"];" << std::endl;
		myfile << "l_expression" << $$ << " -> {l_expression" << $1 << " ; \"[" << $$ << "\" ; expression" << $3 << " ; \"]" << $$ << "\"};" << std::endl;
	}
	;

expression_list
   : expression
   {
	   $$ = counter_global++;
	   myfile << "expression_list" << $$ << " [label=expresssion_list];" << std::endl;
	   myfile << "expression_list" << $$ << " -> {expression" << $1 << "};" << std::endl;
   }
   | expression_list ',' expression
   {
	   $$ = counter_global++;
	   myfile << "expression_list" << $$ << " [label=expresssion_list];" << std::endl;
	   myfile << "\"," << $$ << "\" [label=\",\"];" << std::endl;
	   myfile << "expression_list" << $$ << " -> {expression_list" << $1 << " ; \"," << $$ << "\" ; expression" << $3 << "};" << std::endl;
   }
   ;

unary_operator
   : '-'
   {
	   $$ = counter_global++;
	   myfile << "unary_operator" << $$ << " [label=unary_operator];" << std::endl;
	   myfile << "\"-" << $$ << "\" [label=\"-\"];" << std::endl;
	   myfile << "unary_operator" << $$ << " -> {\"-" << $$ << "\"};" << std::endl;
   }
   | '!'
   {
	   $$ = counter_global++;
	   myfile << "unary_operator" << $$ << " [label=unary_operator];" << std::endl;
	   myfile << "\"!" << $$ << "\" [label=\"!\"];" << std::endl;
	   myfile << "unary_operator" << $$ << " -> {\"!" << $$ << "\"};" << std::endl;
   }
   ;

selection_statement
    : IF '(' expression ')' statement ELSE statement
	{
		$$ = counter_global++;
		myfile << "selection_statement" << $$ << " [label=selection_statement];" << std::endl;
		myfile << "IF" << $$ << " [label=IF];" << std::endl;
		myfile << "ELSE" << $$ << " [label=ELSE];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "selection_statement" << $$ << " -> {IF"<< $$ << " ; \"(" << $$ << "\" ; expression" << $3 <<" ; \")" << $$ << " ; statement" << $5 << " ; ELSE" << $$ << " ; statement};" << std::endl;
	}
	;

iteration_statement
	: WHILE '(' expression ')' statement
	{
		$$ = counter_global++;
		myfile << "WHILE" << $$ << " [label=WHILE];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "iteration_statement" << $$ << " [label=\"iteration_statement\"];" << std::endl;
		myfile << "iteration_statement" << $$ << " -> {WHILE" << $$ << " ; \"(" << $$ << "\" ; expression" << $3 << " ; \")" << $$ << "\"; statement" << $5 <<"};" << std::endl;
	}
	| FOR '(' assignment_statement ';' expression ';' assignment_statement ')' statement
	{
		$$ = counter_global++;
		myfile << "FOR" << $$ << " [label=FOR];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "\";" << $$ << "\" [label=\";\"];" << std::endl;
		myfile << "iteration_statement" << $$ << " [label=\"iteration_statement\"];" << std::endl;
		myfile <<
			"iteration_statement" << $$ <<
			" -> {FOR" << $$ <<
			" ; \"(" << $$ << "\"" <<
			" ; assignment_statement" << $3 <<
			" ; \"(" << $$ << "\"" <<
			" ; expression" << $5 <<
			" ; \"(" << $$ << "\"" <<
			" ; assignment_statement" << $7 <<
			" ; \"(" << $$ << "\"" <<
			" ; statement" << $9 <<
			"};" << std::endl;
		/* myfile << "iteration_statement" << $$ << " -> {FOR" << $$ << " ; \"(" << $$ << "\" ; assignment_statement" << $3 << " ; \";"<< $$ "\" ; expression" << $5 << " ; \";" << $$ << "\" ; assignment_statement" << $7 << " ; \")" << $$ << "\"; statement" << $9 <<"};" << std::endl; */
	}
	;

declaration_list
	: declaration
	{
		$$ = counter_global++;
		myfile << "declaration_list" << $$ << " [label=\"declaration_list\"];" << std::endl;
		myfile << "declaration_list" << $$ << " -> {declaration" << $1 << "};" << std::endl;
	}
	| declaration_list declaration
	{
		$$ = counter_global++;
		myfile << "declaration_list" << $$ << " [label=\"declaration_list\"];" << std::endl;
		myfile << "declaration_list" << $$ << " -> {declaration_list" << $1 << " ; declarator" << $2 << "};" << std::endl;
	}
	;

declaration
	: type_specifier declarator_list';'
	{
		$$ = counter_global++;
		myfile << "declaration" << $$ << " [label=\"declaration\"];" << std::endl;
		myfile << "declaration" << $$ << " -> {type_specifier" << $1 << " ; declarator_list" << $2 <<"};" << std::endl;
	}
	;

declarator_list
	: declarator
	{
		$$ = counter_global++;
		myfile << "declarator_list" << $$ << " [label=\"declarator_list\"];" << std::endl;
		myfile << "declarator_list" << $$ << " -> {declarator" << $1 << "};" << std::endl;
	}
	| declarator_list ',' declarator
	{
		$$ = counter_global++;
		myfile << "declarator_list" << $$ << " [label=\"declarator_list\"];" << std::endl;
		myfile << "declarator_list" << $$ << " -> {declarator_list" << $1 << " ; \"," << $$ << "\" ; declarator" << $1 << "};" << std::endl;
	}
	;
