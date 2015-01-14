#include <iostream>
#include "Scanner.h"

int main(void)
{
	Scanner scanner;
	while(scanner.lex());
	return 0;
}
