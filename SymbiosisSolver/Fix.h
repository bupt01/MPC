#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <string>

using namespace std;

class Fix {
	int beginLine;
	int endLine;
	string lock;
	string varName;

public:
	Fix (int bL, int eL, string l, string v) {
		beginLine = bL;
		endLine = eL;
		lock = l;
		varName = v;
	}
	
	int getBeginLine()	{	return beginLine;	}
	int getEndLine()	{	return endLine;		}
	string getLock()	{	return lock;		}
	string getVarName() {	return varName;		}
};
