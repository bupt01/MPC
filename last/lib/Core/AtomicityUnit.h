#ifndef KLEE_ATOMICITYUNIT_H
#define KLEE_ATOMICITYUNIT_H

#include "klee/ExecutionState.h"

#include <iostream>
#include <set>

// yqp added

namespace klee {
	class ExecutionState;

class AU {
public:
	std::string filename;
	int bLine;
	int eLine;

	AU(std::string file, int beg, int end) {
		filename = file;
		bLine = beg;
		eLine = end;
	}
};

class AtomicityUnit {
	std::set<AU*> AUs;
	std::map<std::string, std::set<int> > skipLines;

public:
	void addAU(std::string file, int beg, int end) {
		AU* au = new AU(file, beg, end);
		AUs.insert(au);
	}

	void addSkipLines(std::string file, int line) {
		if (skipLines.find(file) == skipLines.end()) {
			std::set<int> v;
			v.insert(line);
			skipLines[file] = v;
		} else {
			skipLines[file].insert(line);
		}
	}

	int getSkipLine(std::string file, int line) {
		if (skipLines.find(file) == skipLines.end())
		  return -1;
		if (skipLines[file].find(line) != skipLines[file].end())
		  return 1;
		return -1;
	}

	AU* getAU(std::string file, int line) {
		for (std::set<AU*>::iterator it = AUs.begin();
					it != AUs.end(); ++it) {
			AU* au = *it;
			if (au->filename != file)
			    continue ;
			if (line >= au->bLine && line <= au->eLine)
			    return au;
		}
		return NULL;
	}
	
	AU* getAU2(std::string file, int line) {
		//std::cerr << "in getAU2: " << AUs.size() << " " << line << "\n";
		for (std::set<AU*>::iterator it = AUs.begin();
					it != AUs.end(); ++it) {
			AU* au = *it;
			//std::cerr << "b&e: " << au->bLine << " " << au->eLine << "\n";
			//std::cerr << "file: " << file << " " << au->filename << "\n";
			if (au->filename != file)
			    continue ;
			if (line == au->bLine || line == au->eLine)
			    return au;
		}
		//std::cerr << "return null!\n";
		return NULL;
	}

};


}

#endif
