#include <iostream>
using namespace std;

int main(){
	double a = 0.01;
	double b = 23.1;
	if (a<b && a)
		a = 2;
	cout << (a&&b) << endl;
}
