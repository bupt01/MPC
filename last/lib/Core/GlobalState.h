#ifndef KLEE_GLOBALSTATE_H
#define KLEE_GLOBALSTATE_H

#include "klee/ExecutionState.h"

#include <iostream>

// yqp added

namespace klee {
	class ExecutionState;

class ThreadData {
	int threadID;
	ExecutionState *state;


public:
	ThreadData(int id, ExecutionState* state) {
		threadID = id;
		this->state = state;
	}
	
	ExecutionState* getState() {
		return state;
	}
};


class GlobalState {
	std::map<int, ThreadData*> threadDataMap;

public:
	ExecutionState* getState(int threadID) {
		if (threadDataMap.find(threadID) == threadDataMap.end()) {
			//std::cout << "Error: No thread " << threadID << " is created!\n";
			//assert(0);
			//exit(1);
			return NULL;
		} else
			return threadDataMap[threadID]->getState();
	}

	void addState(int id, ExecutionState* state) {
		if (threadDataMap.find(id) == threadDataMap.end()) {
			ThreadData* tData = new ThreadData(id, state);
			threadDataMap[id] = tData;
		} else {
			std::cout << "Error: More than one state exists for thread " << id << "\n"; 
		}
	}

	void deleteState(int id) {
		if (threadDataMap.find(id) == threadDataMap.end()) {
			std::cout << "Error: no thread " << id << " exist!\n";
			//exit(1);
		} else {
			threadDataMap.erase(id);
		}
 	}

	unsigned size() {
		return threadDataMap.size();
	}

	bool isEmpty() {
		if (threadDataMap.size() == 0)
		  return true;
		else
		  return false;
	}

};


}

#endif
