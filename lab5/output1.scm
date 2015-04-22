printing1
printing1
##SymbolTable::# Function Name: sum#Return Type: Kind: 0#Basetype: 1#Size: 4##Printing parameters: #i => Offset: 4#Kind: 0#Basetype: 1#Size: 4###j => Offset: 8#Kind: 0#Basetype: 1#Size: 4####Printing local variables: #l => Offset: -4#Kind: 0#Basetype: 0#Size: 4###printing: (Block [(Ass (Identifier l) (MULT_INT (IntConst 3) (IntConst 4))) (Return (PLUS_FLOAT (Identifier i) (Identifier j)))])errorhere 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 1#Size: 4#Kind: 0#Basetype: 1#Size: 4#printing type 
printing1
printing1
printing1
##SymbolTable::# Function Name: factorial#Return Type: Kind: 0#Basetype: 0#Size: 4##Printing parameters: #n => Offset: 4#Kind: 0#Basetype: 0#Size: 4####Printing local variables: #printing: (Block [(If (LE_OP_INT (Identifier n) (IntConst 0)) (Block [(Return (IntConst 1))]) (Block [(Return (MULT_INT (Identifier n) (Funcall (Identifier factorial) (MINUS_INT (Identifier n) (IntConst 1)))))]))])something
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
printing1
##SymbolTable::# Function Name: main#Return Type: Kind: 0#Basetype: 2#Size: 0##Printing parameters: ##Printing local variables: #Ar => Offset: -216#Kind: 1#Basetype: 29761824#Size: 200#20###f => Offset: -220#Kind: 0#Basetype: 1#Size: 4###i => Offset: -4#Kind: 0#Basetype: 0#Size: 4###j => Offset: -12#Kind: 0#Basetype: 0#Size: 4###k => Offset: -8#Kind: 0#Basetype: 0#Size: 4###l => Offset: -16#Kind: 0#Basetype: 0#Size: 4###printing: (Block [(Ass (Index (Index (Identifier Ar) (IntConst 1)) (IntConst 0)) (IntConst 1)) (Ass (Identifier f) (Funcall (Identifier sum) (FloatConst 3) (TO_FLOAT (Index (Index (Identifier Ar) (IntConst 1)) (IntConst 0))))) (Empty) (Ass (Identifier l) (Index (Index (Identifier Ar) (Index (Index (Identifier Ar) (IntConst 1)) (IntConst 0))) (IntConst 0))) (Empty) (Ass (Identifier f) (PLUS_FLOAT (TO_FLOAT (Identifier l)) (Identifier f))) (Ass (Funcall (Identifier print) (Identifier f))) (Ass (Identifier i) (Funcall (Identifier factorial) (IntConst 6))) (Ass (Funcall (Identifier print) (Identifier i))) (Ass (Identifier l) (IntConst 8)) (Ass (Identifier i) (IntConst 4)) (Ass (Identifier k) (IntConst 23)) (Ass (Identifier j) (MINUS_INT (PLUS_INT (MULT_INT (Identifier i) (Identifier l)) (DIV_INT (MULT_INT (Identifier k) (Identifier l)) (IntConst 5))) (Identifier l))) (Ass (Identifier l) (PLUS_INT (PLUS_INT (PLUS_INT (PLUS_INT (PLUS_INT (Identifier i) (Identifier i)) (Identifier l)) (Identifier k)) (Identifier j)) (PLUS_INT (MULT_INT (Identifier j) (Identifier k)) (Identifier l)))) (Ass (Funcall (Identifier print) (Identifier l))) (Ass (Identifier i) (IntConst 0)) (Ass (Identifier l) (IntConst 0)) (While (LT_INT (Identifier l) (IntConst 4)) (Block [(Ass (Funcall (Identifier print) (Identifier l))) (For (ASSIGN (Identifier k) (IntConst 0)) (LT_INT (Identifier k) (IntConst 10)) (PP_INT (Identifier k)) (Block [(If (AND (NOT_INT (OR (EQ_OP_INT (Identifier k) (IntConst 5)) (NE_OP_INT (Identifier l) (IntConst 0)))) (GT_INT (Identifier i) (IntConst 10))) (Block [(Ass (Funcall (Identifier print) (Identifier k))) (Empty) (Ass (Funcall (Identifier print) (Identifier i)))]) (Ass (Identifier i) (PLUS_INT (Identifier i) (Identifier k))))])) (Ass (Identifier l) (PLUS_INT (Identifier l) (IntConst 1)))])) (Ass (Funcall (Identifier print) (Identifier i))) (Ass (Identifier i) (IntConst 0)) (Ass (Funcall (Identifier print) (Identifier i))) (Ass (PP_INT (Identifier i))) (Ass (Funcall (Identifier print) (Identifier i))) (Ass (Identifier i) (AND (EQ_OP_INT (Identifier l) (IntConst 4)) (GT_INT (Identifier i) (IntConst 0)))) (If (NE_OP_INT (Identifier i) (IntConst 0)) (Ass (Funcall (Identifier print) (Identifier i))) (Ass (Identifier i) (Identifier i))) (Ass (Identifier i) (TO_INT (PLUS_FLOAT (TO_FLOAT (IntConst 2)) (MULT_FLOAT (TO_FLOAT (IntConst 3)) (FloatConst 5))))) (Ass (Funcall (Identifier print) (Identifier i)))])errorhere 
Kind: 0#Basetype: 1#Size: 4#Kind: 0#Basetype: 1#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 0#Size: 4#Kind: 0#Basetype: 0#Size: 4#printing type 
Kind: 0#Basetype: 1#Size: 4#Kind: 0#Basetype: 1#Size: 4#printing type 
Kind: 0#Basetype: 1#Size: 4#Kind: 0#Basetype: 1#Size: 4#printing type 
