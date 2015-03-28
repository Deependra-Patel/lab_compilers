#include <iostream>
#include <vector>
#include "SymbolTable.h"
using namespace std;


enum opNameB{OR=1,
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
			 ASSIGN=30,  
};


enum opNameU{
  UMINUS=31,
  UMINUS_INT=32,
  UMINUS_FLOAT=33,
	NOT=34,
  NOT_INT=35,
  NOT_FLOAT=36,
	PP=37,
  PP_INT=38,
  PP_FLOAT=39,
  TO_FLOAT=40,
  TO_INT=41
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
  //virtual std::string generate_code(const symbolTable&) = 0;
  //virtual basic_types getType() = 0;
  //virtual bool checkTypeofAST() = 0;
 protected:
  // virtual void setType(basic_types) = 0;
 private:
  typeExp astnode_type;
};

class StmtAst:public abstract_astnode{
 public:	
  void print () = 0;
};
class ExpAst:public abstract_astnode{
 public:	
  void print () = 0;
};
class ArrayRef: public ExpAst{
 public:	
  void print () = 0;
};

class Seq:public StmtAst{
 protected:
  StmtAst *left, *right;
 public:
  void print();
  Seq();
  Seq(StmtAst* left, StmtAst* right);
};


class BlockStatement:public StmtAst{
 public:
	vector<StmtAst*> children;
 public:
  void print();
  BlockStatement();
  BlockStatement(StmtAst*);
};



class Ass: public StmtAst{
  ExpAst* left, *right;
 public:
  bool empty;
  void print();
  Ass();
  Ass(ExpAst* left, ExpAst* right);
};

class Return: public StmtAst{
  ExpAst * child;
 public:
  void print();
  Return();
  Return(ExpAst*);
};

class If: public StmtAst{
  ExpAst * first;
  StmtAst * second, *third;
 public:
  void print();
  If();
  If(ExpAst*, StmtAst*, StmtAst*);
};


class While:public StmtAst{
  ExpAst * left;
  StmtAst * right;
 public:
  void print();
  While();
  While(ExpAst*, StmtAst*);
};


class For:public StmtAst{
  ExpAst * first, *second, *third;
  StmtAst * child;
 public:
  void print();
  For();
  For(ExpAst*, ExpAst*, ExpAst*, StmtAst*);
};

///////////////////////////////////////////////
class OpBinary:public ExpAst{
  ExpAst * left, *right;
  opNameB opName;
 public:
  void print();
  OpBinary();
  void setArguments(ExpAst*, ExpAst*);
  OpBinary(ExpAst*, ExpAst*, opNameB);
  OpBinary(opNameB);
};

class OpUnary:public ExpAst{
  ExpAst * child;
  opNameU opName;
 public:
  void print();
  OpUnary();
  OpUnary(ExpAst*, OpUnary*);
  OpUnary(ExpAst*, opNameU);
  OpUnary(opNameU);
};

class Funcall:public ExpAst{
 public:
  vector<ExpAst*> children;
  void print();
  Funcall();
  Funcall(vector<ExpAst*>);
  Funcall(ExpAst*);
};

class FloatConst:public ExpAst{
 public:
 float  child;
  void print();
  FloatConst();
  FloatConst(float x);
};

class IntConst:public ExpAst{
 public:
 int  child;
  void print();
  IntConst();
  IntConst(int x);
};

class StringConst:public ExpAst{
 string  child;
 public:
  void print();
  StringConst();
  StringConst(string x);
};

class Identifier:public ArrayRef{
 public:
 string  child;
  void print();
  Identifier();
  Identifier(string x);
};

class Index:public ArrayRef{
  ArrayRef* left;
  ExpAst* right;
 public:
	string identifier_name;
  void print();
  Index();
  Index(ArrayRef* left, ExpAst* right);
  Index(string s);
};
