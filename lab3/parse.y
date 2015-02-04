%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL



%%

translation_unit
	: function_definition {
		$$ = counter_global++;
		myfile << "translation_unit"<<$$<<"->"<<"function_definition"<<$1<<";\n";	
		myfile << "translation_unit"<<$$<<"[label = translation_unit];\n";			
	}
	| translation_unit function_definition{
		$$ = counter_global++;
		myfile << "translation_unit"<<$$<<"->"<<"{translation_unit"<<$1<<"; function_definition"<<$2<<"};\n";
		myfile << "translation_unit"<<$$<<"[label = translation_unit];\n";			
	}
	;

function_definition
	: type_specifier fun_declarator compound_statement {
		$$ = counter_global++;
		myfile << "function_definition"<<$$<<"->"<<"{type_specifier"<<$1<<"; fun_declarator"<<$2<<"; compound_statement"<<$3<<"};\n";	
		myfile << "function_definition"<<$$<<"[label = function_definition];\n";
	}
	;

type_specifier
	: VOID {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->VOID"<<$$<<";\n";
		myfile << "VOID"<<$$<<"[label = VOID];\n";						
		myfile << "type_specifier"<<$$<<"[label = typespecifier];\n";
	}
	| INT {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->INT"<<$$<<";\n";
		myfile << "INT"<<$$<<"[label = INT];\n";						
		myfile << "type_specifier"<<$$<<"[label = typespecifier];\n";		
	}
	| FLOAT {$$ = counter_global++;
		myfile << "type_specifier"<<$$<<"->FLOAT"<<$$<<";\n";
		myfile << "FLOAT"<<$$<<"[label = FLOAT];\n";				
		myfile << "type_specifier"<<$$<<"[label = typespecifier];\n";		
	}
	;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' {
		$$ = counter_global++;
		myfile << "fun_declarator"<<$$<<"->{IDENTIFIER"<<$$<<"; \"("<<$$<<"\"; parameter_list"<<$3<<"; \")"<<$$<<"\"};\n";
		myfile << "\"("<<$$<<"\"[label=\"(\"];\n";
		myfile << "\")"<<$$<<"\"[label=\")\"];\n";	
		myfile << "IDENTIFIER"<<$$<<"[label = IDENTIFIER];\n";							
		myfile << "fun_declarator"<<$$<<"[label = fun_declarator];\n";							
	}
	| IDENTIFIER '(' ')'{
		$$ = counter_global++;
		myfile << "fun_declarator"<<$$<<"->{IDENTIFIER"<<$$<<";\"("<<$$<<"\"; \")"<<$$<<"\"};\n";
		myfile << "fun_declarator"<<$$<<"[label = fun_declarator];\n";
		myfile << "IDENTIFIER"<<$$<<"[label = IDENTIFIER];\n";							
		myfile << "\"("<<$$<<"\"[label=\"(\"];\n";
		myfile << "\")"<<$$<<"\"[label=\")\"];\n";		
	}
	;

parameter_list
	: parameter_declaration{
		$$ = counter_global++;
		myfile << "parameter_list"<<$$<<"->parameter_declaration"<<$1<<";\n";
		myfile << "parameter_list"<<$$<<"[label = parameter_list];\n";					
	}
	| parameter_list ',' parameter_declaration{
		$$ = counter_global++;
		myfile << "parameter_list"<<$$<<"->{parameter_list"<<$1<<"; ,"<<$$<<";parameter_declaration"<<$1<<"};\n";
		myfile << ","<<$$<<"[label = ,];\n";									
		myfile << "parameter_list"<<$$<<"[label = parameter_list];\n";							
	}
	;
parameter_declaration
	: type_specifier declarator{
		$$ = counter_global++;
		myfile << "parameter_declaration"<<$$<<"->"<<"{type_specifier"<<$1<<"; declarator"<<$2<<"};\n";		
		myfile << "parameter_declaration"<<$$<<"[label = parameter_declaration];\n";			
	}
	;

declarator
	: IDENTIFIER{
		$$ = counter_global++;
		myfile << "declarator"<<$$<<"->"<<"IDENTIFIER"<<$$<<";\n";
		myfile << "declarator"<<$$<<"[label = declarator];\n";				
	}
	| declarator '[' constant_expression ']'{
		$$ = counter_global++;
		myfile << "declarator"<<$$<<"->"<<"{declarator"<<$1<<"; \"["<<$$<<"\"; constant_expression"<<$3<<";  \"]"<<$$<<"};\n";
		myfile << "\"[\""<<$$<<"[label = \"[\"];\n";
		myfile << "\"]\""<<$$<<"[label = \"]\"];\n";							
		myfile << "declarator"<<$$<<"[label = declarator];\n";						
	}
	;

constant_expression
	: INT_CONSTANT{
		$$ = counter_global++;
		myfile << "constant_expression"<<$$<<"->"<<"INT_CONSTANT"<<$$<<";\n";
		myfile << "constant_expression"<<$$<<"[label = constant_expression];\n";
		myfile << "INT_CONSTANT"<<$$<<"[label = INT_CONSTANT];\n";				

	}
	| FLOAT_CONSTANT{
		$$ = counter_global++;
		myfile << "constant_expression"<<$$<<"->"<<"FLOAT_CONSTANT"<<$$<<";\n";	
		myfile << "constant_expression"<<$$<<"[label = constant_expression];\n";
		myfile << "FLOAT_CONSTANT"<<$$<<"[label = FLOAT_CONSTANT];\n";	
	}
	;

compound_statement
	: '{' '}' {
		$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"}\"];\n";
		myfile << "compound_statement"<<$$<<"[label = compound_statement];\n";					
	}
	| '{' statement_list '}' {
		$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; statement_list"<<$2<<"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"}\"];\n";
		myfile << "compound_statement"<<$$<<"[label = compound_statement];\n";					
	 }
    | '{' declaration_list statement_list '}'{
    	$$ = counter_global++;
		myfile << "compound_statement"<<$$<<"->{\"{"<<$$<<"\"; declaration_list"<<$2<<", statement_list"<<$3<<"; \"}"<<$$<<"\"};\n";
		myfile << "\"{"<<$$<<"\"[label=\"{\"];\n";
		myfile << "\"}"<<$$<<"\"[label=\"}\"];\n";
		myfile << "compound_statement"<<$$<<"[label = compound_statement];\n";					
    }
	;

statement_list
	: statement 
	{
		$$ = counter_global++;
		myfile << "statement_list"<<$$<<"->{statement"<<$1<<"};\n";
		myfile << "statement_list"<<$$<<"[label = statement_list];\n";					
	}
	| statement_list statement
	{
		$$ = counter_global++;
		myfile << "statement_list"<<$$<<"->{statement_list"<<$1<<"; "<<"statement"<<$2<<"};\n";
		myfile << "statement_list"<<$$<<"[label = statement_list];\n";					
	}	
	;

statement
   : compound_statement
	{
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> compound_statement"<<$1<<";\n";   
		myfile << "statement"<<$$<<"[label = statement];\n";							
   }
   | selection_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> selection_statement"<<$1<<";\n"; 
		myfile << "statement"<<$$<<"[label = statement];\n";					
   }
   | iteration_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> iteration_statement"<<$1<<";\n";   
		myfile << "statement"<<$$<<"[label = statement];\n";						
   }
   | assignment_statement
   {
		$$ = counter_global++;
		myfile << "statement"<<$$<<" -> assignment_statement"<<$1<<";\n";  
		myfile << "statement"<<$$<<"[label = statement];\n";								 		
	}
   | RETURN expression ';'
   {
   		$$ = counter_global++;
		myfile << "statement"<<$$<<" ->{RETURN"<<$$<<"; expression"<<$2<<"; \";"<<$$<<"\"};\n";  
		myfile << "statement"<<$$<<"[label = statement];\n";	
		myfile << "\";"<<$$<<"\"[label = \";\"];\n";
		myfile << "RETURN"<<$$<<"[label = RETURN];\n";					
   }
   ;


assignment_statement
	: ';'{
		$$ = counter_global ++;
		myfile << "assignment_statement"<<$$<<" -> "<<"\";"<<$$<<"\";\n";
		myfile << "\";"<<$$<<"\"[label = \";\"];\n";
		myfile << "assignment_statement"<<$$<<"[label = assignment_statement];\n";
	}
	|  l_expression '=' expression ';'{
		$$ = counter_global ++;
		myfile << "assignment_statement"<<$$<<" -> "<<"{l_expression"<<$1<<";\"="<<$$<<"\"; expression"<<$3<<";\";"<<$$<<"\"};\n";
		myfile << "\";"<<$$<<"\"[label = \";\"];\n";	
		myfile << "\"="<<$$<<"\"[label = \"=\"];\n";
		myfile << "assignment_statement"<<$$<<"[label = assignment_statement];\n";	
	}				
	;

expression
	: logical_and_expression{
		$$ = counter_global ++;
		myfile << "expression"<<$$<<" -> logical_and_expression"<<$1<<";\n";
		myfile << "expression"<<$$<<"[label = expression];\n";
	}
	| expression OR_OP logical_and_expression{
		$$ = counter_global ++;
		myfile << "expression"<<$$<<" -> {expression"<<$1<<"; OR_OP"<<$$<<";logical_and_expression"<<$3<<"};\n";
		myfile << "expression"<<$$<<"[label = expression];\n";	
		myfile << "OR_OP"<<$$<<"[label = OR_OP];\n";			
	}
	;

logical_and_expression
	: equality_expression{
		$$ = counter_global ++;
		myfile << "logical_and_expression"<<$$<<" -> equality_expression"<<$1<<";\n";
		myfile << "logical_and_expression"<<$$<<"[label = logical_and_expression];\n";		
	}
	| logical_and_expression AND_OP equality_expression{
		$$ = counter_global ++;
		myfile << "logical_and_expression"<<$$<<" -> {logical_and_expression"<<$1<<"; AND_OP"<<$$<<";equality_expression"<<$3<<"};\n";
		myfile << "logical_and_expression"<<$$<<"[label = logical_and_expression];\n";	
		myfile << "AND_OP"<<$$<<"[label = AND_OP];\n";					
	}
	;

equality_expression
	: relational_expression{
		$$ = counter_global ++;
		myfile << "equality_expression"<<$$<<" -> relational_expression"<<$1<<";\n";
		myfile << "equality_expression"<<$$<<"[label = equality_expression];\n";				
	}
	| equality_expression EQ_OP relational_expression{
		$$ = counter_global ++;
		myfile << "equality_expression"<<$$<<" -> {equality_expression"<<$1<<"; EQ_OP"<<$$<<";relational_expression"<<$3<<"};\n";
		myfile << "equality_expression"<<$$<<"[label = equality_expression];\n";	
		myfile << "EQ_OP"<<$$<<"[label = EQ_OP];\n";					
	}
	| equality_expression NE_OP relational_expression{
		$$ = counter_global ++;
		myfile << "equality_expression"<<$$<<" -> {equality_expression"<<$1<<"; NE_OP"<<$$<<";relational_expression"<<$3<<"};\n";
		myfile << "equality_expression"<<$$<<"[label = equality_expression];\n";	
		myfile << "NE_OP"<<$$<<"[label = NE_OP];\n";							
	}
	;
relational_expression
	: additive_expression{
		$$ = counter_global ++;
		myfile << "relational_expression"<<$$<<" -> additive_expression"<<$1<<";\n";
		myfile << "relational_expression"<<$$<<"[label = relational_expression];\n";						
	}
	| relational_expression '<' additive_expression{
		$$ = counter_global ++;
		myfile << "relational_expression"<<$$<<"->{relational_expression"<<$1<<";\"<"<<$$<<"\";additive_expression"<<$3<<"};\n";
		myfile << "relational_expression"<<$$<<"[label = relational_expression];\n";	
		myfile << "\"<"<<$$<<"\"[label = \"<\"];\n";										
	}
	| relational_expression '>' additive_expression{
		$$ = counter_global ++;
		myfile << "relational_expression"<<$$<<" -> {relational_expression"<<$1<<";\">"<<$$<<"\";additive_expression"<<$3<<"};\n";
		myfile << "relational_expression"<<$$<<"[label = relational_expression];\n";	
		myfile << "\">"<<$$<<"\"[label = \">\"];\n";		
	}
	| relational_expression LE_OP additive_expression{
		$$ = counter_global ++;
		myfile << "relational_expression"<<$$<<" -> {relational_expression"<<$1<<";LE_OP"<<$$<<";additive_expression"<<$3<<"};\n";
		myfile << "relational_expression"<<$$<<"[label = relational_expression];\n";	
		myfile << "LE_OP"<<$$<<"[label = LE_OP];\n";		
	}
	| relational_expression GE_OP additive_expression{
		$$ = counter_global ++;
		myfile << "relational_expression"<<$$<<" -> {relational_expression"<<$1<<";GE_OP"<<$$<<";additive_expression"<<$3<<"};\n";
		myfile << "relational_expression"<<$$<<"[label = relational_expression];\n";	
		myfile << "GE_OP"<<$$<<"[label = <];\n";		
	}
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
		myfile << "additive_expression" << $$ << " -> {additive_expression" << $1 << " ; \"+" << $$ << "\" ; multiplicative_expression" << $3 << "};" << std::endl;
	}
	| additive_expression '-' multiplicative_expression
	{
		$$ = counter_global++;
		myfile << "additive_expression" << $$ << " [label=additive_expression];" << std::endl;
		myfile << "\"-" << $$ << "\" [label=\"-\"];" << std::endl;
		myfile << "additive_expression" << $$ << " -> {additive_expression" << $1 << " ; \"-" << $$ << "\" ; multiplicative_expression" << $3 << "};" << std::endl;
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
	| l_expression '=' expression{
		$$ = counter_global++;
		myfile << "primary_expression" << $$ << " [label=primary_expression];" << std::endl;
		myfile << "\"=" << $$ << "\"[label=\"=\"];" << std::endl;		
		myfile << "primary_expression" << $$ << " -> {l_expression" << $1 << "; \"="<<$$<<"\"; expression"<<$3<<"};" << std::endl;	
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
		myfile << "selection_statement" << $$ << " -> {IF"<< $$ << " ; \"(" << $$ << "\" ; expression" << $3 <<" ; \")" << $$ << "\"; statement" << $5 << " ; ELSE" << $$ << " ; statement"<<$7<<"};" << std::endl;
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
	| FOR '(' expression ';' expression ';' expression ')' statement
	{
		$$ = counter_global++;
		myfile << "FOR" << $$ << " [label=FOR];" << std::endl;
		myfile << "\"(" << $$ << "\" [label=\"(\"];" << std::endl;
		myfile << "\")" << $$ << "\" [label=\")\"];" << std::endl;
		myfile << "\";1" << $$ << "\" [label=\";\"];" << std::endl;
		myfile << "\";2" << $$ << "\" [label=\";\"];" << std::endl;		
		myfile << "expression" << $3 << " [label=expression];" << std::endl;
		myfile << "expression" << $5 << " [label=expression];" << std::endl;
		myfile << "expression" << $7 << " [label=expression];" << std::endl;		
		myfile <<
			"iteration_statement" << $$ <<
			" -> {FOR" << $$ <<
			" ; \"(" << $$ << "\"" <<
			" ; expression" << $3 <<
			" ; \";1" << $$ << "\"" <<
			" ; expression" << $5 <<
			" ; \";2" << $$ << "\"" <<
			" ; expression" << $7 <<
			" ; \")" << $$ << "\"" <<			
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
