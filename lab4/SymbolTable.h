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
	// enum Kind {
	// 	Base, Pointer, Error, Ok
	// };
	// enum Basetype {
	// 	Int, Float, Void
	// };
	Kind tag;
	union {
		Basetype basetype;
		Type* pointed;
	};
	Type();    // Default
	Type(Kind); // Error, Ok
	Type(Kind, Basetype); //Int, Float, Void
	Type(Kind, Type*);   // Pointer
	void Print();
	Type* copy();
};

struct SymbolTableEntry{
	int addr;
	Type* idType;
	SymbolTableEntry();
	SymbolTableEntry(int addr, Type* idType);
	void Print();
};

struct SymbolTable{
	map<string, SymbolTableEntry*> parameters;
	map<string, SymbolTableEntry*> localVariables;
	string funcName;
	Type * retType;

	SymbolTable(Type* retType, map<string, SymbolTableEntry*> parameters);
	SymbolTable();
	void addLocalVariable(string identifier, int addr, Type* identifierType);
	void Print();
};

struct globalTable{
	map<string, SymbolTable*> funcSymbolTable;
};

