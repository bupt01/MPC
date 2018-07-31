CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
LLVM_LINK=llvm-link
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

aget:
	$(LLVM_CC) -emit-llvm -c -g agetKLEE.c -o agetKLEE.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB agetKLEE.bc -o aget_inst.bc


clean:
	-rm result* Values0.txt *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled -rf
