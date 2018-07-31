CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_OPT=opt
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

ctrace1:
	$(LLVM_CC) -emit-llvm -c -g ctrace1KLEE.c -o ctrace1.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB ctrace1.bc -o ctrace1_inst.bc

ctrace2:
	$(LLVM_CC) -emit-llvm -c -g ctrace2KLEE.c -o ctrace2.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB ctrace2.bc -o ctrace2_inst.bc

clean:
	-rm *.o *.s result* *.ll *.bc -rf
	-rm CheckedPath* paralleled Values0.txt *.bc klee-out-* index_* result* *.ll -rf
