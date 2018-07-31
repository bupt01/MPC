CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

msqueue:
	$(LLVM_CC) -emit-llvm -c -g msqueue.c -o msqueue.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB msqueue.bc -o msqueue_inst.bc

clean:
	-rm *.o *.s result* *.ll *.bc -rf
	-rm CheckedPath paralleled Values0.txt *.bc klee-out-* index_* result* *.ll -rf 
