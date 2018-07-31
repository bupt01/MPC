//
//  Z3Solver.cpp
//  symbiosisSolver
//
//  Created by Nuno Machado on 03/01/14.
//  Copyright (c) 2014 Nuno Machado. All rights reserved.
//

#include "Z3Solver.h"
#include "Util.h"
#include "Parameters.h"
#include "Schedule.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <signal.h>
#include <cassert>
#include <map>
#include <algorithm>
#include <sys/timeb.h>
#include <sys/time.h>

#define LINEMAX 256

using namespace std;

long long getSystemTime() {
	struct timeb t;
	ftime(&t);
	return 1000 * t.time + t.millitm;
}

string Time = "30";

Z3Solver::Z3Solver()
{
    numOps = 0;
    
    //create a process running Z3 and the corresponding pipes for inter-proces communication
    //string z3ExePath = solverPath+" -T:30 -smt2 -in ";
    string z3ExePath = solverPath+" -T:" + Time + " -smt2 -in ";
    char *command = (char *)z3ExePath.c_str();
    
    z3pid = util::popen2(command, &procW, &procR);
    
    cout << "[Solver] Init solver... " << z3ExePath << "\n";
    cout << "[Solver] create Z3 pid " << z3pid << endl;
    if (!z3pid)
    {
        perror("Problems with pipe");
        exit(1);
    }
}

void Z3Solver::reStart() {
	//create a process running Z3 and the corresponding pipes for inter-proces communication
	//string z3ExePath = solverPath+" -T:30 -smt2 -in ";
    string z3ExePath = solverPath+" -T:" + Time + " -smt2 -in ";
	char *command = (char *)z3ExePath.c_str();

	z3pid = util::popen2(command, &procW, &procR);

	cout << "[Solver] restart solver...\n";
	cout << "[Solver] create Z3 pid " << z3pid << endl;
	if (!z3pid)
	{
		perror("Problems with pipe");
		exit(1);
	}
}

void Z3Solver::openOutputFile()
{
    //open file in output mode and deleting previous content
    z3File.open(formulaFile, ios::trunc);
    cout << "Opening file: " << formulaFile << endl;
    if(!z3File.is_open())
    {
        cerr << " -> Error opening file "<< formulaFile <<".\n";
        z3File.close();
        exit(1);
    }
    
    //set Z3 options
    //writeLineZ3("(set-option :fixedpoint.try_minimize_core true)");
    writeLineZ3("(set-option :produce-unsat-cores true)");
}

void Z3Solver::openInputFile()
{
    //open file in input mode and deleting previous content
    z3File.open(formulaFile, ios::trunc);
    cout << "Opening file: " << formulaFile << endl;
    if(!z3File.is_open())
    {
        cerr << " -> Error opening file "<< formulaFile <<".\n";
        z3File.close();
        exit(1);
    }
    
    //set Z3 options
    writeLineZ3("(set-option :produce-unsat-cores true)");
}


string Z3Solver::readLinePipe()
{
    string ret;
    char c[1000000/*LINEMAX*/];
    read(procR,c,1);
	while(c[0]!='\n')
    {
        ret = ret + c[0];
        read(procR,c,1);
    }
    
    return ret;
}


string getOpDefinition(string line)
{
    int posBegin = (int)line.find("(define-fun ") + 12;  //place posBegin in the first char of the order operation
    int posEnd = (int)line.find("()") - 1;               //place posEnd in the last char of the order operation    
    return line.substr(posBegin, posEnd-posBegin);
}


bool Z3Solver::checkSat_yqp()
{
	vector<string> globalOrderTmp (numOps+30000); //order of execution of each operation (we add a little extra room to account for errors in the parsing)
	string line;
	string opName;                   //indicates the name of the operation
	bool isOrderOp = false;          //indicates that we have parsed an order constraint, thus we need to read its value
	bool isReadOp = false;           //indicates that we have parsed an read operation, thus we need to read its value
	map<string, string> readValues;  //map read operation -> read value
	bool isSat = false;

	unsatCoreStr.clear();
	solutionValues.clear();
	std::vector<std::string> allOperations; // yqp

	ifstream fin;
	fin.open((formulaFile + "_solution").c_str());
	
	char buf[1000000];
	string ss;
	while (!fin.eof() && 
				line.compare("end") != 0 && line.compare("end") != 1)
	{
		if(!line.compare("unsat")) {
			cout << "[Solver] Model Satisfiability: "<< line << endl;
		}
		if(!line.compare("sat")) {
			cout << "[Solver] Model Satisfiability: "<< line << endl;
			isSat = true;
			endTime = time(NULL);

		} else if(line.find("(define-fun") != std::string::npos) { //its an operation definition
			opName = getOpDefinition(line);
			if(opName.front()=='O')
			  isOrderOp = true;
			else if((opName.front()=='R' && opName.find("R-") != std::string::npos) || 
						opName.find("InitR-") != std::string::npos){
				isReadOp = true;
				fin.getline(buf, 1000000);
				line = buf;
				int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
				int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
				string value = line.substr(posBegin, posEnd-posBegin);
                if (line.find("(-") != std::string::npos) 
                    value = "-" + value;
				solutionValues.insert(std::pair<string,string>(opName,value));
			}
			
		} else if(isOrderOp) {//its an index for a previous read variable definition
			int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
			int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
			string index = line.substr(posBegin, posEnd-posBegin);
			std::stringstream s_str(index);
			int ind;
			s_str >> ind;
			globalOrderTmp[ind] = opName;
			isOrderOp = false;
			allOperations.push_back(opName);
		} else if(isReadOp) {
			int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
			int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
			string index = line.substr(posBegin, posEnd-posBegin);
			readValues[opName] = index;//stoi(index);
			isReadOp = false;
		} //else 
       
        if(line.find("error")!=std::string::npos) {//something wrong happened
			cout << "[Solver] " << line << endl;
		} else if(line.find("PC") !=std::string::npos
					|| line.find("RWC")!=std::string::npos
					|| line.find("Aviso")!=std::string::npos
					|| line.find("solution")!=std::string::npos
					|| line.find("LC")!=std::string::npos) {//get unsat core     

			if(saveUnsatCore) {
				while (line.find("PC") != string::npos) {
					line = line.substr(line.find("PC"));
					if (line.find(" ") != string::npos) {
						string id = line.substr(0, line.find(" "));
						line = line.substr(line.find(" ")+1);
						unsatCoreStr.insert(id);
					} else if (line.find(")") != string::npos) {
						string id = line.substr(0, line.find(")"));
						unsatCoreStr.insert(id);
						break;
					}
				}
			}

			//save the unsat core if in bug-fixing mode
			if(bugFixMode) {
				unsatCore.clear();
				size_t found = line.find("solution");
				while(found!=std::string::npos) {
					size_t end = line.find_first_of(" ",found+1);
					string sub = line.substr(found,end-found);
					string id = sub.substr(sub.find("n")+1);
					unsatCore.push_back(util::intValueOf(id)); //store the label id of each solution constraint in the unsat core
					found = line.find("solution", found+8);
				}
				//** insert the second operation of the last constraint as well (it might be needed)
				int lastConst = unsatCore.front();
				unsatCore.push_back(lastConst+1);
			}
			
		}
		fin.getline(buf, 1000000);
		line = buf;
	}
	fin.close();

	if(isSat) {
		double solvingTime = difftime(endTime, startTime);//(double)(endTime-startTime)/(double) CLOCKS_PER_SEC;
		cout << "[Solver] Solution found in "<< solvingTime<<"s:\n\n";
		scheduleLIB::loadSchedule(globalOrderTmp); // can be failScheduleOrd or altScheduleOrd depending on the boolean flag bugFixMode
	}

	// yqp
	std::map<string, string> newSolution;
	for (std::map<string, string>::iterator it = solutionValues.begin();
				it != solutionValues.end(); ++it) {
		std::string str = it->first;
		bool flag = false;
		for (std::vector<std::string>::iterator it2 = allOperations.begin();
					it2 != allOperations.end(); ++it2) {
			if (it2->find(str) != string::npos) {
				std::string str2 = *it2;
				str2 = str2.substr(str2.find(str));
				newSolution[str2] = it->second;
				flag = true;
				break;
			}
		}
		
		if (!flag) {
			newSolution[str] = it->second;
		}
	}
	
	solutionValues.clear();
	solutionValues.insert(newSolution.begin(), newSolution.end());
	
	return isSat;
}


/*
 *  Parses the solver output. If the model is satisfiable, return true and write the solution to file.
 *  Otherwise, return false and store the unsat core in a variable.
 */
bool Z3Solver::checkSat()
{
	vector<string> globalOrderTmp (numOps+20000); //order of execution of each operation (we add a little extra room to account for errors in the parsing)
	string line;
	string opName;                   //indicates the name of the operation
	bool isOrderOp = false;          //indicates that we have parsed an order constraint, thus we need to read its value
	bool isReadOp = false;           //indicates that we have parsed an read operation, thus we need to read its value
	map<string, string> readValues;  //map read operation -> read value
	bool isSat = false;

	unsatCoreStr.clear();
	solutionValues.clear();
	std::vector<std::string> allOperations; // yqp
	while (line.compare("end") != 0 && line.compare("end") != 1)
	{
		if(!line.compare("unsat")) {
			cout << "[Solver] Model Satisfiability: "<< line << endl;
		}
		if(!line.compare("sat")) {
			cout << "[Solver] Model Satisfiability: "<< line << endl;
			isSat = true;
			endTime = time(NULL);

		} else if(line.find("(define-fun") != std::string::npos) { //its an operation definition
			opName = getOpDefinition(line);
			if(opName.front()=='O')
			  isOrderOp = true;
			else if((opName.front()=='R' && opName.find("R-") != std::string::npos) || 
						opName.find("InitR-") != std::string::npos){
				isReadOp = true;
				line = readLinePipe();
				int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
				int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
				string value = line.substr(posBegin, posEnd-posBegin);
				solutionValues.insert(std::pair<string,string>(opName,value));
			}
			
		} else if(isOrderOp) {//its an index for a previous read variable definition
			int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
			int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
			string index = line.substr(posBegin, posEnd-posBegin);
			std::stringstream s_str(index);
			int ind;
			s_str >> ind;
			globalOrderTmp[ind] = opName;
			isOrderOp = false;
			allOperations.push_back(opName);
		} else if(isReadOp) {
			int posBegin = (int)line.find_last_of(" ") + 1;  //place posBegin in the first char of the value
			int posEnd = (int)line.find_last_of(")");        //place posEnd in the last char of the value
			string index = line.substr(posBegin, posEnd-posBegin);
			readValues[opName] = index;//stoi(index);
			isReadOp = false;
		} else if(line.find("error")!=std::string::npos) {//something wrong happened
			cout << "[Solver] " << line << endl;
		} else if(line.find("PC") !=std::string::npos
					|| line.find("RWC")!=std::string::npos
					|| line.find("Aviso")!=std::string::npos
					|| line.find("solution")!=std::string::npos
					|| line.find("LC")!=std::string::npos) {//get unsat core     

			if(saveUnsatCore) {
				while (line.find("PC") != string::npos || 
							line.find("RWC") != string::npos) {
					if (line.find("RWC") != std::string::npos)
					  line = line.substr(line.find("RWC"));
					else
					  line = line.substr(line.find("PC"));

					if (line.find(" ") != string::npos) {
						string id = line.substr(0, line.find(" "));
						line = line.substr(line.find(" ")+1);
						unsatCoreStr.insert(id);
					} else if (line.find(")") != string::npos) {
						string id = line.substr(0, line.find(")"));
						unsatCoreStr.insert(id);
						break;
					}
				}
			}

			//save the unsat core if in bug-fixing mode
			if(bugFixMode) {
				unsatCore.clear();
				size_t found = line.find("solution");
				while(found!=std::string::npos) {
					size_t end = line.find_first_of(" ",found+1);
					string sub = line.substr(found,end-found);
					string id = sub.substr(sub.find("n")+1);
					unsatCore.push_back(util::intValueOf(id)); //store the label id of each solution constraint in the unsat core
					found = line.find("solution", found+8);
				}
				//** insert the second operation of the last constraint as well (it might be needed)
				int lastConst = unsatCore.front();
				unsatCore.push_back(lastConst+1);
			}
			
		}
		line = readLinePipe();
		if (line == "") { 
			timeout = true;
			reStart();
			return false;
		}
	}

	if(isSat) {
		double solvingTime = difftime(endTime, startTime);//(double)(endTime-startTime)/(double) CLOCKS_PER_SEC;
		cout << "[Solver] Solution found in "<< solvingTime<<"s:\n\n";
		scheduleLIB::loadSchedule(globalOrderTmp); // can be failScheduleOrd or altScheduleOrd depending on the boolean flag bugFixMode
	}

	// yqp
	std::map<string, string> newSolution;
	for (std::map<string, string>::iterator it = solutionValues.begin();
				it != solutionValues.end(); ++it) {
		std::string str = it->first;
		bool flag = false;
		for (std::vector<std::string>::iterator it2 = allOperations.begin();
					it2 != allOperations.end(); ++it2) {
			if (it2->find(str) != string::npos) {
				std::string str2 = *it2;
				str2 = str2.substr(str2.find(str));
				newSolution[str2] = it->second;
				flag = true;
				break;
			}
		}
		
		if (!flag) {
			newSolution[str] = it->second;
		}
	}
	
	solutionValues.clear();
	solutionValues.insert(newSolution.begin(), newSolution.end());
	
	return isSat;
}

bool Z3Solver::solve_yqp()
{
	timeout = false;
	struct timeval startday, endday;
	long long start=getSystemTime();	
	gettimeofday(&startday, NULL);
    writeLineZ3("(check-sat)\n");
    writeLineZ3("(get-model)\n");
    writeLineZ3("(get-unsat-core)\n");
    writeLineZ3("(echo \"end\")\n(reset)\n");
    z3File.close();
    
    //** open input file again to read every line (this is needed because, for some reason.., writing the constraints directly into the pipe stops before reaching the end, for large constraint models)
	//std::string cmd = "nohup z3 -T:30 -smt2 " + formulaFile + " > " + formulaFile + "_solution";
    clock_t b = clock();
	std::string cmd = "nohup z3 -T:" + Time + " -smt2 " + formulaFile + " > " + formulaFile + "_solution";
	system(cmd.c_str());
	startTime = time(NULL);
  
    bool success = checkSat_yqp();
    cmd = "rm " + formulaFile + " " + formulaFile + "_solution -rf";
    system(cmd.c_str());
	
	long long end = getSystemTime();
	gettimeofday(&endday, NULL);
	int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
		endday.tv_usec - startday.tv_usec; 
	//printf("Solver Time3: %d us\n", timeuse);
    return success;
}


bool Z3Solver::solve()
{
	timeout = false;
	struct timeval startday, endday;
	long long start=getSystemTime();	
	gettimeofday(&startday, NULL);
    writeLineZ3("(check-sat)\n");
    writeLineZ3("(get-model)\n");
    writeLineZ3("(get-unsat-core)\n");
    writeLineZ3("(echo \"end\")\n(reset)\n");
    z3File.close();
    
    //** open input file again to read every line (this is needed because, for some reason.., writing the constraints directly into the pipe stops before reaching the end, for large constraint models)
    ifstream infile(formulaFile);
    string line;
    while (getline(infile, line))
    {
        write(procW, line.c_str(), line.length());
    }
    startTime = time(NULL);
    infile.close();
  
    bool success = checkSat();
	
	long long end = getSystemTime();
	gettimeofday(&endday, NULL);
	int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
		endday.tv_usec - startday.tv_usec; 
    return success;
}

/* Read input file containing the constraint model, then invert the bug condition
 * and add the solution schedule as extra constraints. The unsat core indicates the
 * event window that causes the bug.
 *
 */
bool Z3Solver::solveWithSolution(vector<string> solution, bool invertBugCond)
{
    //** open input file again to read every line (this is needed because, for some reason.., writing the constraints directly in the pipe stops before reaching the end, for large constraint models)
    ifstream infile(formulaFile);
    string line;
    while (getline(infile, line))
    {
        //** invert bug condition if requested
        if(invertBugCond && line.find("BUGCOND")!=std::string::npos)
        {
            size_t init = line.find_first_of("!")+1;
            size_t end = line.find_first_of(":");
            string cond = line.substr(init, end-init);
            string newcond = line.substr(0,init) + " (= false "+cond+")" + line.substr(end);
            
            write(procW, newcond.c_str(), newcond.length());
            
            //** store the operations in the bug condition into 'bugCondOps'
            init = cond.find_first_of("RW");
            end = cond.find_first_of(" )",init);
            while(init!=std::string::npos)
            {
                string op = cond.substr(init,end-init);
                bugCondOps.push_back(op);
                init = cond.find_first_of("RW",init+op.length());
                end = cond.find_first_of(" )",init);
            }
        }
        //** add solution constraints before asking to solve
        else if(line.find("(check-sat)")!=std::string::npos)
        {
            for(int i = 0; i < solution.size(); i++)
            {
                if(i < solution.size()-1)
                {
                    string solConst = "(assert (! (< "+solution[i]+" "+solution[i+1]+" ):named solution"+util::stringValueOf(i)+"))\n";
                    write(procW, solConst.c_str(), solConst.length());
                }
            }
            write(procW, line.c_str(), line.length());
        }
        else
        {
            write(procW, line.c_str(), line.length());
        }
    }
    startTime = time(NULL);
    infile.close();
    
    numOps = (int)solution.size();
    bool success = checkSat();
    
    return success;
}

void Z3Solver::closeZ3()
{
    writeLineZ3("(exit)");
    close(procR);
    close(procW);
    cerr << ">> Killing Z3 pid "<< z3pid <<" and "<< (z3pid+1) << endl;
    kill(z3pid,SIGKILL);
    //kill(z3pid+1,SIGKILL);//** Nuno: apparently, the process created has always PID=z3pid+1, so we must increment the pid in order to kill it properly (yqp)
}

void Z3Solver::reset()
{
    operationsVars.clear();
    orderVars.clear();
    numOps = 0;
    threadIds.clear();
    
}

void Z3Solver::writeLineZ3(string content)
{
    content = content + "\n";
    z3File << content;
}

string Z3Solver::writeLineZ3_yqp(string content)
{
    content = content + "\n";
    return content;
}

int Z3Solver::getNumOps(){
    return numOps;
}

void Z3Solver::setNumOps(int n){
    numOps = n;
}


string Z3Solver::cAnd(string exp1, string exp2) {
    return "(and "+exp1+" "+exp2+")";
}


string Z3Solver::cAnd(string exp1){
    return "(and "+exp1+ ")";
}

string Z3Solver::cOr(string exp1, string exp2){
    return "(or "+exp1+" "+exp2+")";
}
string Z3Solver::cOr(string exp1){
    return "(or "+exp1+")";
}

string Z3Solver::cEq(string exp1, string exp2){
    return "(= "+exp1+" "+exp2+")";
}

string Z3Solver::cNeq(string exp1, string exp2){
    return "(not (= "+exp1+" "+exp2+"))";
}

string Z3Solver::cGeq(string exp1, string exp2){
    return "(>= "+exp1+" "+exp2+")";
}

string Z3Solver::cGt(string exp1, string exp2){
    return "(> "+exp1+" "+exp2+")";
}

string Z3Solver::cLeq(string exp1, string exp2){
    return "(<= "+exp1+" "+exp2+")";
}

string Z3Solver::cLt(string exp1, string exp2){
    return "(< "+exp1+" "+exp2+")";
}

string Z3Solver::cLt(string exp1){
    return "(< "+exp1+" )";
}

string Z3Solver::cDiv(string exp1, string exp2){
    return "(div "+exp1+" "+exp2+")";
}

string Z3Solver::cMod(string exp1, string exp2){
    return "(mod "+exp1+" "+exp2+")";
}

string Z3Solver::cPlus(string exp1, string exp2){
    return "(+ "+exp1+" "+exp2+")";
}

string Z3Solver::cMinus(string exp1, string exp2){
    return "(- "+exp1+" "+exp2+")";
}

string Z3Solver::cMult(string exp1, string exp2){
    return "(* "+exp1+" "+exp2+")";
}

string Z3Solver::cSummation(std::vector<string> sum){
    string ret = "(+";
    for(vector<string>::iterator it = sum.begin(); it != sum.end(); ++it)
    {
        ret.append(" "+*it);
    }
    ret.append(")");
    return ret;
}

string Z3Solver::declareIntVar(string varname){
    string ret;
    ret.append("(declare-const "+varname+" Int)\n");
    return ret;
}

string Z3Solver::declareBitVec(string varname){
    string ret;
    ret.append("(declare-const "+varname+" (_ BitVec 32) )\n");
    return ret;
}


string Z3Solver::declareIntVar(string varname, int min, int max){
    string ret;
    ret.append("(declare-const "+varname+" Int)\n");
    ret.append("(assert (>= "+varname+" "+util::stringValueOf(min)+"))\n(assert (<= "+varname+" "+util::stringValueOf(max)+"))");
    
    return ret;
}

string Z3Solver::declareIntVarAndStore(string varname, int min, int max){
    string ret = declareIntVar(varname, min, max);
    operationsVars.push_back(varname);
    return ret;
}

string Z3Solver::declareIntOrderVar(string varname, int min, int max){
    string ret;
    ret.append("(declare-const "+varname+" Int)\n");
    ret.append("(assert (>= "+varname+" "+util::stringValueOf(min)+"))\n(assert (<= "+varname+" "+util::stringValueOf(max)+"))");
    
    return ret;
}

string Z3Solver::declareIntOrderVarAndStore(string varname, int min, int max){
    string ret = declareIntVar(varname, min, max);
    orderVars.push_back(varname);
    return ret;
}

string Z3Solver::declareRealVar(string varname, int min, int max){
    string ret;
    ret.append("(declare-const "+varname+" Real)\n");
    ret.append("(assert (>= "+varname+" "+util::stringValueOf(min)+"))\n(assert (<= "+varname+" "+util::stringValueOf(max)+"))");
    
    return ret;
}

string Z3Solver::postAssert(string constraint){
    return ("(assert "+constraint+")\n");
}

string Z3Solver::postNamedAssert(string constraint,string label){
    return ("(assert (! "+constraint+":named "+label+"))\n");
}

string Z3Solver::invertBugCondition(string expr){
    return (" (= false "+expr+")");
}
