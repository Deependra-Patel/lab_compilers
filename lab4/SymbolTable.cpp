#include "SymbolTable.h"
#include <iostream>
using namespace std;
Type::Type(){}
Type::Type(Kind tag){
	this->tag = tag;
}
Type::Type(Kind tag, Basetype basetype){
	this->tag = tag;
	this->basetype = basetype;
}
Type::Type(Kind tag, Type* pointed){
	this->tag = tag;
	this->pointed = pointed;
}
void Type::Print(){
	cout<<"Kind: "<<tag<<"\nBasetype: "<<basetype<<endl;
}

Type* Type::copy(){
	Type * copied = new Type(tag, basetype);
	return copied;
}
int Type::size(){
	return 4;
}
SymbolTableEntry::SymbolTableEntry(){}
SymbolTableEntry::SymbolTableEntry(int addr, Type* idType){
	this->addr = addr;
	this->idType = idType;
}
void SymbolTableEntry::Print(){
	cout<<"Addr: "<<addr<<endl;
	idType->Print();
	cout<<endl;
}
SymbolTable::SymbolTable(){}
SymbolTable::SymbolTable(Type* retType, map<string, SymbolTableEntry*> parameters){
	this->retType = retType;
	this->parameters = parameters;
}

void SymbolTable::addLocalVariable(string identifier, int addr, Type* idType){
	SymbolTableEntry* param = new SymbolTableEntry(addr, idType);
	localVariables[identifier] = param;
}

void printMap(map<string, SymbolTableEntry*> myMap){
	for (std::map<string, SymbolTableEntry*>::iterator it=myMap.begin(); it!=myMap.end(); ++it){
	    cout << it->first << " => ";
	    it->second->Print();
	    cout<<endl;
	}	
}

void SymbolTable::Print(){
	cout<<"Function Name: "<<funcName<<"\nReturn Type: ";
	retType->Print();
	cout<<"Printing parameters: \n";	
	printMap(parameters);
	cout<<"Printing local variables: \n";
	printMap(localVariables);
}
