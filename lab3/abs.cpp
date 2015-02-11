#include <iostream>
#include "abs.h"
using namespace std;


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

// for Ass
Ass::Ass(){}
Ass::Ass(ExpAst* l, ExpAst* r){
	left = l;
	right = r;
};

void Ass::print(){
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
	cout << ")";
}

OpBinary::OpBinary(){};
OpBinary::OpBinary(ExpAst* left, ExpAst* right, opNameE e){
  opName = e;
}
void OpBinary::print(){
  cout<<"( "<<opName;
  left->print();
  cout<<" ";
  right->print();
  cout<<")"<<endl;
}

OpUnary::OpUnary(){}
OpUnary::OpUnary(ExpAst* x, opNameE e){
  child = x;
  opName = e;
}
void OpUnary::print(){
  cout<<"( "<<opName;
  child->print();
  cout<<")"<<endl;
}

Funcall::Funcall(){}
Funcall::Funcall(vector<ExpAst*> exps){
  children = exps;
}
void Funcall::print(){
  cout<<"(Funcall ";
  int l = children.size();
  for(int i = 0; i<l; i++){
    children[i]->print();
    cout<<" ";
  }
  cout<<")"<<endl;
}

FloatConst::FloatConst(float x){
  child = x;
}
void FloatConst::print(){
  cout<<"FloatConst "<<child<<")";
}

IntConst::IntConst(){}
IntConst::IntConst(int x){
  child = x;
}
void IntConst::print(){
  cout<<"IntConst "<<child<<")";
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
  cout<<"(INDEX";
  left->print();
  cout<<" ";
  right->print();
  cout<<")"<<endl;
}

int main()
{
	
    return 0;
}

