#include "klee/ClapUtil.h"
#include <iostream>

std::string tname;

std::string getThreadName()
{
	return tname;
}
void setThreadName(std::string name)
{
	tname = name;
	//std::cout << "set thread name: " << name << "\n";
}
