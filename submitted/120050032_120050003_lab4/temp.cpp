#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include <stdio.h>
#include <iomanip>
#include <string>
using namespace std;

int function() {
	int a;
	{
		int b = 10;
		cout << b << endl;
		return b;
	}
}

int main()
{
    function();
    return 0;
}
