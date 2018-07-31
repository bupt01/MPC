CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=/home/easyqiu/installed/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

linuxrwlock:
	$(LLVM_CC) -emit-llvm -c -g linuxrwlock.c -o linuxrwlock.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB linuxrwlock.bc -o linuxrwlock_inst.bc

clean:
	-rm *.o *.s *.bc *.ll -rf
	-rm CheckedPath* klee-out-* index_* paralleled result* linuxrwlock_inst -rf
