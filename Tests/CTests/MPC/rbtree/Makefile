CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
LLVM_LINK=llvm-link
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

rbtree:
	$(LLVM_CC) -emit-llvm -c -g rbtreeKLEE.c -o rbtree.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB rbtree.bc -o rbtree_inst.bc

clean:
	-rm *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled *.bc -rf
