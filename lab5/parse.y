%debug
%scanner Scanner.h
%scanner-token-function d_scanner.lex()

%token VOID INT FLOAT IDENTIFIER INT_CONSTANT FLOAT_CONSTANT RETURN OR_OP AND_OP EQ_OP NE_OP LE_OP GE_OP INC_OP STRING_LITERAL IF ELSE WHILE FOR OTHER SYMBOL

/* %polymorphic INT: int; TEXT: std::string; IF: If*; */
/* %type <TEXT> unary_operator */
/* %type <IF> selection_statement */
%polymorphic type : Type*; expAst : ExpAst* ; stmtAst : StmtAst*; Int : int; Float : float; String : string; SymbolTableEntry : SymbolTableEntry*;

%type <expAst> expression logical_and_expression equality_expression relational_expression additive_expression multiplicative_expression unary_expression postfix_expression primary_expression l_expression constant_expression expression_list
%type <stmtAst> selection_statement iteration_statement assignment_statement translation_unit function_definition compound_statement statement statement_list
%type <Int> INT_CONSTANT unary_operator
%type <Float> FLOAT_CONSTANT
%type <String> STRING_LITERAL IDENTIFIER fun_declarator
%type <type> type_specifier
%type <SymbolTableEntry> declarator
%%


translation_unit
	: function_definition
	{
		$<stmtAst>$ = $<stmtAst>1;
	}
	| translation_unit function_definition
	{
		$<stmtAst>$ = new Seq($<stmtAst>1, $<stmtAst>2);
	}
	;

function_definition
    : type_specifier
	{
		st = new SymbolTable();
		st->retType = $<type>1;
		cout << endl;
		offset = 4;
		paramMap.clear();
		index = 0;
	}
	fun_declarator
	{
		st->funcName = $<String>3;
		st->parameters = paramMap;
		paramMap.clear();
		offset = 0;
		code.clear();
		gencode("\nvoid "+st->funcName+"(){");
		gencode("    pushi(ebp); // Setting dynamic link");
		gencode("    move(esp,ebp); // Setting dynamic link");
		gt->insert(st);
	}
	compound_statement
	{
		cout << "compound done" << endl;
		insert_locals(st);
		save_regs();
		st->localVariables = paramMap;
		$<stmtAst>$ = $<stmtAst>5;
		st->Print();
		gt->insert(st);
		cout << "printing: ";
		$<stmtAst>$->print();
		$<stmtAst>$->generate_code(st);
		cout << endl;	
		gencode("ret"+st->funcName+":");
		/* if (st->funcName == "main") { */
		/* 	gencode("    print_int(eax);"); */
		/* 	gencode("    print_char('\\n');"); */
		/* 	gencode("    print_int(ebx);"); */
		/* 	gencode("    print_char('\\n');"); */
		/* 	gencode("    print_int(ecx);"); */
		/* 	gencode("    print_char('\\n');"); */
		/* 	gencode("    print_int(edx);"); */
		/* 	gencode("    print_char('\\n');"); */
		/* } */
		load_regs();
		remove_locals(st);
		gencode("    loadi(ind(ebp), ebp);");
		gencode("    popi(1);");
		gencode("    return;");
		gencode("}");
		myfile << code.str() << endl;	
		st = new SymbolTable();
	}
	;

type_specifier
	: VOID
	{
		$<type>$ = new Type(Kind::Base, Basetype::Void);
		retType = $<type>$;
		//$<Int>$ = 0;
	}
    | INT
	{
		$<type>$ = new Type(Kind::Base, Basetype::Int);		
		retType = $<type>$;
		//$<Int>$ = 1;
	} 
	| FLOAT
	{
		$<type>$ = new Type(Kind::Base, Basetype::Float);
		retType = $<type>$;		
		//$<Int>$ = 2;
	}
    ;

fun_declarator
	: IDENTIFIER '(' parameter_list ')'
	{
		if (gt->funcSymbolTable.find($<String>1) != gt->funcSymbolTable.end()) {
			cout << "Error:: On line " << d_scanner.lineNr() << " Function with the same name exists." << endl;
		}
		$<String>$ = $<String>1;
	}
    | IDENTIFIER
	'(' ')'
	{
		if (gt->funcSymbolTable.find($<String>1) != gt->funcSymbolTable.end()) {
			cout << "Error:: On line " << d_scanner.lineNr() << " Function with the same name exists." << endl;
		}
		$<String>$ = $<String>1;
	}
	;

parameter_list
	: parameter_declaration 
	| parameter_list ',' parameter_declaration 
	;

parameter_declaration
	: 	type_specifier declarator {
		paramMap[$<SymbolTableEntry>2->name] = $<SymbolTableEntry>2;
		offset += $<SymbolTableEntry>2->size();
		index += 1;
		if (retType->basetype == Void) {
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Parameter " << $<SymbolTableEntry>2->name <<" has type void."<< endl;
		}
	}
    ;

declarator
	: IDENTIFIER
	{
		$<SymbolTableEntry>$ = new SymbolTableEntry(index, offset, retType, $<String>1);
		if (st->checkScope($<String>1)){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Variable '"<< $<String>1<<"' already defined"<<endl;
		}
		else if (gt->funcSymbolTable.find($<String>1) != gt->funcSymbolTable.end()) {
			cout << "Error:: On line " << d_scanner.lineNr() << " Function with the same name exists." << endl;
		}
	}
	| declarator '[' constant_expression ']'
	{
		if ($<expAst>3->type->basetype != Int){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Non integer Array index of variable."<< endl;
		}
		/* Type* cur = new Type(); */
		/* cur->tag = Pointer; */
		/* cur->pointed = $<SymbolTableEntry>1->idType; */
		/* cur->sizeType = ((IntConst*)$<expAst>3)->child; */
		/* $<SymbolTableEntry>$ = $<SymbolTableEntry>1; */
		/* $<SymbolTableEntry>$->idType = cur; */
		$<SymbolTableEntry>$->idType->update(((IntConst*)$<expAst>3)->child);
	}
	;

constant_expression 
    : INT_CONSTANT
	{
		$<expAst>$ = new IntConst($<Int>1);
		$<expAst>$->type = new Type(Base, Int);
	}
	| FLOAT_CONSTANT 
	{
		$<expAst>$ = new FloatConst($<Float>1);
		$<expAst>$->type = new Type(Base, Float);
	}
	;

compound_statement
	: '{' '}'
	{
		$<stmtAst>$ = new BlockStatement();
		$<expAst>$->type = new Type(Ok);
	}
	| '{' statement_list '}'
	{
		$<stmtAst>$ = $<stmtAst>2;
	}
    | '{' declaration_list
	{
		st->setOffsets();
	}
	statement_list '}'
	{
		$<stmtAst>$ = $<stmtAst>4;
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
		$<stmtAst>$ = new Return($<expAst>2, st->retType);
		if ($<stmtAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Incompatible return type."<<endl;			
		}
	}
	;

assignment_statement
	: ';'
	{
		$<stmtAst>$ = new Ass(NULL, NULL);
	}
	|  l_expression '=' expression ';'
	{		
		//$<expAst>1->type->Print();		
		//$<expAst>3->type->Print();		
		$<stmtAst>$ = new Ass($<expAst>1, $<expAst>3);	
		if ($<stmtAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Assignment of Incompatible types."<<endl;			
		}
	}
    | expression ';'
    {
		$<stmtAst>$ = new Ass(NULL, $<expAst>1);	
	
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
	}
	| equality_expression NE_OP relational_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::NE_OP);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}	
		cout<<"ddddddddddd"<<endl;
		$<expAst>$->print();
		cout<<endl;	
	}
	| relational_expression '>' additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::GT);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
	}
	| relational_expression LE_OP additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::LE_OP);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
	}
	| relational_expression GE_OP additive_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::GE_OP);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;			
		}		
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type mismatch for addition. Not numeric"<<endl;			
		}			
	}
	| additive_expression '-' multiplicative_expression
	{
		$<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::MINUS);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type mismatch for subtraction. Not numeric"<<endl;			
		}			
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type mismatch for multiplication. Not numeric"<<endl;			
		}		  
	  //$<expAst>$->type = new Type();
	}
	| multiplicative_expression '/' unary_expression
	{
	  $<expAst>$ = new OpBinary($<expAst>1, $<expAst>3, opNameB::DIV);//no div operator defined
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type mismatch for division. Not numeric"<<endl;			
		}		  
	}
	;
unary_expression
	: postfix_expression
	{
	  $<expAst>$ = $<expAst>1;
	}
	| unary_operator postfix_expression
	{
		$<expAst>$ = new OpUnary($<expAst>2, ((OpUnary*)$<expAst>1)->opName);
		$<expAst>$->type = $<expAst>2->type;
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
		bool funcok = true;

		// checking the function call

		Funcall *fc = (Funcall *) $<expAst>$;
		if (gt->funcSymbolTable.find($<String>1) == gt->funcSymbolTable.end()) {
			cout << "Error:: On line " << d_scanner.lineNr() << " Function " << $<String>1 << " is not defined." << endl;
			funcok = false;
		}
		else {
			SymbolTable * calledst = gt->funcSymbolTable[$<String>1];
			if (fc->children.size() - 1 != calledst->parameters.size()) {
				cout << "Error:: On line " << d_scanner.lineNr() << " Function " << $<String>1 << " has " << calledst->parameters.size() << " parameters, " << fc->children.size() - 1 << " given." << endl;
			}
		}
		
		// function call checking finished
		
		if (! funcok) $<expAst>$->type = new Type(Error, Int);
		else {
			$<expAst>$->type = gt->funcSymbolTable[$<String>1]->retType;
		}
	}
	| IDENTIFIER '(' expression_list ')'
	{
		((Funcall*)$<expAst>3)->children.insert(((Funcall*)$<expAst>3)->children.begin(), new Identifier($<String>1));
		$<expAst>$ = $<expAst>3;
		bool funcok = true;

		// checking the function call

		Funcall *fc = (Funcall *) $<expAst>$;
		if (gt->funcSymbolTable.find($<String>1) == gt->funcSymbolTable.end()) {
			cout << "Error:: On line " << d_scanner.lineNr() << " Function " << $<String>1 << " is not defined." << endl;
			funcok = false;
		}

		else {
			SymbolTable * calledst = gt->funcSymbolTable[$<String>1];
			if (fc->children.size() - 1 != calledst->parameters.size()) {
				cout << "Error:: On line " << d_scanner.lineNr() << " Function " << $<String>1 << " has " << calledst->parameters.size() << " parameters, " << fc->children.size() - 1 << " given." << endl;
			}
			else {
				for (int i = 1; i < fc->children.size(); i++) {
					Type * actualtype = calledst->getParaByInd(i-1);
					IntConst *temp = new IntConst(11);
					FloatConst* temp2 = new FloatConst(1.1);
					if (typeid(*temp) == typeid(*fc->children[i]) || typeid(*temp2) == typeid(*fc->children[i])){
						if (!(fc->children[i]->type)->equal(actualtype)) {
							if (fc->children[i]->type->tag == Base && actualtype->tag == Base) {
								if (fc->children[i]->type->basetype == Int) {
									OpUnary *xf = new OpUnary(fc->children[i], TO_FLOAT);
									fc->children[i] = xf;
								}
								else if(fc->children[i]->type->basetype == Float) {
									OpUnary *xf = new OpUnary(fc->children[i], TO_INT);
									fc->children[i] = xf;
								}
							}
							else {
								cout << "Error:: On line " << d_scanner.lineNr() << " Parameter " << i << " of Function " << $<String>1 << " has wrong type." << endl;
							}
						}	
						continue;					
					}
					Type* paratype = fc->children[i]->type;
					if (!paratype->equal(actualtype)) {
						if (paratype->tag == Base && actualtype->tag == Base) {
							if (paratype->basetype == Int) {
								OpUnary *xf = new OpUnary(fc->children[i], TO_FLOAT);
								fc->children[i] = xf;
							}
							else if(paratype->basetype == Float) {
								OpUnary *xf = new OpUnary(fc->children[i], TO_INT);
								fc->children[i] = xf;
							}
						}
						else {
							cout << "Error:: On line " << d_scanner.lineNr() << " Parameter " << i << " of Function " << $<String>1 << " has wrong type." << endl;
						}
					}
				}
			}
		}
		
		// function call checking finished		
		if (! funcok) $<expAst>$->type = new Type(Error, Int);
		else {
			$<expAst>$->type = gt->funcSymbolTable[$<String>1]->retType;
		}
	}
	| l_expression INC_OP
	{
		$<expAst>$ = new OpUnary($<expAst>1, opNameU::PP);
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", in inc_op lexpression should be variable"<<endl;			
		}
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
		if ($<expAst>$->type->tag == Error){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type mismatch."<<endl;			
		}		  
	}
	| INT_CONSTANT
	{
	  $<expAst>$ = new IntConst($1); 
	  $<expAst>$->type = new Type(Base, Int);
	}
	| FLOAT_CONSTANT
	{
	  $<expAst>$ = new FloatConst($1); 
	  $<expAst>$->type = new Type(Base, Float);	  
	}
    | STRING_LITERAL
	{
	  $<expAst>$ = new StringConst($1); 
	  $<expAst>$->type = new Type(Base, Void);
	}
	| '(' expression ')'
	{
	  $<expAst>$ = $<expAst>2;
	}
	;

l_expression
    : IDENTIFIER
	{
		if(!st->checkScope($<String>1)){
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Undeclared variable '"<<$<String>1<<"' "<<endl;			
		}
		$<expAst>$ = new Identifier($1);
		$<expAst>$->type = st->getType($<String>1);
	}
	| l_expression '[' expression ']'
	{
		Type * t = $<expAst>1->type;
		$<expAst>$ = new Index((ArrayRef* )$<expAst>1, $<expAst>3);
		if (t->tag == 0) {
			//$<expAst>$->type->tag = Error;
			cout << "Error:: On line " << d_scanner.lineNr() << " Unmatched dimension being tried to access. "  << endl;
			$<expAst>$->type = t;
		}
		else {
			$<expAst>$->type = t->pointed;

		}
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
		$<expAst>$->type = new Type(Ok);
 	}
	| '!'
	{
		$<expAst>$ = new OpUnary(opNameU::NOT); 
		$<expAst>$->type = new Type(Ok);		
	} 	
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement
	{
	  $<stmtAst>$ = new If($<expAst>3, $<stmtAst>5, $<stmtAst>7);
		$<stmtAst>$->print();
		cout << endl;
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
		if($<expAst>5->type->tag == Base && $<expAst>5->type->basetype == Int)
			$<stmtAst>$->type = new Type(Ok);
		else {
			$<stmtAst>$->type = new Type(Error);
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Type of condition is not an integer"<<endl;
			exit(0);
		}		
	}
	;

declaration_list
    : declaration
	{
		//$<expAst>$ = new Funcall($<expAst>1);
		st->localVariables = paramMap;
	}
	| declaration_list declaration
	{
		//((Funcall*)$<expAst>1)->children.push_back($<expAst>2);
		//$<expAst>$ = $<expAst>1;
		st->localVariables = paramMap;
	}
	;

declaration
	: type_specifier
	{
		retType = $<type>1;
		if (retType->basetype == Void) {
			cout<<"Error:: On line "<<d_scanner.lineNr()<<", Variables being declared as void."<< endl;
		}
	}
	declarator_list';'
	{
		// paramMap[]
	}
	;

declarator_list
	: declarator {
		paramMap[$<SymbolTableEntry>1->name] = $<SymbolTableEntry>1;
		st->localVariables = paramMap;
		offset += $<SymbolTableEntry>1->size();
	}
	| declarator_list ',' declarator {
		paramMap[$<SymbolTableEntry>3->name] = $<SymbolTableEntry>3;
		st->localVariables = paramMap;		
		offset += $<SymbolTableEntry>3->size();
	}
	;
