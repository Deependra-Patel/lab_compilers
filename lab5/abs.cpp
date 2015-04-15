#include <iostream>
#include "abs.h"
#include <string>
#include <sstream>
#include <fstream>
using namespace std;
vector<string> regs = {"edx", "ecx", "ebx", "eax"};
Code code;

extern ofstream myfile;

void gencode(string new_line) {
	code.code_array.push_back(new_line);
}

int Code::size() {
	return code_array.size();
}

string Code::str() {
	string s = "";
	for (int i = 0; i < code_array.size(); i++) {
		s += code_array[i] + "\n";
	}
	return s;
}

void Code::clear() {
	code_array.clear();
}


string int_to_str(int a) {
	stringstream ss;
	ss << a;
	return ss.str();
}

string float_to_str(double a) {
	stringstream ss;
	ss << a;
	return ss.str();
}

void swap() {
	string reg1 = regs.back();
	regs.pop_back();
	string reg2 = regs.back();
	regs.pop_back();
	regs.push_back(reg1);
	regs.push_back(reg2);
	return;
}


string inverse_enum[] = {
"",
"OR",
"AND",
"EQ_OP",
"EQ_OP_INT",
"EQ_OP_FLOAT",
"NE_OP",
"NE_OP_INT",
"NE_OP_FLOAT",
"LT",
"LT_INT",
"LT_FLOAT",
"LE_OP",
"LE_OP_INT",
"LE_OP_FLOAT",
"GT",
"GT_INT",
"GT_FLOAT",
"GE_OP",
"GE_OP_INT",
"GE_OP_FLOAT",
"PLUS",
"PLUS_INT",
"PLUS_FLOAT",
"MINUS",
"MINUS_INT",
"MINUS_FLOAT",
"MULT",
"MULT_INT",
"MULT_FLOAT",
"DIV",
"DIV_INT",
"DIV_FLOAT",
"ASSIGN",
"UMINUS",
"UMINUS_INT",
"UMINUS_FLOAT",
"NOT",
"NOT_INT",
"NOT_FLOAT",
"PP",
"PP_INT",
"PP_FLOAT",
"TO_FLOAT",
"TO_INT"
};

void Seq::generate_code(SymbolTable* st){
	//return "";
}
Seq::Seq(){}
Seq::Seq(StmtAst* l, StmtAst* r){
	left = l;
	right = r;
};

void Seq::print(){
	cout << "(Seq ";
	left->print();
	cout << " ";
	right->print();
	cout <<")";
}

void BlockStatement::generate_code(SymbolTable* st){
	code.clear();
	gencode("\nvoid "+st->funcName+"(){");
	gencode("\t pushi(ebp); // Setting dynamic link");
	gencode("\t move(esp,ebp); // Setting dynamic link");
	for (int i = 0; i < children.size(); i++) children[i]->generate_code(st);
	if (st->funcName == "main") {
	  gencode("\t print_int(eax);");
	  gencode("\t print_char('\\n');");
	  gencode("\t print_int(ebx);");
	  gencode("\t print_char('\\n');");
	  gencode("\t print_int(ecx);");
	  gencode("\t print_char('\\n');");
	  gencode("\t print_int(edx);");
	  gencode("\t print_char('\\n');");
	}
	gencode("}");
	myfile << code.str() << endl;
}
BlockStatement::BlockStatement(){}
BlockStatement::BlockStatement(StmtAst* c){
	children.push_back(c);
};

void BlockStatement::print(){
	if (children.empty()) cout << "(Empty)";
	cout << "(Block [";
	for (int i = 0; i < children.size(); i++) {
		children.at(i)->print();
		if (i < children.size() - 1) cout << " ";
	}
	cout << "])";
}



// for Ass
void Ass::generate_code(SymbolTable* st){
	if (left == NULL && right == NULL) return;
	right->generate_code(st);
	if (left == NULL) return;
	ArrayRef* left1 = (ArrayRef *)left;
	if (regs.size() == 2) {
		if (right->type->basetype == Int) {
			gencode("\t pushi("+ regs.back() +");    // pushing temporary storage");
			left1->generate_code_addr(st);
			gencode("\t loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("\t storei("+ regs[0] +", ind("+ regs.back() +"));");
		}
		else {
			gencode("\t pushf("+ regs.back() +");    // pushing temporary storage");
			left1->generate_code_addr(st);
			gencode("\t loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("\t storef("+ regs[0] +", ind("+ regs.back() +"));");
		}
	}
	else {
		string right_reg = regs.back();
		regs.pop_back();
		if (right->type->basetype == Int) {
			left1->generate_code_addr(st);
			gencode("\t storei("+ right_reg +", ind("+ regs.back() +"));");
		}
		else {
			left1->generate_code_addr(st);
			gencode("\t storef("+ right_reg +", ind("+ regs.back() +"));");
		}
		regs.push_back(right_reg);
		swap();
	}
}
Ass::Ass(){
	empty = true;
}
Ass::Ass(ExpAst* l, ExpAst* r){
	if (l == NULL) {
		left = l;
		right = r;
		type = new Type(Ok);
		return;
	}	
	if(l->type->basetype == Int && r->type->basetype == Float){
		OpUnary *xf = new OpUnary(r, TO_INT);
		left = l;
		right = xf;
		type = new Type(Ok);
	}
	else if(l->type->basetype == Float && r->type->basetype == Int){
		OpUnary *yf = new OpUnary(r, TO_FLOAT);
		left = l;
		right = yf;
		type = new Type(Ok);
	} 
	else if(l->type->basetype == r->type->basetype){
		left = l;
		right = r;
		type = new Type(Ok);
	}
	else{
		type = new Type(Error);
		left = l;
		right = r;
	}
	empty = false;
};

void Ass::print(){
	if (empty) {
		cout << "(Empty)";
		return ;
	}
	cout << "(Ass ";
	if (left != NULL) {
		left->print();
		cout << " ";
	}
	right->print();
	cout << ")";
}

// for Return
void Return::generate_code(SymbolTable* st){
}
Return::Return() {
	 
}
Return::Return(ExpAst* c, Type * t) {
	if (t->equal(c->type)) {
		child = c;
		type = new Type(Ok);
	}
	else if (c->type->tag != Base) {
		type = new Type(Error);
		child = c;
	}
	else if (c->type->basetype == Int) {
		OpUnary *xf = new OpUnary(c, TO_FLOAT);
		child = xf;
		type = new Type(Ok);
	}else if (c->type->basetype == Float) {
		OpUnary *xf = new OpUnary(c, TO_INT);
		child = xf;
		type = new Type(Ok);
	}
}

void Return::print() {
	cout << "(Return ";
	child->print();
	cout << ")";
}

// for If
void If::generate_code(SymbolTable* st){
}
If::If() {
	
}
If::If(ExpAst* f, StmtAst* s, StmtAst* t){
	first = f;
	second = s;
	third = t;
}

void If::print() {
	cout << "(If ";
	first->print();
	cout << " ";
	second->print();
	cout << " ";
	third->print();
	cout << ")";
}
// for While
void While::generate_code(SymbolTable* st){
}
While::While() {
	
}
While::While(ExpAst* l, StmtAst* r) {
	left = l;
	right = r;
}

void While::print() {
	cout << "(While ";
	left->print();
	cout << " ";
	right->print();
	cout << ")";
}

// for For
void For::generate_code(SymbolTable* st){
	//return "";
}
For::For() {
	
}
For::For(ExpAst* f, ExpAst* s, ExpAst* t, StmtAst* c){
	first = f;
	second = s;
	third = t;
	child = c;
}

void For::print() {
	cout << "(For ";
	first->print();
	cout << " ";
	second->print();
	cout << " ";
	third->print();
	cout << " ";
	child->print();
	cout << ")";
}

void OpBinary::generate_code(SymbolTable* st){
	left->generate_code(st);
	if (regs.size() == 2) {
		if (left->type->basetype == Int) {
			gencode("\t pushi("+ regs.back() +");    // pushing temporary storage");
		}
		else {
			gencode("\t pushf("+ regs.back() +");    // pushing temporary storage");
		}
		right->generate_code(st);
		if (left->type->basetype == Int) {
			gencode("\t loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
			if (opName == MULT_INT) gencode("\t muli("+ regs[0] +", "+ regs[1] +");");
			if (opName == PLUS_INT) gencode("\t addi("+ regs[0] +", "+ regs[1] +");");
			if (opName == MINUS_INT) {
				gencode("\t muli(-1, "+ regs[1] +");");
				gencode("\t addi("+ regs[0] +", "+ regs[1] +");");
			}
			if (opName == DIV_INT) gencode("\t divi("+ regs[0] +", "+ regs[1] +");");
			gencode("\t popi(1);");
		}
		else {
			gencode("\t loadf(esp, "+ regs[0] +");    // loading temporary storage");
			if (opName == MULT_FLOAT) gencode("\t mulf("+ regs[0] +", "+ regs[1] +");");
			if (opName == PLUS_FLOAT) gencode("\t addf("+ regs[0] +", "+ regs[1] +");");
			if (opName == MINUS_FLOAT) {
				gencode("\t mulf(-1, "+ regs[1] +");");
				gencode("\t addf("+ regs[0] +", "+ regs[1] +");");
			}
			if (opName == DIV_FLOAT) gencode("\t divf("+ regs[0] +", "+ regs[1] +");");
			gencode("\t popf(1);");
		}
		
	}
	else {
		string left_reg = regs.back();
		regs.pop_back();
		right->generate_code(st);
		if (left->type->basetype == Int) {
			if (opName == MULT_INT) gencode("\t muli("+ left_reg+", "+ regs.back() +");");
			if (opName == PLUS_INT) gencode("\t addi("+ left_reg	+", "+ regs.back() +");");
			if (opName == MINUS_INT) {
				gencode("\t muli(-1, "+ regs.back() +");");
				gencode("\t addi("+ left_reg +", "+ regs.back() +");");
			}
			if (opName == DIV_INT) gencode("\t divi("+ left_reg +", "+ regs.back() +");");
		}
		else {
			if (opName == MULT_FLOAT) gencode("\t mulf("+ left_reg +", "+ regs.back() +");");
			if (opName == PLUS_FLOAT) gencode("\t addf("+ left_reg +", "+ regs.back() +");");
			if (opName == MINUS_FLOAT) {
				gencode("\t mulf(-1, "+ regs.back() +");");
				gencode("\t addf("+ left_reg +", "+ regs.back() +");");

			}
			if (opName == DIV_FLOAT) gencode("\t divf("+ left_reg +", "+ regs.back() +");");
		}
		regs.push_back(left_reg);
		swap();
	}
	// if (regs.size() == 2) {
	// 	if (left->type->basetype == Int) {
	// 		gencode("\t pushi("+ regs.back() +");    // pushing temporary storage");
	// 	}
	// 	else {
	// 		gencode("\t pushf("+ regs.back() +");    // pushing temporary storage");
	// 	}
	// 	right->generate_code(st);
	// 	if (left->type->basetype == Int) {
	// 		gencode("\t loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
	// 		if (opName == MULT_INT) gencode("\t muli("+ regs[0] +", "+ regs[1] +");");
	// 		if (opName == PLUS_INT) gencode("\t addi("+ regs[0] +", "+ regs[1] +");");
	// 		if (opName == MINUS_INT) {
	// 			gencode("\t muli(-1, "+ regs[1] +");");
	// 			gencode("\t addi("+ regs[0] +", "+ regs[1] +");");
	// 		}
	// 		if (opName == DIV_INT) gencode("\t divi("+ regs[0] +", "+ regs[1] +");");
	// 		gencode("\t popi(1);");
	// 	}
	// 	else {
	// 		gencode("\t loadf(esp, "+ regs[0] +");    // loading temporary storage");
	// 		if (opName == MULT_FLOAT) gencode("\t mulf("+ regs[0] +", "+ regs[1] +");");
	// 		if (opName == PLUS_FLOAT) gencode("\t addf("+ regs[0] +", "+ regs[1] +");");
	// 		if (opName == MINUS_FLOAT) {
	// 			gencode("\t mulf(-1, "+ regs[1] +");");
	// 			gencode("\t addf("+ regs[0] +", "+ regs[1] +");");
	// 		}
	// 		if (opName == DIV_FLOAT) gencode("\t divf("+ regs[0] +", "+ regs[1] +");");
	// 		gencode("\t popf(1);");
	// 	}
		
	// }
	// else {
	// 	string left_reg = regs.back();
	// 	regs.pop_back();
	// 	right->generate_code(st);
	// 	if (left->type->basetype == Int) {
	// 		if (opName == MULT_INT) gencode("\t muli("+ left_reg+", "+ regs.back() +");");
	// 		if (opName == PLUS_INT) gencode("\t addi("+ left_reg	+", "+ regs.back() +");");
	// 		if (opName == MINUS_INT) {
	// 			gencode("\t muli(-1, "+ regs.back() +");");
	// 			gencode("\t addi("+ left_reg +", "+ regs.back() +");");
	// 		}
	// 		if (opName == DIV_INT) gencode("\t divi("+ left_reg +", "+ regs.back() +");");
	// 	}
	// 	else {
	// 		if (opName == MULT_FLOAT) gencode("\t mulf("+ left_reg +", "+ regs.back() +");");
	// 		if (opName == PLUS_FLOAT) gencode("\t addf("+ left_reg +", "+ regs.back() +");");
	// 		if (opName == MINUS_FLOAT) {
	// 			gencode("\t mulf(-1, "+ regs.back() +");");
	// 			gencode("\t addf("+ left_reg +", "+ regs.back() +");");

	// 		}
	// 		if (opName == DIV_FLOAT) gencode("\t divf("+ left_reg +", "+ regs.back() +");");
	// 	}
	// 	regs.push_back(left_reg);
	// 	swap();
	// }
}
OpBinary::OpBinary(){};
OpBinary::OpBinary(opNameB e){
  opName = e;
}

void OpBinary::setArguments(ExpAst* x, ExpAst *y) {
	left = x;
	right = y;
}
OpBinary::OpBinary(ExpAst*x, ExpAst*y, opNameB o) {
	
	if (x->type->tag == Error || y->type->tag == Error){
		type->tag = Error;
		return;
	}
	if (x->type->tag == Ok && y->type->tag == Ok){
		type->tag = Ok;
		return;
	}

	if (x->type->tag != Base || y->type->tag != Base){
		if (x->type->equal(y->type)) {
			left=x;
			right=y;
			opName = o;
			return;
		}
		type->tag = Error;
		return;
	}
	else if(x->type->basetype == y->type->basetype){
		left = x;
		right = y;
		if (x->type->basetype == Int)
			opName = (opNameB)((int)o+1);
		if (x->type->basetype == Float)
			opName = (opNameB)((int)o+2);
		if (o == ASSIGN) opName = o;
		type = x->type->copy();
		if (o == LT || o == GT || o == LE_OP || o == GE_OP || o == NE_OP || o == EQ_OP || o == OR || o == AND){
			if (x->type->isNumeric() && y->type->isNumeric()){
				type = new Type(Base, Int);
			}
			else {
				type = new Type(Error);
			}
			return ;
		}
	}
	else if (o == ASSIGN) {
		if(x->type->basetype == Int && y->type->basetype == Float){
			OpUnary *xf = new OpUnary(y, TO_INT);
			left = x;
			right = xf;
			type = x->type->copy();
		}
		else if(y->type->basetype == Int && x->type->basetype == Float){
			OpUnary *yf = new OpUnary(y, TO_FLOAT);
			left = x;
			right = yf;
			type = x->type->copy();
		} 
		else {

		} 
	}
	else if(x->type->basetype == Int && y->type->basetype == Float){
		OpUnary *xf = new OpUnary(x, TO_FLOAT);
		left = xf;
		right = y;
		opName = (opNameB)((int)o+2);
		type = y->type->copy();
		if (o == LT || o == GT || o == LE_OP || o == GE_OP || o == NE_OP || o == EQ_OP || o == OR || o == AND){
			if (x->type->isNumeric() && y->type->isNumeric()){
				type = new Type(Base, Int);
			}
			else {
				type = new Type(Error);
			}
			return ;
		}
	}

	else if(y->type->basetype == Int && x->type->basetype == Float){
		OpUnary *yf = new OpUnary(y, TO_FLOAT);
		left = x;
		right = yf;
		opName = (opNameB)((int)o+2);
		type = x->type->copy();
		if (o == LT || o == GT || o == LE_OP || o == GE_OP || o == NE_OP || o == EQ_OP || o == OR || o == AND){
		if (x->type->isNumeric() && y->type->isNumeric()){
			type = new Type(Base, Int);
		}
		else {
			type = new Type(Error);
		}
		return ;
	}
	}	
}

void OpBinary::print(){
	cout<<"("<<inverse_enum[opName] << " ";
  left->print();
  cout<<" ";
  right->print();
  cout<<")";
}

void OpUnary::generate_code(SymbolTable* st){
	//return "";
}
OpUnary::OpUnary(){}
OpUnary::OpUnary(opNameU e){
  opName = e;
}
OpUnary::OpUnary(ExpAst*x, opNameU e) {
	child = x;
	type = x->type;
	opName = e;
}
OpUnary::OpUnary(ExpAst * x, OpUnary* y) {
	opName = y->opName;
	child = x;
}
void OpUnary::print(){
	cout<<"("<<inverse_enum[opName] << " ";
  child->print();
  cout<<")";
}

extern GlobalTable* gt;

void Funcall::generate_code(SymbolTable* st){
	
	if (gt->getRetType(st->funcName)->basetype == Int)
		gencode("\t pushi(1); //return");
	else if (gt->getRetType(st->funcName)->basetype == Float)
		gencode("\t pushi(1); //return");
	else if (gt->getRetType(st->funcName)->basetype == Void)
		gencode("\t pushi(0); //return ");
				
	for (int i = 1; i<children.size(); i++){
		children[i]->generate_code(st);
		if (children[i]->type->basetype == Int){
			gencode("\t pushi("+regs[0]+");//args");
		}
		else{
			gencode("\t pushf("+regs[0]+");//args");
		}
	}
}
Funcall::Funcall(){}
Funcall::Funcall(vector<ExpAst*> exps){
  children = exps;
}
Funcall::Funcall(ExpAst* x) {
	children.push_back(x);
}
void Funcall::print(){
  cout<<"(Funcall ";
  int l = children.size();
  for(int i = 0; i<l; i++){
    children[i]->print();
    if (i < l-1) cout<<" ";
  }
  cout<<")";
}


void FloatConst::generate_code(SymbolTable* st){
	gencode("\t move("+ float_to_str(child) +", "+ regs.back() +");");
	//return "";
}
FloatConst::FloatConst(float x){
  child = x;
}
void FloatConst::print(){
  cout<<"(FloatConst "<<child<<")";
}


void IntConst::generate_code(SymbolTable* st){
	gencode("\t move("+ int_to_str(child) +", "+ regs.back() +");");
	//return "";
}
IntConst::IntConst(){}
IntConst::IntConst(int x){
  child = x;
}
void IntConst::print(){
  cout<<"(IntConst "<<child<<")";
}


void StringConst::generate_code(SymbolTable* st){
	//return "";
}
StringConst::StringConst(string x){
  child = x;
}
void StringConst::print(){
  cout<<"(StringConst "<<child<<")";
}


void Identifier::generate_code( SymbolTable* st){
	if (st->checkScope(child)) {
		Type * tp = st->getType(child);
		int offset = st->getOffset(child);
		string offset_str = int_to_str(offset);
		if (tp->tag == Base && tp->basetype == Int) gencode("\t loadi(ind(ebp, "+ offset_str +"), "+ regs.back() +");");
		else if (tp->tag == Base && tp->basetype == Float) gencode("\t loadf(ind(ebp, "+ offset_str +"), "+ regs.back() +");");
		else if (tp->tag == Pointer) {
			gencode("\t move("+ offset_str +", "+ regs.back() +");");
			gencode("\t addi(ebp,"+ regs.back() +");");
		}
	}
}


void Identifier::generate_code_addr( SymbolTable* st){
	if (st->checkScope(child)) {
		Type * tp = st->getType(child);
		int offset = st->getOffset(child);
		string offset_str = int_to_str(offset);
		gencode("\t move("+ offset_str +", "+ regs.back() +");");
		gencode("\t addi(ebp,"+ regs.back() +");");
	}
}

Identifier::Identifier(){}
Identifier::Identifier(string x){
  child = x;
}
void Identifier::print(){
  cout<<"(Identifier "<<child<<")";
}


void Index::generate_code(SymbolTable* st){
	left->generate_code(st);
	if (regs.size() == 2) {
		gencode("\t pushi("+ regs.back() +");");
		right->generate_code(st);
		gencode("\t loadi(ind(esp), "+ regs[0] +");");
		gencode("\t muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("\t addi("+ regs[0] +", "+ regs.back() +"); ");
		if (type->tag == Base) {
			if (type->basetype == Int) {
				gencode("\t loadi(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
			else if (type->basetype == Float) {
				gencode("\t loadf(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
		}
		gencode("\t popi(1);");
	}
	else {
		string left_reg = regs.back();
		regs.pop_back();
		right->generate_code(st);
		gencode("\t muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("\t addi("+ left_reg +", "+ regs.back() +"); ");
		if (type->tag == Base) {
			if (type->basetype == Int) {
				gencode("\t loadi(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
			else if (type->basetype == Float) {
				gencode("\t loadf(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
		}
		regs.push_back(left_reg);
		swap();
	}
}


void Index::generate_code_addr(SymbolTable* st){
	left->generate_code(st);
	if (regs.size() == 2) {
		gencode("\t pushi("+ regs.back() +");");
		right->generate_code(st);
		gencode("\t loadi(ind(esp), "+ regs[0] +");");
		gencode("\t muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("\t addi("+ regs[0] +", "+ regs.back() +"); ");
		gencode("\t popi(1);");
	}
	else {
		string left_reg = regs.back();
		regs.pop_back();
		right->generate_code(st);
		gencode("\t muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("\t addi("+ left_reg +", "+ regs.back() +"); ");
		regs.push_back(left_reg);
		swap();
	}
}


Index::Index(){}
Index::Index(ArrayRef* left, ExpAst* right){
  this->left = left;
  this->right = right;
}

Index::Index(string s) {
	identifier_name = s;
}

void Index::print(){
  cout<<"(Index ";
  left->print();
  cout<<" ";
  right->print();
  cout<<")";
}
