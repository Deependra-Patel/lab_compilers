%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL



%%

translation_unit
	: function_definition {
		$$ = counter_global++;
		myfile << "translation_unit"<<$$<<"->"<<"function_definition"<<$1<<";\n";		
	}
	| translation_unit function_definition{
		$$ = counter_global++;
		myfile << "translation_unit"<<$$<<"->"<<"{translation_unit"<<$1<<"; function_definition"<<$2<<"};\n";				
	}
	;

function_definition
	: type_specifier fun_declarator compound_statement {
		$$ = counter_global++;
		myfile << "function_definition"<<$$<<"->"<<"{type_specifier"<<$1<<"; fun_declarator"<<$2<<"; compound_statement"<<$3<<"};\n";	
	}
	;

type_specifier
	: VOID {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->VOID"<<$$<<";\n";
	}
	| INT {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->INT"<<$$<<";\n";
	}
	| FLOAT {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->FLOAT"<<$$<<";\n";
	}
	;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' {
		$$ = counter_global++;
		myfile << "fun_declarator"<<$$<<"->{IDENTIFIER"<<$$<<"\"("<<$$<<"\"; parameter_list"<<$3<<"; \")"<<$$<<"\"};\n";
		myfile << "\"("<<$$<<"\"[label=\"(\"];\n";
		myfile << "\")"<<$$<<"\"[label=\")\"];\n";		
	}
	| IDENTIFIER '(' ')'{
		$$ = counter_global++;
		myfile << "fun_declarator"<<$$<<"->{IDENTIFIER"<<$$<<"\"("<<$$<<"\"; \")"<<$$<<"\"};\n";
		myfile << "\"("<<$$<<"\"[label=\"(\"];\n";
		myfile << "\")"<<$$<<"\"[label=\")\"];\n";		
	}
	;

parameter_list
	: parameter_declaration{
		$$ = counter_global++;
		myfile << "parameter_list"<<$$<<"->parameter_declaration"<<$1<<";\n";		
	}
	| parameter_list ',' parameter_declaration{
		$$ = counter_global++;
		myfile << "parameter_list"<<$$<<"->{parameter_list"<<$1<<"; ,"<<$$<<";parameter_declaration"<<$1<<"};\n";			
	}
	;
parameter_declaration
	: type_specifier declarator{
		$$ = counter_global++;
		myfile << "parameter_declaration"<<$$<<"->"<<"{type_specifier"<<$1<<"; declarator"<<$2<<"};\n";		
	}
	;

declarator
	: IDENTIFIER{
		$$ = counter_global++;
		myfile << "declarator"<<$$<<"->"<<"IDENTIFIER"<<$$<<";\n";
	}
	| declarator '[' constant_expression ']'{
		$$ = counter_global++;
		myfile << "declarator"<<$$<<"->"<<"{declarator"<<$1<<"; \"["<<$$<<"\"; constant_expression"<<$3<<";  \"]"<<$$<<"};\n";
	}
	;

constant_expression
	: INT_CONSTANT{
		$$ = counter_global++;
		myfile << "constant_expression"<<$$<<"->"<<"INT_CONSTANT"<<$$<<";\n";
	}
	| FLOAT_CONSTANT{
		$$ = counter_global++;
		myfile << "constant_expression"<<$$<<"->"<<"FLOAT_CONSTANT"<<$$<<";\n";	
	}
	;

compound_statement
	: '{' '}' {
		$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"}\"];\n";
	}
	| '{' statement_list '}' {
		$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; statement_list"<<$2<<"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"{\"];\n";
	 }
    | '{' declaration_list statement_list '}'{
    	$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; declaration_list"<<$2<<", statement_list"<<$3<<"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"}\"];\n";
    }
	;

statement_list
	: statement 
	{
		$$ = counter_global++;
		myfile << "statement_list"<<$$<<"->{statement"<<$1<<"}\n";
	}
	| statement_list statement
	{
		$$ = counter_global++;
		myfile << "{statement_list"<<$$<<"->statement_list"<<$1<<"; "<<"statement"<<$2<<"};\n";
	}	
	;

statement
   : compound_statement
	{
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> compound_statement"<<$1<<";\n";   		
   }
   | selection_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> selection_statement"<<$1<<";\n";   		
   }
   | iteration_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> iteration_statement"<<$1<<";\n";   		   
   }
   | assignment_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> assignment_statement"<<$1<<";\n";   		
	}
   | RETURN expression ';'
   {
   		$$ = counter_global++;
		myfile << "statement"<<$$<<" ->{RETURN"<<$$<<"; expression"<<$2<<"';'"<<$$<<"};\n";   
   }
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
    |  l_expression '=' expression       
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
		myfile << "declarator_list" << $$ << " -> {declarator_list" << $1 << " ; \"," << $2 << "\" ; declarator" << $1 << "};" << std::endl;
	}
	;

