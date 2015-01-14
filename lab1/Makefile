all:
	@flexc++ lex.l
	@g++ -std=c++11 main.cpp lex.cc
	@./a.out <test | less
