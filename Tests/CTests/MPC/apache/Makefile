CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
LLVM_LINK=llvm-link
SYMB_PASS=/home/easyqiu/installed/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

apache1:
	$(LLVM_CC) -emit-llvm -c -g apache1KLEE.c -o apache1.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB apache1.bc -o apache1_inst.bc

apache2:
	$(LLVM_CC) -emit-llvm -c -g apache2KLEE.c -o apache2.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB apache2.bc -o apache2_inst.bc

clean:
	-rm *.o *.s result* *.ll *.bc -rf
	-rm CheckedPath paralleled Values0.txt *.bc klee-out-* index_* result* *.ll -rf
