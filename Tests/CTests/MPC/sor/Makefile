CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
LLVM_LINK=llvm-link
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

plain:
	$(CC) $(CFLAGS) -o example example.c $(LDFLAGS)

sor:
	$(LLVM_CC) -emit-llvm -c -g sor-bug-isolaKLEE.c -o sor.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB sor.bc -o sor_inst.bc

clean:
	-rm paralleled *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled result* -rf
