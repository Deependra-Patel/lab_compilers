#include "SymbolTable.h"
#include <iostream>
#include <string>
using namespace std;
Type::Type(){}
Type::Type(Type* left, Type* right){
	if (left->tag == Error || right->tag == Error){
		cout<<"Error Not Ok";
	}
}
bool Type::equal(Type* other){
	if (tag != other->tag)
		return false;
	if (tag == Base)
		return (basetype == other->basetype);
	if (tag == Pointer){
		if (sizeType != other->sizeType)
			return false;
		else return pointed->equal(other->pointed);
	}
}
bool Type::isNumeric(){
	if(tag == Base && (basetype == Int || basetype == Float)){
		return true;
	}
	else return false;
}

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
	cout<<"Kind: "<<tag<<"#Basetype: "<<basetype<<"#Size: "<<size()<<"#";
	if (tag == Pointer) cout << pointed->size() << "#";
}

Type* Type::copy(){
	Type * copied = new Type(tag, basetype);
	if (tag == Pointer) copied->pointed = pointed->copy();
	return copied;
}
int Type::size() {
	if (tag == Base) {
		if (basetype == Void)
			return 0;
		return 4;
	}
	else if (tag == Pointer){
		return sizeType*pointed->size();
	}
}

void Type::update(int s) {
	if (tag == Base) {
		tag = Pointer;
		pointed = new Type(Base, basetype);
		sizeType = s;
	}
	else pointed->update(s);
}

void Type::print_size(string offset) {
	if (tag == Base) cout << offset << basetype << endl;
	else {
		cout << offset << sizeType << endl;
		pointed->print_size(offset+"  ");
	}
}

Basetype Type::getBasetype() {
	if (tag == Base) return basetype;
	else if (tag == Pointer) return pointed->getBasetype();
	return Void;
}

SymbolTableEntry::SymbolTableEntry(){}
SymbolTableEntry::SymbolTableEntry(int addr, Type* idType){
	this->addr = addr;
	this->idType = idType;
}
void SymbolTable::setOffsets(){
	for (std::map<string, SymbolTableEntry*>::iterator it=localVariables.begin(); it!=localVariables.end(); ++it){
	    it->second->addr = -(it->second->addr + it->second->size());
	}
}
SymbolTableEntry::SymbolTableEntry(int ind, int addr, Type* idType, string name){
	this->name = name;
	this->addr = addr;
	this->idType = idType;
	index = ind;
}
int SymbolTableEntry::size(){
	return idType->size();
}
void SymbolTableEntry::Print(){
	cout<<"Offset: "<<addr<<"#";
	idType->Print();
	cout<<"#";
}
SymbolTable::SymbolTable(){
	returnAddr = -1;
}
SymbolTable::SymbolTable(Type* retType, map<string, SymbolTableEntry*> parameters){
	this->retType = retType;
	this->parameters = parameters;
	returnAddr = -1;
}

void SymbolTable::addLocalVariable(string identifier, int addr, Type* idType){
	SymbolTableEntry* param = new SymbolTableEntry(addr, idType);
	localVariables[identifier] = param;
}

int SymbolTable::getOffset(string varname) {
	if (parameters.find(varname) != parameters.end()) return parameters[varname]->addr;
	if (localVariables.find(varname) != localVariables.end()) return localVariables[varname]->addr;
	return 0;
}

void printMap(map<string, SymbolTableEntry*> myMap){
	for (std::map<string, SymbolTableEntry*>::iterator it=myMap.begin(); it!=myMap.end(); ++it){
	    cout << it->first << " => ";
	    it->second->Print();
	    cout<<"#";
	}	
}

bool SymbolTable::checkScope(string var){
	if (parameters.find(var)!=parameters.end() || localVariables.find(var)!=localVariables.end())
		return true;
	else return false;
}


Type * SymbolTable::getParaByInd(int i) {
	for (map<string, SymbolTableEntry*>::iterator it = parameters.begin(); it != parameters.end(); it++) {
		if ((it->second)->index == i) {
			return (it->second)->idType;
		}
	}
}

Type* SymbolTable::getType(string var){
	if (parameters.find(var) != parameters.end())
		return parameters[var]->idType;
	else if(localVariables.find(var) != localVariables.end()){
		localVariables[var]->idType->Print();
		return localVariables[var]->idType;	
	}
}

void SymbolTable::Print(){
	cout<<"##SymbolTable::# Function Name: "<<funcName<<"#Return Type: ";
	retType->Print();
	cout<<"#Printing parameters: #";	
	printMap(parameters);
	cout<<"#Printing local variables: #";
	printMap(localVariables);
}

int SymbolTable::getReturnAddr() {
	cout << "getting"<< endl;
	if (returnAddr != -1) return returnAddr;
	returnAddr = 4;
	for (map<string, SymbolTableEntry *>::iterator it = parameters.begin(); it != parameters.end(); it++) {
		if (returnAddr < it->second->addr+it->second->size())
			returnAddr = it->second->addr+it->second->size();
	}
	return returnAddr;
}

void GlobalTable::insert(SymbolTable* st){
	funcSymbolTable[st->funcName] = st;
}

Type* GlobalTable::getRetType(string str){
	return funcSymbolTable[str]->retType;
}

