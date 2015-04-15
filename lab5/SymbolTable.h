#include <iostream>
#include <map>
#include <string>

using namespace std;
enum Kind {
	Base, Pointer, Error, Ok
};
enum Basetype {
	Int, Float, Void
};

struct Type {
	int sizeType;
	Kind tag;
	union {
		Basetype basetype;
		Type* pointed;
	};
	Type();    // Default
	Type(Kind); // Error, Ok
	Type(Kind, Basetype); //Int, Float, Void
	Type(Kind, Type*);   // Pointer
	Type(Type*, Type*);
	void Print();
	bool equal(Type*);
	Type* copy();
	int size();
	bool isNumeric();
	void update(int);
	void print_size(string);
};

struct SymbolTableEntry{
	string name;
	int index;
	int addr;
	Type* idType;
	SymbolTableEntry();
	int size();
	SymbolTableEntry(int addr, Type* idType);
	SymbolTableEntry(int ,int addr, Type* idType, string name);
	void Print();
};

struct SymbolTable{
	map<string, SymbolTableEntry*> parameters;
	map<string, SymbolTableEntry*> localVariables;
	string funcName;
	Type * retType;

	Type* getType(string);
	SymbolTable(Type* retType, map<string, SymbolTableEntry*> parameters);
	SymbolTable();
	void addLocalVariable(string identifier, int addr, Type* identifierType);
	void Print();
	bool checkScope(string);
	Type * getParaByInd(int);
	void setOffsets();
	int getOffset(string);
};

struct GlobalTable{
	map<string, SymbolTable*> funcSymbolTable;
	void insert(SymbolTable*);
	Type* getRetType(string name);
};
