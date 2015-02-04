all:    lex.cc parse.cc main.cc Scanner.h Scannerbase.h Scanner.ih Parser.h Parserbase.h Parser.ih
	g++   --std=c++0x lex.cc parse.cc main.cc;
	./a.out < test-assembly > junk;
	egrep 'nextToken|reduce' junk
        

lex.cc: lex.l Scanner.ih 
	./cond_remove_scannerh; 
	flexc++ lex.l; 
	sed -i '/int lex()/r enums' Scanner.h
	sed -i '/include/a #include "Parserbase.h"' Scanner.ih; 

parse.cc: parse.y Parser.ih Parser.h Parserbase.h
	bisonc++  parse.y; 
	sed -i 's/#include <iomanip>/#include <iomanip>\n#include <fstream>\nint counter_global = 0;\n std::ofstream myfile("graph.gv", std::ofstream::out | std::ofstream::app); \n /g' parse.cc

#	bisonc++   --construction -V parse.y; 
#	sed -i '/ifndef/a #include "tree_util.hh"' Parserbase.h;
#	sed -i '/ifndef/a #include "tree.hh"' Parserbase.h;
#	./sedscript
     

Parser.ih: parse.y
Parser.h:  parse.y
Parserbase.h: parse.y
Scanner.ih: lex.l
Scanner.h: lex.l
Scannerbase.h: lex.l

distClean:
	rm -f a.out lex.cc junk Parser* Scanner* parse.cc graph.ps graph.gv parse.y.output

lex:   lex.cc  main.cc
		g++   --std=c++0x lex.cc main.cc
		make run

run:
	rm -f graph.gv graph.ps
	echo "digraph G { " >> graph.gv
	./a.out < test-assembly
	echo "}" >> graph.gv
	dot -Tps graph.gv -o graph.ps
	gnome-open graph.ps
plot:
	dot -Tps graph.gv -o graph.ps
	gnome-open graph.ps