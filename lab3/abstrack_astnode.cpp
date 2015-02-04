#include <iostream>
using namespace std;

class symbolTable{
	
};

class basic_types {
	
};

class typeExp {
	
};

class abstract_astnode
{
public:
	virtual void print () = 0;
	virtual string generate_code(const symbolTable&) = 0;
	virtual basic_types getType() = 0;
	virtual bool checkTypeofAST() = 0;
protected:
	virtual void setType(basic_types) = 0;
private:
	typeExp astnode_type;
};

int main()
{
    cout << "No error" << endl;
    return 0;
}
