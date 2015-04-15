#include <iostream>
#include "abs.h"
#include <string>
#include <sstream>
#include <fstream>
#include <algorithm>
using namespace std;
vector<string> regs = {"edx", "ecx", "ebx", "eax"};
extern Code code;

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


string nextInstr(){
	return ("l"+int_to_str(code.size()));
}
int nextInt(){
	return code.size();
}

vector<int> merge(vector<int> vec1, vector<int> vec2){
	vector<int> merged;
	vec1.insert(vec1.end(), vec2.begin(), vec2.end());
	sort(vec1.begin(), vec1.end());
	merged.push_back(vec1[0]);
	for (int i=1; i<vec1.size(); i++){
		if(vec1[i] != vec1[i-1])
			merged.push_back(vec1[i]);
	}
	cout << "merging " << vec1.size() << " " << vec2.size() << " " << merged.size() << endl;
	return merged;
}

void replaceAll( string &s, const string &search, const string &replace ) {
    for( size_t pos = 0; ; pos += replace.length() ) {
        // Locate the substring to replace
        pos = s.find( search, pos );
        if( pos == string::npos ) break;
        // Replace by erasing and inserting
        s.erase( pos, search.length() );
        s.insert( pos, replace );
    }
}

void backpatch(vector<int> vec, string jl){
	for(int i=0; i<vec.size(); i++){
		replaceAll(code.code_array[vec[i]], "_", jl);
	}
}

vector<int> makeList(int x){
	vector<int> l;
	l.push_back(x);
	return l;
}

void printCode(){
	cout<<"CODE::"<<endl;
	cout<<code.str()<<endl;
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
	for (int i = 0; i < children.size(); i++) children[i]->generate_code(st);
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
	first->generate_code(st);
	string sec = nextInstr();
	gencode(sec +":");
	cout << "truelist : ";
	for (int i = 0; i < first->TrueList.size(); i++) cout << first->TrueList[i] << " ";
	cout << " -> " << sec << endl;
	backpatch(first->TrueList, sec);
	second->generate_code(st);
	gencode("\t j(_);");
	vector<int> temp;
	temp.push_back(code.size()-1);
	
	string els = nextInstr();
	gencode(els+":");
	backpatch(first->FalseList, els);
	third->generate_code(st);
	string out = nextInstr();
	gencode(out+":");

	backpatch(temp, out);
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
	string start = nextInstr();
	gencode(start+":");
	
	left->generate_code(st);
	string stmt_instr = nextInstr();
	gencode(stmt_instr+":");
	right->generate_code(st);
	gencode("\t j("+start+");");
	string end = nextInstr();
	backpatch(left->FalseList, end);
	backpatch(left->TrueList, stmt_instr);
	gencode(end+":");	
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
	first->generate_code(st);
	string cond = nextInstr();
	gencode(cond+":");
	second->generate_code(st);
	string child_instr = nextInstr();
	gencode(child_instr+":");
	child->generate_code(st);
	third->generate_code(st);
	gencode("\t j("+cond+");");
	
	string end = nextInstr();
	backpatch(second->FalseList, end);
	backpatch(second->TrueList, child_instr);
	gencode(end+":");

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
	string left_reg, right_reg;
	string type = "";
	int regs_size = regs.size();
	if (left->type->basetype == Int)
		type = "i";
	else if (left->type->basetype == Int)
		type = "f";
	
	if (regs_size == 2) {
		gencode("\t push"+type+"("+ regs.back() +");    // pushing temporary storage");		
	}
	else {
		left_reg = regs.back();
		regs.pop_back();
	}

	if (opName == AND) {
		string sec = nextInstr();
		gencode(sec+":");
		right->generate_code(st);
		FalseList = merge(left->FalseList, right->FalseList);
		backpatch(left->TrueList, sec);
	}
	else if(opName == OR){
		string sec = nextInstr();
		gencode(sec+":");
		right->generate_code(st);
		TrueList = merge(left->TrueList, right->TrueList);
		FalseList = right->FalseList;
		backpatch(left->FalseList, sec);	
	}
	else if (type == "i" || type == "f"){
		right->generate_code(st);
		if(regs_size == 2){
			gencode("\t load"+type+"(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("\t pop"+type+"(1);");
			left_reg = regs[0];
			right_reg = regs[1];
		}
		else {
			right_reg = regs.back();
		}
		if (opName == MULT_INT || opName == MULT_FLOAT) gencode("\t mul"+type+"("+ left_reg  +", "+ right_reg +");");
		else if (opName == PLUS_INT || opName == PLUS_FLOAT) gencode("\t add"+type+"("+ left_reg +", "+ right_reg +");");
		else if (opName == MINUS_INT || opName == MINUS_FLOAT) {
			gencode("\t mul"+type+"(-1, "+ right_reg +");");
			gencode("\t add"+type+"("+ left_reg +", "+ right_reg +");");
		}
		else if (opName == DIV_INT || opName == DIV_FLOAT) gencode("\t div"+type+"("+ left_reg +", "+ right_reg +");");
		else if (opName == ASSIGN) {
			Ass * tempass = new Ass(left, right);
			tempass->generate_code(st);
		}
		else {
			//from here comp commands
			gencode("\t cmp"+type+"("+ left_reg +", "+ right_reg +");");
			TrueList.push_back(nextInt());
			FalseList.push_back(nextInt()+1);
			if (opName == EQ_OP_INT || opName == EQ_OP_FLOAT) gencode("\t je(_);");
			if (opName == NE_OP_INT || opName == NE_OP_FLOAT) gencode("\t jne(_);");
			if (opName == LT_INT || opName == LT_FLOAT) gencode("\t jl(_);");
			if (opName == LE_OP_INT || opName == LE_OP_FLOAT) gencode("\t jle(_);");
			if (opName == GT_INT || opName == GT_FLOAT) gencode("\t jg(_);");
			if (opName == GE_OP_INT || opName == GE_OP_FLOAT) gencode("\t jge(_);");
			gencode("\t j(_);");
		}
		
		if(regs_size > 2){
			regs.push_back(left_reg);
			swap();			
		}
	}
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
		if (o == ASSIGN || o == OR || o == AND) opName = o;
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
