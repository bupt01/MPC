CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=/home/easyqiu/installed/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

dekker1:
	$(LLVM_CC) -emit-llvm -c -g dekker1.c -o dekker1.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB dekker1.bc -o dekker1_inst.bc

dekker2:
	$(LLVM_CC) -emit-llvm -c -g dekker2.c -o dekker2.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB dekker2.bc -o dekker2_inst.bc

clean:
	-rm *.o *.s *.bc *.ll -rf
	-rm *_inst klee-out-* index_* CheckedPath* result* paralleled -rf
