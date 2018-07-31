//
//  main.cpp
//  symbiosisSolver
//
//  Created by Nuno Machado on 30/12/13.
//  Copyright (c) 2013 Nuno Machado. All rights reserved.
//
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <iostream>
#include <fstream>
#include <map>
#include <set>
#include <vector>
#include <string.h>
#include <stack>
#include <dirent.h>
#include <algorithm>
#include <sstream>
#include <cassert>
#include <sys/types.h>
#include <unistd.h>
#include "Operations.h"
#include "ConstraintModelGenerator.h"
#include "Util.h"
#include "Types.h"
#include "Parameters.h"
#include "GraphvizGenerator.h"
#include "Schedule.h"
#include "LEGraph.h"
<<<<<<< HEAD
#include "KQueryParser.h"
=======
#include "Fix.h"
#include "KQueryParser.h"
//#include "AtomicityUnit.h"
>>>>>>> 560a77928ae99e42683d212517329ad7a4f5b415

#include <sys/timeb.h>
#include <sys/time.h>



using namespace std;
using namespace kqueryparser;


map<string, vector<RWOperation> > readset;              //map var id -> vector with variable's read operations
map<string, vector<RWOperation> > writeset, writeset2;             //map var id -> vector with variable's write operations
map<string, vector<LockPairOperation> > lockpairset;    //map object id -> vector with object's lock pair operations
map<string, SyncOperation> startset;                    //map thread id -> thread's start operation
map<string, SyncOperation> exitset;                     //map thread id -> thread's exit operation
map<string, vector<SyncOperation> > forkset;            //map thread id -> vector with thread's fork operations
map<string, vector<SyncOperation> > joinset;            //map thread id -> vector with thread's join operations
map<string, vector<SyncOperation> > waitset;            //map object id -> vector with object's wait operations
map<string, vector<SyncOperation> > signalset;          //map object id -> vector with object's signal operations
vector<SyncOperation> syncset;
vector<std::pair<PathOperation, string> > pathset;
map<string, vector<int> > threadIDToPathCond;			//map thrad id -> vector with path cond id in pathset (yqp)
vector<vector<pair<string, int> > > indexes;	//store all possible paths based on the just observed path (yqp)
map<string, string> lastPathConds, lastPathConds0;		//map thread id to its last path condition for truncate OP order list (yqp)
map<string, int> lastIndex, lastIndex0;		//map thread id to its last path condition for truncate OP order list (yqp)
map<string, string> preLastPathConds;	//map thread id to its (pre) last path condition for truncate OP order list (yqp)
map<string, int> prefix;						//map thread id -> thread's length of path prefix (yqp)
set<int> invertId; // store the ids that should be reverted for the executions which are only used as path split (yqp)
set<string> invertTID; // store the Tids that should be reverted for the executions which are only used as path split (yqp)
//map<string, string> pathStr;
std::string pathString = "";
string prePath;
map<string, map<string, stack<LockPairOperation> > > lockpairStack;   //map object id -> (map thread id -> stack with incomplete locking pairs)
int numIncLockPairs = 0;    //number of incomplete locking pairs, taking into account all objects
map<string, vector<string> > symTracesByThread;         //map thread id -> vector with the filenames of the symbolic traces
vector<string> solution;                                //vector that stores a given schedule (i.e. solution) found by the solver (used in --fix-mode)
std::set<std::vector<std::string> > globalOrders;
std::vector<PathOperation> globalOrderConstraints;

// temp sets
std::map<std::string, std::vector<Operation*> > old_operationsByThread;
set<string> bitVars;

int numConstraints, numVariables;
set<string> limitStr;
vector<PathOperation> limitConstraints;

//RWOperation *p;
int pathSizeLimit = 100000;  // the limit of symbolic path len of each thread 

AvisoTrace atrace;          //map: thread Id -> vector<avisoEvent>
AvisoEventVector fulltrace; //sorted vector containing all avisoEvents
int solverInvokedNum = 0;
double solverTime = 0; 
clock_t beginTime = 0;
struct timeval startday;

bool myCMP (pair<int, int> a, pair<int, int> b) {
	return a.second > b.second;
}

vector< vector<int> > getAllSubsets(vector<int> set) {
	vector< vector<int> > subset;
	vector<int> empty;
	subset.push_back( empty );

	for (int i = 0; i < set.size(); i++)
	{
		vector< vector<int> > subsetTemp = subset;

		for (int j = 0; j < subsetTemp.size(); j++)
		  subsetTemp[j].push_back( set[i] );

		for (int j = 0; j < subsetTemp.size(); j++)
		  subset.push_back( subsetTemp[j] );
	}
	return subset;
}

vector< vector<int> > getAllSubsets2(vector<int> set) {
	vector< vector<int> > subset;
	for (int i=0; i<set.size(); ++i) {
		vector<int> temp;
		temp.push_back(set[i]);
		subset.push_back(temp);
	}
	return subset;
}
	
int bit_width(unsigned int n) {
	unsigned int i = 0;

	if (n == 0)
	  return 0;

	do {
		++i;
	} while ((n >> i));

	return i;
}

int findNumSubstr(std::string str, std::string subs) {
	int num = 0;
	while (str.find(subs) != std::string::npos) {
		str = str.substr(str.find(subs)+subs.size());
		num++;
	}
	return num;
}

bool justCheck = false;
std::set<string> checkID, revertedID;
int minimalIndex = 0;
// yqp: generate all possible paths
void traverseAllPath(ConstModelGen *cmgen) {
	std::vector<string> threadIDVec;
	std::vector<int> width;

	if (justCheck) {
		std::vector<std::pair<string, int> > index;
		for (std::map<string, int>::iterator it = prefix.begin();
					it !=prefix.end(); ++it ) {
			if (it->second > threadIDToPathCond[it->first].size()) { // the current trace is incomplete
				return ;
			}

			if (preLastPathConds.find(it->first) == preLastPathConds.end())
			  continue ;
			string preLastCond = preLastPathConds[it->first];
			string currentLastCond = pathset[threadIDToPathCond[it->first][it->second-1]].first.getExpression();
			int num1 = findNumSubstr(preLastCond, "false") % 2;
			int num2 = findNumSubstr(currentLastCond, "false") % 2;

			if (num1 != num2 && it->first != "0") {
				revertedID.insert(it->first);
				invertId.insert(threadIDToPathCond[it->first][it->second-1]);
				invertTID.insert(it->first);
				int len = threadIDToPathCond[it->first].size();
				for (int i = it->second; i < len; ++i) {
					threadIDToPathCond[it->first].erase(threadIDToPathCond[it->first].end()-1);
				}
			}
			index.push_back(std::make_pair(it->first, it->second-1));
		}
	}

	int maxNum = 1;
	vector<int> sizes;
	int excluedForT0 = 7;
	//prefix["0"] = 2; // 7 for pfscanf
	for (map<string, vector<int> >::reverse_iterator it = threadIDToPathCond.rbegin();
				it != threadIDToPathCond.rend(); ++it) {
        if (it->first == "0") continue ;
		threadIDVec.push_back(it->first);
		int size;
		if (prefix.find(it->first) == prefix.end()) { 
			size = it->second.size();
		} else {
			size = it->second.size() - prefix[it->first];
		}

		maxNum *= (size + 1);
		if (sizes.size() == 0)
		  sizes.push_back(size+1);
		else
		  sizes.push_back(sizes.back() * (size+1));
	}
	std::reverse(width.begin(), width.end());

	std::reverse(sizes.begin(), sizes.end());
	sizes.push_back(1);
	sizes.erase(sizes.begin());

	if (!justCheck)
	  maxNum --;
	std::cerr << "MaxNum: " << maxNum << "\n";

	for (int i=0; i<maxNum; ++i) {
		std::vector<std::pair<string, int> > index;

		int checkNum = i;

		int j = threadIDVec.size();
		bool flag = true;
		for (int k=0; k<sizes.size(); ++k) {
			int ss = sizes[k];
			int ind = checkNum / ss;
			index.push_back(std::make_pair(threadIDVec[--j], ind + prefix[threadIDVec[j-1]]));

			if (index.back().second > pathSizeLimit) { 
				flag = false;
				break;
			}
			checkNum = checkNum % ss;
		}
		
		if (flag) { 
		  indexes.push_back(index); 
        }

		continue ;

		for (std::vector<int>::iterator it = width.begin();
					it != width.end(); ++it)  {
			int ind = checkNum & (int)(pow((double)2, (double)(*it))-1);
			if (prefix.find(threadIDVec[j-1]) != prefix.end())
			  index.push_back(std::make_pair(threadIDVec[--j], ind + prefix[threadIDVec[j-1]]));
			else
			  index.push_back(std::make_pair(threadIDVec[--j], ind));
			checkNum = checkNum >> (*it);
		}
		std::reverse(index.begin(), index.end());
		indexes.push_back(index);
	}

    if (threadIDToPathCond.find("0") != threadIDToPathCond.end()) {
        int len = threadIDToPathCond["0"].size();
        if (prefix.find("0") != prefix.end())
            len = len - prefix["0"];
        for (int i=0; i<len; ++i) {
            std::vector<std::pair<string, int> > index;
            index.push_back(std::make_pair("0", i+prefix["0"]));
            indexes.push_back(index);
        }
    }

	if (indexes.size() == 0) {
		struct timeval endday;
		gettimeofday(&endday, NULL);
		int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
			endday.tv_usec - startday.tv_usec;

		cmgen->closeSolver();
		/*std::cout << "Solver Invoked Num: " << util::stringValueOf(solverInvokedNum) << "\n";
		std::cerr << "Solver Time: " << util::stringValueOf(solverTime) << "\n";
		std::cerr << "Check Time: " << util::stringValueOf(timeuse) << "\n";
		std::cerr << "Constraints Num: " << numConstraints << "\n";
		std::cerr << "Vars Num: " << numVariables << "\n";*/
	}
}


/**
 *  Parse the input arguments.
 */
std::string bcFile = "";
void parse_args(int argc, char *const* argv)
{
	int c;

	if(argc < 7)
	{
		cerr << "Not enough arguments.\nUsage:\n#FAILING SCHEDULE FINDING MODE\n--trace-folder=/path/to/symbolic/traces/folder \n--with-solver=/path/to/solver/executable \n--model=/path/to/output/constraint/model/file \n--solution=/path/to/output/solution/file \n--debug (print optional debug info)\n\n#BUG FIXING MODE\n--fix-mode (this flag must be set on in order to run in bug fixing mode) \n--model=/path/to/input/constraint/model/file\n--solution=/path/to/input/solution/file \n--with-solver=/path/to/solver/executable \n--debug (print optional debug info)\n--times=the ith invocation of SymbolicSolver\n";
		exit(1);
	}

	while(1)
	{
		static struct option long_options[] =
		{
			//{"fail-thread", required_argument, 0, 'r'},
			{"trace-folder", required_argument, 0, 'c'},
			{"aviso-trace", required_argument, 0, 'a'},
			{"with-solver", required_argument, 0, 's'},
			{"model", required_argument, 0, 'm'},
			{"solution", required_argument, 0, 'l'},
			{"source", required_argument, 0, 'i'},
			{"debug", no_argument, 0, 'd'},
			{"fix-mode", no_argument, 0, 'f'},
			{"dsp", required_argument, 0, 'u'},
			{"csr", no_argument, 0, 'r'},
			{"times", required_argument, 0, 't'},
			{"last", required_argument, 0, 'x'},
			{"solutions", required_argument, 0, 'o'},
			{"trace", required_argument, 0, 'e'},
			{"bcfile", required_argument, 0, 'b'},
			{"parallel", required_argument, 0, 'p'},
			{"", }


		};
		/* getopt_long stores the option index here. */
		int option_index = 0;

		c = getopt_long(argc, argv, "", long_options, &option_index);

		/* Detect the end of the options. */
		if (c == -1)
		  break;

		switch (c)
		{
            case 'b':
                bcFile = optarg;
                break;

			case 'd':
				debug = true;
				break;

			case 'a':
				avisoFilePath = optarg;
				break;

			case 'c':
				symbFolderPath = optarg;
				break;
			case 'i':
				sourceFilePath = optarg;
				break;

			case 's':
				solverPath = optarg;
				break;

			case 'm':
				formulaFile = optarg;
				break;

			case 'l':
				solutionFile = optarg;
				break;

			case 'f':
				bugFixMode = true;
				break;
			case 'u':
				dspFlag = optarg; // extended, short, can be also empty
				break;
			case 'r':
				csr = true; // context switch reduction
				break;
			case 't':
				times = optarg;
				break;

			case 'o':
				solutions = optarg;
				break;

            case 'p':
                parallel = optarg;
                break;

			case 'e':
				trace = optarg;
				break;


			case 'x':
				last = optarg;
				break;

				/*case 'r':
				  assertThread = optarg;
				  break;
				  */
			case '?':
				/* getopt_long already printed an error message. */
				break;

			default:
				abort ();
		}
	}

	symbFolderPath2 = symbFolderPath.substr(0, symbFolderPath.rfind("/")+1) + "klee-out-"+last;
	/* Print any remaining command line arguments (not options). */
	if (optind < argc)
	{
		printf ("non-option ARGV-elements: ");
		while (optind < argc)
		  printf ("%s ", argv[optind++]);
		putchar ('\n');
		exit(1);
	}

	if(bugFixMode && dspFlag!="extended" && dspFlag!="short" && dspFlag!="")
	{
		cerr << "Unknow argument for --dsp\nUsage: --dsp=\"extended\", \"short\" or \"\" to have different DSP views\n";
		exit(1);
	}

	if(bugFixMode && (formulaFile.empty() || solutionFile.empty() || solverPath.empty()))
	{
		cerr << "Not enough arguments for bugFixMode.\nUsage: --model=/path/to/input/constraint/model\n--solution=/path/to/input/solution\n--with-solver=/path/to/solver/executable\n";
		exit(1);
	}
	else if(!bugFixMode && (formulaFile.empty() || solutionFile.empty() || solverPath.empty() || symbFolderPath.empty()))
	{
		cerr << "Not enough arguments.\nUsage:\n--trace-folder=/path/to/symbolic/traces/folder\n--aviso-trace=/path/to/aviso/trace\n--with-solver=/path/to/solver/executable\n--model=/path/to/output/constraint/model\n--solution=/path/to/output/solution\n";
		exit(1);
	}

	//** pretty print
	if(bugFixMode)
	  cout << "# MODE: FIND BUG'S ROOT CAUSE\n";
	else
	  cout << "# MODE: FIND BUG-TRIGGERING SCHEDULE\n";

	if(csr && !bugFixMode)
	  cout << "# CONTEXT SWITCH REDUCTION: on"   << endl;
	if(!csr && !bugFixMode)
	  cout << "# CONTEXT SWITCH REDUCTION: off"   << endl;

	cout << "# DSP:" << dspFlag <<"\t\t(options = extended, short, \"\")" << endl;

	if(!avisoFilePath.empty()) cout << "# AVISO TRACE: " << avisoFilePath << endl;
	if(!symbFolderPath.empty()) cout << "# SYMBOLIC TRACES: " << symbFolderPath << endl;
	cout << "# SOLVER: " << solverPath << endl;
	cout << "# CONSTRAINT MODEL: " << formulaFile << endl;
	cout << "# SOLUTION: " << solutionFile << endl;
	cout << endl;
}

/**
 * Parse the symbolic information contained in a trace and
 * populate the respective data strucutures
 */
void parse_constraints(string symbFilePath)
{
	bool rwconst = false;
	bool pathconst = false;
	int line = 0;
	string filename;
	string syncType;
	string threadId;
	string obj;
	string var;
	int varId;
	int callCounter = 0;

	map<string, int> varIdCounters; //map var name -> int counter to uniquely identify the i-th similar operation
	map<string, int> reentrantLocks; //map lock obj -> counter of reentrant acquisitions (used to differentiate reentrant acquisitions of the same lock)

	ifstream fin;
	std::string file = symbFilePath;
	symbFilePath = symbFolderPath2+"/"+symbFilePath;
	fin.open(symbFilePath);
	while (!fin.good())
	{
		util::print_state(fin);
		cerr << " -> Error opening file "<< symbFilePath <<".\n";
		fin.open(symbFilePath);
	}

    string f = util::extractFileBasename(symbFilePath);
	std::cout << ">> Parsing " << util::extractFileBasename(symbFilePath) << endl;

	string actualThreadID = f.substr(1, f.find_first_of("_")-1);
    // read each line of the file
	string order  = "";
	while (!fin.eof())
	{
		// read an entire line into memory
		char buf[MAX_LINE_SIZE];
		if (!(fin.getline(buf, MAX_LINE_SIZE))) {
			break;
		}
		char* token;
		string event = buf;
		if (event.size() == 0) {
			return ;
		}
		switch (buf[0]) {
			case '<':
				token = strtok (buf,"<>");
				if(!strcmp(token,"readwrite"))  //is readwrite constraints
				{
					rwconst = true;
					if(debug) cout << "parsing readwrite constraints...\n";
				} else if (!strcmp(token, "PathString")) {
                    if (pathString != "")
                        pathString += "_";
                    pathString += "T" + actualThreadID + "_" + event.substr(13);

                } else if(!strcmp(token,"path"))
				{
					pathconst = true;
					if(debug) cout << "parsing path constraints...\n";
				}
				else if(!strcmp(token,"pathjpf"))
				{
					pathconst = true;
					jpfMode = true;
					if(debug) cout << "parsing path constraints...\n";
				}
				else if(!strcmp(token,"assertThread_ok"))
				{
					string tmpfname = util::extractFileBasename(symbFilePath);
					tmpfname = tmpfname.substr(1,tmpfname.find_first_of("_\n")-1); //extract thread id from file name
					failedExec = false;
					assertThread = tmpfname;
					cout << "# ASSERT THREAD: " << assertThread << " (ok)\n";
				}
				else if(!strcmp(token,"assertThread_fail"))
				{
					string tmpfname = util::extractFileBasename(symbFilePath);
					tmpfname = tmpfname.substr(1,tmpfname.find_first_of("_\n")-1); //extract thread id from file name
					failedExec = true;
					assertThread = tmpfname;
					cout << "# ASSERT THREAD: " << assertThread << " (fail)\n";
				}
				break;

			case 'P':
				{
					assert(event.find("Path") != std::string::npos);
					string branchId = event.substr(6);
				}
				break;
			case '$':   //indicates that is a write
				{
					string tmp = buf; //tmp is only used to ease the check of the last character
					if(tmp.back() == '$')
					{
						token = strtok (buf,"$"); //token is the written value
						if(token == NULL){
							token[0] = '0';
							token[1] = '\0';
						}
						RWOperation* op = new RWOperation(threadId, var, varId, line, filename, token, true);
						op->setOrder(order);

						//update variable id
						string varname = op->getOrderConstraintName();
                        varname = varname.substr(0, varname.find("&"));
						if(!varIdCounters.count(varname))
						{
							varIdCounters[varname] = 0;
						}
						else
						{
							varIdCounters[varname] = varIdCounters[varname] + 1;
						}
						op->setVariableId(varIdCounters[varname]);

						writeset[var].push_back(*op);
						old_operationsByThread[threadId].push_back(op);

					}
					else
					{
						tmp.erase(0,1); //erase first '$'
						string value = "";
						while(tmp.back() != '$')
						{
							value.append(tmp);
							fin.getline(buf, MAX_LINE_SIZE);
							tmp = buf;
						}
						tmp.erase(tmp.find('$'),1); //erase last '$'
						value.append(tmp); //add last expression part

						RWOperation* op = new RWOperation(threadId, var, varId, line, filename, value, true);
						op->setOrder(order);

						//update variable id
						string varname = op->getOrderConstraintName();
                        varname = varname.substr(0, varname.find("&"));
						if(!varIdCounters.count(varname))
						{
							varIdCounters[varname] = 0;
						}
						else
						{
							varIdCounters[varname] = varIdCounters[varname] + 1;
						}
						op->setVariableId(varIdCounters[varname]);

						writeset[var].push_back(*op);
						old_operationsByThread[threadId].push_back(op);
					}
					break;
				}

			case 'T':  //indicates that is a path constraint
				{
					string tmp = buf;

					//make sure that this is a path condition and not the name of the file
					if(tmp.find("@")==string::npos){
						threadId = tmp.substr(1,tmp.find(":")-1); //get the thread id

						string expr;
						tmp.erase(0,tmp.find(":")+1);

						while(expr.back() != ')' || !util::isClosedExpression(expr))
						{
							expr.append(tmp);
							if(util::isClosedExpression(expr))
							  break;
							fin.getline(buf, MAX_LINE_SIZE);
							tmp = buf;
						}

                        string index;
						if (file.at(0) != 'L') {
							fin.getline(buf, MAX_LINE_SIZE);
							index = buf;
                            index = index.substr(index.find(" ")+1);
						}
					
						//remove unnecessary spaces from expression
						size_t space = expr.find("  ");
						while(space!= std::string::npos)
						{
							size_t endspace = expr.find_first_not_of(" ",space);
							expr.replace(space, endspace-space, " ");
							space = expr.find("  ");
						}

						PathOperation* po = new PathOperation(threadId, "", 0, 0, filename, expr);
						po->setLine(atoi(buf));
						pathset.push_back(std::make_pair(*po, index));
                        threadIDToPathCond[actualThreadID].push_back(pathset.size()-1);
						break;
					}
				}

			default:  //constraint has form line:constraint
				{
					if (buf[0] == 'O') {
						string newBuf = buf;
						char* toks = strtok(buf, " ");
						order = toks;
						order = order.substr(1);
 
						newBuf = newBuf.substr(newBuf.find(" ")+1);
						strncpy(buf, newBuf.c_str(), sizeof(buf));
						buf[sizeof(buf)-1] = '0';
					}
					
					if(!strcmp(buf,"")) {
						break;
					}
					token = strtok (buf,"@");
					filename = token;
					token = strtok (NULL,"-:");
					line = atoi(token);

					token = strtok (NULL,"-:"); //token = type (S,R, or W)
					//########## HEAD
					if(!strcmp(token,"CS"))
					{
						callCounter++;
						varId = callCounter;

						token = strtok (NULL,"-\n");
						threadId = token;
						string scrFilename = filename;

						int scrLine = line;

						//Get CodeDestiny
						fin.getline(buf, MAX_LINE_SIZE);
						//char* token2;
						string event = buf;

						token = strtok(buf,"@");
						string destFilename = token;
						token = strtok(NULL,"-:");
						int destLine = atoi(token);

						CallOperation* op = new CallOperation(threadId, varId, scrLine, destLine, scrFilename, destFilename);
						op->setOrder(order);

						old_operationsByThread[threadId].push_back(op);
					}
					else if(!strcmp(token,"S"))  //handle sync constraints
					{
						token = strtok (NULL,"-_");
						string tmpId = event.substr(event.find_last_of("-")+1);
						syncType = token;
						if(!strcmp(token,"lock"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							threadId = tmpId;

							//we don't add a constraint for a reentrant lock
							if(reentrantLocks.count(obj) == 0 || reentrantLocks[obj] == 0){
								reentrantLocks[obj] = 1;
							}
							else if(reentrantLocks[obj] > 0){
								int rcounter = reentrantLocks[obj];
								rcounter++;
								reentrantLocks[obj] = rcounter;
								std::cerr << "|************************************|\n";
								std::cerr << "|***********Reentry a lock **********|\n";
								std::cerr << "|************************************|\n";
								continue;
							}

							//add the lock operation to the thread memory order set in its correct order
							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,"lock");
							op->setOrder(order);
	
							//update variable id
							string varname = op->getOrderConstraintName();
							if(!varIdCounters.count(varname)){
								varIdCounters[varname] = 0;
							}
							else{
								varIdCounters[varname] = varIdCounters[varname] + 1;
							}
							op->setVariableId(varIdCounters[varname]);
							old_operationsByThread[threadId].push_back(op);

							//create new lock pair operation
							LockPairOperation lo (threadId,obj,varIdCounters[varname],filename,line,-1,0);

							//the locking pair is not complete, so we add it to a temp stack
							if(lockpairStack.count(obj)){
								lockpairStack[obj][threadId].push(lo);
							}
							else{
								stack<LockPairOperation> s;
								s.push(lo);
								lockpairStack[obj][threadId] = s;
							}
							numIncLockPairs++;
						}
						else if(!strcmp(token,"unlock"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							threadId = tmpId;// token;

							//check whether it is a reentrant unlock
							//if(reentrantLocks.count(obj) && reentrantLocks[obj] > 0){
							//  int rcounter = reentrantLocks[obj];
							//  rcounter--; //we have to decrement before renaming the obj to match the last rcounter
							//  string newobj;

							//  continue;

							//  if(rcounter > 0){
							//  newobj = obj + "r" + util::stringValueOf(rcounter);
							//  }
							//  else{
							//  newobj = obj;
							//  }
							//  reentrantLocks[obj] = rcounter;
							//  obj = newobj;
							//  }
							//we don't add a constraint for a reentrant lock
							if(reentrantLocks.count(obj) && reentrantLocks[obj] >= 1){
								int rcounter = reentrantLocks[obj];
								rcounter--;
								reentrantLocks[obj] = rcounter;
								if(rcounter > 0)
								  continue;
							}

							//the unlock completes the locking pair, thus we can add it to the lockpairset
							LockPairOperation *lo = new LockPairOperation(lockpairStack[obj][threadId].top());
							lo->setOrder(order);
							lockpairStack[obj][threadId].pop();
							lo->setUnlockLine(line);
							lo->setVariableName(obj);
							numIncLockPairs--;

							//add the unlock operation to the thread memory order set in its correct order
							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,"unlock");
							op->setOrder(order);


							//update variable id
							string varname = lo->getUnlockOrderConstraintName();
							if(!varIdCounters.count(varname))
							{
								varIdCounters[varname] = 0;
							}
							else
							{
								varIdCounters[varname] = varIdCounters[varname] + 1;
							}
							op->setVariableId(varIdCounters[varname]);
							lo->setUnlockVarId(varIdCounters[varname]);

							lockpairset[obj].push_back(*lo);
							old_operationsByThread[threadId].push_back(op);
						}
						else if(!strcmp(token,"fork"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,syncType);
							op->setOrder(order);
							
							if(forkset.count(threadId)){
								forkset[threadId].push_back(*op);
							}
							else{
								vector<SyncOperation> v;
								v.push_back(*op);
								forkset[threadId] = v;
							}
							old_operationsByThread[threadId].push_back(op);
						}
						else if(!strcmp(token,"join"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							if(token == NULL){
								cout << ">> PARSING ERROR: Missing child thread id in event \""<< event <<"\"! Join event must have format \"S-join_childId-parentId\". Please change file " << util::extractFileBasename(symbFilePath) << " accordingly.\n";
								exit(EXIT_FAILURE);
							}
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,syncType);
							op->setOrder(order);

							if(joinset.count(threadId)){
								joinset[threadId].push_back(*op);
							}
							else{
								vector<SyncOperation> v;
								v.push_back(*op);
								joinset[threadId] = v;
							}
							old_operationsByThread[threadId].push_back(op);
						}
						else if(!strcmp(token,"wait") || !strcmp(token,"timedwait"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,syncType);
							op->setOrder(order);

							//update variable id
							string varname = op->getOrderConstraintName();
							if(!varIdCounters.count(varname))
							{
								varIdCounters[varname] = 0;
							}
							else
							{
								varIdCounters[varname] = varIdCounters[varname] + 1;
							}
							op->setVariableId(varIdCounters[varname]);

							if(waitset.count(obj)){
								waitset[obj].push_back(*op);
							}
							else{
								vector<SyncOperation> v;
								v.push_back(*op);
								waitset[obj] = v;
							}

							//as the wait operations release and acquire locks internally, we also have to account for that behavior
							Schedule tmpvec = old_operationsByThread[threadId];
							for(Schedule::reverse_iterator in = tmpvec.rbegin(); in!=tmpvec.rend(); ++in)
							{
								SyncOperation* lop = dynamic_cast<SyncOperation*>(*in);
								if(lop!=0 && lop->getType() == "lock")
								{
									//1 - create an unlock operation and the corresponding locking pair
									string lockobj = lop->getVariableName();
									LockPairOperation *lo = new LockPairOperation(lockpairStack[lockobj][threadId].top());
									lo->setOrder(order);
									lockpairStack[lockobj][threadId].pop();
									lo->setUnlockLine(line);
									lo->setVariableName(lockobj);
									lo->setVariableId(0); //we need to set var id to 0 in order to match the correct key for lock operations (see 'lock' case above)
									lo->setVariableId(varIdCounters[lo->getLockOrderConstraintName()]); //now, set the var id to the correct value

									//create an extra unlock operation
									SyncOperation* unlop = new SyncOperation(threadId,lockobj,0,line,filename,"unlock");
									unlop->setOrder(order);

									//update unlock var id
									string uvarname = lo->getUnlockOrderConstraintName();
									if(!varIdCounters.count(uvarname)){
										varIdCounters[uvarname] = 0;
									}
									else{
										varIdCounters[uvarname] = varIdCounters[uvarname] + 1;
									}
									unlop->setVariableId(varIdCounters[uvarname]);
									lo->setUnlockVarId(varIdCounters[uvarname]);

									//add the extra unlock to the thread memory order set
									lockpairset[lockobj].push_back(*lo);
									old_operationsByThread[threadId].push_back(unlop);

									//2 - insert timedwait in the operations vector
									old_operationsByThread[threadId].push_back(op);

									//3 - create a new lock operation
									SyncOperation* newlop = new SyncOperation(threadId,lockobj,0,line,filename,"lock");
									newlop->setOrder(order);

									//update lock variable id
									string newlvarname = newlop->getOrderConstraintName();
									if(!varIdCounters.count(newlvarname)){
										varIdCounters[newlvarname] = 0;
									}
									else{
										varIdCounters[newlvarname] = varIdCounters[newlvarname] + 1;
									}
									newlop->setVariableId(varIdCounters[newlvarname]);

									//add the lock operation to the thread memory order set in its correct order
									old_operationsByThread[threadId].push_back(newlop);

									//create a new locking pair
									LockPairOperation newlpair (threadId,lockobj,varIdCounters[newlvarname],filename,line,-1,0);

									//the locking pair is not complete, so we add it to a temp stack
									lockpairStack[lockobj][threadId].push(newlpair);

									break;
								}
							}
						}
						else if(!strcmp(token,"signal") || !strcmp(token,"signalall"))
						{
							token = strtok (NULL,"-_");
							obj = token;

							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,obj,0,line,filename,syncType);
							op->setOrder(order);

							//update variable id
							string varname = op->getOrderConstraintName();
							if(!varIdCounters.count(varname)){
								varIdCounters[varname] = 0;
							}
							else{
								varIdCounters[varname] = varIdCounters[varname] + 1;
							}
							op->setVariableId(varIdCounters[varname]);

							if(signalset.count(obj)){
								signalset[obj].push_back(*op);
							}
							else{
								vector<SyncOperation> v;
								v.push_back(*op);
								signalset[obj] = v;
							}
							old_operationsByThread[threadId].push_back(op);
						}
						else if(!strcmp(token,"start"))
						{
							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,"",0,line,filename,syncType);
							op->setOrder(order);
							startset[threadId] = *op;
							old_operationsByThread[threadId].push_back(op);
						}
						else if(!strcmp(token,"exit"))
						{
							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,"",0,line,filename,syncType);
							op->setOrder(order);
							exitset[threadId] = *op;
							old_operationsByThread[threadId].push_back(op);
						}
						else //syncType is unknown
						{
							token = strtok (NULL,"-\n");
							threadId = token;

							SyncOperation* op = new SyncOperation(threadId,"",0,line,filename,syncType);
							op->setOrder(order);
							syncset.push_back(*op);
							old_operationsByThread[threadId].push_back(op);
						}

					} else if(!strcmp(token,"R"))
					{
						token = strtok (NULL,"-");
						var = token;
						token = strtok (NULL,"-");
						while(token[0] == '>'){
							var.append("-");
							var.append(token);
							token = strtok (NULL,"-");
						}
						threadId = token;
						token = strtok (NULL,"-\n");
						varId = atoi(token);

						RWOperation* op = new RWOperation(threadId, var, varId, line, filename,"", false);
						op->setOrder(order);
						for (int ii=0; ii<=10; ++ii) {
							string str = "_k" + util::stringValueOf(ii);
							if (op->getConstraintName().find(str) != string::npos) {
								limitStr.insert(op->getConstraintName());
							}
						}

						readset[var].push_back(*op);
						old_operationsByThread[threadId].push_back(op);

					} else if(!strcmp(token,"W"))
					{
						token = strtok (NULL,"-");
						var = token;
						token = strtok (NULL,"-");
						while(token[0] == '>'){
							var.append("-");
							var.append(token);
							token = strtok (NULL,"-");
						}
						threadId = token;
                        token = strtok (NULL,"-");
						varId = 0;//atoi(token);
					}
					break;
				}
		}
	} //end while
	fin.close();

	//resolve written values that are references to other writes
	for(map<string, vector<RWOperation> >:: iterator oit = writeset.begin(); oit != writeset.end(); ++oit)
	{
		for(vector<RWOperation>:: iterator iit = oit->second.begin(); iit != oit->second.end(); ++iit)
		{
			RWOperation wOp = *iit;
			string wRef = wOp.getValue(); //check whether the written value is a reference to another write
			if(wRef.substr(0,2) == "W-")
			{
				//find that referenced write and replace the value with the referenced one
				for(vector<RWOperation>:: iterator rit = oit->second.begin(); rit != oit->second.end(); ++rit)
				{
					RWOperation wOp2 = *rit;
					if(wRef == wOp2.getConstraintName()){

					}
				}
			}
		}
	}

	//add non-closed locking pairs to lockpairset
	while(numIncLockPairs > 0)
	{
		for(Schedule::reverse_iterator rit = old_operationsByThread[threadId].rbegin();
					rit != old_operationsByThread[threadId].rend() && numIncLockPairs > 0; ++rit)
		{
			SyncOperation* tmplop = dynamic_cast<SyncOperation*>(*rit);
			if(tmplop!=0 && tmplop->getType() == "lock"
						&& lockpairStack[tmplop->getVariableName()][threadId].size() > 0)
			{
				string tmpobj = tmplop->getVariableName();
				LockPairOperation* lo = new LockPairOperation(lockpairStack[tmpobj][threadId].top());
				int prevLine = old_operationsByThread[threadId].back()->getLine(); //** line of the last event in thread's trace
				lo->setUnlockLine(prevLine+1);
				lo->setFakeUnlock(true);
				lo->setVariableId(tmplop->getVariableId());


				//** create a fake unlock (placed after the last event in the schedule) and complete the locking pair
				SyncOperation* op = new SyncOperation(threadId,lo->getVariableName(),0,prevLine+1,filename,"unlockFake");

				//update var id
				string uvarname = lo->getUnlockOrderConstraintName();
				if(!varIdCounters.count(uvarname)){
					varIdCounters[uvarname] = 0;
				}
				else{
					varIdCounters[uvarname] = varIdCounters[uvarname] + 1;
				}

				op->setVariableId(varIdCounters[uvarname]);
				lo->setUnlockVarId(varIdCounters[uvarname]);

				old_operationsByThread[threadId].push_back(op);
				lockpairset[lo->getVariableName()].push_back(*lo);
				lockpairStack[tmpobj][threadId].pop();
				numIncLockPairs--;
				break;
			}
		}
	}
	lockpairStack.clear(); //** doing this we guarantee that we only add lock constraints only once

	//add the exit events...
	int prevLine = old_operationsByThread[threadId].back()->getLine();
	SyncOperation* op;
	if(assertThread == threadId){
		op = new SyncOperation(threadId, "", 0, prevLine + 1, filename, "AssertFAIL");
	} else
	  op = new SyncOperation(threadId, "", 0, prevLine + 1, filename, "exit");
	old_operationsByThread[threadId].push_back(op);
	exitset[threadId] = *op;

} 

/**
 *  Parse the events contained in the Aviso trace.
 */
void parse_avisoTrace()
{
	ifstream fin;
	fin.open(avisoFilePath);

	if (!fin.good())
	{
		util::print_state(fin);
		cout << " -> Error opening file "<< avisoFilePath <<".\n";
		fin.close();
		exit(1);
	}

	// read each line of the file
	while (!fin.eof())
	{
		// read an entire line into memory
		char buf[MAX_LINE_SIZE];
		fin.getline(buf, MAX_LINE_SIZE);

		if(buf[0])
		{
			char* token;
			token = strtok (buf," :"); //token == thread id

			AvisoEvent aetmp;
			aetmp.tid = token;

			token = strtok (NULL," :"); //token == filename
			aetmp.filename = util::extractFileBasename(token);

			token = strtok (NULL," :"); //token == line of code
			aetmp.loc = atoi(token);

			atrace[aetmp.tid].push_back(aetmp);
			fulltrace.push_back(aetmp);
		}
	}
	fin.close();


	if(debug)
	{
		cout<< "\n### AVISO TRACE\n";

		for (unsigned i = 0; i < fulltrace.size(); i++) {
			cout << "[" << fulltrace[i].tid << "] " << util::extractFileBasename(fulltrace[i].filename) << "@" << fulltrace[i].loc << endl;
		}
		cout << endl;
	}
}

pid_t executeWithoutWait(string cmd) {
	pid_t childPid;
	childPid = fork();
	if (childPid == 0) {
		system(cmd.c_str());
		exit(0);
	}

	return childPid;
}

std::string INSTALL_PATH = getenv("INSTALL_PATH");
void executeSE(std::string name, std::string sub, std::string sub1) {
	std::string cmd = "mv " + name + " " + trace + "/index_"+ sub;
	//std::cerr << "cmd2: " << cmd << "\n";
	system(cmd.c_str());

	cmd = "cp _back _testSMALL.tar";
	system(cmd.c_str());
	cmd = "rm _testSMALL.tar.bz2*";
	system(cmd.c_str());
    cmd = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSE/Release+Asserts/bin/symbiosisse --allow-external-sym-calls --bb-trace=" + trace + "/example.trace.fail " + bcFile + " --parallel=1 --times="+times+ " --index=" +sub+ " --last="+last + " --trace=" + trace;

    string cmd2 = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/symbiosisSolver --trace-folder="+trace+"/klee-last --model=" + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/modelCrasher.txt --solution=" + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/failCrasher.txt --with-solver=" + INSTALL_PATH + "/z3/bin/z3 --times=" + sub + " --last=" + sub + " --solutions=" + solutions + " --trace=" + trace + " " + " --bcfile="+bcFile;
	
	FILE *ls = popen("cat paralleled", "r");
	char b[256];
	string str = "w";
	while (fgets(b, sizeof(b), ls) != 0) {
		str = b;
	}
	pclose(ls);

	int num = util::intValueOf(str);
	if (str.at(0) != 'w' && num > 10) 
	    system(cmd.c_str());
	else {
		std::ofstream outFile;
		outFile.open("paralleled", ios::app);
		if (!outFile.is_open()) {
			cerr << "-> Error opening file paralleled\n";
			outFile.close();
			exit(1);
		}

		std::cerr << "Begin a work: " <<  num+1 << "\n";
		outFile <<  num+1 << "\n";

        std::cerr << "cmd: " << cmd << "\n";
	    executeWithoutWait(cmd);
        //system(cmd.c_str());
		std::cerr << "end a work!\n";

	}
}

void identifyBitVecVariables(vector<PathOperation> &tmpPathSet) {
    bitVars.clear();
    for (vector<PathOperation>::iterator it = tmpPathSet.begin();
            it != tmpPathSet.end(); ++it) {
        PathOperation op = *it;
        string expr = op.getExpression();
        if (expr.find("And") == string::npos) continue ;
        
        while (expr.find("T") != string::npos) {
            string var = expr.substr(expr.find("T"));
            if (var.find_first_of(" ") < var.find_first_of(")")) {
                expr = var.substr(var.find(" "));
                var = var.substr(0, var.find(" "));
            } else {
                expr = var.substr(var.find(")"));
                var = var.substr(0, var.find(")"));
            }

            var = var.substr(0, var.find_first_of("-"));
            bitVars.insert(var);
        }
    }
}

int successed = 0;
int globalIndex = 0;
bool speedup = false;
std::set<std::pair<std::set<string>, int> > unsatPCs;
std::string memoryOrderConstraint = "";
std::string lockConstraint = "";
std::string forkConstraint = "";
std::string joinConstraint = "";
std::string waitConstraint = "";
// yqp: flag is true when the generated test case is used to split path prefix
bool checkPath(ConstModelGen* cmgen, vector<PathOperation> tmpPathSet,
			std::map<string, pair<int, string> > prefixInd) {
    tmpPathSet.insert(tmpPathSet.begin(), limitConstraints.begin(),
				limitConstraints.end());

    identifyBitVecVariables(tmpPathSet);

    //tmpPathSet.insert(tmpPathSet.begin(), globalOrderConstraints.begin(), globalOrderConstraints.end());

    cmgen->openOutputFile(); //** opens a new file to store the model

	cout << "[Solver] Adding memory-order constraints...\n";
    memoryOrderConstraint = cmgen->addMemoryOrderConstraints_yqp(operationsByThread);
	cmgen->z3solver.writeLineZ3(memoryOrderConstraint);
	
	cout << "[Solver] Adding read-write constraints...\n";
	cmgen->addReadWriteConstraintsWithSimplify(readset,writeset,operationsByThread);

	int tmpIndex = globalIndex;
	cout << "[Solver] Adding path constraints1111... " << times+"_"+util::stringValueOf(tmpIndex+1) << "\n";
	cmgen->addPathConstraints2(tmpPathSet);

    cout << "[Solver] Adding locking-order constraints...\n";
	if (lockConstraint == "")
		lockConstraint = cmgen->addLockingConstraints_yqp2(lockpairset);
		//cmgen->addLockingConstraints_yqp/*WithSimplify*/(lockpairset);
	cmgen->z3solver.writeLineZ3(lockConstraint);
	
    cout << "[Solver] Adding fork/start constraints...\n";
	if (forkConstraint == "")
		forkConstraint = cmgen->addForkStartConstraints_yqp(forkset, startset);
	cmgen->z3solver.writeLineZ3(forkConstraint);

	cout << "[Solver] Adding join/exit constraints...\n";
	if (joinConstraint == "")
		joinConstraint = cmgen->addJoinExitConstraints_yqp(joinset, exitset);
	cmgen->z3solver.writeLineZ3(joinConstraint);

	cout << "[Solver] Adding wait/signal constraints...\n";
	if (waitConstraint == "")
		waitConstraint = cmgen->addWaitSignalConstraints_yqp(waitset, signalset);
	cmgen->z3solver.writeLineZ3(waitConstraint);

	cout << "\n### SOLVING CONSTRAINT MODEL: Z3\n";
	double time = clock();
	bool success = cmgen->solve_yqp();//solve_yqp();
	solverTime += clock() - time;
	numConstraints += cmgen->total;
	numVariables += cmgen->numUnkownVars;
	solverInvokedNum++;

	if (tmpPathSet.back().getFilename().find("Property") != std::string::npos)
		return success;
	if(success)
	{
		//cout<< "\n\nOLD SCH" << times+"_"+util::stringValueOf(tmpIndex+1) << endl;
		//scheduleLIB::printSch(failScheduleOrd);

		Schedule simpleSch;

		if(csr){
			simpleSch = scheduleLIB::scheduleSimplify(failScheduleOrd,cmgen);
			cout<< "\n\nNEW SCH" << endl;
			scheduleLIB::printSch(failScheduleOrd);
		}
		else
		  simpleSch = failScheduleOrd;

		string filename = solutionFile+"_yqp";
		for (std::map<string, pair<int, string> >::iterator it = prefixInd.begin();
					it != prefixInd.end(); ++it) {
			filename = filename + "_" + it->first + "*" + util::stringValueOf(it->second.first);
		}

		string name = solutionFile+"_yqp_"+ times + "_" + util::stringValueOf(getpid()) + "_" + util::stringValueOf(tmpIndex);
        //std::cerr << "file: " << name << " " << globalIndex << "\n";
		scheduleLIB::saveScheduleFile2(name, scheduleLIB::schedule2string2(simpleSch), prefixInd);
		util::saveVarValues2File(name, solutionValues);
		globalIndex++;
		successed++;
	
		if (parallel=="1") {
			executeSE(name, util::stringValueOf(getpid())+"_"+util::stringValueOf(tmpIndex+1), util::stringValueOf(getpid())+"_"+util::stringValueOf(tmpIndex+2));
        }
	}

	return success;
}

void updateWriteSet(map<string, string> lastConds, vector<PathOperation> paths) {

    //std::cerr << "in updateWriteSet!\n";
    std::map<std::string, std::set<std::string> > terminateVars;
    for (vector<PathOperation>::iterator it = paths.begin();
            it != paths.end(); ++it) {
        std::string path = it->getExpression();
        while (path.find("T0*") != std::string::npos) {
            path = path.substr(path.find("T0*"));
            std::string var;
            if (path.find_first_of(")") < path.find_first_of(" ")) {
                var = path.substr(0, path.find_first_of(")"));
                path = path.substr(path.find_first_of(")"));
            } else {
                var = path.substr(0, path.find_first_of(" "));
                path = path.substr(path.find_first_of(" "));
            }
            std::string threadId = var.substr(var.find_first_of("-")+1);
            threadId = threadId.substr(0, threadId.find("-"));
            terminateVars[threadId].insert(var);
        }
    }
        
    for (map<string, string >::iterator it = lastConds.begin();
         it != lastConds.end(); ++it) {
        std::string path = it->second;
        while (path.find("T0*") != std::string::npos) {
            path = path.substr(path.find("T0*"));
            std::string var;
            if (path.find_first_of(")") < path.find_first_of(" ")) {
                var = path.substr(0, path.find_first_of(")"));
                path = path.substr(path.find_first_of(")"));
            } else {
                var = path.substr(0, path.find_first_of(" "));
                path = path.substr(path.find_first_of(" "));
            }
            std::string threadId = var.substr(var.find_first_of("-")+1);
            threadId = threadId.substr(0, threadId.find("-"));
            terminateVars[threadId].insert(var);
        }
    }

     writeset.clear(), readset.clear();
     operationsByThread.clear();
     for (map<string, string >::iterator it = lastConds.begin();
            it != lastConds.end(); ++it) {
        string threadID = it->first;
        string lastPath = it->second;
        bool begin = false;
        bool end = false;
        for (vector<Operation*>::iterator oit = old_operationsByThread[threadID].begin();
             oit != old_operationsByThread[threadID].end(); ++oit) {
            Operation *o = *oit;
            string tmp = "";
            string name = o->getConstraintName().substr(2);
            if (lastPath.find(name) != string::npos) {
                tmp = lastPath.substr(lastPath.find(name) + name.size());
            }

            if (tmp != "" && (tmp.at(0) == ' ' || tmp.at(0) == ')')) {
                begin = true;
                lastPath = lastPath.substr(0, lastPath.find(name)) + tmp;
            } else if (begin && lastPath.find("T") == std::string::npos) {
                end = true;
            }
            
            //std::cerr << "!!!: " << tmp << " " << begin << " " << end << " " 
            //    << threadID << " " << lastPath << " " << o->getConstraintName() << "\n";
            if (terminateVars[threadID].find(name) != terminateVars[threadID].end() || !end || dynamic_cast<RWOperation *>(o) == NULL) {
                operationsByThread[threadID].push_back(o);
                if (RWOperation* rw = dynamic_cast<RWOperation*>(o)) {
                    if (rw->isWriteOp())
                        writeset[o->getVariableName()].push_back(*rw);
                    else
                        readset[o->getVariableName()].push_back(*rw);
                }
            } else {
                ;//std::cerr << "skip: " << threadID << " " << o->getConstraintName() << "\n";
            }
        }
    }

    for (map<string, vector<Operation*> >::iterator it = old_operationsByThread.begin();
            it != old_operationsByThread.end(); ++it) {
        string threadID = it->first;
         if (lastConds.find(threadID) != lastConds.end()) continue;

         for (vector<Operation*>::iterator oit = old_operationsByThread[threadID].begin();
              oit != old_operationsByThread[threadID].end(); ++oit) {
             Operation *o = *oit;
             operationsByThread[threadID].push_back(o);
             if (RWOperation* rw = dynamic_cast<RWOperation*>(o)) {
                  if (rw->isWriteOp())
                      writeset[o->getVariableName()].push_back(*rw);
                  else
                      readset[o->getVariableName()].push_back(*rw);
             }

         }
     }

	return ;
}

bool checkSatisfiability2_1(ConstModelGen* cmgen, 
			std::vector<std::pair<string, int> > index,
			std::map<string, std::pair<int, string> > prefixInd, 
			map<string, string> unsatIDs) {
	std::set<string> pastID;
	bool canBeExtended = false;

	vector<PathOperation> tmpPathSet;
	lastPathConds0.clear();
	for (unsigned i = 0; i < index.size(); ++i) {
		vector<PathOperation> currentSet;
		string threadID = index[i].first;
		int ind = index[i].second;
		if (checkID.find(threadID) != checkID.end() && unsatIDs.find(threadID) == unsatIDs.end() ) {
			canBeExtended = true;
		}

		if (ind == threadIDToPathCond[threadID].size() &&
					unsatIDs.find(threadID) != unsatIDs.end()) {
			ind --;
		}

		for (int j = 0; j < ind; ++j) {
			PathOperation p = pathset[threadIDToPathCond[threadID][j]].first;
            bool temp;
			string expr = kqueryparser::translateExprToZ3(p.getExpression(), temp);
			string label = labels[expr];
			currentSet.push_back(p);//pathset[threadIDToPathCond[threadID][j]]);

		}

		if (/*i != k*/unsatIDs.find(threadID) != unsatIDs.end()) {
			if (currentSet.size() != threadIDToPathCond[threadID].size()) {
                bool temp;
				string expr = kqueryparser::translateExprToZ3(
							pathset[threadIDToPathCond[threadID][ind]].first.getExpression(), temp);
				lastPathConds0[threadID] = expr;
			}

			if (currentSet.size() == 0) 
			  continue ;

			tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
			continue ;
		}

		int sub = threadIDToPathCond[threadID][ind];
		if (currentSet.size() == threadIDToPathCond[threadID].size()) {
			tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
			if (revertedID.find(threadID) != revertedID.end()) {
			    lastPathConds0[threadID] = currentSet.back().getExpression();
			}

			continue;
		}

		PathOperation lastOp = pathset[sub].first;
        bool temp;
		string expr = kqueryparser::translateExprToZ3(lastOp.getExpression(), temp);
		expr = cmgen->z3solver.invertBugCondition(expr);

		string filename = lastOp.getFilename();
		PathOperation* po = new PathOperation(threadID, "", 0, 0,  filename, expr);
		currentSet.push_back(*po);
		tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
		lastPathConds0[threadID] = currentSet.back().getExpression();
	}

	prefixInd["-1"] = std::make_pair(-1, "");
	if (!canBeExtended /*&& unsatIDs.size() < 2*/) {
		std::cerr << "Note: No new behavior can be found. Stop!\n";
		return false;
	}

	updateWriteSet(lastPathConds0, tmpPathSet);
	bool success = checkPath(cmgen, tmpPathSet, prefixInd);

	cmgen->resetSolver();
	if (success) {
		std::cerr << "Note: should split the current prefix!\n";
		return true;
	}
	return false;
}

// yqp: check whether path prefix 'index' is an unreachable path
// For solution 3
void checkSatisfiability2(ConstModelGen* cmgen, 
			std::vector<std::pair<string, int> > index,
			std::map<string, std::pair<int, string> > prefixInd) {
	std::set<string> pastID;

	map<string, string> unsatIDs, unsatIDsTmp;
	vector<int> ids;
	for (std::set<string>::iterator it = unsatCoreStr.begin();
				it != unsatCoreStr.end(); ++it) {
		if (it->find("PC") == std::string::npos)
		    continue;

		string str = *it;
		str = str.substr(str.find("T"));
		str = str.substr(1, str.find("_")-1);
		int id = util::intValueOf(str);
		unsatIDsTmp[str] = *it;
		if (std::find(ids.begin(), ids.end(), id) == ids.end())
		  ids.push_back(id);
	}

	vector< vector<int> > sets = getAllSubsets2(ids);
	std::vector<pair<int, int> > indexPair;
	for (std::vector<vector<int> >::iterator it = sets.begin();
				it != sets.end(); ++it) {
		indexPair.push_back(make_pair(it-sets.begin(), it->size()));
	}

	std::sort(indexPair.begin(), indexPair.end(), myCMP);

	for (vector<pair<int, int> >::iterator it = indexPair.begin();
				it != indexPair.end(); ++it) {
		vector<int> subset = sets[it->first];
		if (subset.size() == 0)
		    continue ;

		map<string, string> unsatIDs;
		for (vector<int>::iterator it2 = subset.begin();
					it2 != subset.end(); ++it2) {
			int id = *it2;
			string threadID = util::stringValueOf(id);
			unsatIDs[threadID] = unsatIDsTmp[threadID];
		}

        bool flag = false;
        for (std::vector<std::pair<string, int> >::iterator it2 = index.begin();
                it2 != index.end(); ++it2) {
            if (unsatIDs.find(it2->first) != unsatIDs.end()) {
                int id = it2->second;
                if (it2->second == threadIDToPathCond[it2->first].size())
                    id--;

                string path = pathset[threadIDToPathCond[it2->first][id]].first.getExpression();
                if (path.find("shared*") != string::npos) {
                    flag = true;
                    break;
                }
            }
        }

        if (!flag) {
            continue ;
        }
		if (checkSatisfiability2_1(cmgen, index, prefixInd, unsatIDs)) {
		    break;
        }
	}
}




// yqp: check whether path prefix 'index' is an unreachable path
// For solution 2
void checkSatisfiability(ConstModelGen* cmgen, 
			std::vector<std::pair<string, int> > index,
			std::map<string, std::pair<int, string> > prefixInd) {
	std::set<string> pastID;

	int beginIndex = 0;
	if (justCheck) {
		// if new condition is found, we can still extend the execution along this thread
		if (threadIDToPathCond[index[minimalIndex].first].size() > prefix[index[minimalIndex].first])
		  beginIndex = minimalIndex;
		else
		  beginIndex = minimalIndex+1;
	}

	lastIndex0.clear();
	for (int k=beginIndex; k<index.size(); ++k) {
		// check whether index[i] is a reachable path
		vector<PathOperation> tmpPathSet;
		cmgen->createZ3Solver();
		if (justCheck) {
			if (revertedID.find(index[k].first) == revertedID.end() && 
						threadIDToPathCond[index[k].first].size() <= prefix[index[k].first]) {
				pastID.insert(index[k].first);
				continue ;
			}
		} else if (checkID.find(index[k].first) == checkID.end()) {
			pastID.insert(index[k].first);
			continue ;
		}

		for (unsigned i = 0; i < index.size(); ++i) {

			vector<PathOperation> currentSet;
			string threadID = index[i].first;
			int ind = index[i].second;
			if (threadID != index[k].first //&& i > k //&& ind == threadIDToPathCond[threadID].size() ||
						&& (!justCheck || invertTID.find(threadID) != invertTID.end()) //{
			  && (pastID.find(threadID) == pastID.end())
			  ) {
				  if (ind == threadIDToPathCond[threadID].size()) {
					  ind --;
				  }
			}

			for (int j = 0; j < ind; ++j) {
				currentSet.push_back(pathset[threadIDToPathCond[threadID][j]].first);
			}

			if (threadID != index[k].first) {
				if (currentSet.size() != threadIDToPathCond[threadID].size()) {
                    bool temp;
					string expr = kqueryparser::translateExprToZ3(
								pathset[threadIDToPathCond[threadID][ind]].first.getExpression(), temp);
					lastPathConds0[threadID] = expr;
				}

				if (currentSet.size() == 0)
				  continue ;

				tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
				continue ;
			}

			int sub = threadIDToPathCond[threadID][ind];
			if (currentSet.size() == threadIDToPathCond[threadID].size()) {
				tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
                bool temp;
                string expr = kqueryparser::translateExprToZ3(currentSet.back().getExpression(), temp);
                lastPathConds0[threadID] = expr;

				continue;
			}

			PathOperation lastOp = pathset[sub].first;
            bool temp;
			string expr = kqueryparser::translateExprToZ3(lastOp.getExpression(), temp);
			expr = cmgen->z3solver.invertBugCondition(expr);

			string filename = lastOp.getFilename();
			PathOperation* po = new PathOperation(threadID, "", 0, 0,  filename, expr);
            currentSet.push_back(*po);
            tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
			lastPathConds0[threadID] = po->getExpression();
		}

		prefixInd["-1"] = std::make_pair(k, "");

		updateWriteSet(lastPathConds0, tmpPathSet);
		bool success = checkPath(cmgen, tmpPathSet, prefixInd);
		cmgen->resetSolver();
		if (success) {
			std::cerr << "Note: should split the current prefix!\n";
			return ;
		}
	}
}

/** yqp
 *  Generate and solve the contraint model
 *  for a given set of symbolic traces
 */
bool verifyConstraintModel2(ConstModelGen* cmgen)
{
	//old_operationsByThread.insert(operationsByThread.begin(), operationsByThread.end());
	if (justCheck) {
		for (std::set<int>::iterator it = invertId.begin(); 
					it != invertId.end(); ++it) {
			int id = *it;

            bool temp;
			string expr = kqueryparser::translateExprToZ3(pathset[id].first.getExpression(), temp);
			expr = cmgen->z3solver.invertBugCondition(expr);

			pathset[id].first.setExpression(expr);
		}
	}

	string oldFormulaFile = formulaFile;
	writeset2.insert(writeset.begin(), writeset.end());

	for (int sub = 0; sub < indexes.size(); ++sub) {
		checkID.clear();

		vector<PathOperation> tmpPathSet;

		std::map<string, pair<int, string> > prefixInd;
        if (indexes[sub].size() != 0 && indexes[sub][0].first != "0") {
            string pathIndex = "";
            for (unsigned i=0; i<threadIDToPathCond["0"].size(); ++i) {
                tmpPathSet.push_back(pathset[threadIDToPathCond["0"][i]].first);
                pathIndex += pathset[threadIDToPathCond["0"][i]].second + " ";
            }
            prefixInd["0"] = make_pair(threadIDToPathCond["0"].size(), pathIndex);
        }

        if (indexes[sub].size() == 0) {
            PathOperation p = pathset[threadIDToPathCond["0"][0]].first;
            std::string expr = ("(Eq false "+p.getExpression()+")");
			PathOperation* po = new PathOperation("0", "", 0, 0,  p.getFilename(), expr);
            tmpPathSet.push_back(*po);
        }

		formulaFile = oldFormulaFile+util::stringValueOf(getpid());

		formulaFile = formulaFile + "_" + times + "_" + util::stringValueOf(sub);//+"_"+last;

		cmgen->createZ3Solver();

		lastPathConds.clear();
		lastPathConds0.clear();
		lastIndex.clear();
		lastIndex0.clear();
		map<string, string > tempLastPath;
		for (unsigned i = 0; i < indexes[sub].size(); ++i) {
            string pathIndex = "";
			vector<PathOperation> currentSet;
			string threadID = indexes[sub][i].first;
			int ind = indexes[sub][i].second;

			for (int j = 0; j < ind; ++j) {
			  currentSet.push_back(pathset[threadIDToPathCond[threadID][j/*+prefix[threadID]*/]].first);
              pathIndex += pathset[threadIDToPathCond[threadID][j]].second + " ";
            }
            
			int index = threadIDToPathCond[threadID][ind/*+prefix[threadID]*/];
			if (currentSet.size() == threadIDToPathCond[threadID].size()) {
				prefixInd[threadID] = make_pair(currentSet.size(), pathIndex);
				tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
                bool temp;
				string expr = kqueryparser::translateExprToZ3(currentSet.back().getExpression(), temp);
			    lastPathConds[threadID] =  expr;
				tempLastPath[threadID] = expr;
				continue;
                //break;
			}

            pathIndex += pathset[index].second;
			prefixInd[threadID] = make_pair(currentSet.size() + 1, pathIndex); 

			PathOperation lastOp = pathset[index].first;
			string expr = lastOp.getExpression();// kqueryparser::translateExprToZ3(lastOp.getExpression());
			//expr = cmgen->z3solver.invertBugCondition(expr);
            expr = ("(Eq false "+expr+")");
            //if (expr.front() == ' ')
            //    expr = expr.substr(1);

			string filename = lastOp.getFilename();
			PathOperation* po = new PathOperation(threadID, "", 0, 0,  filename, expr);
			currentSet.push_back(*po);
			tmpPathSet.insert(tmpPathSet.end(), currentSet.begin(), currentSet.end());
			lastPathConds[threadID] = currentSet.back().getExpression();
			lastPathConds0[threadID] = currentSet.back().getExpression();
			checkID.insert(threadID);
		}

		cout << "\n### GENERATING CONSTRAINT MODEL11: " << sub << "\n";

		saveUnsatCore = true;

		if (!justCheck) {
			for (map<string, string >::iterator it = preLastPathConds.begin();
						it != preLastPathConds.end(); ++it) {
				lastPathConds0[it->first] = it->second;
			}
		} else {
			for (set<string>::iterator it = revertedID.begin();
						it != revertedID.end(); ++it) {
				lastPathConds0[*it] = tempLastPath[*it];
			}
		}

		updateWriteSet(lastPathConds0, tmpPathSet);
		struct timeval startday, endday;
		gettimeofday(&startday, NULL);
		bool success = checkPath(cmgen, tmpPathSet, prefixInd);
		gettimeofday(&endday, NULL);
		int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
		endday.tv_usec - startday.tv_usec; 
		//printf("check path: %d us\n", timeuse);
		saveUnsatCore = false;
		cmgen->resetSolver();
		if (!timeout && (solutions == "2" || solutions == "3") && !success){ // check whether its an unreachable path
			if (solutions == "2")
			  checkSatisfiability(cmgen, indexes[sub], prefixInd);
			else {
			  checkSatisfiability2(cmgen, indexes[sub], prefixInd);
            }
		}

	}

	//** clean data structures
	readset.clear();
	writeset.clear();
	lockpairset.clear();
	startset.clear();
	exitset.clear();
	forkset.clear();
	joinset.clear();
	waitset.clear();
	signalset.clear();
	syncset.clear();
	pathset.clear();
	lockpairStack.clear();
	operationsByThread.clear();

	//return success;
	return true;
}

/**
 *  Function used to update the counters used to generate all combinations
 *  of symbolic trace files.
 */
bool updateCounters(vector<string> keys, vector<int> *traceCounterByThread)
{
	for(int i = (int)keys.size()-1; i>=0; i--)
	{
		string tid = keys[i];
		if((*traceCounterByThread)[i] < symTracesByThread[tid].size()-1)
		{
			(*traceCounterByThread)[i]++;
			return true;
		}
		else
		{
			(*traceCounterByThread)[i] = 0;
		}
	}
	cout << ">> No more combinations left!\n";
	return false;
}

/**
 *  Comparator to sort filenames in ascending order of their length
 *
 */
bool filenameComparator(string a, string b)
{
	return (a.length() < b.length());
}

void writeReadStr(string prefixStr, string fileName) {

	std::ofstream outFile;
	outFile.open(fileName.c_str(), ios::app);
	if (!outFile.is_open()) {
		cerr << "-> Error opening file" << fileName << ".\n";
		outFile.close();
		exit(1);
	}

	//std::cerr << "new path: " << prefixStr <<  " " << prePath << "\n";
	outFile << prefixStr << "\n";
}

void writePathStr() {
	
    vector<string> pathS;

	string str;
	bool flag = true;
    str = pathString;

	std::string fileName = "CheckedPath";

	fromPath = str;
	ifstream fin;
	fin.open(fileName.c_str());
	if (!fin.good()) {
		cerr << "->Error opening file" << fileName << ".\n";
		fin.close();
		writeReadStr(str, fileName);
		return ;
	}

	char buf[10000];
	string ss;
	while (!fin.eof()) {
		fin.getline(buf, 10000);
		ss = buf;
		if (ss == str) { 
			std::cerr << " redundant str: " << str << " " << prePath << "\n"; 
			//exit(0);
			return ;
		}
	}

	writeReadStr(str, fileName);
	return ;
}

/**
 *  Identify the files containing symbolic traces pick
 *  a set of traces to generate the constraint model
 */
void generateConstraintModel2()
{
	string symbolicFile = "";
	bool foundBug = false;  //boolean var indicating whether the solver found a model that triggers the bug or not
	vector<string> keys;    //vector of strings indicating the names of the threads (used for optimizing the iterations over the other data structures)
	int attempts = 0;       //number of attempts to obtain the buggy interleaving tested so far


	//** instatiate a constrain model generator object
	ConstModelGen* cmgen = new ConstModelGen();
	//cmgen->createZ3Solver();

	//** find symbolic trace files and populate map symTracesByThread
	DIR* dirFile = opendir(symbFolderPath2.c_str());
	if ( dirFile ) {
		struct dirent* hFile;
		while (( hFile = readdir( dirFile )) != NULL ) {
			if ( !strcmp( hFile->d_name, "."  )) continue;
			if ( !strcmp( hFile->d_name, ".." )) continue;

			// in linux hidden files all start with '.'
			if (hFile->d_name[0] == '.' ) continue;

			if ( strstr( hFile->d_name, "T" )) {
				char filename[250];
				strcpy(filename, hFile->d_name);

				//** extract the thread id to serve as key in the map
				string tid = filename;
				tid = tid.substr(tid.find("T")+1,tid.find("_")-1);

				if(symTracesByThread.count(tid)) {
					string shortname = util::extractFileBasename(filename);
					symTracesByThread[tid].push_back(shortname);
				} else {
					vector<string> vec;
					vec.push_back(util::extractFileBasename(filename));
					symTracesByThread[tid] = vec;
				}
			} else if (strstr(hFile->d_name, "prefix")) {
				char filename[250];
				strcpy(filename, hFile->d_name);

				ifstream fin;
				string symbFilePath = symbFolderPath2+"/prefix";
				fin.open(symbFilePath);
				if (!fin.good()) {
					util::print_state(fin);
					cerr << " -> Error opening file "<< symbFilePath <<".\n";
					fin.close();
					exit(1);
				}

				std::cout << ">> Extract Path Prefix From File " << symbFilePath << endl;

				// read each line of the file
				char buf1[10000], buf2[10000];
				string ss1, ss2, ss3;
				bool flag = false;
				while (!fin.eof()) {
					fin.getline(buf1, 10000);
                    ss1 = buf1;
					if (ss1.find("LastConds: End") != string::npos) { 
                      flag = false;
					  continue ;
                    }
                    
					if (ss1.find("From path") != string::npos) {
						prePath = ss1.substr(ss1.find("From path: ") + 11);
						continue ;
					}

                    if (ss1.find("globalOrder: ") != string::npos) {
                        string num = ss1.substr(ss1.find_last_of(" "));
                        std::map<std::string, std::map<std::string, int> > count;
                        for (unsigned j=0; j<util::intValueOf(num); ++j) {
                            fin.getline(buf2, 10000);
                            ss1 = buf2;
                            string len = ss1.substr(ss1.find_last_of(" "));
                            std::vector<std::string> vec;
                            for (unsigned i=0; i<util::intValueOf(len); ++i) {
                                fin.getline(buf2, 10000);
                                ss2 = buf2;
                                if (ss2.find("OW-") != std::string::npos) {
                                    std::string var = ss2.substr(0, ss2.find_last_of("-"));
                                    std::string threadId = ss2.substr(ss2.find_last_of("-")+1);
                                    threadId = threadId.substr(0, threadId.find("&"));
                                    if (count.find(var) == count.end() || count[var].find(threadId) == count[var].end())
                                        count[var][threadId] = 0;

                                    int n = count[var][threadId];
                                    count[var][threadId] = count[var][threadId]+1;
                                    ss2 = var + "-" + threadId + "-" + util::stringValueOf(n) + ss2.substr(ss2.find("&"));
                                }  
                                vec.push_back(ss2);
                            }
                            
                            globalOrders.insert(vec);
                            for (unsigned i=0; i<vec.size()-1; ++i) {
                                std::string expr = "(Slt " + vec[i] + " " + vec[i+1] + ")";
                                PathOperation* po = new PathOperation("0", "", 0, 0, filename, expr);
                                globalOrderConstraints.push_back(*po);
                            }
                        }
                    }

					fin.getline(buf2, 10000);
					ss2 = buf2;
					if (ss1.find("LastConds: Begin") != string::npos) {
						ss1 = ss2;
						fin.getline(buf2, 10000);
						ss2 = buf2;
						flag = true;
					} else if (flag) {
					}

					if (flag) {
						preLastPathConds[ss1] = ss2;
						continue ;
					}

					if (util::intValueOf(ss1) == -1) {
						justCheck = true;						
						minimalIndex = util::intValueOf(ss2);
                        std::cerr << "Just check!!!\n";
						continue;
					}

                    if (ss2 != "") {
                        prefix[buf1] = util::intValueOf(ss2);
                        //std::cerr << "prefix: " << buf1 << " " << ss2 << "\n";
                    }
				}
			}
		}
		closedir( dirFile );
	}

    

	//** test all combinations of traces to find a feasible buggy interleaving
	vector<int> traceCounterByThread; //vector of thread counters (each array position corresponds to a given thread): used to iteratively pick a different thread symb trace to generate the constraint model

	//** initialize counters and sort files in ascending order of their name (i.e. path length)
	for(map<string, vector<string> >:: iterator it = symTracesByThread.begin(); it != symTracesByThread.end() ; ++it)
	{
		traceCounterByThread.push_back(0);
		keys.push_back(it->first);

		//** sort files in ascending order of their name (i.e. path length)
		std::sort(symTracesByThread[it->first].begin(), symTracesByThread[it->first].end(), filenameComparator);
	}

	do
	{
		std::cout << "\n---- ATTEMPT " << attempts << " " << keys.size() << endl;

		//** pick one symbolic trace per thread
		for(int i = 0; i < keys.size(); i++)
		{
			string tid = keys[i];
			parse_constraints(symTracesByThread[tid][traceCounterByThread[i]]);
		}

		writePathStr();

		traverseAllPath(cmgen);

		//debug: print constraints
		if(debug)
		{
			cout<< "\n-- READ SET\n";
			for(map< string, vector<RWOperation> >::iterator out = readset.begin(); out != readset.end(); ++out)
			{
				vector<RWOperation> tmpvec = out->second;
				for(vector<RWOperation>::iterator in = tmpvec.begin() ; in != tmpvec.end(); ++in)
				{
					in->print();
				}
			}

			cout<< "\n-- WRITE SET\n";
			for(map< string, vector<RWOperation> >::iterator out = writeset.begin(); out != writeset.end(); ++out)
			{
				vector<RWOperation> tmpvec = out->second;
				for(vector<RWOperation>::iterator in = tmpvec.begin() ; in != tmpvec.end(); ++in) {
				  in->print();
                }
			}

			cout<< "\n-- LOCKPAIR SET\n";
			for(map<string, vector<LockPairOperation> >::iterator out = lockpairset.begin(); out != lockpairset.end(); ++out)
			{
				vector<LockPairOperation> tmpvec = out->second;
				for(vector<LockPairOperation>::iterator in = tmpvec.begin() ; in!=tmpvec.end(); ++in)
				  in->print();
			}

			cout<< "\n-- WAIT SET\n";
			for(map<string, vector<SyncOperation> >::iterator out = waitset.begin(); out != waitset.end(); ++out)
			{
				vector<SyncOperation> tmpvec = out->second;
				for(vector<SyncOperation>::iterator in = tmpvec.begin() ; in!=tmpvec.end(); ++in)
				  in->print();
			}

			cout<< "\n-- SIGNAL SET\n";
			for(map<string, vector<SyncOperation> >::iterator out = signalset.begin(); out != signalset.end(); ++out)
			{
				vector<SyncOperation> tmpvec = out->second;
				for(vector<SyncOperation>::iterator in = tmpvec.begin() ; in!=tmpvec.end(); ++in)
				  in->print();
			}


			cout<< "\n-- FORK SET\n";
			for (map<string, vector<SyncOperation> >::iterator it=forkset.begin(); it!=forkset.end(); ++it)
			{
				vector<SyncOperation> tmpvec = it->second;
				for(vector<SyncOperation>::iterator in = tmpvec.begin(); in!=tmpvec.end(); ++in)
				  in->print();
			}

			cout<< "\n-- JOIN SET\n";
			for (map<string, vector<SyncOperation> >::iterator it=joinset.begin(); it!=joinset.end(); ++it)
			{
				vector<SyncOperation> tmpvec = it->second;
				for(vector<SyncOperation>::iterator in = tmpvec.begin(); in!=tmpvec.end(); ++in)
				  in->print();
			}

			cout<< "\n-- START SET\n";
			for (map<string, SyncOperation>::iterator it=startset.begin(); it!=startset.end(); ++it)
			{
				it->second.print();
			}

			cout<< "\n-- EXIT SET\n";
			for (map<string, SyncOperation>::iterator it=exitset.begin(); it!=exitset.end(); ++it)
			{
				it->second.print();
			}

			if(!syncset.empty())
			{
				cout<< "\n-- OTHER SYNC SET\n";
				for(vector<SyncOperation>::iterator it = syncset.begin(); it!=syncset.end(); ++it)
				  it->print();
			}

			cout<< "\n-- PATH SET\n";
			for(vector<std::pair<PathOperation, string> >::iterator it = pathset.begin(); it!=pathset.end(); ++it)
			  it->first.print();

			cout<< "\n### OPERATIONS BY THREAD\n";
			for (map<string, Schedule >::iterator it=old_operationsByThread.begin(); it!=old_operationsByThread.end(); ++it)
			{
				cout << "-- Thread " << it->first << endl;
				Schedule tmpvec = it->second;
				for(Schedule::iterator in = tmpvec.begin(); in!=tmpvec.end(); ++in)
				{
					(*in)->print();
				}
			}
		}

		//** generate the constraint model and try to solve it
		foundBug = verifyConstraintModel2(cmgen);
		attempts++;
		break;

	}while(!foundBug && updateCounters(keys, &traceCounterByThread));

	cmgen->closeSolver();
}

/* Generate pairs of events to be inverted, between a given set of operations
 * and the operations in the unsat core.
 * A pair is comprised of two segments, where each segment is itself a pair
 * indicating the init and the end positions in the schedule 
 *
 *  mapOpToId -> maps events to its id in the array containing the failing schedule
 *  opsToInvert -> vector of events to be inverted in the new schedule
 */
vector<EventPair> generateEventPairs(map<string, int> mapOpToId, vector<string> opsToInvert)
{
	vector<EventPair> eventPairs;
	for(vector<string>::iterator it = opsToInvert.begin(); it!=opsToInvert.end();++it)
	{
		string op1 = *it;
		string tid1 = operationLIB::parseThreadId(op1);
		string var1 = util::parseVar(op1);
		Segment seg1 = std::make_pair(mapOpToId[op1],mapOpToId[op1]);

		/* if the operation is not wrapped by a lock, the segment will be a pair
		 * with the position of the operation in the schedule array.
		 * Otherwise, it is a pair with the positions of the lock/unlock operations in the array.*/
		int i;
		for(i = mapOpToId[op1]; i > 0; i--)
		{
			string op2 = solution[i];
			string tid2 = operationLIB::parseThreadId(op2);

			if(op2.find("-lock")!=std::string::npos && tid2 == tid1)
			{
				//the operation is wrapped by a lock
				seg1.first = i;
				break;
			}
			else if (op2.find("-unlock")!=std::string::npos)
			{
				//the operation is not wrapped by a lock
				i = 0;
			}
		}

		if(i > 0) //if wrapped by a lock, find the corresponding unlock
		{
			for(i = mapOpToId[op1]; i < solution.size(); i++)
			{
				string op2 = solution[i];
				if(op2.find("-unlock")!=std::string::npos)
				{
					seg1.second = i;
					break;
				}
			}
		}

		/* generate pairs for the operation in the bug condition and
		   the operations in the unsatCore (from other threads)*/
		cout << "\n>> Event Pairs for '"<< op1 <<"':\n";
		for(int i = 0; i<unsatCore.size(); i++)
		{
			int pos = unsatCore[i];
			string op2 = solution[pos];
			string tid2 = operationLIB::parseThreadId(op2);

			//** disregard events of the same thread, as well as exits/joins
			if(tid1 == tid2
						|| op2.find("-exit-")!=string::npos
						|| op2.find("-FAILURE-")!=string::npos
						|| op2.find("-AssertOK-")!=string::npos
						|| op2.find("-AssertFAIL-")!=string::npos
						|| op2.find("-join_")!=string::npos)
			  continue;

			//** disregard read operations and events (which are not locks) on different variables
			string var2 = util::parseVar(op2);
			if(op2.find("R-")!=string::npos
						|| (op2.find("lock")==string::npos && var1 != var2))
			  continue;

			Segment seg2 = std::make_pair(pos, pos);
			EventPair p;

			//** check whether the operation to be inverted occurs before or after the segment containing the bug condition operation
			if(seg1.first < seg2.first){

				//** if the op occurs concurrently with the critical section, than it is not wrapped by locks and thus can be directly inverted with the bug condition operation
				if(seg1.second > seg2.first){
					Segment segR = std::make_pair(mapOpToId[op1],mapOpToId[op1]);
					p = std::make_pair(seg2, segR);
				}
				else
				  p = std::make_pair(seg1, seg2);
			}
			else
			  p = std::make_pair(seg2, seg1);
			eventPairs.insert(eventPairs.begin(), p);

			cout << pairToString(p, solution);
		}
	}
	return eventPairs;
}

/* Generate a new schedule by inverting the event pairs in the original failing schedule.
*/
vector<string> generateNewSchedule(EventPair invPair)
{
	vector<string> bugCore; //vector used to store the events that compose the 'bug core'; if the event pair produces a sat schedule, then we save the bugCore in the map altSchedules

	//** generate the new schedule by copying the original schedule, apart from the events to be reordered
	int i = 0;
	vector<string> newSchedule;

	//** for a pair (A,B) to be inverted, add events from init to A
	for(i = 0; i < solution.size(); i++)
	{
		if(i == invPair.first.first){
			break;
		}
		newSchedule.push_back(solution[i]);
	}

	//** from A to B add all events that not belong to A's thread
	int j;
	vector<string> aThreadOps; //vector containing the operations after A that belong to A's thread
	//parse A's thread id
	string opA = solution[i];
	size_t init, end;
	string tidA = operationLIB::parseThreadId(opA);

	//parse B's thread id
	string opB = solution[invPair.second.first];
	string tidB = operationLIB::parseThreadId(opB);

	for(j = i; j < solution.size(); j++)
	{
		//stop if we hit the first event of segment B
		if(j == invPair.second.first)
		{
			break;
		}

		//parse op thread id
		string opC = solution[j];
		string tidC = operationLIB::parseThreadId(opC);

		//** we don't want to reorder the events of the other threads (Nuno: we're not doing this at the moment)
		if(tidC!=tidB)//if(tidA == tidB)
		  aThreadOps.push_back(opC);
		else
		  newSchedule.push_back(opC);
	}

	//** add all events of segment B before A
	//** (there might be some events belonging to other threads in seg B,
	//** so add them to aThreadOps)
	// (NOTE: at the end of this loop, 'i' will point to the operation right after segment B's last operation)
	for(i = invPair.second.first; i <= invPair.second.second; i++)
	{
		//parse op thread id
		string opC = solution[i];
		end = opC.find_last_of("-");
		if(opC.find("exit")!=string::npos)
		{
			init = opC.find_last_of("-")+1;
			end = opC.find_last_of("@");
		}
		else
		  init = opC.find_last_of("-",end-1)+1;
		string tidC = opC.substr(init,end-init);

		if(tidC==tidB)
		{
			newSchedule.push_back(opC);
			bugCore.push_back(opC);
		}
		else
		{
			aThreadOps.push_back(opC);
		}
	}

	//** add events of segment of A, and all the other of A's thread that
	//** occurred between A and B
	for(j = 0; j < aThreadOps.size(); j++)
	{
		newSchedule.push_back(aThreadOps[j]);
		bugCore.push_back(aThreadOps[j]);
	}

	//** finally, add the remaining events from B to the end
	for(j = i; j < solution.size(); j++)
	{
		newSchedule.push_back(solution[j]);
	}

	return newSchedule;
}


/**
 *  Algorithm to find the root cause of a given concurrency bug.
 *
 *  Outline:
 *  1) solve constraint model with the bug-inducing schedule and
 *  invert the bug condition to find the constraints that
 *  make the model to be unsat.
 *
 *  2) generate event pairs for the operations in the buggy schedule
 *  that appear in the unsat core and are part of the bug condition
 *
 *  3) for each pair, invert the event order in the buggy schedule
 *  and solve the constraint model with the no-bug constraint again. If
 *  the new model is sat, then it means that we found the root cause.
 *  Otherwise, simply attempt with another pair.
 */
bool findBugRootCause(map<EventPair, vector<string>>* altSchedules, vector<string>* solutionRetriver)
{
	map<string, int> mapOpToId; //map: operation name -> id in 'solution' array
	bool success= false; //indicates whether we have found a bug-avoiding schedule
	int numAttempts = 0; //counts the number of attempts to find a sat alternate schedule

	ConstModelGen* cmgen = new ConstModelGen();
	cmgen->createZ3Solver();

	ifstream inSol(solutionFile);
	string lineSol;

	//** store in 'solution' the failing schedule  
	while (getline(inSol, lineSol))
	{
		//** parse first element of the constraint (e.g. for (< O1 O2) -> parse O1)
		size_t init = lineSol.find_first_of("<")+2;
		size_t end = lineSol.find_first_of(" ",init);
		string constraint = lineSol.substr(init,end-init);
		solution.push_back(constraint);
	}
	inSol.close();

	cmgen->solveWithSolution(solution,true); //** solve the model with the bug condition inverted in order to get the unsat core

	//** sort because the values in unsatCore are often in descending order (which the opposite of the memory-order of the program)
	std::sort(unsatCore.begin(),unsatCore.end());

	//** check if the unsat core begins within a region wrapped by a lock; if so, fetch all the operations until the locking operation
	for(int i = 0; i<unsatCore.size();i++)
	{
		string op = solution[unsatCore[i]];
		if(op.find("-lock")!=std::string::npos)
		  break;
		else if (op.find("-unlock")!=std::string::npos) //we are missing a lock, search backwards in the solution schedule for it
		{
			for(int j = unsatCore[0]-1; j>0; j--)
			{
				string op2 = solution[j];
				unsatCore.insert(unsatCore.begin(), j);
				if(op2.find("-lock")!=std::string::npos)
				  break;
			}
			break;
		}
	}

	cout << "\n>> Operations in unsat core ("<< unsatCore.size() <<"):\n";
	for(int i = 0; i<unsatCore.size();i++)
	{
		string op = solution[unsatCore[i]];
		cout << op << endl;
		mapOpToId[op] = unsatCore[i];
	}

	cout << "\n>> Operations in bug condition ("<< bugCondOps.size() <<"):\n";
	for(int i = 0; i < bugCondOps.size(); i++)
	{
		string bop = bugCondOps[i];
		cout << bop << endl;

		//find the position of each op in the bug condition in the solution array
		for(int j = 0; j<solution.size();j++)
		{
			string op = solution[j];
			if(op.find(bop)!=string::npos)
			{
				int pos = j;
				mapOpToId[bop] = pos;
				break;
			}
		}
	}

	//generate event pairs with the operations from the bug condition
	vector<EventPair> eventPairs = generateEventPairs(mapOpToId, bugCondOps);

	/* Generate a new schedule by inverting the event pairs and try to solve the original constraint model.
	 * If it is sat with the bug condition inverted, than we found the root cause of the bug;
	 * otherwise, attempt again with a new pair
	 */
	for(vector<EventPair>::iterator it = eventPairs.begin(); it!=eventPairs.end();++it)
	{
		EventPair invPair; //the pair to be inverted
		invPair = *it;
		vector<string> newSchedule = generateNewSchedule(invPair);

		cout << "\n------------------------\n";
		cout << "["<< ++numAttempts <<"] Attempt by inverting pair:\n" << pairToString(invPair, solution) << endl;

		bugCondOps.clear(); //clear bugCondOps to avoid getting repeated operations

		success = cmgen->solveWithSolution(newSchedule,true);
		if(success)
		{
			cout << "\n>> FOUND BUG AVOIDING SCHEDULE:\n" << bugCauseToString(invPair, solution);
			//altSchedules[invPair] = bugCore;
			(*altSchedules)[invPair] = newSchedule;
			break;
		}
	}

	//if we haven't found any alternate schedule by manipulating the events in the bug condition
	//let's broad the search scope to consider all reads on variables that appear in the bug condition
	if(!success)
	{
		cout << "\n\n>> No alternate schedule found! Increase search scope to consider other read operations on the variables contained in the bug condition.\n";

		//find the new operations ops to be inverted
		vector<string> opsToInvert;
		for(int i = 0; i < bugCondOps.size(); i++)
		{
			string bop = bugCondOps[i];
			string bvar = util::parseVar(bop);
			cout << "> For "<< bvar <<":\n";
			for(int j = 0; j < mapOpToId[bop]; j++)
			{
				string sop = solution[j];
				string svar = util::parseVar(sop);

				//store operation if its a read on the same var that of the Op in the bug condition
				if(svar == bvar && sop.find("R-")!=string::npos)
				{
					cout << sop << endl;
					opsToInvert.push_back(sop);
					mapOpToId[sop] = j;
				}
			}
		}

		//generate event pairs with the new set of operations
		eventPairs.clear();
		eventPairs = generateEventPairs(mapOpToId, opsToInvert); //NOTE: the unsat at this point might be different from the first one.. this might cut-off some events (?)

		//generate the respective new schedule and attempt to solve the model again
		for(vector<EventPair>::iterator it = eventPairs.begin(); it!=eventPairs.end();++it)
		{
			EventPair invPair; //the pair to be inverted
			invPair = *it;
			vector<string> newSchedule = generateNewSchedule(invPair);

			cout << "\n------------------------\n";
			cout << "["<< ++numAttempts <<"] Attempt by inverting pair:\n" << pairToString(invPair, solution) << endl;

			bugCondOps.clear(); //clear bugCondOps to avoid getting repeated operations
 
			success = cmgen->solveWithSolution(newSchedule,true);
			if(success)
			{
				cout << "\n>> FOUND BUG AVOIDING SCHEDULE:\n" << bugCauseToString(invPair, solution);
				//altSchedules[invPair] = bugCore;
				(*altSchedules)[invPair] = newSchedule;
				break;
			}
		}
	}
	*solutionRetriver = solution;
	return success;
}

int main(int argc, char *const* argv)
{
	gettimeofday(&startday, NULL);
	beginTime = clock();
	parse_args(argc, argv);

	numConstraints = numVariables = 0;
	map<EventPair, vector<string> > altSchedules; //set used to store the event pairs that yield a sat non-failing alternative schedule
	vector<string> solution ;
	if(!bugFixMode)
	{
		generateConstraintModel2(); // 3 for incremental
	} else {

		//findBug
		bool success = findBugRootCause(&altSchedules, &solution);
		if(success) //print data-dependencies and stats only when Symbiosis has found an alternate schedule
		{
			solutionValuesAlt = solutionValues;
			graphgen::drawAllGraph(altSchedules, solution);
		}

		solutionFile.insert(solutionFile.find(".txt"),"ALT");
		scheduleLIB::saveScheduleFile(solutionFile,altScheduleOrd); //save solution schedule
	}

	struct timeval endday;
	gettimeofday(&endday, NULL);
	int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
		endday.tv_usec - startday.tv_usec; 

	exit(successed);
	return 0;
}
