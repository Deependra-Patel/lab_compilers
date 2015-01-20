all:    lex.cc  main.cpp	
		g++   --std=c++0x lex.cc main.cpp
		make run

run:
	./a.out < test

lex.cc: lex.l 
	./cond_remove_scannerh
	flexc++ lex.l 
	sed -i '/int lex()/r enums' Scanner.h

push: 
	rm -f a.out
	rm .*.swp
