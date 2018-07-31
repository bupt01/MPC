
### Steps for checking 'mymotivation':

* Step0: 
```
export $PATH=/path/to/llvm-2.9/bin/:$PATH
export $PATH=/path/to/llvm-2.9/Release+Asserts/lib/:$PATH
export $PATH=/path/to/symbolisis/SymbiosisRuntime:$PATH
cd mymotivation

```
* Step1: 
```
Insert statements 'klee_make_symbolic' in source file 'M0.c'. 
       
Specifically, to make global variable 'x' with 'klee_make_symbolic(&x, sizeof(x), "shared*x")'.
input variable 'i' with 'klee_make_symbolic(&i, sizeof(i), "i")';
```
* Step2: 
```
make RUN KLEE
```
* Step3: 
```
nohup ../../../../Engine/engine --last=0 --times=0 --trace=$PWD/ --solutions=1 M0_inst.bc > result & 
(engine_p is for parallelization, solutions=1,3 represents the solution1/2 in our paper)
change the '--trace' argument, which represents the place of the checked program.  
```
