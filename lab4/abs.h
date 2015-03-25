#include <iostream>
#include <vector>
using namespace std;


enum opNameB{OR=1,
			 AND=2,
			 EQ_OP=3,
			 NE_OP=4,
			 LT=5,
			 LE_OP=6,
			 GT=7,
			 GE_OP=8,
			 PLUS=9,
			 MINUS=10,
			 MULT=11,
			 ASSIGN=12
};


enum opNameU{UMINUS=13,
			 NOT=14,
			 PP=15
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
 float  child;
 public:
  void print();
  FloatConst();
  FloatConst(float x);
};

class IntConst:public ExpAst{
 int  child;
 public:
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
 string  child;
 public:
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
  Index(ArrayRef* left, ExpAst* right, bool);
  Index(string s);
};
