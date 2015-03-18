%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL

/* %polymorphic INT: int; TEXT: std::string; IF: If*; */
/* %type <TEXT> unary_operator */
/* %type <IF> selection_statement */
%polymorphic type : Type*; expAst : ExpAst* ; stmtAst : StmtAst*; Int : int; Float : float; String : string;

%type <expAst> expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression postfix_expression primary_expression l_expression constant_expression expression_list
%type <stmtAst> selection_statement iteration_statement assignment_statement translation_unit function_definition compound_statement statement statement_list
%type <Int> INT_CONSTANT unary_operator
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL IDENTIFIER fun_declarator
%type <type> type_specifier
%%


translation_unit
	: function_definition
	{
		$<stmtAst>$ = $<stmtAst>1;
		cout << "printing: ";
		$<stmtAst>$->print();
		cout << endl;
	}
	| translation_unit function_definition
	{
		$<stmtAst>$ = new Seq($<stmtAst>1, $<stmtAst>2);
	}
	;

function_definition
    : type_specifier {st = new SymbolTable(); st->retType = $<type>1; } fun_declarator {st->funcName = $<String>3;st->parameters = paramMap; paramMap.clear();} compound_statement
	{
		st->localVariables = paramMap;
		$<stmtAst>$ = $<stmtAst>5;
		st->Print();
		// st = new SymbolTableEntry();
	}
	;

type_specifier
	: VOID
	{
		$<type>$ = new Type(Kind::Base, Basetype::Void);
		//$<Int>$ = 0;
	}
    | INT
	{
		$<type>$ = new Type(Kind::Base, Basetype::Int);		
		//$<Int>$ = 1;
	} 
	| FLOAT
	{
		$<type>$ = new Type(Kind::Base, Basetype::Float);		
		//$<Int>$ = 2;
	}
    ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')' {$<String>$ = $<String>1;}
    | IDENTIFIER '(' ')' {$<String>$ = $<String>1;}
	;

parameter_list
	: parameter_declaration 
	| parameter_list ',' parameter_declaration 
	;

parameter_declaration
	: 	type_specifier declarator {
		SymbolTableEntry* ste = new SymbolTableEntry(12, $<type>1);
		paramMap[$<String>2] = ste;
	}
    ;

declarator
	: IDENTIFIER { $<String>$ = $<String>1;}
	| declarator '[' constant_expression ']'
	;

constant_expression 
    : INT_CONSTANT
	{
		$<expAst>$ = new IntConst($<Int>1);
	}
	| FLOAT_CONSTANT 
	{
		$<expAst>$ = new FloatConst($<Float>1);
	}
	;

compound_statement
	: '{' '}'
	{
		$<stmtAst>$ = new BlockStatement();
	}
	| '{' statement_list '}'
	{
		$<stmtAst>$ = $<stmtAst>2;
	}
    | '{' declaration_list statement_list '}'
	{
		$<stmtAst>$ = $<stmtAst>3;
 	}
	;

statement_list
	: statement
	{
		$<stmtAst>$ = new BlockStatement($<stmtAst>1);
	}
    | statement_list statement
	{
		((BlockStatement*)$<stmtAst>1)->children.push_back($<stmtAst>2);
		$<stmtAst>$ = $<stmtAst>1;
	}
	;

statement
    : '{' statement_list '}'  //a solution to the local decl problem
	{
		$<stmtAst>$ = $<stmtAst>2;
	}
	| selection_statement
	{
		$<stmtAst>$ = $<stmtAst>1;
	}
	| iteration_statement
	{
		$<stmtAst>$ = $<stmtAst>1;
	}
	| assignment_statement
	{
		$<stmtAst>$ = $<stmtAst>1;
	}
    | RETURN expression ';'
	{
		$<stmtAst>$ = new Return($<expAst>2);
	}
	;

assignment_statement
	: ';'
	{
		$<stmtAst>$ = new Ass();
	}
	|  l_expression '=' expression ';'
	{
		$<stmtAst>$ = new Ass($<expAst>1, $<expAst>3);
	}
	;

expression
	: logical_and_expression
	{
		$<expAst>$ = $<expAst>1;
	}
	| expression OR_OP logical_and_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::OR);
	}
	;

logical_and_expression
    : equality_expression
	{
		$<expAst>$ = $<expAst>1;
	}
	| logical_and_expression AND_OP equality_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::AND);
	}
	;

equality_expression
	: relational_expression
	{
		$<expAst>$ = $<expAst>1;
	}
	| equality_expression EQ_OP relational_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::EQ_OP);
	}
	| equality_expression NE_OP relational_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::NE_OP);
	}
	;
relational_expression
	: additive_expression
	{
		$<expAst>$ = $<expAst>1;
	}
	| relational_expression '<' additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::LT);
	}
	| relational_expression '>' additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::GT);
	}
	| relational_expression LE_OP additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::LE_OP);
	}
	| relational_expression GE_OP additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::GE_OP);
	}
	;

additive_expression 
	: multiplicative_expression
	{
		$<expAst>$ = $<expAst>1;
	}
	| additive_expression '+' multiplicative_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::PLUS);
	}
	| additive_expression '-' multiplicative_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::MINUS);
	}
	;

multiplicative_expression
	: unary_expression
	{
	  $<expAst>$ = $<expAst>1; 
	}
	| multiplicative_expression '*' unary_expression
	{
	  $<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::MULT);
	}
	| multiplicative_expression '/' unary_expression
	{
	  $<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::MULT);//no div operator defined
	}
	;
unary_expression
	: postfix_expression
	{
	  $<expAst>$ = $<expAst>1;
	}
	| unary_operator postfix_expression
	{
		$<expAst>$ = new OpUnary($<expAst>1, (OpUnary*)$<expAst>2);
	} 
	;

postfix_expression
	: primary_expression
	{
	  $<expAst>$ = $<expAst>1;	  
	}
    | IDENTIFIER '(' ')'
	{
		
		$<expAst>$ = new Funcall(new Identifier($<String>1));
	}
	| IDENTIFIER '(' expression_list ')'
	{
		((Funcall*)$<expAst>3)->children.insert(((Funcall*)$<expAst>3)->children.begin(), new Identifier($<String>1));
		$<expAst>$ = $<expAst>3;
	}
	| l_expression INC_OP
	{
		$<expAst>$ = new OpUnary($<expAst>1, opNameU::PP);
	}
	;

primary_expression
	: l_expression
	{
	  $<expAst>$ = $<expAst>1;
	}
    | l_expression '=' expression // added this production
	{
	  $<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::ASSIGN);
	}
	| INT_CONSTANT
	{
	  $<expAst>$ = new IntConst($1); 
	}
	| FLOAT_CONSTANT
	{
	  $<expAst>$ = new FloatConst($1); 
	}
    | STRING_LITERAL
	{
	  $<expAst>$ = new StringConst($1); 
	}
	| '(' expression ')'
	{
	  $<expAst>$ = $<expAst>2;
	}
	;

l_expression
    : IDENTIFIER
	{
		$<expAst>$ = new Identifier($1);
	}
	| l_expression '[' expression ']'
	{
		$<expAst>$ = new Index((ArrayRef*)$<expAst>1, $<expAst>3); 
	}
	;
expression_list
    : expression
	{
	  $<expAst>$ = new Funcall($<expAst>1);
	}
	| expression_list ',' expression
	{
		((Funcall*)$<expAst>1)->children.push_back($<expAst>3);
		$<expAst>$ = $<expAst>1;
	}
	;
unary_operator
	: '-'
	{
		$<expAst>$ = new OpUnary(opNameU::UMINUS); 
 	}
	| '!'
	{
		$<expAst>$ = new OpUnary(opNameU::NOT); 
	} 	
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement
	{
	  $<stmtAst>$ = new If($<expAst>3, $<stmtAst>5, $<stmtAst>7);
 	} 
	;

iteration_statement
	: WHILE '(' expression ')' statement
	{
	  $<stmtAst>$ = new While($<expAst>3, $<stmtAst>5);
	}	
    | FOR '(' expression ';' expression ';' expression ')' statement  //modified this production
	{
	  $<stmtAst>$ = new For($<expAst>3, $<expAst>5, $<expAst>7, $<stmtAst>9);
	}
	;

declaration_list
    : declaration
	{
		//$<expAst>$ = new Funcall($<expAst>1);
	}
	| declaration_list declaration
	{
		//((Funcall*)$<expAst>1)->children.push_back($<expAst>2);
		//$<expAst>$ = $<expAst>1;
	}
	;

declaration
	: type_specifier {retType = $<type>1;} declarator_list';'{
		// paramMap[]
	}
	;

declarator_list
	: declarator {
		paramMap[$<String>1] = new SymbolTableEntry(23, retType->copy());
	}
	| declarator_list ',' declarator {
		paramMap[$<String>3] = new SymbolTableEntry(23, retType->copy());
	}
	;
