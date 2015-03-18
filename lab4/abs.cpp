#include <iostream>
#include "abs.h"
#include <string>
#include "SymbolTable.h"
using namespace std;

string inverse_enum[] = {
	"",
	"OR",
	"AND",
	"EQ_OP",
	"NE_OP",
	"LT",
	"LE_OP",
	"GT",
	"GE_OP",
	"PLUS",
	"MINUS",
	"MULT",
	"ASSIGN",
	"UMINUS",
	"NOT",
	"PP"
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
	left = l;
	right = r;
	empty = false;
};

void Ass::print(){
	if (empty) {
		cout << "(Empty)";
		return ;
	}
	cout << "(Ass ";
	left->print();
	cout << " ";
	right->print();
	cout << ")";
}

// for Return
Return::Return() {
	
}
Return::Return(ExpAst* c) {
	child = c;
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
	left = x;
	right = y;
	opName = o;
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
void Index::print(){
  cout<<"(Index ";
  left->print();
  cout<<" ";
  right->print();
  cout<<")";
}
