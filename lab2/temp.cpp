#include <iostream>
#include <vector>
#include <set>
#include <map>
#include <algorithm>
#include <stdio.h>
#include <iomanip>
#include <string>
#include <fstream>
using namespace std;


int main() {
	ofstream file;
	file.open("file.txt");
	file << "something" << endl;
	return 0;
}
