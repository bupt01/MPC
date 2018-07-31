CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

seqlock:
	$(LLVM_CC) -emit-llvm -c -g seqlock.c -o seqlock.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB seqlock.bc -o seqlock_inst.bc

clean:
	-rm *.o *.s result* *.ll *.bc -rf
	-rm CheckedPath paralleled Values0.txt *.bc klee-out-* index_* result* *.ll -rf
