whitespace									[ \t\n]+

STRING_LITERAL								\"([^\\]|([\\][tn\"\\]))*\"
C-integer-constant-1						[1-9][0-9]*
C-integer-constant-2						0[bB][01]*
C-integer-constant-3						0[0-7]*
C-integer-constant-4						0[xX][0-9a-fA-F]*
integer-part								[0-9]*
fractional-part								[0-9]*
exponent-part								([eE][+-][0-9]*)|([eE][0-9]*)
floating-point-constant						[+-]?([0-9]+\.[0-9]*{exponent-part}?)|([0-9]*\.[0-9]+{exponent-part}?)
INT											int
FLOAT										float
IDENTIFIER									[[:alpha:]_][[:alpha:][:digit:]_]*
RETURN										return
OR_OP										"||"
AND_OP										"&&"
EQ_OP										"=="
NE_OP										"!="
LE_OP										"<="
GE_OP										">="
INC_OP										"++"
INT_CONSTANT									[+-]?({C-integer-constant-1}|{C-integer-constant-2}|{C-integer-constant-3}|{C-integer-constant-4})
FLOAT_CONSTANT									{floating-point-constant}
IF            								if
ELSE          								else
WHILE         								while
FOR           								for
symbols										['('')'',''['']''{''}'';''=''<''>'-'''+''*''/''!']

%%
{whitespace}		
{STRING_LITERAL}                        	return Parser::STRING_LITERAL;						
void										return Parser::VOID;
{INT}										return Parser::INT;
{FLOAT}                                 	return Parser::FLOAT;
{RETURN}	                               	return Parser::RETURN;
{OR_OP}                                 	return Parser::OR_OP;
{AND_OP}                                	return Parser::AND_OP;
{EQ_OP}                                 	return Parser::EQ_OP;
{NE_OP}                                 	return Parser::NE_OP;
{LE_OP}                                 	return Parser::LE_OP;
{GE_OP}                                 	return Parser::GE_OP;
{INC_OP}                                	return Parser::INC_OP;
{IF}                                    	return Parser::IF;
{ELSE}                                  	return Parser::ELSE;
{WHILE}                                 	return Parser::WHILE;
{FOR}                                   	return Parser::FOR;
{INT_CONSTANT}                             	return Parser::INT_CONSTANT;
{FLOAT_CONSTANT}                           	return Parser::FLOAT_CONSTANT;
{symbols}									return Scanner::matched()[0];
{IDENTIFIER}                            	return Parser::IDENTIFIER;
.                                           return Parser::OTHER;


// There may be some flexer directives here

//%%
//[ \t]                                    //skip
//(push|mov|and|sub)l|call|leave|ret          return Parser::MNEMONIC;
//(-?)[[:digit:]]+                            return Parser::NUMBER;
//"$"(-?)[[:digit:]]+                         return Parser::IMMNUMBER;  
//"%"(ebp|esp|edx|eax|esp)                    return Parser::REGISTER;     
//[[:alpha:]][[:alnum:]]*                     return Parser::SYMBOL;
//("."?)[[:alpha:]][[:alnum:]]*               return Parser::IMMSYMBOL;
//"+"                                         return Parser::'+';
//","                                         return Parser::',';
//"("                                         return Parser::'(';
//")"                                         return Parser::')';
//":"                                         return Parser::':';
//"\n"                                        return Parser::'\n';
//.                                           

