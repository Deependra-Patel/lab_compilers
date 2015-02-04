#include <iostream>
#include "abs.h"
using namespace std;


Seq::Seq(){}
Seq::Seq(StmtAst* l, StmtAst* r){
	left = l;
	right = r;
};


Ass::Ass(){}
Ass::Ass(ExpAst* l, ExpAst* r){
	left = l;
	right = r;
};

int main()
{
	
    return 0;
}

