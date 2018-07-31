CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
SYMB_PASS=/home/easyqiu/installed/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

spinlock1:
	$(LLVM_CC) -emit-llvm -c -g spinlock1.c -o spinlock1.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB spinlock1.bc -o spinlock1_inst.bc

spinlock2:
	$(LLVM_CC) -emit-llvm -c -g spinlock2.c -o spinlock2.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB spinlock2.bc -o spinlock2_inst.bc

clean:
	-rm *.o *.s *.bc *.ll CheckedPath* -rf
	-rm klee-out-* result* paralleled index_* spinlock1_inst spinlock2_inst Values0.txt -rf
