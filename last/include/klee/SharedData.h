#ifndef KLEE_SHAREDDATA_H
#define KLEE_SHAREDDATA_H

class SharedData {
	int x;
public:
	SharedData(int x) {
		this->x = x;
	}

	void dec() {x--;}
};

#endif
