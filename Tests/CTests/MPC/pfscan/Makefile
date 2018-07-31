CC=/usr/bin/clang
CFLAGS=-g
LDFLAGS=-lpthread

LLVM_CC=llvm-gcc
LLVM_LLC=llc
LLVM_OPT=opt
LLVM_LINK=llvm-link
SYMB_PASS=$(INSTALL_PATH)/llvm-2.9/Release+Asserts/lib/SymbiosisBBPass.so

pfscan:
	$(LLVM_CC) -emit-llvm -c -g pfscanKLEE.c -o pfscanKLEE.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB pfscanKLEE.bc -o pfscan_inst.bc

pfscan2:
	$(LLVM_CC) -emit-llvm -c -g pfscanKLEE2.c -o pfscanKLEE.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB pfscanKLEE.bc -o pfscan_inst.bc

clean:
	-rm *.o *.s result* *.ll *.bc -rf
	-rm CheckedPath paralleled Values0.txt *.bc klee-out-* index_* result* *.ll -rf 
