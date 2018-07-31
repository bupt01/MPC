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
#include <unistd.h>
#include <sys/wait.h>

#include <memory>
#include <stdexcept>

using namespace std;
std::string trace, times, last, solutions;
std::set<pid_t> pids;

//transforms a int into a string
string stringValueOf(int i)
{
    stringstream ss;
    ss << i;
    return ss.str();
}

//transforms a string into an int
int intValueOf(std::string i)
{
    int res;
    stringstream ss(i);
    ss >> res;
    
    return res;
}

std::string bcFile = "";
void parse_args(int argc, char *const* argv) {
	if (argc < 2)
		cerr << "Not enough arguments!\n";

    for (unsigned i=0; i<argc; ++i) {
        std::string s = argv[i];
        if (s.find(".bc") != std::string::npos) {
            bcFile = s;
            break;
        }
    }

	int c;
	while (1) {
		static struct option long_options[] = {
			{"trace", required_argument, 0, 'r'},
			{"times", required_argument, 0, 't'},
			{"last", required_argument, 0, 'l'},
			{"solutions", required_argument, 0, 'o'},
			{"", }
		};

        int option_index = 0;
		c = getopt_long(argc, argv, "", long_options, &option_index);
		if (c == -1)
		  break; 

		switch (c) {
			case 'r': 
				trace = optarg;
				break;

			case 't':
				times = optarg;
				times = times.substr(0, times.find('*'));
				break;

			case 'l':
				last = optarg;
				break
					;
			case 'o':
				solutions = optarg;
				break;



			default:
				abort();
		}
	}
}

pid_t executeWithoutWait(string cmd) {
	pid_t childPid;
	childPid = fork();
	if (childPid == 0) {
		system(cmd.c_str());
		exit(0);
	}

	pids.insert(childPid);
	return childPid;
}


pid_t executeAndWait(string cmd) {
	pid_t childPid;
	childPid = fork();
	if (childPid == 0) {
		system(cmd.c_str());
		exit(0);
	} else {
		int returnStatus;
		waitpid(childPid, &returnStatus, 0);
		if (returnStatus == -1) exit(0);
	}

	return childPid;
}

void execute(string cmd) {
	int retV = system(cmd.c_str());
}

void executeParallel(string cmd) {
	FILE *ls = popen("ps | grep engine | wc -l", "r");
	char buf[256];
	string str;
	while (fgets(buf, sizeof(buf), ls) != 0) {
		str = buf;
		std::cerr << "Running Engine Num: " << str << "\n";
	}
	pclose(ls);

	if (intValueOf(str) > 20) 
	    system(cmd.c_str());
	else {
		std::cerr << "Parallizing!!!\n";
	    executeWithoutWait(cmd);
	}
}


std::string exec(const char* cmd) {
	char buffer[128];
	std::string result = "";
	std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
	if (!pipe) throw std::runtime_error("popen() failed!");
	while (!feof(pipe.get())) {
		if (fgets(buffer, 128, pipe.get()) != NULL)
		  result += buffer;
	}
	return result;
}

bool checkState() {
	string str = "";
	
	//str += exec("ps cax | grep engine");
	str += exec("ps cax | grep z3");
	str += exec("ps cax | grep symbiosis");

	if (str == "")
	  return true;
	else {
	  return false;
    }
}

bool checkSolverState(pid_t pid) {
	string str = "";
	
	//str += exec(("ps cax | grep " + stringValueOf(pid)).c_str());
	str += exec("ps cax | grep symbiosisSolver");

	if (str == "")
	  return true;
	else {
	  return false;
    }
}

string INSTALL_PATH = getenv("INSTALL_PATH");
int main(int argc, char *const* argv) {
	
	double beginTime = clock();
	int pathNum = 0;
	parse_args(argc, argv);

	std::string cmd;
	if (intValueOf(times) == 0) {
		execute("rm klee-* index_* -rf");
		execute("rm CheckedPath -rf");
		execute("rm " + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/failCrasher.txt* -rf");
		execute("rm " + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/modelCrasher.txt* -rf");

	  pathNum++;


	  clock_t t = clock();
	  cmd = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSE/Release+Asserts/bin/symbiosisse --allow-external-sym-calls --bb-trace=" + trace + "/example.trace.fail " + trace + bcFile + " --parallel=1 --times="+times+ " --index=0 --last="+last + " --trace=" + trace;
	  execute(cmd.c_str());
	}

	if (last == "0") {
		while (!checkState()){}
	}

	return 0;
}
