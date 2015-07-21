## Compiler
This was a cumulative project in which we kept adding features after each lab(1-5).<br />
There are two versions for this due to algorithms used for registor allocation in lab5:<br />
#### 1. codeGen-greedy: ####
<b>n</b> = no. of registers currently available<br />
<b>if n>2</b> allocate register to left child first and evaluate it, then allocate n-1 to right child then evaluate <br />
<b> else if n = 2</b> allocate both to left child, evaluate it then store that in memory. Allocate both to right child, and get result<br />
#### 2. codeGen-su: ####
<b>Sethi ullman</b> is used for allocating registers.
## Run
Go to respective codeGen-greedy/codeGen-su folder and see the README.txt
## Compilers lab
cs304<br />
Authors:<br />
Deependra Patel<br />
Anurag Shirolkar


