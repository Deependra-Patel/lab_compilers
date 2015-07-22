all: clean lex.cc parse.cc main.cc Scanner.h Scannerbase.h Scanner.ih Parser.h Parserbase.h Parser.ih
	./sedscript
	g++   --std=c++0x lex.cc parse.cc main.cc abs.cpp SymbolTable.cpp;
	./a.out < testC > junk;

data: 
	@echo "\nOutput:"
	@grep printing junk > output1.scm
	@tr "#" "\n" < output1.scm > output.scm
	@cat output.scm	
	@grep Error:: junk 
	
        

lex.cc: lex.l Scanner.ih 
	./cond_remove_scannerh; 
	flexc++ lex.l; 
	sed -i '/int lex()/r enums' Scanner.h
	sed -i '/include/a #include "Parserbase.h"' Scanner.ih; 

parse.cc: parse.y Parser.ih Parser.h Parserbase.h
	bisonc++  parse.y;
	sed -i 's/#include <iomanip>/#include <iomanip> \n #include "abs.h" \n/g' Parserbase.h 
	sed -i 's/#include <iomanip>/#include <iomanip>\n#include <map>\n#include <fstream> \n SymbolTableEntry* ste; SymbolTable* st; map<string, SymbolTableEntry*> paramMap; Type* retType;\nGlobalTable *gt = new GlobalTable();\n Code code;\n int counter_global = 0;\nint offset = 0;\nint index = 0;\n std::ofstream myfile("code.asm"); \n /g' parse.cc

#	bisonc++   --construction -V parse.y; 
#	sed -i '/ifndef/a #include "tree_util.hh"' Parserbase.h;
#	sed -i '/ifndef/a #include "tree.hh"' Parserbase.h;
#	./sedscript
     

compile:  lex.cc parse.cc main.cc Scanner.h Scannerbase.h Scanner.ih Parser.h Parserbase.h Parser.ih
	g++   --std=c++0x lex.cc parse.cc main.cc abs.cpp SymbolTable.cpp;

Parser.ih: parse.y
Parser.h:  parse.y
Parserbase.h: parse.y
Scanner.ih: lex.l
Scanner.h: lex.l
Scannerbase.h: lex.l

clean:
	rm -f a.out lex.cc junk Parser* Scanner* parse.cc graph.ps graph.gv parse.y.output *~ output.scm

lex:   lex.cc  main.cc
		g++   --std=c++0x lex.cc main.cc
		make run

run:
	rm -f graph.gv graph.ps 
	echo "digraph G { " >> graph.gv
	./a.out < testC
	echo "}" >> graph.gv
	dot -Tps graph.gv -o graph.ps
	gnome-open graph.ps
plot:
	dot -Tps graph.gv -o graph.ps
	gnome-open graph.ps

l5: machine.cc code.asm
	g++  machine.cc -m32
	./a.out
