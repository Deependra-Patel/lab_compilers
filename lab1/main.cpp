#include <iostream>
#include "Scanner.h"
using namespace std;
int main()
{
  Scanner scanner;   // define a Scanner object
  while (int token = scanner.lex()) // get all tokens
    {
      string const &text = scanner.matched();
      switch (token){
		case Scanner::IDENTIFIER:
		  cout << "identifier: " << text << '\n';
		  break;
		case Scanner::SYMBOL:
			cout<<"Symbol: "<< text <<endl;
			break;
		case Scanner::VOID:
			cout<<"void: "<< text <<endl;
			break;
		case Scanner::INT:
			cout<<"int: "<< text <<endl;
			break;
		case Scanner::FLOAT:
			cout<<"float: "<< text <<endl;
			break;
		case Scanner::OR_OP:
			cout<<"or: "<< text <<endl;
			break;
		case Scanner::AND_OP:
			cout<<"and: "<< text <<endl;
			break;
		case Scanner::EQ_OP:
			cout<<"equal: "<< text <<endl;
			break;
		case Scanner::NE_OP:
			cout<<"not equal: "<< text <<endl;
			break;
		case Scanner::LE_OP:
			cout<<"less than: "<< text <<endl;
			break;
		case Scanner::INC_OP:
			cout<<"increment: "<< text <<endl;
			break;
		case Scanner::INT_CONST:
			cout<<"int const: "<< text <<endl;
			break;
		case Scanner::FLOAT_CONST:
			cout<<"float const: "<< text <<endl;
			break;
		case Scanner::STRING_LITERAL:
			cout<<"string const: "<< text <<endl;
			break;
		case Scanner::IF:
			cout<<"if: "<< text <<endl;
			break;
		case Scanner::ELSE:
			cout<<"else: "<< text <<endl;
			break;
		case Scanner::WHILE:
			cout<<"while: "<< text <<endl;
			break;
		case Scanner::FOR:
			cout<<"for: "<< text <<endl;
			break;
		case Scanner::RETURN:
			cout<<"return : "<< text <<endl;
			break;
		default:
		  cout << "char. token: `" << text << "'\n";
		}
    }
}
