#include <cassert>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <utility>
#include <stdlib.h>

using namespace std;

int intValueOf(std::string i)
{
    int res;
    stringstream ss(i);
    ss >> res;
    
    return res;
}

int numConstraints = 0;
int numVariables = 0;
double solverTime = 0;
double checkTime = 0;
double executeTime = 0;
int solverInvokedNum = 0;

void sortPath() {
	ifstream fin;
	fin.open("CheckedPath");
	if (!fin.good()) {
		cerr << "Error: No file CheckedPath existing!\n";
		fin.close();
		return ;
	}

	char buf[10000];
	string str;
	vector<string> paths;
	while (!fin.eof()) {
		fin.getline(buf, 10000);
		str = buf;
		paths.push_back(str);
	}

	std::sort(paths.begin(), paths.end());
	
	std::ofstream outFile;
	outFile.open("SortedPath");
	if (!outFile.is_open()) {
		cerr << "-> Error opening file SortedPath" << ".\n";
		outFile.close();
		exit(1);
	}

	for (vector<string>::iterator it = paths.begin(); 
				it != paths.end(); ++it) {
		outFile << *it << "\n";
	}

}


int main() {
	std::string fileName = "result";
	ifstream fin;

	fin.open(fileName.c_str());
	if (!fin.good()) {
		cerr << "Error: No file x existing!\n";
		fin.close();
		return 0;
	}

	char buf[10000];
	string str;
	while (!fin.eof()) {
		fin.getline(buf, 10000);
		str = buf;
		if (str.find("CONSTRAINTS: ") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			numConstraints += intValueOf(ss);
		} else if (str.find("UNKNOWN VARS: ") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			numVariables += intValueOf(ss);
		} else if (str.find("Solver Time") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			solverTime += intValueOf(ss);
			//std::cerr << "solver time: " << solverTime << " " << ss << "\n";
		} else if (str.find("Symbolic Execution Time: ") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			executeTime += intValueOf(ss);
			//std::cerr << "elapsed Time: " << executeTime << " " << ss << "\n";
		} else if (str.find("Solver Invoked Num: ") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			solverInvokedNum += intValueOf(ss);
		} else if (str.find("Check Time") != std::string::npos) {
			string ss = str.substr(str.find(": ") + 2);
			checkTime += intValueOf(ss);
		}
	}	
	
	fin.close();
	std::cerr << "All Variables Num: " << numVariables << "\n";
	std::cerr << "All Constraints Num: " << numConstraints << "\n";
	std::cerr << "Solver Invoked Num: " << solverInvokedNum << "\n";
	std::cerr << "Solver Time: " << solverTime / 1000000 << "\n";
	std::cerr << "Check Time: " << checkTime / 1000000 << "\n";
	std::cerr << "Symbolic Execute Time: " << executeTime / 1000000 << "\n";

	sortPath();
	return 0;
}
