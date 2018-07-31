CC=g++
C_FLAGS=-std=c++11 -c

all: 
	$(CC) $(C_FLAGS) engine.cpp -o engine.o
	$(CC) engine.o -o engine
	$(CC) $(C_FLAGS) engine_p.cpp -o engine_p.o
	$(CC) engine_p.o -o engine_p

clean:
	rm *.o engine engine_p
