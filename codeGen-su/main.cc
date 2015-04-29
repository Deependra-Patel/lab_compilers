#include <iostream>
#include <stdio.h>
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
      // switch (token){
	  // 	case Parser::MNEMONIC:
	  // 	  cout << "mnemonic: " << text << '\n';
	  // 	  break;
	  // 	case Parser::NUMBER:
	  // 		cout<<"number: "<< text <<endl;
	  // 		break;
	  // 	default:
	  // 		cout<<"Other: "<< text<<endl;
	  // 	}
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
			cout<<"less than equal: "<< text <<endl;
			break;
		case Scanner::GE_OP:
			cout<<"greater than equal: "<< text <<endl;
			break;			
		case Scanner::INC_OP:
			cout<<"increment: "<< text <<endl;
			break;
		case Scanner::INT_CONSTANT:
			cout<<"int const: "<< text <<endl;
			break;
		case Scanner::FLOAT_CONSTANT:
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


