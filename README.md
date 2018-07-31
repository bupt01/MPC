### Installation 
* Install **LLVM-2.9**, **STP**, and **uclibc** as described at http://klee.github.io/build-llvm29/
* Download the Z3 solver version corresponding to your OS from: https://github.com/Z3Prover/z3/wiki
* Build Symbiosis LLVM Pass as indicated by the instructions in folder **Instrumentation**.
* Build SymbiosisRuntime:
```
$ cd SymbiosisRuntime
$ make
```
* Build Symbiosis Symbolic Execution Engine:
```
$ cd SymbiosisSE
$ make
```
* Build Symbiosis Symbolic Solver:
```
$ cd SymbiosisSolver
$ make
```
* Build Engine
```
$ cd Engine
$ make
```

### How to use
```
For how to use MPC, please follow the 'README' in dir 'symbiosis-master/Tests/CTests/MPC'.
```
