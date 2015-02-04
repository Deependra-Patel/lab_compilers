#include <vector>
class abstract_astnode
{
 public:
  virtual void print () = 0;
  virtual std::string generate_code(const symbolTable&) = 0;
  virtual basic_types getType() = 0;
  virtual bool checkTypeofAST() = 0;
 protected:
  virtual void setType(basic_types) = 0;
 private:
  typeExp astnode_type;
};

class StmtAst:abstract_astnode{
};
class ExpAst:abstract_astnode{
};
class ArrayRef:ExpAst{
};

class Seq:StmtAst{
  StmtAst* left, right;
 public:
  void print();
  Seq();
  Seq(StmtAst* left, StmtAst* right);
};

class Ass:StmtAst{
  ExpAst* left, right;
 public:
  void print();
  Ass();
  Ass(ExpAst* left, ExpAst* right);
};

class Return:StmtAst{
  ExpAst * child;
 public:
  void print();
  Return();
  Return(ExpAst*);
};

class If:StmtAst{
  ExpAst * first;
  StmtAst * second, third;
 public:
  void print();
  If();
  If(ExpAst*, StmtAst*, StmtAst*);
};


class While:StmtAst{
  ExpAst * left;
  StmtAst * right;
 public:
  void print();
  While();
  While(ExpAst*, StmtAst*);
};


class For:StmtAst{
  ExpAst * first, second, third;
  StmtAst * child;
 public:
  void print();
  For();
  For(ExpAst*, ExpAst*, ExpAst*, StmtAst*);
};

///////////////////////////////////////////////
class Op:ExpAst{
  ExpAst * left, right;
  enum opName;
 public:
  void print();
  Op();
  Op(ExpAst*, ExpAst*, enum);
};

class Op:ExpAst{
  ExpAst * child;
  enum opName;
 public:
  void print();
  Op(ExpAst*, enum);
};

class Funcall:ExpAst{
  vector<ExpAst*> children;
 public:
  void print();
  Funcall();
  Funcall(vector<ExpAst*>);
};

class FloatConst:ExpAst{
 float  child;
 public:
  void print();
  FloatConst(){}
  FloatConst(float x);
};

class IntConst:ExpAst{
 int  child;
 public:
  void print();
  IntConst(){}
  IntConst(int x);
};

class StringConst:ExpAst{
 string  child;
 public:
  void print();
  StringConst(){}
  StringConst(string x);
};

class Identifier:ExpAst{
 string  child;
 public:
  void print();
  Identifier(){}
  Identifier(string x);
};

class Identifier:ArrayRef{
 string  child;
 public:
  void print();
  Identifier(){}
  Identifier(string x);
};

class Index:ExpAst{
  ArrayRef* left;
  ExpAst* right;
 public:
  void print();
  Index(){}
  Index(ArrayRef* left, ExpAst* right);
};
