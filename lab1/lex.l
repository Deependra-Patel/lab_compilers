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
VOID										void
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
INT_CONST									[+-]?({C-integer-constant-1}|{C-integer-constant-2}|{C-integer-constant-3}|{C-integer-constant-4})
FLOAT_CONST									{floating-point-constant}
IF            								if
ELSE          								else
WHILE         								while
FOR           								for
symbols										['('')'',''['']''{''}'';''=''<''>'-'''+''*''/''!']

%%
{whitespace}		
{STRING_LITERAL}                        	return STRING_LITERAL;						
{VOID}										return VOID;
{INT}										return INT;
{FLOAT}                                 	return FLOAT;
{RETURN}                                	return RETURN;
{OR_OP}                                 	return OR_OP;
{AND_OP}                                	return AND_OP;
{EQ_OP}                                 	return EQ_OP;
{NE_OP}                                 	return NE_OP;
{LE_OP}                                 	return LE_OP;
{GE_OP}                                 	return GE_OP;
{INC_OP}                                	return INC_OP;
{IF}                                    	return IF;
{ELSE}                                  	return ELSE;
{WHILE}                                 	return WHILE;
{FOR}                                   	return FOR;
{INT_CONST}                             	return INT_CONST;
{FLOAT_CONST}                           	return FLOAT_CONST;
{symbols}									return SYMBOL;
{IDENTIFIER}                            	return IDENTIFIER;
.                                           return OTHER;
