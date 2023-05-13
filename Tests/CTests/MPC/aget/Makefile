CC=/home/llvm-project/build/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=/home/llvm-project/build/bin/clang
LLVM_LLC=llc
LLVM_OPT=/home/llvm-project/build/bin/opt
LLVM_LINK=llvm-link
SYMB_PASS=/home/llvm-project/build/lib/SymbiosisBBPass.so

aget:
	$(LLVM_CC) -emit-llvm -c -g agetKLEE.c -o agetKLEE.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB agetKLEE.bc -o aget_inst.bc


clean:
	-rm result* Values0.txt *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled -rf
