//
//  Parameters.cpp
//  symbiosisSolver
//
//  Created by Nuno Machado on 21/05/14.
//  Copyright (c) 2014 Nuno Machado. All rights reserved.
//


#include "Parameters.h"


const int MAX_LINE_SIZE = 512;
bool debug = false;
bool bugFixMode = false;
bool saveUnsatCore = false;
bool jpfMode = false;
bool csr = false;
bool timeout = false;
std::string symbFolderPath = "";
std::string symbFolderPath2 = "";
std::string avisoFilePath = "";
std::string solverPath = "";
std::string formulaFile = "";
std::string solutionFile = "";
std::string assertThread = "";
std::string sourceFilePath = "";
std::string dspFlag = "";
std::string times = "";
std::string last = "";
std::string solutions = "";
std::string parallel = "";
std::string fromPath = "";
std::string trace = "";


bool failedExec = false;


std::map<std::string, std::string > solutionValuesFail;
std::map<std::string, std::string > solutionValuesAlt;
std::map<std::string,std::string> solutionValues;
std::vector<Operation*> failScheduleOrd;
std::vector<std::string> altScheduleOrd;
std::map<std::string, std::vector<Operation*> > operationsByThread;    //map thread id -> vector with thread's operations



std::vector<int> unsatCore;
std::set<std::string> unsatCoreStr;
std::map<std::string, std::string> labels;
std::map<std::string, std::string> label2Expr;
std::vector<std::string> bugCondOps;

time_t startTime;
time_t endTime;

int numEventsDifDebug = 0;
int numDepFull = 0;
int numDepDifDebug = 0;      
