#include <iostream>
#include "Scanner.h"
#include "Parser.h"
using namespace std;
int main (int argc, char** arg)
{
  Parser parser;
  parser.parse();
  Scanner scanner;   // define a Scanner object
  while (int token = scanner.lex()) // get all tokens
    {
      string const &text = scanner.matched();
      switch (token){
		case Parser::MNEMONIC:
		  cout << "mnemonic: " << text << '\n';
		  break;
		case Parser::NUMBER:
			cout<<"number: "<< text <<endl;
			break;
		default:
			cout<<"Other: "<< text<<endl;
		}
	}
}


