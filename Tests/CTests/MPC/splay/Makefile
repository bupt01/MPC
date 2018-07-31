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

splay:
	$(LLVM_CC) -emit-llvm -c -g splayKLEE.c -o splay.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB splay.bc -o splay_inst.bc

splays:
	$(LLVM_CC) -emit-llvm -c -g splay-simpKLEE.c -o splays.bc
	$(LLVM_OPT) -load $(SYMB_PASS) -symbiosisBB splays.bc -o splays_inst.bc

clean:
	-rm paralleled *.o *.s *.ll *.bc klee-out-* CheckedPath* index_* result* paralleled result* Values0.txt -rf
