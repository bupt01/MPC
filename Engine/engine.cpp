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
std::string trace="", times="", last="", solutions="";
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

string INSTALL_PATH="/home" ; //= getenv("INSTALL_PATH");
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
	  //cmd = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSE/Release+Asserts/bin/symbiosisse --allow-external-sym-calls --bb-trace=" + trace + "/example.trace.fail " + trace + bcFile + " --times="+times+ " --index=0 --last="+last + " --trace=" + trace;
      cmd = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSE/build/bin/klee --bb-trace=" + trace + "example.trace.fail " + trace +bcFile + " --times="+times+ " --index=0 --last="+last + " --trace=" + trace;
	  std::cout<<"cmd: "<<cmd<<std::endl; 
	  execute(cmd.c_str());
	}
    
	clock_t t = clock();
	pid_t curPID = getpid();
	cmd = "time " + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/symbiosisSolver --trace-folder="+trace+"klee-last --model=" + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/modelCrasher.txt --solution=" + INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/failCrasher.txt --with-solver=" + INSTALL_PATH + "/z3-z3-4.8.8/build/z3 --parallel=0 --times=" + stringValueOf(curPID) + " --last=" + last + " --solutions=" + solutions + " --trace=" + trace + " " + " --bcfile="+bcFile;
	std::cout<<"cmd01:"<<cmd<<std::endl;
	execute(cmd);
	string dir = INSTALL_PATH + "/symbiosis-master/SymbiosisSolver/tmp/";

	std::set<string> checkedFiles;
	string name = "failCrasher.txt_yqp_" + stringValueOf(curPID);
	bool flag;
	int i=-2;

	do {
		DIR* dirFile = opendir(dir.c_str());
	    std::cout<<"dirFile"<<dir.c_str()<<std::endl;
		flag = false;
		if ( dirFile )
		{
			struct dirent* hFile;
			while (( hFile = readdir( dirFile )) != NULL )
			{
				string str = hFile->d_name;
				if ( !strcmp( hFile->d_name, "."  )) continue;
				if ( !strcmp( hFile->d_name, ".." )) continue;

				// in linux hidden files all start with '.'
				if (hFile->d_name[0] == '.' ) continue;

				if ( str.find(name) != std::string::npos &&
							checkedFiles.find(hFile->d_name) == checkedFiles.end()) {
					if ((clock() - beginTime) /1000000 > 3600) {
						std::cerr << "Note: Stop because of exceeding the time limit 3600!\n";
						exit(1);
					}

					checkedFiles.insert(hFile->d_name);
					i = i+2;
					flag = true;
					string Index = stringValueOf(curPID) + "_" + stringValueOf(i); 
                    string Index1 = stringValueOf(curPID) + "_" + stringValueOf(i+1); 

                    char filename[250];
                    strcpy(filename, hFile->d_name);
                    cmd = "mv " + dir + filename + " " + trace+ "index_"+ stringValueOf(curPID) + "_" + stringValueOf(i);
                    std::cout<<"cmd_while:" <<cmd<<std::endl;
                    execute(cmd.c_str());

                    t = clock();

                    cmd = "nohup " + INSTALL_PATH + "/symbiosis-master/SymbiosisSE/build/bin/klee --bb-trace="+trace+"example.trace.fail "+trace+bcFile + " --times="+times+ " --index="+ Index + " --last="+last + " --solutions=" + solutions + " --trace="+trace;
                    std::cout<<"cmd_while01:" <<cmd<<std::endl;
					execute(cmd);

                    cmd = "nohup " + INSTALL_PATH + "/symbiosis-master/Engine/engine --times=1 --last=" + Index + " --solutions=" + solutions + " --trace=" + trace + " " + bcFile;
				    std::cout<<"cmd_while02:" <<cmd<<std::endl;
                    execute(cmd);
				} else {
					;//std::cerr << "skip file: " << hFile->d_name << "\n";
				}

			}
		}
		closedir(dirFile);
	} while (flag);

	for (std::set<pid_t>::iterator it = pids.begin();
				it != pids.end(); ++it) {
		pid_t p = *it;
		int returnStatus;
		waitpid(p, &returnStatus, 0);
	}
	
	return 0;
}
