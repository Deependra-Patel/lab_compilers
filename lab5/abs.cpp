#include <iostream>
#include "abs.h"
#include <string>
#include <sstream>
#include <fstream>
#include <algorithm>
using namespace std;
vector<string> regs = {"edx", "ecx", "ebx", "eax"};
vector<string> all_regs = {"edx", "ecx", "ebx", "eax"};
extern Code code;

extern ofstream myfile;


string int_to_str(int a) {
	stringstream ss;
	ss << a;
	return ss.str();
}

string float_to_str(double a) {
	stringstream ss;
	ss << a;
	int b = a;
	if (a == b) return ss.str()+".0";
	return ss.str();
}

void save_regs() {
	for (int i = 0; i < 4; i++) {
		gencode("    pushi("+ all_regs[i] +");");
	}
}

void load_regs() {
	for (int i = 3; i >= 0; i--) {
		gencode("    loadi(ind(esp), "+ all_regs[i] +");");
		gencode("    popi(1);");
	}
}

void gencode(string new_line) {
	code.code_array.push_back(new_line);
}

void insert_locals(SymbolTable * st) {
	int tot_size = 0;
	for (map<string, SymbolTableEntry *> :: iterator it = st->localVariables.begin(); it != st->localVariables.end(); it++) {
		cout << "inserting " << it->first << endl;
		tot_size += it->second->idType->size();
	}
	gencode("    addi("+ int_to_str(0-tot_size) +", esp);");
}


void remove_locals(SymbolTable * st) {
	int tot_size = 0;
	for (map<string, SymbolTableEntry *> :: iterator it = st->localVariables.begin(); it != st->localVariables.end(); it++) {
		cout << "inserting " << it->first << endl;
		tot_size += it->second->idType->size();
	}
	gencode("    popi("+int_to_str(tot_size/4)+");");
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
	if(vec1.size() >= 1)
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

ExpAst * make_boolean(ExpAst * exp) {
	string type = exp->getClass();
	string type_str = "";
	if (exp->type->tag == Base && exp->type->basetype == Int)
		type_str = "Int";
	else if (exp->type->tag == Base && exp->type->basetype == Float)
		type_str = "Float";
	bool do_it = false;
	if (type == "Identifier" || type == "Index") {
		do_it = true;
	}
	else if (type == "OpBinary") {
		OpBinary * new_opb = (OpBinary *) exp;
		if ((int)new_opb->opName >= 21 && (int)new_opb->opName <= 33) {
			do_it = true;
		}
	}
	else if (type == "OpUnary") {
		OpUnary * new_opu = (OpUnary *) exp;
		if ((int)new_opu->opName >= 37 && (int)new_opu->opName <= 39) {
			do_it = true;
		}
	}
	else if (type == "Funcall") do_it = true;
	if (!do_it) return exp;
	ExpAst * new_exp = exp;
	if (type_str == "Int")
		new_exp = new OpBinary(exp, new IntConst(0), NE_OP);
	else if (type_str == "Float")
		new_exp = new OpBinary(exp, new FloatConst(0), NE_OP);
	return new_exp;
}


void gen_bool(ExpAst * exp) {
	if (exp->getClass() == "OpBinary") {
		OpBinary * opb = (OpBinary *) exp;
		if ((int)opb->opName > 20) return;
	}
	else if (exp->getClass() == "OpUnary") {
		OpUnary * opu = (OpUnary *) exp;
		if ((int)opu->opName > 39 || (int)opu->opName < 37) return;
	}
	else return;
	
	string sec = nextInstr();
	gencode(sec +":");
	backpatch(exp->TrueList, sec);
	gencode("    move(1, "+ regs.back() +");");
	gencode("    j(_);");
	vector<int> temp;
	temp.push_back(code.size()-1);
	sec = nextInstr();
	gencode(sec +":");
	backpatch(exp->FalseList, sec);
	gencode("    move(0, "+ regs.back() +");");
	sec = nextInstr();
	gencode(sec +":");
	backpatch(temp, sec);
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

string Seq::getClass() {
	return "Seq";
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

string BlockStatement::getClass() {
	return "BlockStatement";
}

// for Ass
void Ass::generate_code(SymbolTable* st){
	cout << "errorhere " << endl;
	if (left == NULL && right == NULL) return;
	right->Fall = true;
	
	right->generate_code(st);
	gen_bool(right);
	if (left == NULL) return;
	ArrayRef* left1 = (ArrayRef *)left;
	if (regs.size() == 2) {
		if (right->type->basetype == Int) {
			gencode("    pushi("+ regs.back() +");    // pushing temporary storage");
			left1->generate_code_addr(st);
			gencode("    loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("    storei("+ regs[0] +", ind("+ regs.back() +"));");
		}
		else {
			gencode("    pushf("+ regs.back() +");    // pushing temporary storage");
			left1->generate_code_addr(st);
			gencode("    loadi(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("    storef("+ regs[0] +", ind("+ regs.back() +"));");
		}
	}
	else {
		string right_reg = regs.back();
		regs.pop_back();
		if (right->type->basetype == Int) {
			left1->generate_code_addr(st);
			gencode("    storei("+ right_reg +", ind("+ regs.back() +"));");
		}
		else {
			left1->generate_code_addr(st);
			gencode("    storef("+ right_reg +", ind("+ regs.back() +"));");
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

string Ass::getClass() {
	return "Ass";
}

// for Return
void Return::generate_code(SymbolTable* st){
	child->generate_code(st);
	if (st->retType->tag == Base && st->retType->basetype == Int) {
		gencode("    storei("+ regs.back() +", ind(ebp, "+ int_to_str(st->getReturnAddr()) +"));");
	}
	if (st->retType->tag == Base && st->retType->basetype == Float) {
		gencode("    storef("+ regs.back() +", ind(ebp, "+ int_to_str(st->getReturnAddr()) +"));");
	}
	gencode("    j(ret"+st->funcName+");");
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

string Return::getClass() {
	return "Return";
}

// for If
void If::generate_code(SymbolTable* st){
	first->Fall = true;
	first->generate_code(st);
	string sec = nextInstr();
	gencode(sec +":");
	backpatch(first->TrueList, sec);
	second->generate_code(st);
	gencode("    j(_);");
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
	first = make_boolean(f);
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

string If::getClass() {
	return "If";
}

// for While
void While::generate_code(SymbolTable* st){
	string start = nextInstr();
	gencode(start+":");
	left->Fall = true;
	left->generate_code(st);
	string stmt_instr = nextInstr();
	gencode(stmt_instr+":");
	right->generate_code(st);
	gencode("    j("+start+");");
	string end = nextInstr();
	backpatch(left->FalseList, end);
	backpatch(left->TrueList, stmt_instr);
	gencode(end+":");	
}
While::While() {
	
}
While::While(ExpAst* l, StmtAst* r) {
	left = make_boolean(l);
	right = r;
}

void While::print() {
	cout << "(While ";
	left->print();
	cout << " ";
	right->print();
	cout << ")";
}

string While::getClass() {
	return "While";
}

// for For
void For::generate_code(SymbolTable* st){
	first->generate_code(st);
	string cond = nextInstr();
	gencode(cond+":");
	second->Fall = true;
	second->generate_code(st);
	string child_instr = nextInstr();
	gencode(child_instr+":");
	child->generate_code(st);
	third->generate_code(st);
	gencode("    j("+cond+");");
	
	string end = nextInstr();
	backpatch(second->FalseList, end);
	backpatch(second->TrueList, child_instr);
	gencode(end+":");

}
For::For() {
	
}
For::For(ExpAst* f, ExpAst* s, ExpAst* t, StmtAst* c){
	first = f;
	second = make_boolean(s);
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

string For::getClass() {
	return "For";
}

void OpBinary::generate_code(SymbolTable* st){
	string left_reg, right_reg;
	string type = "";
	int regs_size = regs.size();
	if (left->type->basetype == Int)
		type = "i";
	else if (left->type->basetype == Float)
		type = "f";
   

	if (opName == AND) {
		left->Fall = true;
		left->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(left);
		string sec = nextInstr();
		gencode(sec+":");
		right->Fall = Fall;
		right->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(right);
		TrueList = right->TrueList;
		FalseList = merge(left->FalseList, right->FalseList);
		backpatch(left->TrueList, sec);
	}
	else if(opName == OR){
		left->Fall = false;
		left->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(left);
		string sec = nextInstr();
		gencode(sec+":");
		right->Fall = Fall;
		right->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(right);
		TrueList = merge(left->TrueList, right->TrueList);
		FalseList = right->FalseList;
		backpatch(left->FalseList, sec);	
	}
	else if (type == "i" || type == "f"){
		left->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(left);
		if (regs_size == 2) {
			gencode("    push"+type+"("+ regs.back() +");    // pushing temporary storage");		
		}
		else {
			left_reg = regs.back();
			regs.pop_back();
		}		
		right->generate_code(st);
		if (opName != AND && opName != OR) gen_bool(right);
		if(regs_size == 2){
			gencode("    load"+type+"(ind(esp), "+ regs[0] +");    // loading temporary storage");
			gencode("    pop"+type+"(1);");
			left_reg = regs[0];
			right_reg = regs[1];
		}
		else {
			right_reg = regs.back();
		}
		if (opName == MULT_INT || opName == MULT_FLOAT) gencode("    mul"+type+"("+ left_reg  +", "+ right_reg +");");
		else if (opName == PLUS_INT || opName == PLUS_FLOAT) gencode("    add"+type+"("+ left_reg +", "+ right_reg +");");
		else if (opName == MINUS_INT || opName == MINUS_FLOAT) {
			gencode("    mul"+type+"(-1, "+ right_reg +");");
			gencode("    add"+type+"("+ left_reg +", "+ right_reg +");");
		}
		else if (opName == DIV_INT || opName == DIV_FLOAT) gencode("    div"+type+"("+ left_reg +", "+ right_reg +");");
		else if (opName == ASSIGN) {
			Ass * tempass = new Ass(left, right);
			tempass->generate_code(st);
		}
		else {
			//from here comp commands
			if (!Fall){
				gencode("    cmp"+type+"("+ left_reg +", "+ right_reg +");");
				TrueList.push_back(nextInt());
				if (opName == EQ_OP_INT || opName == EQ_OP_FLOAT) gencode("    je(_);");
				if (opName == NE_OP_INT || opName == NE_OP_FLOAT) gencode("    jne(_);");
				if (opName == LT_INT || opName == LT_FLOAT) gencode("    jl(_);");
				if (opName == LE_OP_INT || opName == LE_OP_FLOAT) gencode("    jle(_);");
				if (opName == GT_INT || opName == GT_FLOAT) gencode("    jg(_);");
				if (opName == GE_OP_INT || opName == GE_OP_FLOAT) gencode("    jge(_);");
				//gencode("    j(_);");
			}
			else {
				gencode("    cmp"+type+"("+ left_reg +", "+ right_reg +");");
				FalseList.push_back(nextInt());
				if (opName == EQ_OP_INT || opName == EQ_OP_FLOAT) gencode("    jne(_);");
				if (opName == NE_OP_INT || opName == NE_OP_FLOAT) gencode("    je(_);");
				if (opName == LT_INT || opName == LT_FLOAT) gencode("    jge(_);");
				if (opName == LE_OP_INT || opName == LE_OP_FLOAT) gencode("    jg(_);");
				if (opName == GT_INT || opName == GT_FLOAT) gencode("    jle(_);");
				if (opName == GE_OP_INT || opName == GE_OP_FLOAT) gencode("    jl(_);");
			}
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
	if (o == OR || o == AND) {
		x = make_boolean(x);
		y = make_boolean(y);
	}
		cout << "printing1" << endl;
		x->print();
		cout << endl;
		y->print();
		cout << endl;
		cout << o << endl;
	type = new Type();
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
		cout << "printinghere "  << endl;
		right->print();
		cout << endl;
	}	
}



void OpBinary::print(){
	cout<<"("<<inverse_enum[opName] << " ";
  left->print();
  cout<<" ";
  right->print();
  cout<<")";
}

string OpBinary::getClass() {
	return "OpBinary";
}



void OpUnary::generate_code(SymbolTable* st){
	string type = "";
	if(child->type->basetype == Int)
		type = "i";
	else if(child->type->basetype == Float)
		type = "f";
	if (opName ==  PP_INT || opName == PP_FLOAT){
		((ArrayRef*)child)->generate_code_addr(st);
		gencode("    load"+type+"(ind("+regs.back()+"), "+regs[0]+");");
		if (type == "i") gencode("    add"+type+"(1, "+regs[0]+");");
		else gencode("    add"+type+"(1.0, "+regs[0]+");");
		gencode("    store"+type+"("+regs[0]+", ind("+regs.back()+"));");
		if (type == "i") gencode("    add"+type+"(-1, "+regs[0]+");");
		else gencode("    add"+type+"(-1.0, "+regs[0]+");");
		gencode("    move("+regs[0]+", "+regs.back()+");");
	}
	if (opName ==  UMINUS_INT || opName == UMINUS_FLOAT){
		child->generate_code(st);
		gen_bool(child);
		gencode("    mul"+type+"(-1, "+regs.back()+");");
	}
	else if(opName == NOT || opName == NOT_INT || opName == NOT_FLOAT){
		child->generate_code(st);
		TrueList = child->FalseList;
		FalseList = child->TrueList;
	}
	else if(opName == TO_FLOAT) {
		child->generate_code(st);
		gencode("    intTofloat("+ regs.back() +");");
	}
	else if(opName == TO_INT) {
		child->generate_code(st);
		gencode("    floatToint("+ regs.back() +");");
	}
	//return "";
}
OpUnary::OpUnary(){}
OpUnary::OpUnary(opNameU e){
  opName = e;
}
OpUnary::OpUnary(ExpAst*x, opNameU e) {
	if (e >= 37 && e <= 39) x = make_boolean(x);
	child = x;
	type = x->type;
	opName = e;
	if(e == PP){
		if (x->type->basetype == Int)
			opName = PP_INT;
		else if(x->type->basetype == Float){
			opName = PP_FLOAT;
		}
		else
			type = new Type(Error);
	}
	if(e == UMINUS){
		if (x->type->basetype == Int)
			opName = UMINUS_INT;
		else if(x->type->basetype == Float){
			opName = UMINUS_FLOAT;
		}
		else
			type = new Type(Error);
	}
	if(e == NOT){
		if (x->type->basetype == Int)
			opName = NOT_INT;
		else if(x->type->basetype == Float){
			opName = NOT_FLOAT;
		}
		else
			type = new Type(Error);
	}
}
OpUnary::OpUnary(ExpAst * x, OpUnary* y) {
	opName = y->opName;
	child = x;
	type = x->type;
}
void OpUnary::print(){
	cout<<"("<<inverse_enum[opName] << " ";
	child->print();
  cout<<")";
}

string OpUnary::getClass() {
	return "OpUnary";
}

extern GlobalTable* gt;

void Funcall::generate_code(SymbolTable* st){
	string calledFunc = ((Identifier *)children[0])->child;
	if (calledFunc == "print") {
		children[1]->generate_code(st);
		gencode("    cout << \"printing "+((Identifier *)children[1])->child+": \";");
		if (children[1]->type->tag == Base && children[1]->type->basetype == Int) gencode("    print_int("+regs.back()+");");
		if (children[1]->type->tag == Base && children[1]->type->basetype == Float) gencode("    print_float("+regs.back()+");");
		gencode("    cout << endl;");
		return;
	}
	if (gt->getRetType(calledFunc)->basetype == Int)
		gencode("    pushi(1); //return");
	else if (gt->getRetType(calledFunc)->basetype == Float)
		gencode("    pushf(1); //return");
	else if (gt->getRetType(calledFunc)->basetype == Void)
		gencode("    pushi(0); //return ");
	int tot_size = 0;
	for (int i = children.size()-1; i>0; i--){
		tot_size += children[i]->type->size();
		children[i]->generate_code(st);
		gen_bool(children[i]);
		Basetype childBtype = children[i]->type->getBasetype();
		if (children[i]->type->tag == Pointer) {
			string typestr = "";
			if (childBtype == Int) typestr = "i";
			else if(childBtype == Float) typestr = "f";
			int nbytes = children[i]->type->size();
			for (int i = nbytes-4; i >= 0; i-=4) {
				gencode("    load"+typestr+"(ind("+regs.back()+", "+int_to_str(i)+"), "+regs[0]+");");
				gencode("    push"+typestr+"("+regs[0]+");");
			}
		}
		else if(children[i]->type->tag == Base) {
			if (childBtype == Int) gencode("    pushi("+ regs.back() +");");
			else if(childBtype == Float) gencode("    pushf("+ regs.back() +");");
		}
	}
	gencode("    "+calledFunc+"();");
	gencode("    popi("+ int_to_str(tot_size/4) +");");
	gencode("    loadi(ind(esp), "+ regs.back() +");");
	gencode("    popi(1);");
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

string Funcall::getClass() {
	return "Funcall";
}


void FloatConst::generate_code(SymbolTable* st){
	gencode("    move("+ float_to_str(child) +", "+ regs.back() +");");
	//return "";
}
FloatConst::FloatConst(float x){
  child = x;
  type = new Type(Base, Float);
}
void FloatConst::print(){
  cout<<"(FloatConst "<<child<<")";
}

string FloatConst::getClass() {
	return "FloatConst";
}

void IntConst::generate_code(SymbolTable* st){
	gencode("    move("+ int_to_str(child) +", "+ regs.back() +");");
	//return "";
}
IntConst::IntConst(){}
IntConst::IntConst(int x){
  child = x;
  type = new Type(Base, Int);
}
void IntConst::print(){
  cout<<"(IntConst "<<child<<")";
}

string IntConst::getClass() {
	return "IntConst";
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

string StringConst::getClass() {
	return "StringConst";
}

void Identifier::generate_code( SymbolTable* st){
	if (st->checkScope(child)) {
		Type * tp = st->getType(child);
		int offset = st->getOffset(child);
		string offset_str = int_to_str(offset);
		if (tp->tag == Base && tp->basetype == Int) gencode("    loadi(ind(ebp, "+ offset_str +"), "+ regs.back() +");");
		else if (tp->tag == Base && tp->basetype == Float) gencode("    loadf(ind(ebp, "+ offset_str +"), "+ regs.back() +");");
		else if (tp->tag == Pointer) {
			gencode("    move("+ offset_str +", "+ regs.back() +");");
			gencode("    addi(ebp,"+ regs.back() +");");
		}
	}
}


void Identifier::generate_code_addr( SymbolTable* st){
	if (st->checkScope(child)) {
		Type * tp = st->getType(child);
		int offset = st->getOffset(child);
		string offset_str = int_to_str(offset);
		gencode("    move("+ offset_str +", "+ regs.back() +");");
		gencode("    addi(ebp,"+ regs.back() +");");
	}
}

Identifier::Identifier(){}
Identifier::Identifier(string x){
  child = x;
}
void Identifier::print(){
  cout<<"(Identifier "<<child<<")";
}

string Identifier::getClass() {
	return "Identifier";
}


void Index::generate_code(SymbolTable* st){
	left->generate_code(st);
	if (regs.size() == 2) {
		gencode("    pushi("+ regs.back() +");");
		right->generate_code(st);
		gencode("    loadi(ind(esp), "+ regs[0] +");");
		gencode("    muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("    addi("+ regs[0] +", "+ regs.back() +"); ");
		if (type->tag == Base) {
			if (type->basetype == Int) {
				gencode("    loadi(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
			else if (type->basetype == Float) {
				gencode("    loadf(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
		}
		gencode("    popi(1);");
	}
	else {
		string left_reg = regs.back();
		regs.pop_back();
		right->generate_code(st);
		gencode("    muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("    addi("+ left_reg +", "+ regs.back() +"); ");
		if (type->tag == Base) {
			if (type->basetype == Int) {
				gencode("    loadi(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
			else if (type->basetype == Float) {
				gencode("    loadf(ind("+ regs.back() +"), "+ regs.back() +"); ");
			}
		}
		regs.push_back(left_reg);
		swap();
	}
}


void Index::generate_code_addr(SymbolTable* st){
	left->generate_code(st);
	if (regs.size() == 2) {
		gencode("    pushi("+ regs.back() +");");
		right->generate_code(st);
		gencode("    loadi(ind(esp), "+ regs[0] +");");
		gencode("    muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("    addi("+ regs[0] +", "+ regs.back() +"); ");
		gencode("    popi(1);");
	}
	else {
		string left_reg = regs.back();
		regs.pop_back();
		right->generate_code(st);
		gencode("    muli("+ int_to_str(type->size()) +", "+ regs.back() +"); ");
		gencode("    addi("+ left_reg +", "+ regs.back() +"); ");
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

string Index::getClass() {
	return "Index";
}

string StmtAst::getClass() {
	return "StmtAst";
}

string ExpAst::getClass() {
	return "ExpAst";
}

string ArrayRef::getClass() {
	return "ArrayRef";
}
