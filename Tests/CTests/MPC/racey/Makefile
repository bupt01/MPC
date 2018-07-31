CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

all: plain

racey:
	$(LLVM_CC) -emit-llvm -c -g racey.c -o racey.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB racey.bc -o racey_inst.bc

clean:
	-rm *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled *.bc -rf
