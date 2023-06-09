//
//  Parameters.h
//  symbiosisSolver
//
//  Created by Nuno Machado on 21/05/14.
//  Copyright (c) 2014 Nuno Machado. All rights reserved.
//

#ifndef __symbiosisSolver__Parameters__
#define __symbiosisSolver__Parameters__

#include <iostream>
#include <vector>
#include <map>
#include <set>
#include "Operations.h"

typedef std::vector<Operation*> Schedule;

    //program inputs
    extern const int MAX_LINE_SIZE;
    extern bool debug;                  //prints debug info
    extern bool bugFixMode;             //run in bug fixing mode
    extern bool saveUnsatCore;          //yqp: check whether store unsat core
    extern bool jpfMode;                //parse symbolic traces with Java Path Finder syntax
    extern bool csr;                    //run with failling scheadule simplification
    extern std::string symbFolderPath;  //path to the folder containing the symbolic event traces
    extern std::string symbFolderPath2; //yqp: path to the folder containing the symbolic event traces
    extern std::string avisoFilePath;   //path to the aviso event trace
    extern std::string solverPath;      //path to the solver executable
    extern std::string formulaFile;     //path to the output file of the generated constraint formula
    extern std::string solutionFile;    //path to the output file of the solution
    extern std::string sourceFilePath;  //path to the source code
    extern std::string assertThread;    //id of the thread that contains the assertion
    extern std::string dspFlag;         //define which view the user wants in the result: "extended" "short" or default
    extern std::string times;			//yqp: describes the ith invocation of SymbolicSolver
    extern std::string last;			//yqp: klee-out-last
    extern std::set<std::string> bitVars;
    extern std::string solutions;
    extern std::string parallel;
    extern std::string trace;
	extern std::string fromPath;
	extern bool timeout;
	extern std::map<std::string, std::string > lastPathConds, lastPathConds0;	//map thread id to its last path condition for truncate OP order list (yqp)
    extern bool failedExec;             //indicates whether the traces correspond to a failing or successful execution

    //global vars

    extern std::map<std::string, std::string > solutionValuesFail;
    extern std::map<std::string, std::string > solutionValuesAlt;
    extern std::map<std::string,std::string> solutionValues; // stores values of SMT solution
    extern std::map<std::string, std::vector<Operation*> > operationsByThread;    //map thread id -> vector with thread's operations
    extern std::vector<Operation*> failScheduleOrd; // vector to store the fail schedules operations in order
    extern std::vector<std::string> altScheduleOrd;    // vector to store the alternate schedules operations in order, TODO std::vector<Operation*>

    extern std::vector<int> unsatCore;  //vector to store the core (i.e. the constraints) of an unsat model (this is only used in the bug-fixing mode, to store which events of the failing schedule cause the non-bug condition to be unsat)
    extern std::set<std::string> unsatCoreStr;
	extern std::map<std::string, std::string> labels;
	extern std::map<std::string, std::string> label2Expr;
    //std::map<std::string, std::vector<Operation*> > operationsByThread;    //map thread id -> vector with thread's operations
    extern std::vector<std::string> bugCondOps; //operations/events that appear in the bug condition

    //vars to measure solving time
    extern time_t startTime;
    extern time_t endTime;

    //vars for statistics of differential debugging
    extern int numEventsDifDebug;   //number of events in the root-cause
    extern int numDepFull;         //number of data-dependencies in the full failing schedule
    extern int numDepDifDebug;      //number of data-dependencies in the differential debugging schedule

#endif /* defined(__symbiosisSolver__Parameters__) */
