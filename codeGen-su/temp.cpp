#include <iostream>
#include <stdio.h>
using namespace std;
float sum(float i, float j){
	int l; 
	l = 3 * 4;
	return i + j;	
}

int factorial(int n){
	if(n <= 0){
		return 1;
	} else {
		return n * factorial(n-1);
	}
}

int main(){
	int i, k, j, l;
	int Ar[10][5];
	float f;
	Ar[1][0] = 1;

	/** checking Arrays and function calls, register save */
	f = sum(3.0,Ar[1][0]);
	printf("%f\n",f);
	l = Ar[Ar[1][0]][0];
	printf("%d\n",l);
	f = l + f; 
	printf("%f\n",f);
	
	/** checking recursion */
	i = factorial(6);
	printf("%d\n",i);

	/* checking long expressions, should not crash */
	l = 8;
	i = 4;
	k = 23;
	j = i * l + k * l / 5 - l;
	l =  i + i + l + k + j + (j*k + l);
	printf("%d\n",l);
	
	/** checking while,for loops and conditional operations*/
	i = 0;
	l = 0;
	while(l < 4){
		printf("%d lllll\n",l);
		for (k = 0; k < 10; k++){
			if(!(k == 5 || l ) && i > 10) {
				printf("%d\n",k);
				printf("%d\n",l);
				printf("%d\n",i);
			}
			else
				i = i + k;							
		}
		l = l+1;
	}
	printf("%d lllllll\n",i);

	/** checking Plus plus */
	i = 0;
	printf("%d\n",i);
	i++;
	printf("%d\n",i);

	/** checking assignment of relational operations */
	i = (l == 4 && i > 0);
	if(i)
		printf("%d\n",i);
	else
		i = i;

	/* checking Constant folding and propagation */
	i = 2 + 3 * 5.0;
	printf("%d\n",i);
}
