#include <iostream>
#include <vector>
#include <string>
#include "SymbolTable.h"

using namespace std;

struct Code {
	vector<string> code_array;

	string str();
	int size();
	void clear();
};

void gencode(string);
void insert_locals(SymbolTable*);
void remove_locals(SymbolTable*);
void save_regs();
void load_regs();

enum opNameB{
	OR=1,
	AND=2,
	EQ_OP=3,
	EQ_OP_INT=4,
	EQ_OP_FLOAT=5,       
	NE_OP=6,
	NE_OP_INT=7,
	NE_OP_FLOAT=8,       
	LT=9,
	LT_INT=10,
	LT_FLOAT=11,
	LE_OP=12,
	LE_OP_INT=13,
	LE_OP_FLOAT=14, 
	GT=15,
	GT_INT=16,
	GT_FLOAT=17,
	GE_OP=18,
	GE_OP_INT=19,
	GE_OP_FLOAT=20, 
	PLUS=21,
	PLUS_INT=22,
	PLUS_FLOAT=23, 
	MINUS=24,  
	MINUS_INT=25,
	MINUS_FLOAT=26,
	MULT=27,
	MULT_INT=28,   
	MULT_FLOAT=29,
	DIV = 30,
	DIV_INT = 31,
	DIV_FLOAT = 32,
	ASSIGN=33,  
};


enum opNameU{
	UMINUS=34,
	UMINUS_INT=35,
	UMINUS_FLOAT=36,
	NOT=37,
	NOT_INT=38,
	NOT_FLOAT=39,
	PP=40,
	PP_INT=41,
	PP_FLOAT=42,
	TO_FLOAT=43,
	TO_INT=44
};

class symbolTable{
	
};

class basic_types {
	
};

class typeExp {
	
};


class abstract_astnode
{
 public:
  virtual void print () = 0;
  Type* type;
  virtual void generate_code(SymbolTable*) = 0;
  virtual string getClass() = 0;
  //virtual bool checkTypeofAST() = 0;
 protected:
  // virtual void setType(basic_types) = 0;
 private:
  typeExp astnode_type;
};

class StmtAst:public abstract_astnode{
 public:
	void generate_code(SymbolTable*) = 0;
	string getClass();
	void print () = 0;
};
class ExpAst:public abstract_astnode{
 public:	
	void generate_code(SymbolTable*) = 0;
	string getClass();
	void print () = 0;
	vector<int> FalseList, TrueList;
	bool Fall = true;
};
class ArrayRef: public ExpAst{
 public:
	void generate_code(SymbolTable*) = 0;
	string getClass();
	virtual void generate_code_addr(SymbolTable*) = 0;
	void print () = 0;
	//	virtual void makeBoolean() = 0;
};

class Seq:public StmtAst{
 protected:
  StmtAst *left, *right;
 public:
  	void generate_code(SymbolTable*);
	string getClass();
	void print();
	Seq();
	Seq(StmtAst* left, StmtAst* right);
};


class BlockStatement:public StmtAst{
 public:
	vector<StmtAst*> children;
	void print();
	BlockStatement();
	void generate_code(SymbolTable*);
	string getClass();
	BlockStatement(StmtAst*);
};



class Ass: public StmtAst{
  ExpAst* left, *right;
public:
  bool empty;
  void print();
  Ass();
  	void generate_code(SymbolTable*);
	string getClass();
	Ass(ExpAst* left, ExpAst* right);
};

class Return: public StmtAst{
  ExpAst * child;
 public:
  void print();
  Return();
	void generate_code(SymbolTable*);
	string getClass();
	Return(ExpAst*, Type *);
};

class If: public StmtAst{
  ExpAst * first;
  StmtAst * second, *third;
 public:
  void print();
  If();
	void generate_code(SymbolTable*);  
	string getClass();
  If(ExpAst*, StmtAst*, StmtAst*);
};


class While:public StmtAst{
  ExpAst * left;
  StmtAst * right;
 public:
  void print();
  While();
	void generate_code(SymbolTable*);  
	string getClass();
  While(ExpAst*, StmtAst*);
};


class For:public StmtAst{
  ExpAst * first, *second, *third;
  StmtAst * child;
 public:
  void print();
  For();
  	void generate_code(SymbolTable*);
	string getClass();
  For(ExpAst*, ExpAst*, ExpAst*, StmtAst*);
};

///////////////////////////////////////////////
class OpBinary:public ExpAst{
 public:
  ExpAst * left, *right;
  opNameB opName;
  void print();
  OpBinary();
  void setArguments(ExpAst*, ExpAst*);
  	void generate_code(SymbolTable*);
	string getClass();
  OpBinary(ExpAst*, ExpAst*, opNameB);
  OpBinary(opNameB);
  void makeBoolean();
};

class OpUnary:public ExpAst{
 public:
  ExpAst * child;
  opNameU opName;
  void print();
  OpUnary();
  OpUnary(ExpAst*, OpUnary*);
  OpUnary(ExpAst*, opNameU);
  	void generate_code(SymbolTable*);
	string getClass();
  OpUnary(opNameU);
  void makeBoolean();
};

class Funcall:public ExpAst{
 public:
  vector<ExpAst*> children;
  void print();
  Funcall();
  Funcall(vector<ExpAst*>);
  	void generate_code(SymbolTable*);
	string getClass();
  Funcall(ExpAst*);
};

class FloatConst:public ExpAst{
 public:
	float  child;
	void print();
	FloatConst();
  	void generate_code(SymbolTable*);
	string getClass();
	FloatConst(float x);
};

class IntConst:public ExpAst{
 public:
 int  child;
  void print();
  IntConst();
  	void generate_code(SymbolTable*);
	string getClass();
  IntConst(int x);
};

class StringConst:public ExpAst{
 public:
 string  child;
  void print();
  StringConst();
  	void generate_code(SymbolTable*);
	string getClass();
  StringConst(string x);
};

class Identifier:public ArrayRef{
 public:
 string  child;
  void print();
  Identifier();
  	void generate_code(SymbolTable*);
	string getClass();
	void generate_code_addr(SymbolTable *);
  Identifier(string x);
  //  void makeBoolean();
};

class Index:public ArrayRef{
  ArrayRef* left;
  ExpAst* right;
 public:
	string identifier_name;
  void print();
  Index();
  	void generate_code(SymbolTable*);
	string getClass();
	void generate_code_addr(SymbolTable *);
  Index(ArrayRef* left, ExpAst* right);
  Index(string s);
  // void makeBoolean();
};


ExpAst * make_boolean(ExpAst*);
void gen_bool(ExpAst *);
