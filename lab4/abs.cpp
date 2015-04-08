#include <iostream>
#include "abs.h"
#include <string>
using namespace std;

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

FloatConst::FloatConst(float x){
  child = x;
}
void FloatConst::print(){
  cout<<"(FloatConst "<<child<<")";
}

IntConst::IntConst(){}
IntConst::IntConst(int x){
  child = x;
}
void IntConst::print(){
  cout<<"(IntConst "<<child<<")";
}

StringConst::StringConst(string x){
  child = x;
}
void StringConst::print(){
  cout<<"(StringConst "<<child<<")";
}


Identifier::Identifier(){}
Identifier::Identifier(string x){
  child = x;
}
void Identifier::print(){
  cout<<"(Identifier "<<child<<")";
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
