//===-- Executor.cpp ------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Common.h"

#include "Executor.h"
 
#include "Context.h"
#include "CoreStats.h"
#include "ExternalDispatcher.h"
#include "ImpliedValue.h"
#include "Memory.h"
#include "MemoryManager.h"
#include "PTree.h"
#include "Searcher.h"
#include "SeedInfo.h"
#include "SpecialFunctionHandler.h"
#include "StatsTracker.h"
#include "TimingSolver.h"
#include "UserSearcher.h"
#include "../Solver/SolverStats.h"

#include "klee/ClapUtil.h" //:CLAP:
#include <unistd.h>

#include "klee/ExecutionState.h"
#include "klee/Expr.h"
#include "klee/Interpreter.h"
#include "klee/TimerStatIncrementer.h"
#include "klee/util/Assignment.h"
#include "klee/util/ExprPPrinter.h"
#include "klee/util/ExprUtil.h"
#include "klee/util/GetElementPtrTypeIterator.h"
#include "klee/Config/Version.h"
#include "klee/Internal/ADT/KTest.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/FloatEvaluation.h"
#include "klee/Internal/System/Time.h"
#include "klee/SharedData.h" //yqp

#include "llvm/Attributes.h"
#include "llvm/BasicBlock.h"
#include "llvm/Constants.h"
#include "llvm/Function.h"
#include "llvm/Instructions.h"
#include "llvm/IntrinsicInst.h"
#if LLVM_VERSION_CODE >= LLVM_VERSION(2, 7)
#include "llvm/LLVMContext.h"
#endif
#include "llvm/Module.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CallSite.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 9)
#include "llvm/System/Process.h"
#else
#include "llvm/Support/Process.h"
#endif
#include "llvm/Target/TargetData.h"

#include <cassert>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <utility>
#include <stdlib.h>
#include <string>

#include <sys/mman.h>

#include <errno.h>
#include <cxxabi.h>

#include <sys/timeb.h>
#include <sys/time.h>

using namespace llvm;
using namespace klee;

extern string Times, Index, Last, Solutions, Trace;
struct timeval startday;
int currentLine;

namespace {
  cl::opt<bool>
  DumpStatesOnHalt("dump-states-on-halt",
                   cl::init(true));
 
  cl::opt<bool>
  NoPreferCex("no-prefer-cex",
              cl::init(false));
 
  cl::opt<bool>
  UseAsmAddresses("use-asm-addresses",
                  cl::init(false));
 
  cl::opt<bool>
  RandomizeFork("randomize-fork",
                cl::init(false));
 
  cl::opt<bool>
  AllowExternalSymCalls("allow-external-sym-calls",
                        cl::init(false));

  cl::opt<bool>
  DebugPrintInstructions("debug-print-instructions", 
                         cl::desc("Print instructions during execution."));

  cl::opt<bool>
  DebugCheckForImpliedValues("debug-check-for-implied-values");


  cl::opt<bool>
  SimplifySymIndices("simplify-sym-indices",
                     cl::init(false));

  cl::opt<unsigned>
  MaxSymArraySize("max-sym-array-size",
                  cl::init(0));

  //:CLAP:
  cl::opt<bool>
  DebugValidateSolver("debug-validate-solver",
		      cl::init(false));

  cl::opt<bool>
  SuppressExternalWarnings("suppress-external-warnings");

  cl::opt<bool>
  AllExternalWarnings("all-external-warnings");

  cl::opt<bool>
  OnlyOutputStatesCoveringNew("only-output-states-covering-new",
                              cl::init(false));

  //:CLAP:
  cl::opt<bool>
  AlwaysOutputSeeds("always-output-seeds",
                              cl::init(true));

  //:CLAP:
  cl::opt<bool>
  UseFastCexSolver("use-fast-cex-solver",
		   cl::init(false));

  //:CLAP:
  cl::opt<bool>
  UseIndependentSolver("use-independent-solver",
                       cl::init(true),
		       cl::desc("Use constraint independence"));

  cl::opt<bool>
  EmitAllErrors("emit-all-errors",
                cl::init(false),
                cl::desc("Generate tests cases for all errors "
                         "(default=one per (error,instruction) pair)"));

  //:CLAP:
  cl::opt<bool>
  UseCexCache("use-cex-cache",
              cl::init(true),
	      cl::desc("Use counterexample caching"));

  //:CLAP:
  cl::opt<bool>
  UseQueryPCLog("use-query-pc-log",
                cl::init(false));
  
  //:CLAP:
  cl::opt<bool>
  UseSTPQueryPCLog("use-stp-query-pc-log",
                   cl::init(false));

  cl::opt<bool>
  NoExternals("no-externals", 
           cl::desc("Do not allow external functin calls"));

  //:CLAP:
  cl::opt<bool>
  UseCache("use-cache",
	   cl::init(true),
	   cl::desc("Use validity caching"));

  cl::opt<bool>
  OnlyReplaySeeds("only-replay-seeds", 
                  cl::desc("Discard states that do not have a seed."));
 
  cl::opt<bool>
  OnlySeed("only-seed", 
           cl::desc("Stop execution after seeding is done without doing regular search."));
 
  cl::opt<bool>
  AllowSeedExtension("allow-seed-extension", 
                     cl::desc("Allow extra (unbound) values to become symbolic during seeding."));
 
  cl::opt<bool>
  ZeroSeedExtension("zero-seed-extension");
 
  cl::opt<bool>
  AllowSeedTruncation("allow-seed-truncation", 
                      cl::desc("Allow smaller buffers than in seeds."));
 
  cl::opt<bool>
  NamedSeedMatching("named-seed-matching",
                    cl::desc("Use names to match symbolic objects to inputs."));

  cl::opt<double>
  MaxStaticForkPct("max-static-fork-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticSolvePct("max-static-solve-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticCPForkPct("max-static-cpfork-pct", cl::init(1.));
  cl::opt<double>
  MaxStaticCPSolvePct("max-static-cpsolve-pct", cl::init(1.));

  cl::opt<double>
  MaxInstructionTime("max-instruction-time",
                     cl::desc("Only allow a single instruction to take this much time (default=0s (off)). Enables --use-forked-stp"),
                     cl::init(0));
  
  cl::opt<double>
  SeedTime("seed-time",
           cl::desc("Amount of time to dedicate to seeds, before normal search (default=0 (off))"),
           cl::init(0));
  
  //:CLAP:
  cl::opt<double>
  MaxSTPTime("max-stp-time",
             cl::desc("Maximum amount of time for a single query (default=0s (off)). Enables --use-forked-stp"),
             cl::init(0.0));
  
  cl::opt<unsigned int>
  StopAfterNInstructions("stop-after-n-instructions",
                         cl::desc("Stop execution after specified number of instructions (0=off)"),
                         cl::init(0));
  
  cl::opt<unsigned>
  MaxForks("max-forks",
           cl::desc("Only fork this many times (-1=off)"),
           cl::init(~0u));
  
  cl::opt<unsigned>
  MaxDepth("max-depth",
           cl::desc("Only allow this many symbolic branches (0=off)"),
           cl::init(0));
  
  cl::opt<unsigned>
  MaxMemory("max-memory",
            cl::desc("Refuse to fork when more above this about of memory (in MB, 0=off)"),
            cl::init(0));

  cl::opt<bool>
  MaxMemoryInhibit("max-memory-inhibit",
            cl::desc("Inhibit forking at memory cap (vs. random terminate)"),
            cl::init(true));

  cl::opt<bool>
  UseForkedSTP("use-forked-stp", 
                 cl::desc("Run STP in a forked process (default=off)"));

  cl::opt<bool>
  STPOptimizeDivides("stp-optimize-divides", 
                 cl::desc("Optimize constant divides into add/shift/multiplies before passing to STP"),
                 cl::init(true));
    
    //Symbiosis
    cl::opt<string>
    bbTrace("bb-trace",
                 cl::desc("Use a particular basic block trace to guide the symbolic execution"),
               cl::init(""));
	//Symbiosis
    cl::opt<string>
    Symargs("sym-args",
                 cl::desc("Use a particular basic block trace to guide the symbolic execution"),
               cl::init(""));

	//yqp
    cl::opt<string>
    Timess("times",
                 cl::desc("Used to identify the times that symbolicsolver been invoked"),
			   cl::init(""));
    
    //yqp
    cl::opt<string>
    Parallell("parallel",
                 cl::desc("Used to identify whether it is paralled"),
			   cl::init(""));

	//yqp
    cl::opt<string>
    Traces("trace",
                 cl::desc("Used to identify the times that symbolicsolver been invoked"),
			   cl::init(""));

          
	//yqp
    cl::opt<string>
    Indexs("index",
                 cl::desc("Used to identify handling the index-th order file"),
               cl::init(""));
	
	cl::opt<string>
    Lasts("last",
                 cl::desc("Used to identify the times that symbolicsolver been invoked"),
			   cl::init(""));

	cl::opt<string>
    Solutionss("solutions",
                 cl::desc("Used to identify the used strategy"),
			   cl::init(""));

	cl::opt<string>
    Parallel("parallel",
                 cl::desc("Used to identify the used strategy"),
			   cl::init(""));

}


namespace klee {
  RNG theRNG;
}

//:CLAP: !!!
Solver *constructSolverChain(STPSolver *stpSolver,
                             std::string queryLogPath,
                             std::string stpQueryLogPath,
                             std::string queryPCLogPath,
                             std::string stpQueryPCLogPath) {
  Solver *solver = stpSolver;

  if (UseSTPQueryPCLog)
    solver = createPCLoggingSolver(solver, 
                                   stpQueryLogPath);

  if (UseFastCexSolver)
    solver = createFastCexSolver(solver);

  if (UseCexCache)
    solver = createCexCachingSolver(solver);

  if (UseCache)
    solver = createCachingSolver(solver);

  if (UseIndependentSolver)
    solver = createIndependentSolver(solver);

  if (DebugValidateSolver)
    solver = createValidatingSolver(solver, stpSolver);

  if (UseQueryPCLog)
    solver = createPCLoggingSolver(solver, 
                                   queryPCLogPath);
  
  return solver;
}

// yqp
static std::string getexepath(string dir) {
	char result[50];
	ssize_t count = readlink(dir.c_str(), result, 50 );
	return std::string( result, (count > 0) ? count : 0 );
}

Executor::Executor(const InterpreterOptions &opts,
                   InterpreterHandler *ih) 
  : Interpreter(opts),
    kmodule(0),
    interpreterHandler(ih),
    searcher(0),
    externalDispatcher(new ExternalDispatcher()),
    statsTracker(0),
    pathWriter(0),
    symPathWriter(0),
    specialFunctionHandler(0),
    processTree(0),
    replayOut(0),
    replayPath(0),    
    usingSeeds(0),
    atMemoryLimit(false),
    inhibitForking(false),
    haltExecution(false),
    ivcEnabled(false),
    stpTimeout(MaxSTPTime != 0 && MaxInstructionTime != 0
      ? std::min(MaxSTPTime,MaxInstructionTime)
      : std::max(MaxSTPTime,MaxInstructionTime)) {
  if (stpTimeout) UseForkedSTP = true;
  STPSolver *stpSolver = new STPSolver(UseForkedSTP, STPOptimizeDivides);
  Solver *solver = 
    constructSolverChain(stpSolver,
                         interpreterHandler->getOutputFilename("queries.qlog"),
                         interpreterHandler->getOutputFilename("stp-queries.qlog"),
                         interpreterHandler->getOutputFilename("queries.pc"),
                         interpreterHandler->getOutputFilename("stp-queries.pc"));
  
  this->solver = new TimingSolver(solver, stpSolver);

  memory = new MemoryManager();

  setThreadName("0"); //:CLAP:
  tid=1;

  initTidMap(); // yqp
  std::string fileName = getexepath(bbTrace) + "index";
  ifstream fin;
  fin.open(fileName.c_str());
  if (!fin.good()) {
     executionBasedOnGivenOrder = false;
  } else 
     executionBasedOnGivenOrder = true;
  fin.close();
  
  gState = new GlobalState();
}

//Nuno: transforms an int into a string
string stringValueOf(int i)
{
    stringstream ss;
    ss << i;
    return ss.str();
}

//Nuno: transforms a string into an int
int intValueOf(std::string i)
{
    int res;
    stringstream ss(i);
    ss >> res;
    
    return res;
}

const Module *Executor::setModule(llvm::Module *module,
                                  const ModuleOptions &opts) {
    assert(!kmodule && module && "can only register one module"); // XXX gross
    
    for(Module::iterator f = module->begin(), fe=module->end();f!=fe;++f)
    {
        Function::iterator BB = f->begin(), BE=f->end();
        for(;BB!=BE;++BB)
        {
            basicblocks.push_back(BB);
        }
    }

    string tPath = bbTrace;
    
    kmodule = new KModule(module);
    
    // Initialize the context.
    TargetData *TD = kmodule->targetData;
    Context::initialize(TD->isLittleEndian(),
                        (Expr::Width) TD->getPointerSizeInBits());
    
    specialFunctionHandler = new SpecialFunctionHandler(*this);
    
    specialFunctionHandler->prepare();
    kmodule->prepare(opts, interpreterHandler);
    specialFunctionHandler->bind();
    
    if (StatsTracker::useStatistics()) {
        statsTracker =
        new StatsTracker(*this,
                         interpreterHandler->getOutputFilename("assembly.ll"),
                         userSearcherRequiresMD2U());
    }
    
    std::ostream &traceFile = interpreterHandler->getTraceStream();
    traceFile << "<readwrite>\n";
    traceFile.flush();
    
    return module;
}



Executor::~Executor() {
  delete memory;
  delete externalDispatcher;
  if (processTree)
    delete processTree;
  if (specialFunctionHandler)
    delete specialFunctionHandler;
  if (statsTracker)
    delete statsTracker;
  delete solver;
  delete kmodule;
}

/***/

void Executor::initializeGlobalObject(ExecutionState &state, ObjectState *os,
                                      const Constant *c, 
                                      unsigned offset) {
  TargetData *targetData = kmodule->targetData;
  if (const ConstantVector *cp = dyn_cast<ConstantVector>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cp->getType()->getElementType());
    for (unsigned i=0, e=cp->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cp->getOperand(i), 
			     offset + i*elementSize);
  } else if (isa<ConstantAggregateZero>(c)) {
    unsigned i, size = targetData->getTypeStoreSize(c->getType());
    for (i=0; i<size; i++)
      os->write8(offset+i, (uint8_t) 0);
  } else if (const ConstantArray *ca = dyn_cast<ConstantArray>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(ca->getType()->getElementType());
    for (unsigned i=0, e=ca->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, ca->getOperand(i), 
			     offset + i*elementSize);
  } else if (const ConstantStruct *cs = dyn_cast<ConstantStruct>(c)) {
    const StructLayout *sl =
      targetData->getStructLayout(cast<StructType>(cs->getType()));
    for (unsigned i=0, e=cs->getNumOperands(); i != e; ++i)
      initializeGlobalObject(state, os, cs->getOperand(i), 
			     offset + sl->getElementOffset(i));
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
  } else if (const ConstantDataSequential *cds =
               dyn_cast<ConstantDataSequential>(c)) {
    unsigned elementSize =
      targetData->getTypeStoreSize(cds->getElementType());
    for (unsigned i=0, e=cds->getNumElements(); i != e; ++i)
      initializeGlobalObject(state, os, cds->getElementAsConstant(i),
                             offset + i*elementSize);
#endif
  } else {
    unsigned StoreBits = targetData->getTypeStoreSizeInBits(c->getType());
    ref<ConstantExpr> C = evalConstant(c);

    // Extend the constant if necessary;
    assert(StoreBits >= C->getWidth() && "Invalid store size!");
    if (StoreBits > C->getWidth())
      C = C->ZExt(StoreBits);

    os->write(offset, C);
  }
}

MemoryObject * Executor::addExternalObject(ExecutionState &state, 
                                           void *addr, unsigned size, 
                                           bool isReadOnly) {
  MemoryObject *mo = memory->allocateFixed((uint64_t) (unsigned long) addr, 
                                           size, 0);
  ObjectState *os = bindObjectInState(state, mo, false);
  for(unsigned i = 0; i < size; i++)
    os->write8(i, ((uint8_t*)addr)[i]);
  if(isReadOnly)
    os->setReadOnly(true);  
  return mo;
}


extern void *__dso_handle __attribute__ ((__weak__));

void Executor::initializeGlobals(ExecutionState &state) {
  Module *m = kmodule->module;

  if (m->getModuleInlineAsm() != "")
    klee_warning("executable has module level assembly (ignoring)");

  assert(m->lib_begin() == m->lib_end() &&
         "XXX do not support dependent libraries");

  // represent function globals using the address of the actual llvm function
  // object. given that we use malloc to allocate memory in states this also
  // ensures that we won't conflict. we don't need to allocate a memory object
  // since reading/writing via a function pointer is unsupported anyway.
  for (Module::iterator i = m->begin(), ie = m->end(); i != ie; ++i) {
    Function *f = i;
    ref<ConstantExpr> addr(0);

    // If the symbol has external weak linkage then it is implicitly
    // not defined in this module; if it isn't resolvable then it
    // should be null.
    if (f->hasExternalWeakLinkage() && 
        !externalDispatcher->resolveSymbol(f->getName())) {
      addr = Expr::createPointer(0);
    } else {
      addr = Expr::createPointer((unsigned long) (void*) f);
      legalFunctions.insert((uint64_t) (unsigned long) (void*) f);
    }
    
    globalAddresses.insert(std::make_pair(f, addr));
  }

  // Disabled, we don't want to promote use of live externals.
#ifdef HAVE_CTYPE_EXTERNALS
#ifndef WINDOWS
#ifndef DARWIN
  /* From /usr/include/errno.h: it [errno] is a per-thread variable. */
  int *errno_addr = __errno_location();
  addExternalObject(state, (void *)errno_addr, sizeof *errno_addr, false);

  /* from /usr/include/ctype.h:
       These point into arrays of 384, so they can be indexed by any `unsigned
       char' value [0,255]; by EOF (-1); or by any `signed char' value
       [-128,-1).  ISO C requires that the ctype functions work for `unsigned */
  const uint16_t **addr = __ctype_b_loc();
  addExternalObject(state, (void *)(*addr-128), 
                    384 * sizeof **addr, true);
  addExternalObject(state, addr, sizeof(*addr), true);
    
  const int32_t **lower_addr = __ctype_tolower_loc();
  addExternalObject(state, (void *)(*lower_addr-128), 
                    384 * sizeof **lower_addr, true);
  addExternalObject(state, lower_addr, sizeof(*lower_addr), true);
  
  const int32_t **upper_addr = __ctype_toupper_loc();
  addExternalObject(state, (void *)(*upper_addr-128), 
                    384 * sizeof **upper_addr, true);
  addExternalObject(state, upper_addr, sizeof(*upper_addr), true);
#endif
#endif
#endif

  // allocate and initialize globals, done in two passes since we may
  // need address of a global in order to initialize some other one.

  // allocate memory objects for all globals
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    if (i->isDeclaration()) {
      // FIXME: We have no general way of handling unknown external
      // symbols. If we really cared about making external stuff work
      // better we could support user definition, or use the EXE style
      // hack where we check the object file information.

      LLVM_TYPE_Q Type *ty = i->getType()->getElementType();
      uint64_t size = kmodule->targetData->getTypeStoreSize(ty);

      // XXX - DWD - hardcode some things until we decide how to fix.
#ifndef WINDOWS
      if (i->getName() == "_ZTVN10__cxxabiv117__class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv120__si_class_type_infoE") {
        size = 0x2C;
      } else if (i->getName() == "_ZTVN10__cxxabiv121__vmi_class_type_infoE") {
        size = 0x2C;
      }
#endif

      if (size == 0) {
        llvm::errs() << "Unable to find size for global variable: " 
                     << i->getName() 
                     << " (use will result in out of bounds access)\n";
      }

      MemoryObject *mo = memory->allocate(size, false, true, i);
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(i, mo));
      globalAddresses.insert(std::make_pair(i, mo->getBaseExpr()));

      // Program already running = object already initialized.  Read
      // concrete value and write it to our copy.
      if (size) {
        void *addr;
        if (i->getName() == "__dso_handle") {
          addr = &__dso_handle; // wtf ?
        } else {
          addr = externalDispatcher->resolveSymbol(i->getName());
        }
        if (!addr)
          klee_error("unable to load symbol(%s) while initializing globals.", 
                     i->getName().data());

        for (unsigned offset=0; offset<mo->size; offset++)
          os->write8(offset, ((unsigned char*)addr)[offset]);
      }
    } else {
      LLVM_TYPE_Q Type *ty = i->getType()->getElementType();
      uint64_t size = kmodule->targetData->getTypeStoreSize(ty);
      MemoryObject *mo = 0;

      if (UseAsmAddresses && i->getName()[0]=='\01') {
        char *end;
        uint64_t address = ::strtoll(i->getName().str().c_str()+1, &end, 0);
        if (end && *end == '\0') {
          klee_message("NOTE: allocated global at asm specified address: %#08llx"
                       " (%llu bytes)",
                       (long long) address, (unsigned long long) size);
          mo = memory->allocateFixed(address, size, &*i);
          mo->isUserSpecified = true; // XXX hack;
        }
      }

      if (!mo)
        mo = memory->allocate(size, false, true, &*i);
      assert(mo && "out of memory");
      ObjectState *os = bindObjectInState(state, mo, false);
      globalObjects.insert(std::make_pair(i, mo));
      globalAddresses.insert(std::make_pair(i, mo->getBaseExpr()));

      if (!i->hasInitializer())
          os->initializeToRandom();
    }
  }
  
  // link aliases to their definitions (if bound)
  for (Module::alias_iterator i = m->alias_begin(), ie = m->alias_end(); 
       i != ie; ++i) {
    // Map the alias to its aliasee's address. This works because we have
    // addresses for everything, even undefined functions. 
    globalAddresses.insert(std::make_pair(i, evalConstant(i->getAliasee())));
  }

  // once all objects are allocated, do the actual initialization
  for (Module::const_global_iterator i = m->global_begin(),
         e = m->global_end();
       i != e; ++i) {
    if (i->hasInitializer()) {
      MemoryObject *mo = globalObjects.find(i)->second;
      const ObjectState *os = state.addressSpace.findObject(mo);
      assert(os);
      ObjectState *wos = state.addressSpace.getWriteable(mo, os);
      
      initializeGlobalObject(state, wos, i->getInitializer(), 0);
    }
  }
}

void Executor::branch(ExecutionState &state, 
                      const std::vector< ref<Expr> > &conditions,
                      std::vector<ExecutionState*> &result) {
  TimerStatIncrementer timer(stats::forkTime);
  unsigned N = conditions.size();
  assert(N);

  stats::forks += N-1;

  // XXX do proper balance or keep random?
  result.push_back(&state);
  for (unsigned i=1; i<N; ++i) {
    ExecutionState *es = result[theRNG.getInt32() % i];
    ExecutionState *ns = es->branch();
    addedStates.insert(ns);
    result.push_back(ns);
    es->ptreeNode->data = 0;
    std::pair<PTree::Node*,PTree::Node*> res = 
      processTree->split(es->ptreeNode, ns, es);
    ns->ptreeNode = res.first;
    es->ptreeNode = res.second;
  }

  // If necessary redistribute seeds to match conditions, killing
  // states if necessary due to OnlyReplaySeeds (inefficient but
  // simple).
  
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    std::vector<SeedInfo> seeds = it->second;
    seedMap.erase(it);

    // Assume each seed only satisfies one condition (necessarily true
    // when conditions are mutually exclusive and their conjunction is
    // a tautology).
    for (std::vector<SeedInfo>::iterator siit = seeds.begin(), 
           siie = seeds.end(); siit != siie; ++siit) {
      unsigned i;
      for (i=0; i<N; ++i) {
        ref<ConstantExpr> res;
        bool success = 
          solver->getValue(state, siit->assignment.evaluate(conditions[i]), 
                           res);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (res->isTrue())
          break;
      }
      
      // If we didn't find a satisfying condition randomly pick one
      // (the seed will be patched).
      if (i==N)
        i = theRNG.getInt32() % N;

      seedMap[result[i]].push_back(*siit);
    }

    if (OnlyReplaySeeds) {
      for (unsigned i=0; i<N; ++i) {
        if (!seedMap.count(result[i])) {
          terminateState(*result[i]);
          result[i] = NULL;
        }
      } 
    }
  }

  for (unsigned i=0; i<N; ++i)
    if (result[i]) {
      addConstraint(*result[i], conditions[i]);
	  addConstraint1(*result[i], conditions[i]);
	}
}

Executor::StatePair
Executor::fork(ExecutionState &current, ref<Expr> condition, ref<Expr> condition1, bool isInternal) {
    Solver::Validity res;
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it =
    seedMap.find(&current);
    bool isSeeding = it != seedMap.end();
    
    if (!isSeeding && !isa<ConstantExpr>(condition) &&
        (MaxStaticForkPct!=1. || MaxStaticSolvePct != 1. ||
         MaxStaticCPForkPct!=1. || MaxStaticCPSolvePct != 1.) &&
        statsTracker->elapsed() > 60.) {
        
        StatisticManager &sm = *theStatisticManager;
        CallPathNode *cpn = current.stack.back().callPathNode;
        if ((MaxStaticForkPct<1. &&
             sm.getIndexedValue(stats::forks, sm.getIndex()) >
             stats::forks*MaxStaticForkPct) ||
            (MaxStaticCPForkPct<1. &&
             cpn && (cpn->statistics.getValue(stats::forks) >
                     stats::forks*MaxStaticCPForkPct)) ||
            (MaxStaticSolvePct<1 &&
             sm.getIndexedValue(stats::solverTime, sm.getIndex()) >
             stats::solverTime*MaxStaticSolvePct) ||
            (MaxStaticCPForkPct<1. &&
             cpn && (cpn->statistics.getValue(stats::solverTime) >
                     stats::solverTime*MaxStaticCPSolvePct))) {
                 ref<ConstantExpr> value;
                 bool success = solver->getValue(current, condition, value);
                 
                 assert(success && "FIXME: Unhandled solver failure");
                 (void) success;
                 addConstraint(current, EqExpr::create(value, condition));
                 condition = value;
             }
    }
    
    double timeout = stpTimeout;
    if (isSeeding)
        timeout *= it->second.size();
    solver->setTimeout(timeout);
    bool success = solver->evaluate(current, condition, res);
    
    solver->setTimeout(0);
    if (!success) {
        current.pc = current.prevPC;
        terminateStateEarly(current, "query timed out");
        return StatePair(0, 0);
    }
    
    if (!isSeeding) {
        if (replayPath && !isInternal) {
            assert(replayPosition<replayPath->size() &&
                   "ran out of branches in replay path mode");
            bool branch = (*replayPath)[replayPosition++];
            
            if (res==Solver::True) {
                assert(branch && "hit invalid branch in replay path mode");
            } else if (res==Solver::False) {
                assert(!branch && "hit invalid branch in replay path mode");
            } else {
                // add constraints
                if(branch) {
                    res = Solver::True;
                    addConstraint(current, condition);
                } else  {
                    res = Solver::False;
                    addConstraint(current, Expr::createIsZero(condition));
                }
            }
        } else if (res==Solver::Unknown) {
            assert(!replayOut && "in replay mode, only one branch can be true.");
            
            if ((MaxMemoryInhibit && atMemoryLimit) ||
                current.forkDisabled ||
                inhibitForking ||
                (MaxForks!=~0u && stats::forks >= MaxForks)) {
                
                if (MaxMemoryInhibit && atMemoryLimit)
                    klee_warning_once(0, "skipping fork (memory cap exceeded)");
                else if (current.forkDisabled)
                    klee_warning_once(0, "skipping fork (fork disabled on current path)");
                else if (inhibitForking)
                    klee_warning_once(0, "skipping fork (fork disabled globally)");
                else
                    klee_warning_once(0, "skipping fork (max-forks reached)");
                
                TimerStatIncrementer timer(stats::forkTime);
                if (theRNG.getBool()) {
                    addConstraint(current, condition);
                    res = Solver::True;
                } else {
                    addConstraint(current, Expr::createIsZero(condition));
                    res = Solver::False;
                }
            }
        }
    }
    
    // Fix branch in only-replay-seed mode, if we don't have both true
    // and false seeds.
    if (isSeeding &&
        (current.forkDisabled || OnlyReplaySeeds) &&
        res == Solver::Unknown) {
        bool trueSeed=false, falseSeed=false;
        // Is seed extension still ok here?
        for (std::vector<SeedInfo>::iterator siit = it->second.begin(),
             siie = it->second.end(); siit != siie; ++siit) {
            ref<ConstantExpr> res;
            bool success =
            solver->getValue(current, siit->assignment.evaluate(condition), res);
            
            assert(success && "FIXME: Unhandled solver failure");
            (void) success;
            if (res->isTrue()) {
                trueSeed = true;
            } else {
                falseSeed = true;
            }
            if (trueSeed && falseSeed)
                break;
        }
        if (!(trueSeed && falseSeed)) {
            assert(trueSeed || falseSeed);
            
            res = trueSeed ? Solver::True : Solver::False;
            addConstraint(current, trueSeed ? condition : Expr::createIsZero(condition));
        }
    }
    
    
    // XXX - even if the constraint is provable one way or the other we
    // can probably benefit by adding this constraint and allowing it to
    // reduce the other constraints. For example, if we do a binary
    // search on a particular value, and then see a comparison against
    // the value it has been fixed at, we should take this as a nice
    // hint to just use the single constraint instead of all the binary
    // search ones. If that makes sense.
    if (res==Solver::True) {
        
        if (!isInternal) {
            if (pathWriter) {
                current.pathOS << "1";
            }
        }
        //std::cerr << "===== FORK return 2\n["<< current.stateId <<"] = \n";// << current.tmpTrace << "\n"; //Nuno debug
        addConstraint1(current, condition1);
		return StatePair(&current, 0);
    } else if (/*threadbbiidsmap[current.getThreadName()].size() == 0 ||*/
				 res==Solver::False) { // yqp: only select one branch
        if (!isInternal) {
            if (pathWriter) {
                current.pathOS << "0";
            }
        }
        //std::cerr << "===== FORK return 3\n["<< current.stateId <<"] = \n";// << current.tmpTrace << "\n"; //Nuno debug
        ref<Expr> e = Expr::createIsZero(condition1);
        addConstraint1(current, e);

        return StatePair(0, &current);
    } else {
        
        TimerStatIncrementer timer(stats::forkTime);
        ExecutionState *falseState, *trueState = &current;
        
        falseState = trueState->branch();
        addedStates.insert(falseState);
        
        if (RandomizeFork && theRNG.getBool())
            std::swap(trueState, falseState);
        
        if (it != seedMap.end()) {
            std::vector<SeedInfo> seeds = it->second;
            it->second.clear();
            std::vector<SeedInfo> &trueSeeds = seedMap[trueState];
            std::vector<SeedInfo> &falseSeeds = seedMap[falseState];
            for (std::vector<SeedInfo>::iterator siit = seeds.begin(),
                 siie = seeds.end(); siit != siie; ++siit) {
                ref<ConstantExpr> res;
                
                bool success =
                solver->getValue(current, siit->assignment.evaluate(condition), res);
                
                
                assert(success && "FIXME: Unhandled solver failure");
                (void) success;
                if (res->isTrue()) {
                    trueSeeds.push_back(*siit);
                } else {
                    falseSeeds.push_back(*siit);
                }
            }
            
            bool swapInfo = false;
            if (trueSeeds.empty()) {
                if (&current == trueState) swapInfo = true;
                seedMap.erase(trueState);
            }
            if (falseSeeds.empty()) {
                if (&current == falseState) swapInfo = true;
                seedMap.erase(falseState);
            }
            if (swapInfo) {
                std::swap(trueState->coveredNew, falseState->coveredNew);
                std::swap(trueState->coveredLines, falseState->coveredLines);
            }
        }
        
        current.ptreeNode->data = 0;
        
        std::pair<PTree::Node*, PTree::Node*> res =
        processTree->split(current.ptreeNode, falseState, trueState);
        
        
        falseState->ptreeNode = res.first;
        trueState->ptreeNode = res.second;
        
        
        if (!isInternal) {
            if (pathWriter) {
                falseState->pathOS = pathWriter->open(current.pathOS);
                trueState->pathOS << "1";
                falseState->pathOS << "0";
            }
            if (symPathWriter) {
                falseState->symPathOS = symPathWriter->open(current.symPathOS);
                trueState->symPathOS << "1";
                falseState->symPathOS << "0";
            }
        }
        
        addConstraint(*trueState, condition);
        addConstraint(*falseState, Expr::createIsZero(condition));
        
        falseState->goalsReached = current.goalsReached;
        falseState->stateId = current.stateId; //we need this to ensure the correct propagation of the state id (otherwise the stateId is reset)
        falseState->updateStateId(false);
        
        trueState->goalsReached = current.goalsReached;
        trueState->updateStateId(true);
        
        tracePerThread[current.getThreadName()].erase(current.stateId); //delete the previous entry to free space
        
        tracePerThread[current.getThreadName()][falseState->stateId] = current.tmpTrace;
        falseState->tmpTrace = current.tmpTrace;
        
        tracePerThread[current.getThreadName()][trueState->stateId] = current.tmpTrace;
        trueState->tmpTrace = current.tmpTrace;
        
        // Kinda gross, do we even really still want this option?
        if (MaxDepth && MaxDepth<=trueState->depth) {
            terminateStateEarly(*trueState, "max-depth exceeded");
            terminateStateEarly(*falseState, "max-depth exceeded");
            std::cerr << "["<<current.getThreadName()<<"] MAX-DEPTH EXCEEDED! -----\n";
            return StatePair(0, 0);
        }
        //std::cerr << "===== FORK return 5\nTRUE/FALSE ["<< trueState->stateId <<"] ["<< falseState->stateId <<"] = \n";// << current.tmpTrace << "\n"; //Nuno debug
        return StatePair(trueState, falseState);
    }
}

std::map<string, std::vector<int> > prefixes;
void Executor::addConstraint1(ExecutionState &state, ref<Expr> condition) {

	if (ConstantExpr *CE = dyn_cast<ConstantExpr>(condition)) {
		assert(CE->isTrue() && "attempt to add invalid constraint");
		return;
	}

  // Check to see if this constraint violates seeds.
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    bool warn = false;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      bool res;
      bool success = 
        solver->mustBeFalse(state, siit->assignment.evaluate(condition), res);

      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res) {
        siit->patchSeed(state, condition, solver);
        warn = true;
      }
    }
    if (warn)
      klee_warning("seeds patched for violating constraint"); 
  }

  unsigned size = state.constraints.constraints1.size();
  state.addConstraint1(condition, currentLine);

  state.tmpTrace.append("Path: " + llvm::utostr(state.constraints.constraints1.size()) + "\n");
  if (ivcEnabled)
    doImpliedValueConcretization(state, condition, 
                                 ConstantExpr::alloc(1, Expr::Bool));

}



void Executor::addConstraint(ExecutionState &state, ref<Expr> condition) {

	if (ConstantExpr *CE = dyn_cast<ConstantExpr>(condition)) {
    assert(CE->isTrue() && "attempt to add invalid constraint");
    return;
  }

  // Check to see if this constraint violates seeds.
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it != seedMap.end()) {
    bool warn = false;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      bool res;
      bool success = 
        solver->mustBeFalse(state, siit->assignment.evaluate(condition), res);

      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res) {
        siit->patchSeed(state, condition, solver);
        warn = true;
      }
    }
    if (warn)
      klee_warning("seeds patched for violating constraint"); 
  }

  state.tmpTrace.append("Path: " + llvm::utostr(state.constraints.constraints1.size()) + "\n");
  state.addConstraint(condition);
  if (ivcEnabled)
    doImpliedValueConcretization(state, condition, 
                                 ConstantExpr::alloc(1, Expr::Bool));

}

ref<klee::ConstantExpr> Executor::evalConstant(const Constant *c) {
  if (const llvm::ConstantExpr *ce = dyn_cast<llvm::ConstantExpr>(c)) {
    return evalConstantExpr(ce);
  } else {
    if (const ConstantInt *ci = dyn_cast<ConstantInt>(c)) {
      return ConstantExpr::alloc(ci->getValue());
    } else if (const ConstantFP *cf = dyn_cast<ConstantFP>(c)) {      
      return ConstantExpr::alloc(cf->getValueAPF().bitcastToAPInt());
    } else if (const GlobalValue *gv = dyn_cast<GlobalValue>(c)) {
      return globalAddresses.find(gv)->second;
    } else if (isa<ConstantPointerNull>(c)) {
      return Expr::createPointer(0);
    } else if (isa<UndefValue>(c) || isa<ConstantAggregateZero>(c)) {
      return ConstantExpr::create(0, getWidthForLLVMType(c->getType()));
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
    } else if (const ConstantDataSequential *cds =
                 dyn_cast<ConstantDataSequential>(c)) {
      std::vector<ref<Expr> > kids;
      for (unsigned i = 0, e = cds->getNumElements(); i != e; ++i) {
        ref<Expr> kid = evalConstant(cds->getElementAsConstant(i));
        kids.push_back(kid);
      }
      ref<Expr> res = ConcatExpr::createN(kids.size(), kids.data());
      return cast<ConstantExpr>(res);
#endif
    } else if (const ConstantStruct *cs = dyn_cast<ConstantStruct>(c)) {
      const StructLayout *sl = kmodule->targetData->getStructLayout(cs->getType());
      llvm::SmallVector<ref<Expr>, 4> kids;
      for (unsigned i = cs->getNumOperands(); i != 0; --i) {
        unsigned op = i-1;
        ref<Expr> kid = evalConstant(cs->getOperand(op));

        uint64_t thisOffset = sl->getElementOffsetInBits(op),
                 nextOffset = (op == cs->getNumOperands() - 1)
                              ? sl->getSizeInBits()
                              : sl->getElementOffsetInBits(op+1);
        if (nextOffset-thisOffset > kid->getWidth()) {
          uint64_t paddingWidth = nextOffset-thisOffset-kid->getWidth();
          kids.push_back(ConstantExpr::create(0, paddingWidth));
        }

        kids.push_back(kid);
      }
      ref<Expr> res = ConcatExpr::createN(kids.size(), kids.data());
      return cast<ConstantExpr>(res);
    } else {
      assert(0 && "invalid argument to evalConstant()");
    }
  }
}

const Cell& Executor::eval(KInstruction *ki, unsigned index,
                           ExecutionState &state) const {
    assert(index < ki->inst->getNumOperands());
    int vnumber = ki->operands[index];
	
	if (vnumber == -1) {
		Cell c;
		c.value = c.value1 = NULL;
		return c;
	}

	assert(vnumber != -1 &&
           "Invalid operand to eval(), not a value or constant!");
    
    // Determine if this is a constant or not.
    if (vnumber < 0) {
        unsigned index = -vnumber - 2;
      
        return kmodule->constantTable[index];
    } else {
        
        unsigned index = vnumber;
        
        StackFrame &sf = state.stack.back();

        return sf.locals[index];
    }
}

void Executor::bindLocal(KInstruction *target, ExecutionState &state, 
                         ref<Expr> value, ref<Expr> value1) {
  getDestCell(state, target).value = value;
  getDestCell(state, target).value1 = value1;
}

void Executor::bindLocal_yqp(KInstruction *target, ExecutionState &state, 
                         ref<Expr> value, ref<Expr> value1) {
  getDestCell(state, target).value1 = value1;
}


std::vector< ref<Expr> > arguments1;
void Executor::bindArgument(KFunction *kf, unsigned index, 
                            ExecutionState &state, ref<Expr> value) {
  getArgumentCell(state, kf, index).value = value;
  if (arguments1.size() == 0)
	getArgumentCell(state, kf, index).value1 = value;
  else
	getArgumentCell(state, kf, index).value1 = arguments1[index];
}

ref<Expr> Executor::toUnique(const ExecutionState &state, 
                             ref<Expr> &e) {
  ref<Expr> result = e;

  if (!isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool isTrue = false;

    solver->setTimeout(stpTimeout);      
    if (solver->getValue(state, e, value) &&
        solver->mustBeTrue(state, EqExpr::create(e, value), isTrue) &&
        isTrue)
      result = value;
    solver->setTimeout(0);
  }
  
  return result;
}


/* Concretize the given expression, and return a possible constant value. 
   'reason' is just a documentation string stating the reason for concretization. */
ref<klee::ConstantExpr> 
Executor::toConstant(ExecutionState &state, 
                     ref<Expr> e,
                     const char *reason) {
  e = state.constraints.simplifyExpr(e);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(e))
    return CE;

  ref<ConstantExpr> value;
  bool success = solver->getValue(state, e, value);
  assert(success && "FIXME: Unhandled solver failure");
  (void) success;
    
  std::ostringstream os;
  os << "silently concretizing (reason: " << reason << ") expression " << e 
     << " to value " << value 
     << " (" << (*(state.pc)).info->file << ":" << (*(state.pc)).info->line << ")";
      
  if (AllExternalWarnings)
    klee_warning(reason, os.str().c_str());
  else
    klee_warning_once(reason, "%s", os.str().c_str());

  addConstraint(state, EqExpr::create(e, value));
    
  return value;
}

void Executor::executeGetValue(ExecutionState &state,
                               ref<Expr> e,
                               KInstruction *target) {
  e = state.constraints.simplifyExpr(e);
  std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
    seedMap.find(&state);
  if (it==seedMap.end() || isa<ConstantExpr>(e)) {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, e, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    bindLocal(target, state, value, value);
  } else {
    std::set< ref<Expr> > values;
    for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
           siie = it->second.end(); siit != siie; ++siit) {
      ref<ConstantExpr> value;
      bool success = 
        solver->getValue(state, siit->assignment.evaluate(e), value);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      values.insert(value);
    }
    
    std::vector< ref<Expr> > conditions;
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit)
      conditions.push_back(EqExpr::create(e, *vit));

    std::vector<ExecutionState*> branches;
    branch(state, conditions, branches);
    
    std::vector<ExecutionState*>::iterator bit = branches.begin();
    for (std::set< ref<Expr> >::iterator vit = values.begin(), 
           vie = values.end(); vit != vie; ++vit) {
      ExecutionState *es = *bit;
      if (es)
        bindLocal(target, *es, *vit, *vit);
      ++bit;
    }
  }
}

void Executor::stepInstruction(ExecutionState &state) {
  if (DebugPrintInstructions)
  {
    printFileLine(state, state.pc);
    std::cerr << std::setw(10) << stats::instructions << " ";
    llvm::errs() << *(state.pc->inst) <<"\n";
  }

  if (statsTracker)
    statsTracker->stepInstruction(state);


  ++stats::instructions;
  state.prevPC = state.pc;
  ++state.pc;

  if (stats::instructions==StopAfterNInstructions)
    haltExecution = true;
  
}

void Executor::executeCall(ExecutionState &state, 
                           KInstruction *ki,
                           Function *f,
                           std::vector< ref<Expr> > &arguments) {
  Instruction *i = ki->inst;
  
  if (f && f->isDeclaration()) {
    switch(f->getIntrinsicID()) {
    case Intrinsic::not_intrinsic:
      callExternalFunction(state, ki, f, arguments);
      break;
        
      // va_arg is handled by caller and intrinsic lowering, see comment for
      // ExecutionState::varargs
    case Intrinsic::vastart:  {
      StackFrame &sf = state.stack.back();
      assert(sf.varargs && 
             "vastart called in function with no vararg object");

      // FIXME: This is really specific to the architecture, not the pointer
      // size. This happens to work fir x86-32 and x86-64, however.
      Expr::Width WordSize = Context::get().getPointerWidth();
      if (WordSize == Expr::Int32) {
        executeMemoryOperation(state, true, arguments[0], 
                               sf.varargs->getBaseExpr(), 0);
      } else {
        assert(WordSize == Expr::Int64 && "Unknown word size!");

        // X86-64 has quite complicated calling convention. However,
        // instead of implementing it, we can do a simple hack: just
        // make a function believe that all varargs are on stack.
        executeMemoryOperation(state, true, arguments[0],
                               ConstantExpr::create(48, 32), 0); // gp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(4, 64)),
                               ConstantExpr::create(304, 32), 0); // fp_offset
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(8, 64)),
                               sf.varargs->getBaseExpr(), 0); // overflow_arg_area
        executeMemoryOperation(state, true,
                               AddExpr::create(arguments[0], 
                                               ConstantExpr::create(16, 64)),
                               ConstantExpr::create(0, 64), 0); // reg_save_area
      }
      break;
    }
    case Intrinsic::vaend:
      // va_end is a noop for the interpreter.
      //
      // FIXME: We should validate that the target didn't do something bad
      // with vaeend, however (like call it twice).
      break;
        
    case Intrinsic::vacopy:
      // va_copy should have been lowered.
      //
      // FIXME: It would be nice to check for errors in the usage of this as
      // well.
    default:
    	//TODO: Jeff: can we disable this??
      klee_error("unknown intrinsic: %s", f->getName().data())

    	//callExternalFunction(state, ki, f, arguments);
    	;
    }

    if (InvokeInst *ii = dyn_cast<InvokeInst>(i))
      transferToBasicBlock(ii->getNormalDest(), i->getParent(), state);
  } else {
    // FIXME: I'm not really happy about this reliance on prevPC but it is ok, I
    // guess. This just done to avoid having to pass KInstIterator everywhere
    // instead of the actual instruction, since we can't make a KInstIterator
    // from just an instruction (unlike LLVM).
    KFunction *kf = kmodule->functionMap[f];
	int num = state.stack.back().calledNum[kf->function];
	state.stack.back().calledNum[kf->function] = num+1;

    state.pushFrame(state.pc, kf); // yqp: stack
    state.pc = kf->instructions;
	state.notStep = true;
        
    if (statsTracker)
      statsTracker->framePushed(state, &state.stack[state.stack.size()-2]);
 
     // TODO: support "byval" parameter attribute
     // TODO: support zeroext, signext, sret attributes
        
    unsigned callingArgs = arguments.size();
    unsigned funcArgs = f->arg_size();
    if (!f->isVarArg()) {
      if (callingArgs > funcArgs) {
        klee_warning_once(f, "calling %s with extra arguments.", 
                          f->getName().data());
      } else if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments", 
                              "user.err");
        return;
      }
    } else {
      if (callingArgs < funcArgs) {
        terminateStateOnError(state, "calling function with too few arguments", 
                              "user.err");
        return;
      }
            
      StackFrame &sf = state.stack.back();
      unsigned size = 0;
      for (unsigned i = funcArgs; i < callingArgs; i++) {
        // FIXME: This is really specific to the architecture, not the pointer
        // size. This happens to work fir x86-32 and x86-64, however.
        Expr::Width WordSize = Context::get().getPointerWidth();
        if (WordSize == Expr::Int32) {
          size += Expr::getMinBytesForWidth(arguments[i]->getWidth());
        } else {
          size += llvm::RoundUpToAlignment(arguments[i]->getWidth(), 
                                           WordSize) / 8;
        }
      }

      MemoryObject *mo = sf.varargs = memory->allocate(size, true, false, 
                                                       state.prevPC->inst);
      if (!mo) {
        terminateStateOnExecError(state, "out of memory (varargs)");
        return;
      }
      ObjectState *os = bindObjectInState(state, mo, true);
      unsigned offset = 0;
      for (unsigned i = funcArgs; i < callingArgs; i++) {
        // FIXME: This is really specific to the architecture, not the pointer
        // size. This happens to work fir x86-32 and x86-64, however.
        Expr::Width WordSize = Context::get().getPointerWidth();
        if (WordSize == Expr::Int32) {
          os->write(offset, arguments[i]);
          offset += Expr::getMinBytesForWidth(arguments[i]->getWidth());
        } else {
          assert(WordSize == Expr::Int64 && "Unknown word size!");
          os->write(offset, arguments[i]);
          offset += llvm::RoundUpToAlignment(arguments[i]->getWidth(), 
                                             WordSize) / 8;
        }
      }
    }

    unsigned numFormals = f->arg_size();
    for (unsigned i=0; i<numFormals; ++i) 
      bindArgument(kf, i, state, arguments[i]);
  }
}


bool Executor::allThreadsFinished()
{
    bool ret = true;
    for(map<string,bool>::iterator iter = threadHasFinished.begin(); iter != threadHasFinished.end(); ++iter )
    {
        bool tmp = (*iter).second;
        if(!tmp)
        {
            ret = false;
            break;
        }
    }
    return ret;
}

void Executor::printSyncTrace(std::string type, std::string line, ExecutionState &state)
{
    state.tmpTrace.append("O" + stringValueOf(currentOrder++) + " " + 
            line +":S-" + type + "-" + state.getThreadName() + "\n");
	return controlPoint(state, "OS-" + type + "-" + state.getThreadName() + "&" + line);
}

std::string Executor::getOrderName(std::string type, std::string line, ExecutionState &state)
{
	std::string s = "OS-" + type + "-" + state.getThreadName() + "&" + line;
	return s;
}


// yqp
std::string Executor::readOrderFile(int ind) {
	std::string fileName = getexepath(bbTrace) + "index";
	cerr << ">> Read Order File: " << tid << " " << Index << " " << Last << " " << fileName << "\n";
	ifstream fin;
	fin.open(fileName.c_str());
	while (!fin.good()) {
		fin.open(fileName.c_str());
	}

	char buf[50];
	string ss;
	int i = 0;
	bool flag = false;
	while (!fin.eof()) {
		i++;
		fin.getline(buf, 50);
		ss = buf;
		if (buf[0] != 'O')
		  break;
		
		if (i == ind) { 
			flag = true;
			break;
		}
	}
	fin.close();

	if (flag)
		return ss;
	else
		return "";
}

std::string prefixStr = "";
static std::vector<std::pair<int, string> > orderVec;
void Executor::readOrderFile2() {
    std::string fileName = getexepath(bbTrace) + "index_"+Index;//+Times+"-"+Index+"_"+Last;
    /*if (Index == "0") {
      system("cp $INSTALL_PATH/symbiosis-master/Tests/CTests/mymotivation/test index_0");
      std::cerr << "cp test to index_0\n";
      }*/
    //cerr << ">> Read Order File: " << tid << " " << fileName << "\n";
    cerr << ">> Read Order File: " << fileName << "\n";
    ifstream fin;

    fin.open(fileName.c_str());
    //fin.open("back");
    if (!fin.good()) {
        //cerr << "Note: Error opening file in readOrderFile!: " << fileName << "\n";
        cerr << "Note: Execute without the guide of readOrderFile!: " << fileName << "\n";
        fin.close();
        //exit(1);
        return ;
    }

    char buf1[10000], buf2[10000];
    string ss1, ss2;
    std::ofstream outfile((getexepath(bbTrace) + "klee-out-"+Index+"/prefix").c_str()); 

    bool beginInput = false;
    bool lastCondBegin = false;
    while (!fin.eof() && fin.getline(buf1, 10000) > 0) {
        ss1 = buf1;
        if (ss1.find("Values: Begin!") != std::string::npos) {
            beginInput = true;
            lastCondBegin = false;
            continue ;
        } else if (ss1.find("LastConds: Begin") != std::string::npos) {
            lastCondBegin = true;
            outfile << ss1 << "\n";
            outfile.flush();  
            prefixStr += ss1 + "\n";
            continue;
        } else if (ss1.find("LastConds: End") != std::string::npos) {
            lastCondBegin = false;
            outfile << ss1 << "\n";
            outfile.flush();
            prefixStr += ss1 + "\n";
            continue ;
        } else if (ss1.find("From path") != std::string::npos) {
            outfile << ss1 << "\n"; 
            outfile.flush();
            prefixStr += ss1 + "\n";
            continue ;
        }

        fin.getline(buf2, 10000);
        ss2 = buf2;

        if (lastCondBegin) {
            outfile << ss1 << "\n" << ss2 << "\n";
            outfile.flush();
            prefixStr += ss1 + "\n" + ss2 + "\n";
            continue ;
        }

        if (beginInput) {
            if (ss1.find("InitR-") == string::npos)
                continue ;

            std::string name = ss1;
            if (name.find("InitR-") != string::npos)
                name = name.substr(4);  // delete "Init"
            name = name.substr(0, name.find_last_of("_"));
            if (name.at(name.size()-1) == '_')
                name = name.substr(0, name.size());

            int v = intValueOf(ss2);
            if (ss2 == "4294967295" || ss2 == "8589934193") {
                v = -1;
                std::cerr << "set to " << v << "\n";
            }

            string offset;
            if (ss1.find("InitR-") == std::string::npos) {
                offset = ss1.substr(ss1.find_last_of("_"));
                std::string s = offset.substr(offset.find("-"));
                if (name.at(name.size()-1) != '_')
                    name += "_";
                name += s;
                name = name.substr(0, name.find("&"));

                if (offset.find("*") == std::string::npos) {
                    offset = "0";
                } else {
                    offset = offset.substr(offset.find("*")+1);
                    offset = offset.substr(0, offset.find("-"));
                }
            } else {
                string threadId = ss1.substr(ss1.find("R-T")+3);
                threadId = threadId.substr(0, threadId.find("*"));
                name += "-" + threadId + "-0"; 
                offset = "0";
            }

            int offInt = intValueOf(offset);

            inputValues[name][offInt] = v;

            continue ;
        }

        int threadId = intValueOf(ss1); 
        if (ss2.at(0) != 'O') {
            fin.getline(buf2, 10000);
            string index = buf2;
            std::vector<int> indexes;
            //std::cerr << "!" << index << "!\n";
            while (index.find(" ") != std::string::npos) {
                std::string s = index.substr(0, index.find_first_of(" "));
                index = index.substr(index.find_first_of(" ")+1);
                indexes.push_back(intValueOf(s));
                prefixes[ss1].push_back(intValueOf(s));
            }

            if (index != "") {
                indexes.push_back(intValueOf(index));
                prefixes[ss1].push_back(intValueOf(index));
            }

            //std::cerr << "prefix: " << ss1 << " " << ss2 << " " << index << " " << indexes.size() << "\n";
            outfile << ss1 << "\n" << ss2 << "\n";
            outfile.flush();  
        } else {
            if (ss2.find("-start-") != string::npos ||
                    ss2.find("OS-join") != string::npos/* ||
                                                          ss2.find("OS-wait") != string::npos*/) {
                /*std::cerr << "for start: " << threadId << "\n";
                  string tId = ss2.substr(ss2.find("start-")+6);
                  tId = tId.substr(0, tId.find("&"));
                  threadId = intValueOf(tId);
                  orderVec.push_back(std::make_pair(threadId, ss2));*/
                continue ;
            }
            string firstPart = ss2.substr(0, ss2.find_last_of("_"));
            string secondPart = ss2.substr(ss2.find_last_of("_"));
            secondPart = secondPart.substr(secondPart.find("-"));
            ss2 = firstPart + secondPart;
            orderVec.push_back(std::make_pair(threadId, ss2));
        }

    }

    std::set<string> lines;
    static std::vector<std::pair<int, string> > newOrder;
    //std::cerr << "new order: \n";
    for (std::vector<pair<int, string> >::iterator it = orderVec.begin();
            it != orderVec.end(); ++it) {
        string od = it->second;
        string l = od.substr(od.find("@")+1);
        if (od.find("shared*") == string::npos &&
                od.find("OS-") == string::npos) {
            continue ;
        } else if (lines.find(l) != lines.end() && 
                (od.find("OS-lock") != string::npos ||
                 od.find("OS-unlock") != string::npos)) { 
            continue ;
        }

        if (od.find("OS-fork") != string::npos || od.find("OS-join") != string::npos ||
                od.find("pthread_") != string::npos)
            continue ;

        if (od.find("OS-wait") != string::npos) {
            lines.insert(l);
            continue ;
        }

        if (od.find("OS-unlock-") != std::string::npos)
            continue ;

        newOrder.push_back(*it);
    }
    orderVec.clear();
    orderVec.insert(orderVec.begin(), newOrder.begin(), newOrder.end());

    //orderVec.clear(); /////////////////////////////////////////////////

    fin.close();
    outfile.close();
}

// yqp
void Executor::writeOrderFile() {
	std::string fileName = getexepath(bbTrace) + "index";
	cerr << ">> Write Order File: " << tid << "\n";
	ifstream fin;
	fin.open(fileName.c_str());
	if (!fin.good()) {
		cerr << "22Error opening file in writeOrderFile!\n";
		fin.close();
		exit(1);
	}

	char buf[50];
	string ss, content;
	int i = 0;
	bool flag = false;
	std::remove(fileName.c_str());	
	std::ofstream outfile(fileName.c_str());
	while (!fin.eof()) {
		i++;
		fin.getline(buf, 50);
		ss = buf;
		
		if (i == 1 || ss == "\n")
		  continue;

		outfile << ss << "\n";
		outfile.flush();
	}
	fin.close();
	outfile.close();
} 

// yqp
void Executor::writeTraceFile() {
	std::string fileName = getexepath(bbTrace) + "trace_" + Index;//Times + "-" + Index+"_"+Last;
	cerr << ">> Write Trace File: " << tid << " " << fileName << "\n";

	char buf[50];
	string ss, content;
	int i = 0;
	bool flag = false;
	std::remove(fileName.c_str());	
	std::ofstream outfile(fileName.c_str());

	for (std::map<string, std::vector<int> >::iterator it = threadbbiidsmap.begin();
				it != threadbbiidsmap.end(); ++it) {
		std::string threadid = it->first;
		for (std::vector<int>::iterator it2 = it->second.begin(); 
					it2 != it->second.end(); ++it2) {
			int bbid = *it2;
			outfile << threadid << " " << stringValueOf(bbid) << "\n";
			outfile.flush();
		}
	}

	outfile.close();
} 

void Executor::forAget() {
	input.insert("InitR-argc");
}

// yqp
void Executor::initTidMap() {
	tidMap[24] = 1, tidMap[25] = 2, tidMap[101] = 1, tidMap[102] = 2;
	tidMap[67] = 1, tidMap[68] = 2, tidMap[58] = 3; 
	tidMap[64] = 1, tidMap[65] = 2, tidMap[66] = 3; 
	tidMap[74] = 1, tidMap[75] = 2, tidMap[76] = 3; tidMap2[57] = 63;//tidMap[61] = 1, tidMap[62] = 2;
	tidMap2[86] = 102, tidMap2[94] = 110;
	tidMap[41] = 1, tidMap[42] = 2;  
	tidMap[111] = 1, tidMap[113] = 2;  //dekker
	tidMap[85] = 1, tidMap[86] = 2, tidMap[87] = 3;  //linuxlock
	tidMap[87] = 1, tidMap[88] = 2, tidMap[89] = 3;  //linuxrwlock
	tidMap[127] = 1, tidMap[128] = 2;  //msqueue
	tidMap[96] = 1, tidMap[97] = 2, tidMap[98] = 3;  //seqlock
	tidMap[1944] = 5; // for pbzip2
	tidMap2[360] = 372, tidMap2[367] = 375; // bbuf
	tidMap2[164] = 170; // racey

	// motivation example
	tidMap[127] = 1, tidMap[128] = 2, tidMap[129] = 3, tidMap[130] = 4;
	tidMap[131] = 5, tidMap[132] = 6, tidMap[133] = 7, tidMap[134] = 8;
	tidMap[135] = 9, tidMap[136] = 10, tidMap[137] = 11;
	tidMap[138] = 12, tidMap[139] = 13;
	tidMap[68] = 1, tidMap[69] = 2, tidMap[70] = 3;
	tidMap2[64] = 68, tidMap2[65] = 69, tidMap[66] = 70;
	tidMap[76] = 1, tidMap[77] = 2, tidMap[78] = 3;
	tidMap[84] = 1, tidMap[85] = 2, tidMap[86] = 3, tidMap[87] = 4, tidMap[88] = 5;
	tidMap[170] = 2, tidMap[80] = 0, tidMap[82] = 2; // aget
	tidMap[103] = 1, tidMap[104] = 2; // for bank
	tidMap[377] = 1, tidMap[378] = 2, tidMap[381] = 3, tidMap[382] = 4; // for bbuf
	tidMap[81] = 1, tidMap[82] = 2, tidMap[83] = 3, tidMap[84] = 4, tidMap[85] = 5, tidMap[86] = 6, tidMap[87] = 7, tidMap[88] = 8, tidMap[89] = 9, tidMap[90] = 10; // for airline
    tidMap[111] = 107, tidMap[113] = 108;
	//set the input points
	input.insert("InitR-x");
	input.insert("InitR-i");
	input.insert("InitR-j");
	input.insert("InitR-m");
	input.insert("InitR-n");
	input.insert("InitR-k");
	input.insert("InitR-k0");
	input.insert("InitR-k1");
	input.insert("InitR-k2");
	input.insert("InitR-k3");
	input.insert("InitR-k4");
	input.insert("InitR-k5");
	input.insert("InitR-k6");
	input.insert("InitR-k7");
	input.insert("InitR-k8");
	input.insert("InitR-k9");

	input.insert("InitR-flag1");
	input.insert("InitR-flag2");
	input.insert("InitR-num");
	
	input.insert("InitR-sbcount");
	input.insert("InitR-buffcount");
	input.insert("InitR-len1");
	input.insert("InitR-len2");
	input.insert("InitR-len3");
	
	input.insert("InitR-ii");
	input.insert("InitR-jj");
	input.insert("InitR-changed");
	input.insert("InitR-x1");
	input.insert("InitR-x2");
	input.insert("InitR-x3");
	input.insert("InitR-x4");
	input.insert("InitR-x5");
	input.insert("InitR-x6");
	input.insert("InitR-x7");
	input.insert("InitR-x8");
	input.insert("InitR-x9");
	input.insert("InitR-x10");
	
	input.insert("InitR-randA0");
	input.insert("InitR-randA1");
	input.insert("InitR-randA2");
	input.insert("InitR-randA3");
	input.insert("InitR-randA4");
	input.insert("InitR-randB0");
	input.insert("InitR-randB1");
	input.insert("InitR-randB2");
	input.insert("InitR-randB3");
	input.insert("InitR-randB4");

	forAget();
}

// yqp
std::map<std::string, std::vector<std::string> > globalOrders;
void Executor::controlPoint(ExecutionState &state, std::string currentOp) {
	if (currentOp.find("shared*") == string::npos &&
				currentOp.find("OS-") == string::npos)
	  return ;

	if (currentOp.find("-start-") == std::string::npos) {
		string op = currentOp;
		if (orderVec.size() != 0) {
			//cerr << "erase orderVec1: " << currentOp << " " << orderVec[0].second << " " << orderVec.size() << "\n";
			if ((currentOp.find("OW-") != string::npos || 
						currentOp.find("OR-") != string::npos) && currentOp != orderVec[0].second) {
                if (stringValueOf(orderVec[0].first) == state.getThreadName()) {
                    std::string name = currentOp.substr(currentOp.find("shared*"));
                    name = name.substr(0, name.find_first_of("-"));
                    globalOrders[name].push_back(currentOp);
                    orderVec.erase(orderVec.begin());
                }
				return ;
			} else if (currentOp.find("OS-") != string::npos && 
						currentOp != orderVec[0].second && 
						!(currentOp.find("OS-wait") != string::npos &&
						orderVec[0].second.find("OS-unlock") != string::npos)) {
				if (stringValueOf(orderVec[0].first) == state.getThreadName() &&
                        orderVec[0].second.find("OS-") != string::npos)
                    orderVec.erase(orderVec.begin());
				
				return ;
			}
			
			orderVec.erase(orderVec.begin());
			if (currentOp.find("OS-timedwait") != std::string::npos) {
				if (orderVec[0].second.find("-lock") == std::string::npos ||
						 orderVec[0].first != intValueOf(state.getThreadName()) ) {
					state.pc = state.prevPC;
				} else {
					orderVec.erase(orderVec.begin());
				}
			}


		}
	}
	return ;
	int ind; 
	if (!executionBasedOnGivenOrder)
		return ;

	while (true) {
		string nextOp = readOrderFile(1);
		if (nextOp == currentOp) {
			//cerr << "1. End In controlPoint in Thread " << tid << " " << currentOp << "\n";
			writeOrderFile();	
			return;
		} else
		  ;//sleep(2);
	}

	return ;
}

void Executor::schedule() {


}

//yqp: !!!
void Executor::runNewThread2(ExecutionState &state,
          KInstruction *ki,
          std::vector< ref<Expr> > &arguments) {

    //Find the function to execute!!!
    //Get function name from arguments
    assert(arguments.size()==4);

	int line = state.pc->info->line;
	tidMap[tidMap2[line]] = tid;
	if (occurTimes.find(line) == occurTimes.end()) {
		occurTimes[line] = 0;
	}
    
	ExecutionState *newState = new ExecutionState(state);
    ref<Expr> expr = arguments[2];
    if(ConstantExpr *e = dyn_cast<ConstantExpr>(expr))
    {
        for(std::map<const llvm::GlobalValue*, ref<ConstantExpr> > ::iterator iter = globalAddresses.begin();
            iter!=globalAddresses.end();iter++)
        {
            if(iter->second==e)
            {
                const GlobalValue *gv = iter->first;
                if (const Function *f = dyn_cast<Function>(gv))
                {
                    //Now we have the function
                    KFunction *kf = kmodule->functionMap[const_cast<Function *>(f)];
                    //Go to process the state
                    newState->pc = kf->instructions;
                    newState->prevPC=newState->pc;
                    newState->depth=0;
                    processTree = new PTree(newState);
                    newState->ptreeNode = processTree->root;
                   
                    newState->constraints.empty();
                    newState->stack.clear();
                    newState->pushFrame(0, kf);
                    statsTracker =0;
                    states.clear();
                    addedStates.clear();
                    removedStates.clear();
                
                    newState->tmpTrace = "";      //Nuno: when forking a new process we must ensure that the trace is empty
                    newState->goalsReached = 0; //Nuno: when forking a new process we must ensure that the number of goals is 0
					
                    //add the current state to states?
                    states.insert(newState);
					gState->addState(tid, newState);
					newState->tid = tid;

					std::string childName;
					std::stringstream ssTid;   //stream to obtain the executor thread id

					//define the name of the child process
					ssTid << tid;
					if(state.getThreadName()=="0"){
						childName = ssTid.str();
					}
					else{
						childName = state.getThreadName()+"_"+ssTid.str();
					}
					
					//get the source code line
					std::stringstream line2;
					line2 << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
					newState->setThreadName(childName);
                    newState->constraints.prefixNum = prefixes[childName];
					printSyncTrace(("fork_"+childName),line2.str(),state);
					
					std::stringstream line;
                    line << extractFileBasename(newState->pc->info->file) << "@" << newState->pc->info->line;
                    printSyncTrace("start",line.str(),*newState);   //Nuno: store the start point of the thread
	

					tid++;
                    
                    //arguments??
                    stateTerminate = false;
                    numOfUndefinedBB = 0;
                    
                    bindArgument(kf, 0, *newState, arguments[3]);
					break;    
                }
            }
        }
    }
    
    
}


//:CLAP: !!!
void Executor::runNewThread(ExecutionState &state,
          KInstruction *ki,
          std::vector< ref<Expr> > &arguments) {

    //Find the function to execute!!!
    //Get function name from arguments
    assert(arguments.size()==4);
    
    ref<Expr> expr = arguments[2];
    if(ConstantExpr *e = dyn_cast<ConstantExpr>(expr))
    {
        for(std::map<const llvm::GlobalValue*, ref<ConstantExpr> > ::iterator iter = globalAddresses.begin();
            iter!=globalAddresses.end();iter++)
        {
            if(iter->second==e)
            {
                const GlobalValue *gv = iter->first;
                if (const Function *f = dyn_cast<Function>(gv))
                {
                    llvm::errs() <<"\tThread function name:"<<f->getName()<<"\n";    //**
                    
                    //Now we have the function
                    KFunction *kf = kmodule->functionMap[const_cast<Function *>(f)];
                    //Go to process the state
                    state.pc = kf->instructions;
                    state.prevPC=state.pc;
                    state.depth=0;
                    processTree = new PTree(&state);
                    state.ptreeNode = processTree->root;
                    
                    state.constraints.empty();
                    state.stack.clear();
                    state.pushFrame(0, kf);
                    statsTracker =0;
                    states.clear();
                    addedStates.clear();
                    removedStates.clear();
                
                    state.tmpTrace = "";      //Nuno: when forking a new process we must ensure that the trace is empty
                    state.goalsReached = 0; //Nuno: when forking a new process we must ensure that the number of goals is 0
                    
                    std::stringstream line;
                    line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
                    printSyncTrace("start",line.str(),state);   //Nuno: store the start point of the thread
                    
                    
                    states.insert(&state);
                    stateTerminate = false;
                    numOfUndefinedBB = 0;
                    
                    bindArgument(kf, 0, state, arguments[3]);
                    
                    searcher = constructUserSearcher(*this);
                    searcher->update(0, states, std::set<ExecutionState*>());
                    
                    //Go on execute
                    while (!states.empty() && !haltExecution) //&& !((AvisoReplaySearcher*)searcher)->getTarget)
                    {
                        ExecutionState &state = searcher->selectState();
                        
                        if(searcher->empty())
                            break;
                        
                        KInstruction *ki = state.pc;
                        stepInstruction(state);
                        executeInstruction(state, ki);
                        
                        if(bbTrace.empty() && ((AvisoReplaySearcher*)searcher)->getTarget)
                        {
                            ((AvisoReplaySearcher*)searcher)->getTarget = false;
;							terminateStateCLAPWithConstraints(state);
                        }
                        
                        updateStates(&state);
                    }
                    std::cerr << "\tThread "<<getThreadName()<<" terminated [runNewThread]\n"; //**
                }
            }
        }
    }
    
    
}

void Executor::newBasicBlockEntry(ExecutionState &state, std::vector< ref<Expr> > &arguments)
{
	return;
    int size = threadbbiidsmap[state.getThreadName()].size();
    if(!bbTrace.empty() && state.goalsReached < size)
    {
        int iid = threadbbiidsmap[state.getThreadName()][state.goalsReached];
        ref<Expr> expr = arguments.front();
        
        int fail = expr.compare(ConstantExpr::create(iid, 32));
        
        string funcname = state.pc->inst->getParent()->getParent()->getNameStr();
        if(funcname.find("klee")!=std::string::npos)
        {
            cerr << "\t[newBasicBlockEntry] T"<<state.getThreadName()<<": function is "<< funcname<<" so allow to proceed regardless of the basic blocks\n";
            return;
        }
        
        if(fail)
        {
            size = states.size()+addedStates.size();
            std::cerr << "\t[newBasicBlockEntry] T"<<state.getThreadName()<< " " << &state << " " << state.goalsReached << ": BBtrace" <<iid<<" != BBprog"<< expr << "\n"; 
            
            terminateStateCLAPDirectly(state);
			std::cerr << "[" << state.getThreadName() << "] Not follow the given trace!\n";
            if(size==0) {
				std::cerr << "[" << state.getThreadName() << "] Terminate without completion!\n";
				exit(0);
			}
        }
        else
        {
	    if(state.goalsReached < size)
            {
                state.goalsReached++;
            }
             std::cerr << "\t[newBasicBlockEntry] T"<<state.getThreadName()<<": BBtrace" << iid << " == BBprog"<< expr << " (reached "<< state.goalsReached <<" of "<< size <<" )\n"; //***
           
 	    if(assertThread == state.getThreadName()
		&& state.goalsReached == size)
	    {
		std::cerr << "["<< state.getThreadName() << "] Thread execution trace completed. Terminate execution.\n";
                terminateStateCLAPWithConstraints(state);
		exit(0);		
	    }
            addedStates.clear(); //Nuno: we don't want to clear all states
        }
    }
    else
    {
	//check if all basic blocks were already executed
	if(state.goalsReached == size)
            {
		std::cerr << "["<< state.getThreadName() << "] Thread execution trace completed. Terminate execution.\n";
                terminateStateCLAPWithConstraints(state);
		exit(0);
            }
	
     	terminateStateCLAPDirectly(state);
    }
}



void Executor::transferToBasicBlock(BasicBlock *dst, BasicBlock *src,
                                    ExecutionState &state) {
	  // Note that in general phi nodes can reuse phi values from the same
	  // block but the incoming value is the eval() result *before* the
	  // execution of any phi nodes. this is pathological and doesn't
	  // really seem to occur, but just in case we run the PhiCleanerPass
	  // which makes sure this cannot happen and so it is safe to just
	  // eval things in order. The PhiCleanerPass also makes sure that all
	  // incoming blocks have the same order for each PHINode so we only
	  // have to compute the index once.
	  //
	  // With that done we simply set an index in the state so that PHI
	  // instructions know which argument to eval, set the pc, and continue.

	  // XXX this lookup has to go ?
	  KFunction *kf = state.stack.back().kf;
	  unsigned entry = kf->basicBlockEntry[dst];
	  state.pc = &kf->instructions[entry];
	  state.notStep = true;
	  if (state.pc->inst->getOpcode() == Instruction::PHI) {
	    PHINode *first = static_cast<PHINode*>(state.pc->inst);
	    state.incomingBBIndex = first->getBasicBlockIndex(src);
	  }
}

void Executor::printFileLine(ExecutionState &state, KInstruction *ki) {
  const InstructionInfo &ii = *ki->info;
  if (ii.file != "") 
    std::cerr << "     " << ii.file << ":" << ii.line << ":";
  else
    std::cerr << "     [no debug info]:";
}

/// Compute the true target of a function call, resolving LLVM and KLEE aliases
/// and bitcasts.
Function* Executor::getTargetFunction(Value *calledVal, ExecutionState &state) {
  SmallPtrSet<const GlobalValue*, 3> Visited;

  Constant *c = dyn_cast<Constant>(calledVal);
  if (!c)
    return 0;

  while (true) {
    if (GlobalValue *gv = dyn_cast<GlobalValue>(c)) {
      if (!Visited.insert(gv))
        return 0;

      std::string alias = state.getFnAlias(gv->getName());
      if (alias != "") {
        llvm::Module* currModule = kmodule->module;
        GlobalValue *old_gv = gv;
        gv = currModule->getNamedValue(alias);
        if (!gv) {
          llvm::errs() << "Function " << alias << "(), alias for " 
                       << old_gv->getName() << " not found!\n";
          assert(0 && "function alias not found");
        }
      }
     
      if (Function *f = dyn_cast<Function>(gv))
        return f;
      else if (GlobalAlias *ga = dyn_cast<GlobalAlias>(gv))
        c = ga->getAliasee();
      else
        return 0;
    } else if (llvm::ConstantExpr *ce = dyn_cast<llvm::ConstantExpr>(c)) {
      if (ce->getOpcode()==Instruction::BitCast)
        c = ce->getOperand(0);
      else
        return 0;
    } else
      return 0;
  }
}

static bool isDebugIntrinsic(const Function *f, KModule *KM) {
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  // Fast path, getIntrinsicID is slow.
  if (f == KM->dbgStopPointFn)
    return true;

  switch (f->getIntrinsicID()) {
  case Intrinsic::dbg_stoppoint:
  case Intrinsic::dbg_region_start:
  case Intrinsic::dbg_region_end:
  case Intrinsic::dbg_func_start:
  case Intrinsic::dbg_declare:
    return true;

  default:
    return false;
  }
#else
  return false;
#endif
}

static inline const llvm::fltSemantics * fpWidthToSemantics(unsigned width) {
  switch(width) {
  case Expr::Int32:
    return &llvm::APFloat::IEEEsingle;
  case Expr::Int64:
    return &llvm::APFloat::IEEEdouble;
  case Expr::Fl80:
    return &llvm::APFloat::x87DoubleExtended;
  default:
    return 0;
  }
}

void Executor::addCondForPointerAccess(ExecutionState &state,
			Instruction *i, ref<Expr> v) {
	bool flag = false;
	if (i->getType()->isPointerTy()) {
		BasicBlock* bb = i->getParent(); 
		for (llvm::BasicBlock::iterator it = bb->begin();
					it != bb->end(); ++it) {
			Instruction *inst = it;
			if (inst == i) {
				it++;
				inst = it;
				if (inst->getOpcode() == Instruction::Load &&
							inst->getOperand(0) == i) {
					flag = true;
				}

				break;
			}
		}
	}

	if (flag) {
		ref<Expr> notNull = NeExpr::create(v, ConstantExpr::create(0, v->getWidth()));
		addConstraint(state, notNull);
		state.addConstraint1(notNull, currentLine);
	}

}

string controlStr = "";
int previousLine = 0;
bool storeFlag = false;
void Executor::executeInstruction(ExecutionState &state, KInstruction *ki) {

  state.executedInsts++;
  Instruction *i = ki->inst;
  const InstructionInfo *info = ki->info;

	currentLine = info->line;

    /*std::cerr << "["<< state.getThreadName() << "] " << extractFileBasename(info->file) << ":" << info->line << "\n";
    if (info->file.find("CTest") != std::string::npos) {
        i->dump();
    }*/
	previousLine = info->line;
    
  switch (i->getOpcode()) {
    // Control flow
  case Instruction::Ret: {
    ReturnInst *ri = cast<ReturnInst>(i);
    KInstIterator kcaller = state.stack.back().caller;
    Instruction *caller = kcaller ? kcaller->inst : 0;
    bool isVoidReturn = (ri->getNumOperands() == 0);
    ref<Expr> result = ConstantExpr::alloc(0, Expr::Bool);
    ref<Expr> result1 = ConstantExpr::alloc(0, Expr::Bool);
    
    if (!isVoidReturn) {
      result = eval(ki, 0, state).value;
      result1 = eval(ki, 0, state).value1;
    }
    
    if (state.stack.size() <= 1) {
      assert(!caller && "caller set on initial stack frame");
	  terminateStateOnExit(state);
    } else {
	  for (std::vector<const MemoryObject*>::iterator it = state.stack.back().allocas.begin(); 
				  it != state.stack.back().allocas.end(); ++it) {
		state.addressToValue.erase((*it)->getBaseExpr());
		state.varaddrnamemap.erase((*it)->getBaseExpr());
		storedAddrs.erase((*it)->getBaseExpr());
	  }

      state.popFrame();
      if (statsTracker)
        statsTracker->framePopped(state);

      if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
        transferToBasicBlock(ii->getNormalDest(), caller->getParent(), state);
      } else {
        state.pc = kcaller;
      }

      if (!isVoidReturn) {
        LLVM_TYPE_Q Type *t = caller->getType();
        if (t != Type::getVoidTy(getGlobalContext())) {
          // may need to do coercion due to bitcasts
          Expr::Width from = result->getWidth();
          Expr::Width to = getWidthForLLVMType(t);
           
          if (from != to) {
            CallSite cs = (isa<InvokeInst>(caller) ? CallSite(cast<InvokeInst>(caller)) : 
                           CallSite(cast<CallInst>(caller)));
            // XXX need to check other param attrs ?
            if (cs.paramHasAttr(0, llvm::Attribute::SExt)) {
              result = SExtExpr::create(result, to);
              result1 = SExtExpr::create(result1, to);
            } else {
              result = ZExtExpr::create(result, to);
              result1 = ZExtExpr::create(result1, to);
            }
          }

          bindLocal(kcaller, state, result, result1);
        }
      } else {
        // We check that the return value has no users instead of
        // checking the type, since C defaults to returning int for
        // undeclared functions.
        if (!caller->use_empty()) {
          terminateStateOnExecError(state, "return void when caller expected a result");
        }
      }
    }      
    break;
  }
#if LLVM_VERSION_CODE < LLVM_VERSION(3, 1)
  case Instruction::Unwind: {
    for (;;) {
      KInstruction *kcaller = state.stack.back().caller;
      state.popFrame();

      if (statsTracker)
        statsTracker->framePopped(state);

      if (state.stack.empty()) {
        terminateStateOnExecError(state, "unwind from initial stack frame");
        break;
      } else {
        Instruction *caller = kcaller->inst;
        if (InvokeInst *ii = dyn_cast<InvokeInst>(caller)) {
          transferToBasicBlock(ii->getUnwindDest(), caller->getParent(), state);
          break;
        }
      }
    }
    break;
  }
#endif
  case Instruction::Br: {
    BranchInst *bi = cast<BranchInst>(i);
    if (bi->isUnconditional()) {
      transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), state);
    } else {
      // FIXME: Find a way that we don't have this hidden dependency.
      assert(bi->getCondition() == bi->getOperand(0) &&
             "Wrong operand index!");
      Cell cell = eval(ki, 0, state);
	  ref<Expr> cond = cell.value;
	  ref<Expr> cond1 = cell.value1;

      Executor::StatePair branches = fork(state, cond, cond1, false);
      //std::cerr << "Br: " << branches.first << " " << branches.second << "\n";
      // NOTE: There is a hidden dependency here, markBranchVisited
      // requires that we still be in the context of the branch
      // instruction (it reuses its statistic id). Should be cleaned
      // up with convenient instruction specific data.
        
        //Nuno: CLAP has this commented
        if(!bbTrace.empty())
        {
            if (statsTracker && state.stack.back().kf->trackCoverage)
                statsTracker->markBranchVisited(branches.first, branches.second);
        }
            
        if (branches.first)
        {
            if (!dyn_cast<ConstantExpr>(cond1))
                branches.first->path += "1";
            transferToBasicBlock(bi->getSuccessor(0), bi->getParent(), *branches.first);
        }
        if (branches.second)
        {
            if (!dyn_cast<ConstantExpr>(cond1))
                branches.second->path += "0";
            transferToBasicBlock(bi->getSuccessor(1), bi->getParent(), *branches.second);
        }
    }
    break;
  }
  case Instruction::Switch: {
    SwitchInst *si = cast<SwitchInst>(i);
    ref<Expr> cond = eval(ki, 0, state).value;
    ref<Expr> cond1 = eval(ki, 0, state).value1;
    BasicBlock *bb = si->getParent();

    cond = toUnique(state, cond);
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(cond)) {
	  ref<Expr> match = EqExpr::create(cond1, cond);
	  addConstraint1(state, match);
      // Somewhat gross to create these all the time, but fine till we
      // switch to an internal rep.
      LLVM_TYPE_Q llvm::IntegerType *Ty = 
        cast<IntegerType>(si->getCondition()->getType());
      ConstantInt *ci = ConstantInt::get(Ty, CE->getZExtValue());
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
      unsigned index = si->findCaseValue(ci).getSuccessorIndex();
#else
      unsigned index = si->findCaseValue(ci);
#endif
      transferToBasicBlock(si->getSuccessor(index), si->getParent(), state);
      if (!dyn_cast<ConstantExpr>(cond1))
          state.path += stringValueOf(index);
    } else {
      std::map<std::pair<BasicBlock*, unsigned>, ref<Expr> > targets;
      ref<Expr> isDefault = ConstantExpr::alloc(1, Expr::Bool);
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)      
      for (SwitchInst::CaseIt i = si->case_begin(), e = si->case_end();
           i != e; ++i) {
        ref<Expr> value = evalConstant(i.getCaseValue());
#else
      for (unsigned i=1, cases = si->getNumCases(); i<cases; ++i) {
        ref<Expr> value = evalConstant(si->getCaseValue(i));
#endif
        ref<Expr> match = EqExpr::create(cond, value);
        isDefault = AndExpr::create(isDefault, Expr::createIsZero(match));
        bool result;
        bool success = solver->mayBeTrue(state, match, result);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        if (result) {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 1)
          BasicBlock *caseSuccessor = i.getCaseSuccessor();
#else
          BasicBlock *caseSuccessor = si->getSuccessor(i);
#endif
          std::map<std::pair<BasicBlock*, unsigned>, ref<Expr> >::iterator it =
            targets.insert(std::make_pair(std::make_pair(caseSuccessor, i),
                           ConstantExpr::alloc(0, Expr::Bool))).first;

          it->second = OrExpr::create(match, it->second);
        }
      }
      bool res;
      bool success = solver->mayBeTrue(state, isDefault, res);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      if (res)
        targets.insert(std::make_pair(std::make_pair(si->getDefaultDest(), 0), isDefault));
      
      std::vector< ref<Expr> > conditions;
      for (std::map<std::pair<BasicBlock*, unsigned>, ref<Expr> >::iterator it = 
             targets.begin(), ie = targets.end();
           it != ie; ++it)
        conditions.push_back(it->second);
      
      std::vector<ExecutionState*> branches;
      branch(state, conditions, branches);
        
      std::vector<ExecutionState*>::iterator bit = branches.begin();
      for (std::map<std::pair<BasicBlock*, unsigned>, ref<Expr> >::iterator it = 
             targets.begin(), ie = targets.end();
           it != ie; ++it) {
        ExecutionState *es = *bit;
        if (es) {
          transferToBasicBlock(it->first.first, bb, *es);//Jeff: need to decide which one to go here
          es->path += stringValueOf(it->first.second);
        }
        ++bit;
      }
    }
    break;
 }
  case Instruction::Unreachable:
    // Note that this is not necessarily an internal bug, llvm will
    // generate unreachable instructions in cases where it knows the
    // program will crash. So it is effectively a SEGV or internal
    // error.
    terminateStateOnExecError(state, "reached \"unreachable\" instruction");
    break;

  case Instruction::Invoke:
  case Instruction::Call: {
    CallSite cs(i);

    unsigned numArgs = cs.arg_size();
    Value *fp = cs.getCalledValue();
    Function *f = getTargetFunction(fp, state);

    // Skip debug intrinsics, we can't evaluate their metadata arguments.
    if (f && isDebugIntrinsic(f, kmodule))
      break;

	if (isa<InlineAsm>(fp)) {
		terminateStateOnExecError(state, "inline assembly is unsupported");
		break;
	}

    // evaluate arguments
    std::vector< ref<Expr> > arguments;
	arguments1.clear();
    arguments1.reserve(numArgs);
    arguments.reserve(numArgs);

    for (unsigned j=0; j<numArgs; ++j) {
	  ref<Expr> e = eval(ki, j+1, state).value;
	  ref<Expr> e1 = eval(ki, j+1, state).value1;
	  if (e.isNull())  // skip asm instructions
		  break;
      arguments.push_back(e);
      arguments1.push_back(e1);
	}

    if (f) {
    	const FunctionType *fType =
        dyn_cast<FunctionType>(cast<PointerType>(f->getType())->getElementType());
      const FunctionType *fpType =
        dyn_cast<FunctionType>(cast<PointerType>(fp->getType())->getElementType());

      // special case the call with a bitcast case
      if (fType != fpType) {
        assert(fType && fpType && "unable to get function type");

        // XXX check result coercion

        // XXX this really needs thought and validation
        unsigned i=0;
        for (std::vector< ref<Expr> >::iterator
               ai = arguments.begin(), ie = arguments.end();
             ai != ie; ++ai) {
          Expr::Width to, from = (*ai)->getWidth();
            
          if (i<fType->getNumParams()) {
            to = getWidthForLLVMType(fType->getParamType(i));

            if (from != to) {
              // XXX need to check other param attrs ?
              if (cs.paramHasAttr(i+1, llvm::Attribute::SExt)) {
                arguments[i] = SExtExpr::create(arguments[i], to);
                arguments1[i] = SExtExpr::create(arguments1[i], to);
              } else {
                arguments[i] = ZExtExpr::create(arguments[i], to);
                arguments1[i] = ZExtExpr::create(arguments1[i], to);
              }
            }
          }
            
          i++;
        }
      } else if (isa<InlineAsm>(fp)) {
        terminateStateOnExecError(state, "inline assembly is unsupported");
        break;
      }

      executeCall(state, ki, f, arguments);
    } else {


    ref<Expr> v = eval(ki, 0, state).value;
	if (v.isNull()) {
		break;
	}

      ExecutionState *free = &state;
      bool hasInvalid = false, first = true;

      /* XXX This is wasteful, no need to do a full evaluate since we
         have already got a value. But in the end the caches should
         handle it for us, albeit with some overhead. */
      do {
        ref<ConstantExpr> value;
        bool success = solver->getValue(*free, v, value);
        assert(success && "FIXME: Unhandled solver failure");
        (void) success;
        StatePair res = fork(*free, EqExpr::create(v, value), EqExpr::create(v, value), true);
        if (res.first) {
          uint64_t addr = value->getZExtValue();
          if (legalFunctions.count(addr)) {
            f = (Function*) addr;

            // Don't give warning on unique resolution
            if (res.second || !first)
              klee_warning_once((void*) (unsigned long) addr, 
                                "resolved symbolic function pointer to: %s",
                                f->getName().data());

            executeCall(*res.first, ki, f, arguments);
          } else {
            if (!hasInvalid) {
              terminateStateOnExecError(state, "invalid function pointer");
              hasInvalid = true;
            }
          }
        }

        first = false;
        free = res.second;
      } while (free);
    }
    break;
  }
  case Instruction::PHI: {
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 0)
    ref<Expr> result = eval(ki, state.incomingBBIndex, state).value;
    ref<Expr> result1 = eval(ki, state.incomingBBIndex, state).value1;
#else
    ref<Expr> result = eval(ki, state.incomingBBIndex * 2, state).value;
    ref<Expr> result1 = eval(ki, state.incomingBBIndex * 2, state).value1;
#endif
    bindLocal(ki, state, result, result1);
    break;
  }

    // Special instructions
  case Instruction::Select: {
    SelectInst *SI = cast<SelectInst>(ki->inst);
    assert(SI->getCondition() == SI->getOperand(0) &&
           "Wrong operand index!");
    ref<Expr> cond = eval(ki, 0, state).value;
    ref<Expr> tExpr = eval(ki, 1, state).value;
    ref<Expr> fExpr = eval(ki, 2, state).value;
    ref<Expr> result = SelectExpr::create(cond, tExpr, fExpr);

    ref<Expr> cond1 = eval(ki, 0, state).value1;
    ref<Expr> tExpr1 = eval(ki, 1, state).value1;
    ref<Expr> fExpr1 = eval(ki, 2, state).value1;
    ref<Expr> result1 = SelectExpr::create(cond1, tExpr1, fExpr1);

    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::VAArg:
    terminateStateOnExecError(state, "unexpected VAArg instruction");
    break;

  case Instruction::Add: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
	
	if (left->getWidth() != right->getWidth()) {
		if (left->getWidth() < right->getWidth()) {
			left = ZExtExpr::create(left, right->getWidth());
			left1 = ZExtExpr::create(left1, right1->getWidth());
		}
	}
	bindLocal(ki, state, AddExpr::create(left, right), AddExpr::create(left1, right1));
    break;
  }

  case Instruction::Sub: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
	if (left->getWidth() != right->getWidth()) {
		if (left->getWidth() < right->getWidth()) {
			left = ZExtExpr::create(left, right->getWidth());
			left1 = ZExtExpr::create(left1, right1->getWidth());
		} else {
			right = ZExtExpr::create(right, left->getWidth());
			right1 = ZExtExpr::create(right1, left1->getWidth());
		}
	}

    bindLocal(ki, state, SubExpr::create(left, right), SubExpr::create(left1, right1));
    break;
  }
 
  case Instruction::Mul: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    bindLocal(ki, state, MulExpr::create(left, right), MulExpr::create(left1, right1));
    break;
  }

  case Instruction::UDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = UDivExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = UDivExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::SDiv: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SDivExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = SDivExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::URem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = URemExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = URemExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }
 
  case Instruction::SRem: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = SRemExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = SRemExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::And: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AndExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = AndExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::Or: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = OrExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = OrExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::Xor: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = XorExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = XorExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::Shl: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = ShlExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = ShlExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::LShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = LShrExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = LShrExpr::create(left1, right1);
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::AShr: {
    ref<Expr> left = eval(ki, 0, state).value;
    ref<Expr> right = eval(ki, 1, state).value;
    ref<Expr> result = AShrExpr::create(left, right);
	ref<Expr> left1 = eval(ki, 0, state).value1;
    ref<Expr> right1 = eval(ki, 1, state).value1;
    ref<Expr> result1 = AShrExpr::create(left1, right1);
    bindLocal(ki, state, result, result);
    break;
  }

    // Compare

  case Instruction::ICmp: {
    CmpInst *ci = cast<CmpInst>(i);
    ICmpInst *ii = cast<ICmpInst>(ci);
 
    switch(ii->getPredicate()) {
    case ICmpInst::ICMP_EQ: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;
	  if (left->getWidth() != right->getWidth()) {
		  if (left->getWidth() < right->getWidth()) {
			  left = ZExtExpr::create(left, right->getWidth());
			  left1 = ZExtExpr::create(left1, right1->getWidth());
		  } else {
			  right = ZExtExpr::create(right, left->getWidth());
			  right1 = ZExtExpr::create(right1, left1->getWidth());
		  }
	  }

      ref<Expr> result = EqExpr::create(left, right);
	  ref<Expr> result1 = EqExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_NE: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;
	  
	  if (left->getWidth() != right->getWidth()) {
		  if (left->getWidth() < right->getWidth()) {
			  left = ZExtExpr::create(left, right->getWidth());
			  left1 = ZExtExpr::create(left1, right1->getWidth());
		  } else {
			  right = ZExtExpr::create(right, left->getWidth());
			  right1 = ZExtExpr::create(right1, left1->getWidth());
		  }
	  }

      ref<Expr> result = NeExpr::create(left, right);
      ref<Expr> result1 = NeExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_UGT: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = UgtExpr::create(left, right);
      ref<Expr> result1 = UgtExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_UGE: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = UgeExpr::create(left, right);
      ref<Expr> result1 = UgeExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_ULT: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = UltExpr::create(left, right);
      ref<Expr> result1 = UltExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_ULE: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = UleExpr::create(left, right);
      ref<Expr> result1 = UleExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_SGT: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = SgtExpr::create(left, right);
      ref<Expr> result1 = SgtExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_SGE: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = SgeExpr::create(left, right);
      ref<Expr> result1 = SgeExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_SLT: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = SltExpr::create(left, right);
      ref<Expr> result1 = SltExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    case ICmpInst::ICMP_SLE: {
      Cell cell1 = eval(ki, 0, state);
      Cell cell2 = eval(ki, 1, state);

	  ref<Expr> left, left1, right, right1;
	  left = left1 = cell1.value;
	  right = right1 = cell2.value;
	  if (cell1.value1.isNull() == false) 
		  left1 = cell1.value1;

	  if (cell2.value1.isNull() == false) 
		right1 = cell2.value1;

      ref<Expr> result = SleExpr::create(left, right);
      ref<Expr> result1 = SleExpr::create(left1, right1);
      bindLocal(ki, state, result, result1);
      break;
    }

    default:
      terminateStateOnExecError(state, "invalid ICmp predicate");
    }
    break;
  }
 
    // Memory instructions...
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  case Instruction::Malloc:
  case Instruction::Alloca: {
    AllocationInst *ai = cast<AllocationInst>(i);
#else
  case Instruction::Alloca: {
    AllocaInst *ai = cast<AllocaInst>(i);
#endif
    unsigned elementSize = 
      kmodule->targetData->getTypeStoreSize(ai->getAllocatedType());
    ref<Expr> size = Expr::createPointer(elementSize);
    if (ai->isArrayAllocation()) {
      ref<Expr> count = eval(ki, 0, state).value;
      count = Expr::createZExtToPointerWidth(count);
      size = MulExpr::create(size, count);
    }
    bool isLocal = i->getOpcode()==Instruction::Alloca;
    executeAlloc(state, size, isLocal, ki);
    break;
  }
#if LLVM_VERSION_CODE < LLVM_VERSION(2, 7)
  case Instruction::Free: {
    executeFree(state, eval(ki, 0, state).value);
    break;
  }
#endif

      
  case Instruction::Load: {

      ref<Expr> base = eval(ki, 0, state).value;

      ResolutionList rl;
      state.addressSpace.resolve(state,solver,base,rl);
	  ref<Expr> concreteValue = getValueFrom(state, false, base, 0, ki);
	  if (concreteValue.isNull()) {
		  return ;
	  } 

	  ref<Expr> v = 0;
	  if (state.addressToValue.find(base) != state.addressToValue.end()) {
		  v = state.addressToValue[base].second;
	  } else if (addressToValue.find(base) != addressToValue.end()) {
		  v = addressToValue[base].second;
	  }

      for (ResolutionList::iterator it = rl.begin(), ie = rl.end(); it != ie; ++it)
      {
          const MemoryObject *mo = it->first;
          bool isCorrectMemObj = false;
         
          if(isa<ConstantExpr>(base))//if base is a constant, must be correct mem object
              isCorrectMemObj = true;
          else if(base->getKind()==Expr::Add
                  &&base->getKid(0)==mo->getBaseExpr())
              isCorrectMemObj = true;
         
          if(isCorrectMemObj)
          {
			  std::string name;
			  if (mo->isGlobal|| mallocAddresses.find(mo->getBaseExpr()) !=
						  mallocAddresses.end()) {
				name =  varaddrnamemap[mo->getBaseExpr()].second;
			  } else
				name =  state.varaddrnamemap[mo->getBaseExpr()].second;

			  ref<Expr> offset = SubExpr::create(base, mo->getBaseExpr());
			  int offInt = dyn_cast<ConstantExpr>(offset)->getZExtValue();
              if(name.length())
              {
				  std::string basevalue, strOff;
				  ref<Expr> off = SubExpr::create(base, mo->getBaseExpr());
				  dyn_cast<ConstantExpr>(off)->toString(strOff);

                  if (ConstantExpr *CE =dyn_cast<ConstantExpr>(base))
                  {
                      CE->toString(basevalue);
                  }
                  else
                  {
                      mo->getBaseExpr()->toString(basevalue);
                      basevalue += "X";
                  }

				  basevalue += "*" + strOff;
                  
                  const InstructionInfo *myinfo = ki->info; //Nuno
                  mo->setName(name);
                  
				  std::pair<std::string, ref<Expr> > p = executeMakeSymbolic_yqp(state, mo, name,basevalue, ki); 
				  std::string uniqueName = p.first;
				  v = p.second;
                  
				  std::stringstream ss;
				  ss << "R-" << uniqueName; // masked by yqp

				  stringstream linestr;
				  linestr << myinfo->line;

				  if (info->file.find("memcpy.c") == std::string::npos) {

                      state.tmpTrace.append("O" + stringValueOf(currentOrder++) + " " + 
                              extractFileBasename(myinfo->file) + "@" + linestr.str() + ":" + ss.str() + "\n");
					  if(!isa<ConstantExpr>(base))
					  {
						  stringstream ssbase;
						  ssbase <<"*"<<base<<"*\n";
						  state.tmpTrace.append(ssbase.str());
					  }
				  }
				  
				  addCondForPointerAccess(state, i, v);
				  // yqp
				  std::string s = "O" + ss.str() + "&" + extractFileBasename(myinfo->file) + "@" + linestr.str();
				  controlStr = "R-" + uniqueName.substr(0, uniqueName.find_last_of("_")+1);
				  std::string str = "R-" + uniqueName.substr(0, uniqueName.find_last_of("_")); 
				  ref<Expr> concValue = getInitValue(state, base, ki, str, offInt, v->getWidth());
				  if (concValue.isNull() == false) {
					  concreteValue = concValue;
				  }

				  controlPoint(state, s);
				  storeFlag = true;
			  }

			  break;
		  }
	  }
	  if (v.isNull()) {
	  	 v = concreteValue;
	  }
	  if (v->getWidth() != concreteValue->getWidth()) {
		  v = ZExtExpr::create(v, concreteValue->getWidth());
	  }

      bindLocal(ki, state, concreteValue, v);

	  break;
						  }
  case Instruction::Store: {
      ref<Expr> base = eval(ki, 1, state).value;
      ref<Expr> value = eval(ki, 0, state).value;
      ref<Expr> value1 = eval(ki, 0, state).value1;
	  if (/*isa<ConstantExpr>(value) || */(value1.isNull() && value.isNull() == false))
		value1 = value;

	  storedAddrs.insert(base);
      ResolutionList rl;
      state.addressSpace.resolve(state,solver,base,rl);
    
	  const MemoryObject *mo = NULL; 
	  for (ResolutionList::iterator it = rl.begin(),
           ie = rl.end(); it != ie; ++it) {
          mo = it->first;
          
          bool isCorrectMemObj = false;
          
          if(isa<ConstantExpr>(base))//if base is a constant, must be correct mem object
              isCorrectMemObj = true;
          else if(base->getKind()==Expr::Add
                  &&base->getKid(0)==mo->getBaseExpr())
              isCorrectMemObj = true;
          
          if(isCorrectMemObj)
          {
              
              std::string oname, name;
			  if (mo->isGlobal || mallocAddresses.find(mo->getBaseExpr()) !=
						  mallocAddresses.end()) {
				oname = varaddrnamemap[mo->getBaseExpr()].second;
				addressToValue[base] = std::make_pair(value, value1);
				name = varaddrnamemap[mo->getBaseExpr()].first + oname;
			  } else {
				oname = state.varaddrnamemap[mo->getBaseExpr()].second;
				state.addressToValue[base] = std::make_pair(value, value1);
				name = state.varaddrnamemap[mo->getBaseExpr()].first + oname;
			  }
			  
              if(value.isNull())
              {
                  std::cerr <<"["<<state.getThreadName()<<"] Store - base: "<<base<<"  name: "<<name<<"  value: null -> set value = 0\n";
				  Expr::Width t = getWidthForLLVMType(i->getOperand(0)->getType());
                  value = ConstantExpr::create(0, t);
				  value = value1;
              }
              
              if(oname.length())
              {
                  std::string basevalue, strOff;
				  ref<Expr> off = SubExpr::create(base, mo->getBaseExpr());
				  dyn_cast<ConstantExpr>(off)->toString(strOff);

                  if (ConstantExpr *CE =dyn_cast<ConstantExpr>(base))
                  {
                      CE->toString(basevalue);
                  }
                  else
                  {
                      mo->getBaseExpr()->toString(basevalue);
                      basevalue += "X";
                  }
				  basevalue += "*" + strOff;
                 
                  
                  const InstructionInfo *myinfo = ki->info; //Nuno
                  
                  std::stringstream ss;
                  ss << "W-" << name<<"_"<<basevalue<<"-"<< state.getThreadName();
                  
				  stringstream linestr;
                  linestr << myinfo->line;

				  if (info->file.find("memcpy.c") == std::string::npos &&
							  info->file.find("memset.c") == std::string::npos &&
							  name.find("rbuf") == std::string::npos) {
                      state.tmpTrace.append("O" + stringValueOf(currentOrder++) + " " + 
                              extractFileBasename(myinfo->file) + "@" + linestr.str() + ":" + ss.str() + "\n");
					  if(!isa<ConstantExpr>(base))
					  {
						  stringstream ssbase;
						  ssbase <<"*"<<base<<"*\n";
						  state.tmpTrace.append(ssbase.str());
					  }

					  stringstream ssvalue;
					  ssvalue << "$"<< value1 <<"$\n";
					  state.tmpTrace.append(ssvalue.str());
				  }
				  
				  // yqp
				  std::string s = "O" + ss.str() + "&" + extractFileBasename(myinfo->file) + "@" + linestr.str();
				  controlPoint(state, s);
			  }
              break;
          }
	  }
	 
      executeMemoryOperation(state, true, base, value, 0);

	  if (!mo || (mo && (mo->isGlobal || mallocAddresses.find(mo->getBaseExpr()) !=
						  mallocAddresses.end()))) {
		addressToValue[base] = std::make_pair(value, value1);
	  } else {
		state.addressToValue[base] = std::make_pair(value, value1);
	  }
      
      break;
  }

  case Instruction::GetElementPtr: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);
    ref<Expr> base = eval(ki, 0, state).value;
    ref<Expr> base1 = eval(ki, 0, state).value1;

    for (std::vector< std::pair<unsigned, uint64_t> >::iterator 
           it = kgepi->indices.begin(), ie = kgepi->indices.end(); 
         it != ie; ++it) {
      uint64_t elementSize = it->second;
      ref<Expr> index = eval(ki, it->first, state).value;
      base = AddExpr::create(base,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));
	  base1 = AddExpr::create(base1,
                             MulExpr::create(Expr::createSExtToPointerWidth(index),
                                             Expr::createPointer(elementSize)));
    }
    if (kgepi->offset) {
      base = AddExpr::create(base,
                             Expr::createPointer(kgepi->offset));
	  base1 = AddExpr::create(base1,
                             Expr::createPointer(kgepi->offset));
	}
    bindLocal(ki, state, base, base1);
    break;
  }

    // Conversion
  case Instruction::Trunc: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ExtractExpr::create(eval(ki, 0, state).value,
                                           0,
                                           getWidthForLLVMType(ci->getType()));
	ref<Expr> result1 = ExtractExpr::create(eval(ki, 0, state).value1,
                                           0,
                                           getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result, result1);
    break;
  }
  case Instruction::ZExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = ZExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
	ref<Expr> result1 = ZExtExpr::create(eval(ki, 0, state).value1,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result, result1);
    break;
  }
  case Instruction::SExt: {
    CastInst *ci = cast<CastInst>(i);
    ref<Expr> result = SExtExpr::create(eval(ki, 0, state).value,
                                        getWidthForLLVMType(ci->getType()));
	ref<Expr> result1 = SExtExpr::create(eval(ki, 0, state).value1,
                                        getWidthForLLVMType(ci->getType()));
    bindLocal(ki, state, result, result1);
    break;
  }

  case Instruction::IntToPtr: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width pType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    ref<Expr> arg1 = eval(ki, 0, state).value1;
    bindLocal(ki, state, ZExtExpr::create(arg, pType), ZExtExpr::create(arg1, pType));
    break;
  } 
  case Instruction::PtrToInt: {
    CastInst *ci = cast<CastInst>(i);
    Expr::Width iType = getWidthForLLVMType(ci->getType());
    ref<Expr> arg = eval(ki, 0, state).value;
    ref<Expr> arg1 = eval(ki, 0, state).value1;
    bindLocal(ki, state, ZExtExpr::create(arg, iType), ZExtExpr::create(arg1, iType));
    break;
  }

  case Instruction::BitCast: {
    ref<Expr> result = eval(ki, 0, state).value;
    ref<Expr> result1 = eval(ki, 0, state).value1;
    bindLocal(ki, state, result, result1);
    break;
  }

    // Floating point instructions

  case Instruction::FAdd: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FAdd operation");

    llvm::APFloat Res(left->getAPValue());
    Res.add(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()),
				ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FSub: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FSub operation");

    llvm::APFloat Res(left->getAPValue());
    Res.subtract(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()),
				ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }
 
  case Instruction::FMul: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FMul operation");

    llvm::APFloat Res(left->getAPValue());
    Res.multiply(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()),
				ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FDiv: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FDiv operation");

    llvm::APFloat Res(left->getAPValue());
    Res.divide(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()),
				ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FRem: {
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FRem operation");

    llvm::APFloat Res(left->getAPValue());
    Res.mod(APFloat(right->getAPValue()), APFloat::rmNearestTiesToEven);
    bindLocal(ki, state, ConstantExpr::alloc(Res.bitcastToAPInt()),
				ConstantExpr::alloc(Res.bitcastToAPInt()));
    break;
  }

  case Instruction::FPTrunc: {
    FPTruncInst *fi = cast<FPTruncInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > arg->getWidth())
      return terminateStateOnExecError(state, "Unsupported FPTrunc operation");

    llvm::APFloat Res(arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res),
				ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPExt: {
    FPExtInst *fi = cast<FPExtInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || arg->getWidth() > resultType)
      return terminateStateOnExecError(state, "Unsupported FPExt operation");

    llvm::APFloat Res(arg->getAPValue());
    bool losesInfo = false;
    Res.convert(*fpWidthToSemantics(resultType),
                llvm::APFloat::rmNearestTiesToEven,
                &losesInfo);
    bindLocal(ki, state, ConstantExpr::alloc(Res),
				ConstantExpr::alloc(Res));
    break;
  }

  case Instruction::FPToUI: {
    FPToUIInst *fi = cast<FPToUIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToUI operation");

    llvm::APFloat Arg(arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, false,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType),
				ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::FPToSI: {
    FPToSIInst *fi = cast<FPToSIInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    if (!fpWidthToSemantics(arg->getWidth()) || resultType > 64)
      return terminateStateOnExecError(state, "Unsupported FPToSI operation");

    llvm::APFloat Arg(arg->getAPValue());
    uint64_t value = 0;
    bool isExact = true;
    Arg.convertToInteger(&value, resultType, false,
                         llvm::APFloat::rmTowardZero, &isExact);
    bindLocal(ki, state, ConstantExpr::alloc(value, resultType),
				ConstantExpr::alloc(value, resultType));
    break;
  }

  case Instruction::UIToFP: {
    UIToFPInst *fi = cast<UIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported UIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), false,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f), ConstantExpr::alloc(f));
    break;
  }

  case Instruction::SIToFP: {
    SIToFPInst *fi = cast<SIToFPInst>(i);
    Expr::Width resultType = getWidthForLLVMType(fi->getType());
    ref<ConstantExpr> arg = toConstant(state, eval(ki, 0, state).value,
                                       "floating point");
    const llvm::fltSemantics *semantics = fpWidthToSemantics(resultType);
    if (!semantics)
      return terminateStateOnExecError(state, "Unsupported SIToFP operation");
    llvm::APFloat f(*semantics, 0);
    f.convertFromAPInt(arg->getAPValue(), true,
                       llvm::APFloat::rmNearestTiesToEven);

    bindLocal(ki, state, ConstantExpr::alloc(f), ConstantExpr::alloc(f));
    break;
  }

  case Instruction::FCmp: {
    FCmpInst *fi = cast<FCmpInst>(i);
    ref<ConstantExpr> left = toConstant(state, eval(ki, 0, state).value,
                                        "floating point");
    ref<ConstantExpr> right = toConstant(state, eval(ki, 1, state).value,
                                         "floating point");
    if (!fpWidthToSemantics(left->getWidth()) ||
        !fpWidthToSemantics(right->getWidth()))
      return terminateStateOnExecError(state, "Unsupported FCmp operation");

    APFloat LHS(left->getAPValue());
    APFloat RHS(right->getAPValue());
    APFloat::cmpResult CmpRes = LHS.compare(RHS);

    bool Result = false;
    switch( fi->getPredicate() ) {
      // Predicates which only care about whether or not the operands are NaNs.
    case FCmpInst::FCMP_ORD:
      Result = CmpRes != APFloat::cmpUnordered;
      break;

    case FCmpInst::FCMP_UNO:
      Result = CmpRes == APFloat::cmpUnordered;
      break;

      // Ordered comparisons return false if either operand is NaN.  Unordered
      // comparisons return true if either operand is NaN.
    case FCmpInst::FCMP_UEQ:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OEQ:
      Result = CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UGT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGT:
      Result = CmpRes == APFloat::cmpGreaterThan;
      break;

    case FCmpInst::FCMP_UGE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OGE:
      Result = CmpRes == APFloat::cmpGreaterThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_ULT:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLT:
      Result = CmpRes == APFloat::cmpLessThan;
      break;

    case FCmpInst::FCMP_ULE:
      if (CmpRes == APFloat::cmpUnordered) {
        Result = true;
        break;
      }
    case FCmpInst::FCMP_OLE:
      Result = CmpRes == APFloat::cmpLessThan || CmpRes == APFloat::cmpEqual;
      break;

    case FCmpInst::FCMP_UNE:
      Result = CmpRes == APFloat::cmpUnordered || CmpRes != APFloat::cmpEqual;
      break;
    case FCmpInst::FCMP_ONE:
      Result = CmpRes != APFloat::cmpUnordered && CmpRes != APFloat::cmpEqual;
      break;

    default:
      assert(0 && "Invalid FCMP predicate!");
    case FCmpInst::FCMP_FALSE:
      Result = false;
      break;
    case FCmpInst::FCMP_TRUE:
      Result = true;
      break;
    }

    bindLocal(ki, state, ConstantExpr::alloc(Result, Expr::Bool), 
				ConstantExpr::alloc(Result, Expr::Bool));
    break;
  }
  case Instruction::InsertValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;
    ref<Expr> agg1 = eval(ki, 0, state).value1;
    ref<Expr> val = eval(ki, 1, state).value;
    ref<Expr> val1 = eval(ki, 1, state).value1;

    ref<Expr> l = NULL, r = NULL, l1 = NULL, r1 = NULL;
    unsigned lOffset = kgepi->offset*8, rOffset = kgepi->offset*8 + val->getWidth();

    if (lOffset > 0) {
      l = ExtractExpr::create(agg, 0, lOffset);
      l1 = ExtractExpr::create(agg1, 0, lOffset);
	}
    if (rOffset < agg->getWidth()) {
      r = ExtractExpr::create(agg, rOffset, agg->getWidth() - rOffset);
      r1 = ExtractExpr::create(agg1, rOffset, agg1->getWidth() - rOffset);
	}

    ref<Expr> result, result1;
    if (!l.isNull() && !r.isNull()) {
      result = ConcatExpr::create(r, ConcatExpr::create(val, l));
      result1 = ConcatExpr::create(r1, ConcatExpr::create(val1, l1));
	} else if (!l.isNull()) {
      result = ConcatExpr::create(val, l);
      result1 = ConcatExpr::create(val1, l1);
	} else if (!r.isNull()) {
      result = ConcatExpr::create(r, val);
      result1 = ConcatExpr::create(r1, val1);
	} else {
      result = val;
      result1 = val1;
	}

    bindLocal(ki, state, result, result1);
    break;
  }
  case Instruction::ExtractValue: {
    KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(ki);

    ref<Expr> agg = eval(ki, 0, state).value;
    ref<Expr> agg1 = eval(ki, 0, state).value1;

    ref<Expr> result = ExtractExpr::create(agg, kgepi->offset*8, getWidthForLLVMType(i->getType()));
    ref<Expr> result1 = ExtractExpr::create(agg1, kgepi->offset*8, getWidthForLLVMType(i->getType()));

    bindLocal(ki, state, result, result1);
    break;
  }
 
    // Other instructions...
    // Unhandled
  case Instruction::ExtractElement:
  case Instruction::InsertElement:
  case Instruction::ShuffleVector:
    terminateStateOnError(state, "XXX vector instructions unhandled",
                          "xxx.err");
    break;
 
  default:
    terminateStateOnExecError(state, "illegal instruction");
    break;
  }
}

void Executor::updateStates(ExecutionState *current) {
  if (searcher) {
    searcher->update(current, addedStates, removedStates);
  }
  
  states.insert(addedStates.begin(), addedStates.end());
  addedStates.clear();
  
  for (std::set<ExecutionState*>::iterator
         it = removedStates.begin(), ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    std::set<ExecutionState*>::iterator it2 = states.find(es);
    assert(it2!=states.end());
    states.erase(it2);
    std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(es);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    processTree->remove(es->ptreeNode);
    delete es;
  }
  removedStates.clear();
}

template <typename TypeIt>
void Executor::computeOffsets(KGEPInstruction *kgepi, TypeIt ib, TypeIt ie) {
  ref<ConstantExpr> constantOffset =
    ConstantExpr::alloc(0, Context::get().getPointerWidth());
  uint64_t index = 1;
  for (TypeIt ii = ib; ii != ie; ++ii) {
    if (LLVM_TYPE_Q StructType *st = dyn_cast<StructType>(*ii)) {
      const StructLayout *sl = kmodule->targetData->getStructLayout(st);
      const ConstantInt *ci = cast<ConstantInt>(ii.getOperand());
      uint64_t addend = sl->getElementOffset((unsigned) ci->getZExtValue());
      constantOffset = constantOffset->Add(ConstantExpr::alloc(addend,
                                                               Context::get().getPointerWidth()));
    } else {
      const SequentialType *set = cast<SequentialType>(*ii);
      uint64_t elementSize = 
        kmodule->targetData->getTypeStoreSize(set->getElementType());
      Value *operand = ii.getOperand();
      if (Constant *c = dyn_cast<Constant>(operand)) {
        ref<ConstantExpr> index = 
          evalConstant(c)->SExt(Context::get().getPointerWidth());
        ref<ConstantExpr> addend = 
          index->Mul(ConstantExpr::alloc(elementSize,
                                         Context::get().getPointerWidth()));
        constantOffset = constantOffset->Add(addend);
      } else {
        kgepi->indices.push_back(std::make_pair(index, elementSize));
      }
    }
    index++;
  }
  kgepi->offset = constantOffset->getZExtValue();
}

void Executor::bindInstructionConstants(KInstruction *KI) {
  KGEPInstruction *kgepi = static_cast<KGEPInstruction*>(KI);

  if (GetElementPtrInst *gepi = dyn_cast<GetElementPtrInst>(KI->inst)) {
    computeOffsets(kgepi, gep_type_begin(gepi), gep_type_end(gepi));
  } else if (InsertValueInst *ivi = dyn_cast<InsertValueInst>(KI->inst)) {
    computeOffsets(kgepi, iv_type_begin(ivi), iv_type_end(ivi));
    assert(kgepi->indices.empty() && "InsertValue constant offset expected");
  } else if (ExtractValueInst *evi = dyn_cast<ExtractValueInst>(KI->inst)) {
    computeOffsets(kgepi, ev_type_begin(evi), ev_type_end(evi));
    assert(kgepi->indices.empty() && "ExtractValue constant offset expected");
  }
}

void Executor::bindModuleConstants() {
  for (std::vector<KFunction*>::iterator it = kmodule->functions.begin(), 
         ie = kmodule->functions.end(); it != ie; ++it) {
    KFunction *kf = *it;
    for (unsigned i=0; i<kf->numInstructions; ++i)
      bindInstructionConstants(kf->instructions[i]);
  }

  kmodule->constantTable = new Cell[kmodule->constants.size()];
  for (unsigned i=0; i<kmodule->constants.size(); ++i) {
    Cell &c = kmodule->constantTable[i];
    c.value = evalConstant(kmodule->constants[i]);
    c.value1 = evalConstant(kmodule->constants[i]);
  }
}

std::map<std::string, int> waitTime;
void Executor::run2(ExecutionState &initialState) {
  currentOrder = 0;

  bindModuleConstants();

  states.insert(&initialState);
  gState->addState(0, &initialState);  // yqp
  initialState.tid = 0;
  initialState.setThreadName("0"); //:CLAP:
  initialState.constraints.prefixNum = prefixes["0"];
  initTimers();

  initialState.goalsReached = 0; //Nuno: added this
  readOrderFile2();  
	
  while (orderVec.size() != 0) {
	 while (orderVec[0].second.find("-start-") != std::string::npos) {
		orderVec.erase(orderVec.begin());
	 }
	
	 if (orderVec.size() == 0)
	    break;


	 int nextTID = orderVec[0].first;
	 ExecutionState* state = gState->getState(nextTID);
	 int ind = 0;
	 bool flag = false, flag1 = false;
	 while (state == NULL) {
		state = gState->getState(ind++);
		if (ind>tid) {
			if (flag) {
				flag1 = true;
				break;
			}

			ind = 0;
			flag = true;
		}
	 }

	 if (flag1) {
		 break;
	 }


	 if (removedStates.find(state) != removedStates.end()) {
		orderVec.erase(orderVec.begin());
		continue;
	 }

	 KInstruction *ki = state->pc;

	 if (ki->inst->getOpcode() == Instruction::Call) {
		 state->executedInsts++;
		 CallSite cs(ki->inst);

		 Value *fp = cs.getCalledValue();
		 Function *f = getTargetFunction(fp, *state);
		 if (f && f->getNameStr() == "pthread_join") {
			 orderVec.erase(orderVec.begin());
			 continue ;
		 } else if (f && f->getNameStr() == "pthread_cond_signal") {
			 ref<Expr> cond = eval(ki, 1, *state).value;

			 if (condWait[cond].size() != 0) {
				 releasedConds[cond].insert(condWait[cond][0]);
				 condWait[cond].erase(condWait[cond].begin());
			 } else {
				 releasedConds[cond].insert("-1"); // any thread
			 }
		 } else if (f && f->getNameStr() == "pthread_cond_broadcast") {
			 ref<Expr> cond = eval(ki, 1, *state).value;
			 std::set<string> s(condWait[cond].begin(), condWait[cond].end());
			 if (condWait[cond].size() == 0)

			 releasedConds[cond].insert(s.begin(), s.end());
			 condWait.erase(cond);
		 }
	 }

	 executeInstruction(*state, ki);
	 if (!state->notStep) 
	   stepInstruction(*state);
	 else
	   state->notStep = false;
  }

  //FIXME: make sure fair schedule among different threads!
  bool flag;
  do {
	  flag = false;
	  for (unsigned i=0; i<tid; ++i) {
		  ExecutionState* state = gState->getState(i);

		  if (state == NULL)
			  continue ;
		  
		  while (removedStates.find(state) == removedStates.end()) {
			  flag = true;
			  KInstruction *ki = state->pc;

			  if (ki->inst->getOpcode() == Instruction::Call) {
				  CallSite cs(ki->inst);

				  state->executedInsts++;
				  Value *fp = cs.getCalledValue();
				  Function *f = getTargetFunction(fp, *state);

                  if (f && f->getNameStr() == "pthread_mutex_lock") {
                      ref<Expr> address = eval(ki, 1, *state).value;
                      if (locks.find(address) != locks.end()) {
                          if (gState->getState(intValueOf(locks[address])) != NULL) {
                              //std::cerr << "[" << i << "] Note: postphone the execution until the lock is released!: " <<
                                  //address << "\n";
                              break;
                          } else  {
                              locks.erase(address);
                          }
                      } else {
                      }
                  } else if (f && f->getNameStr() == "pthread_cond_wait" ||
							  f && f->getNameStr() == "pthread_cond_timedwait") {
					  // evaluate arguments
					  std::cerr << "["<< state->getThreadName() << "] " << state << " wait " 
						  << extractFileBasename(ki->info->file) << ":" << ki->info->line << "\n";

					  std::vector< ref<Expr> > arguments;
					  unsigned numArgs = cs.arg_size();
					  arguments.reserve(numArgs);
					  for (unsigned j=0; j<numArgs; ++j)
						arguments.push_back(eval(ki, j+1, *state).value);
					  ref<Expr> cond = arguments[0];
					  ref<Expr> lock = arguments[1];
					  lockToConds[lock].insert(cond);
					  if (releasedConds.find(cond) != releasedConds.end() &&
								  (releasedConds[cond].find(state->getThreadName())
									  != releasedConds[cond].end() ||
									  releasedConds[cond].find("-1") !=
									  releasedConds[cond].end())) {
						  if (locks.find(lock) != locks.end() &&
									  locks[lock] != state->getThreadName()) { // the lock is hold by other threads.
							  break ;
						  }

						  // release a wait and hold a lock
						  releasedConds[cond].erase(state->getThreadName());
						  locks[lock] = state->getThreadName();
					  } else {
						  if (locks.find(lock) != locks.end()) {
							  assert(locks.find(lock) != locks.end());
							  if (locks[lock] == state->getThreadName()) {
								  locks.erase(lock);
							  }
						  }
						  if (std::find(condWait[cond].begin(), condWait[cond].end(), 
										  state->getThreadName()) == condWait[cond].end()) {
							  condWait[cond].push_back(state->getThreadName());
						  }
						  break;
					  }
				  } else if (f && f->getNameStr() == "pthread_cond_signal") {
					  ref<Expr> cond = eval(ki, 1, *state).value;
					  if (condWait[cond].size() != 0) {
						  releasedConds[cond].insert(condWait[cond][0]);
						  condWait[cond].erase(condWait[cond].begin());
					  }
				  } else if (f && f->getNameStr() == "pthread_cond_broadcast") {
					  ref<Expr> cond = eval(ki, 1, *state).value;
					  releasedConds[cond].insert(condWait[cond].begin(), condWait[cond].end());
					  if (condWait[cond].size() == 0) 
						releasedConds[cond].insert("-1");

					  condWait.erase(cond);
				  }
			  }

			  executeInstruction(*state, ki);

			  if (!state->notStep) 
				stepInstruction(*state);
			  else
				state->notStep = false;
				
			  break;
		  }
	  }
  } while (flag);


  /*std::ofstream outfile((getexepath(bbTrace) + "klee-out-"+Index+"/prefix").c_str()); 
  std::string str = "";
  for (std::map<string, vector<int> >::iterator it = prefixes.begin();
          it != prefixes.end(); ++it) {
      str += it->first + "\n" + stringValueOf(it->second.size()) + "\n";
  }
  prefixStr = str + prefixStr;
  outfile << prefixStr;

  outfile.flush();
  outfile.close();*/
}


void Executor::run(ExecutionState &initialState) {
  bindModuleConstants();

  // Delay init till now so that ticks don't accrue during
  // optimization and such.
  initTimers();

   initialState.goalsReached = 0; 
    
  states.insert(&initialState);

  if (usingSeeds) {
    
	  std::vector<SeedInfo> &v = seedMap[&initialState];

    for (std::vector<KTest*>::const_iterator it = usingSeeds->begin(), 
           ie = usingSeeds->end(); it != ie; ++it)
      v.push_back(SeedInfo(*it));

    int lastNumSeeds = usingSeeds->size()+10;
    double lastTime, startTime = lastTime = util::getWallTime();
    ExecutionState *lastState = 0;
    while (!seedMap.empty()) {
      if (haltExecution) goto dump;

      std::map<ExecutionState*, std::vector<SeedInfo> >::iterator it = 
        seedMap.upper_bound(lastState);
      if (it == seedMap.end())
        it = seedMap.begin();
      lastState = it->first;
      unsigned numSeeds = it->second.size();
      ExecutionState &state = *lastState;
      KInstruction *ki = state.pc;
      stepInstruction(state);
      executeInstruction(state, ki);
      processTimers(&state, MaxInstructionTime * numSeeds);
      updateStates(&state);

      if ((stats::instructions % 1000) == 0) {
        int numSeeds = 0, numStates = 0;
        for (std::map<ExecutionState*, std::vector<SeedInfo> >::iterator
               it = seedMap.begin(), ie = seedMap.end();
             it != ie; ++it) {
          numSeeds += it->second.size();
          numStates++;
        }
        double time = util::getWallTime();
        if (SeedTime>0. && time > startTime + SeedTime) {
          klee_warning("seed time expired, %d seeds remain over %d states",
                       numSeeds, numStates);
          break;
        } else if (numSeeds<=lastNumSeeds-10 ||
                   time >= lastTime+10) {
          lastTime = time;
          lastNumSeeds = numSeeds;          
          klee_message("%d seeds remaining over: %d states", 
                       numSeeds, numStates);
        }
      }
    }

    klee_message("seeding done (%d states remain)", (int) states.size());

    // XXX total hack, just because I like non uniform better but want
    // seed results to be equally weighted.
    for (std::set<ExecutionState*>::iterator
           it = states.begin(), ie = states.end();
         it != ie; ++it) {
      (*it)->weight = 1.;
    }

    if (OnlySeed)
      goto dump;
  }
    
    searcher = constructUserSearcher(*this);
    
    searcher->update(0, states, std::set<ExecutionState*>());
    
    while (!states.empty() && !haltExecution)
    {
        ExecutionState &state = searcher->selectState();
        if(!bbTrace.empty())
        {
            KInstruction *ki = state.pc;
            stepInstruction(state);
            
            executeInstruction(state, ki);
            
        }
        else
        {
            if (searcher->empty()) {
                std::vector<ExecutionState*> arr(states.begin(), states.end());
                states.clear();
                states.insert(&state);
                haltExecution =true;
                continue;
            }
            
            if(((AvisoReplaySearcher*)searcher)->getTarget)
            {     
                ((AvisoReplaySearcher*)searcher)->getTarget = false;
                terminateStateCLAPWithConstraints(state);
                updateStates(&state);
                continue;
            }
            
            KInstruction *ki = state.pc;
            stepInstruction(state);
            
            bool removecurstate = false;
            
            if (!removecurstate){
                
				executeInstruction(state, ki);
                processTimers(&state, MaxInstructionTime);
            }
            
            if (MaxMemory) {
                if ((stats::instructions & 0xFFFF) == 0) {
                    // We need to avoid calling GetMallocUsage() often because it
                    // is O(elts on freelist). This is really bad since we start
                    // to pummel the freelist once we hit the memory cap.
                    unsigned mbs = sys::Process::GetTotalMemoryUsage() >> 20;
                    
                    if (mbs > MaxMemory) {
                        if (mbs > MaxMemory + 100) {
                            // just guess at how many to kill
                            unsigned numStates = states.size();
                            unsigned toKill = std::max(1U, numStates - numStates*MaxMemory/mbs);
                            
                            if (MaxMemoryInhibit)
                                klee_warning("killing %d states (over memory cap)",
                                             toKill);
                            
                            std::vector<ExecutionState*> arr(states.begin(), states.end());
                            for (unsigned i=0,N=arr.size(); N && i<toKill; ++i,--N) {
                                unsigned idx = rand() % N;
                                
                                // Make two pulls to try and not hit a state that
                                // covered new code.
                                if (arr[idx]->coveredNew)
                                    idx = rand() % N;
                                
                                std::swap(arr[idx], arr[N-1]);
                                terminateStateEarly(*arr[N-1], "Memory limit exceeded.");
                            }
                        }
                        atMemoryLimit = true;
                    } else {
                        atMemoryLimit = false;
                    }
                }
            }
        }
        
        updateStates(&state);
    }
    
    delete searcher;
    searcher = 0;
    
dump:
    if (DumpStatesOnHalt && !states.empty())
    {
        std::cerr << "[" << getThreadName()<<"] KLEE: halting execution, dumping remaining states (Executor.run)\n";
        for (std::set<ExecutionState*>::iterator it = states.begin(), ie = states.end(); it != ie; ++it)
        {
            ExecutionState &state = **it;
            stepInstruction(state); // keep stats rolling
            terminateStateEarly(state, "execution halting");
        }
        updateStates(0);
    }
}

std::string Executor::getAddressInfo(ExecutionState &state, 
                                     ref<Expr> address) const{
  std::ostringstream info;
  info << "\taddress: " << address << "\n";
  uint64_t example;
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(address)) {
    example = CE->getZExtValue();
  } else {
    ref<ConstantExpr> value;
    bool success = solver->getValue(state, address, value);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    example = value->getZExtValue();
    info << "\texample: " << example << "\n";
    std::pair< ref<Expr>, ref<Expr> > res = solver->getRange(state, address);
    info << "\trange: [" << res.first << ", " << res.second <<"]\n";
  }
  
  MemoryObject hack((unsigned) example);    
  MemoryMap::iterator lower = state.addressSpace.objects.upper_bound(&hack);
  info << "\tnext: ";
  if (lower==state.addressSpace.objects.end()) {
    info << "none\n";
  } else {
    const MemoryObject *mo = lower->first;
    std::string alloc_info;
    mo->getAllocInfo(alloc_info);
    info << "object at " << mo->address
         << " of size " << mo->size << "\n"
         << "\t\t" << alloc_info << "\n";
  }
  if (lower!=state.addressSpace.objects.begin()) {
    --lower;
    info << "\tprev: ";
    if (lower==state.addressSpace.objects.end()) {
      info << "none\n";
    } else {
      const MemoryObject *mo = lower->first;
      std::string alloc_info;
      mo->getAllocInfo(alloc_info);
      info << "object at " << mo->address 
           << " of size " << mo->size << "\n"
           << "\t\t" << alloc_info << "\n";
    }
  }

  return info.str();
}

void Executor::terminateStateCLAPDirectly(ExecutionState &state) {

	  std::set<ExecutionState*>::iterator it = addedStates.find(&state);
	  if (it==addedStates.end()) {
	    state.pc = state.prevPC;

	    removedStates.insert(&state);
	  } else {
	    // never reached searcher, just delete immediately
	    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it3 =
	      seedMap.find(&state);
	    if (it3 != seedMap.end())
	      seedMap.erase(it3);
	    addedStates.erase(it);
	    processTree->remove(state.ptreeNode);
	    delete &state;
	  }
}
    
         
//:CLAP:
void Executor::terminateStateCLAPWithConstraints(ExecutionState &state) {
    
    //append last collected info
    if(!state.tmpTrace.empty())
        tracePerThread[state.getThreadName()][state.stateId] = state.tmpTrace;
    
    //** NEW: use a single tracefile per path
    string tracefilename = "T"+state.getThreadName()+"_"+state.stateId;
    std::ostream *tmp_outFile = interpreterHandler->openOutputFile(tracefilename);
    std::ostream &stateTraceFile = *tmp_outFile;
    
    stateTraceFile << "<PathString> " << state.path << "\n";
    //add a tag to the trace if this thread contains the assertion
    if(state.getThreadName() == assertThread){
	if(failedExec)
		stateTraceFile << "<assertThread_fail>\n";
	else
		stateTraceFile << "<assertThread_ok>\n";
    }
    stateTraceFile << "<readwrite>\n";
    
    stateTraceFile << tracePerThread[state.getThreadName()][state.stateId];
    stateTraceFile.flush();
    
	if(!state.constraints.constraints1.empty())
    {
        stateTraceFile << "<path>\n";
    }
    
	int i=0;
    for(std::vector< ref<Expr> >::const_iterator cb = 
				state.constraints.constraints1.begin(), 
				ce=state.constraints.constraints1.end();cb!=ce;cb++)
    {
        if(Expr *e = dyn_cast<Expr>(*cb))
        {
            stateTraceFile<<"T"<<state.getThreadName()<<":";
            e->print(stateTraceFile);
            std::pair<int, int> p = state.constraints.indexes[cb-state.constraints.constraints1.begin()];
            stateTraceFile<< "\n" << p.first << " " << p.second << "\n";
        }
		i++;
    }
    std::cerr << "[" << state.getThreadName() << "_" << state.stateId <<"] terminateStateCLAPWithConstraints\n";
   
	// release all holded locks
	std::map<const ref<Expr>, std::string> tmpLocks;
	tmpLocks.insert(locks.begin(), locks.end());
	for (std::map<ref<Expr>, std::string>::iterator it = tmpLocks.begin();
				it != tmpLocks.end(); ++it) {
		if (it->second == state.getThreadName()) {
			locks.erase(it->first);
		}
	}

    stateTraceFile.flush();
    
    //print all load/store values in order
	interpreterHandler->incPathsExplored();
    
    std::set<ExecutionState*>::iterator it = addedStates.find(&state);
    if (it==addedStates.end())
    {
	    state.pc = state.prevPC;
	    removedStates.insert(&state);
    }
    else
    {
	    // never reached searcher, just delete immediately
	    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it3 =
        seedMap.find(&state);
	    if (it3 != seedMap.end())
        seedMap.erase(it3);
	    addedStates.erase(it);
	    processTree->remove(state.ptreeNode);
	    delete &state;
    }
    
    stateTerminate = true;
    std::cerr<<"Thread "<<state.getThreadName()<< " " << &state << " terminated. Flush Constraint Trace\n"; //***
    endTime = clock();
    std::cerr << "Elapsed Time: " << stringValueOf(endTime-beginTime)/*/(double) CLOCKS_PER_SEC*/ << "s\n";
    std::cerr<< "------------------\n";
	gState->deleteState(intValueOf(state.getThreadName()));
}

void Executor::terminateState(ExecutionState &state) {
  if (replayOut && replayPosition!=replayOut->numObjects) {
    klee_warning_once(replayOut, 
                      "replay did not consume all objects in test input.");
  }

  interpreterHandler->incPathsExplored();

  std::set<ExecutionState*>::iterator it = addedStates.find(&state);
  if (it==addedStates.end()) {
    state.pc = state.prevPC;

    removedStates.insert(&state);
  } else {
    // never reached searcher, just delete immediately
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it3 = 
      seedMap.find(&state);
    if (it3 != seedMap.end())
      seedMap.erase(it3);
    addedStates.erase(it);
    processTree->remove(state.ptreeNode);
    delete &state;
  }
   
  stateTerminate = true;
}

void Executor::terminateStateEarly(ExecutionState &state, 
                                   const Twine &message) {
  if (!OnlyOutputStatesCoveringNew || state.coveredNew ||
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, (message + "\n").str().c_str(),
                                        "early");
    
    std::cerr << "[" << state.getThreadName() << "] terminateStateEarly ----- \n";
    
    terminateState(state);
}

void Executor::terminateStateOnExit(ExecutionState &state) {
  if (!OnlyOutputStatesCoveringNew || state.coveredNew || 
      (AlwaysOutputSeeds && seedMap.count(&state)))
    interpreterHandler->processTestCase(state, 0, 0);

    std::cerr << "[" << state.getThreadName() << "] terminateStateOnExit ----- \n";
 
    
  terminateStateCLAPWithConstraints(state);
}

void Executor::terminateStateOnError(ExecutionState &state,
                                     const llvm::Twine &messaget,
                                     const char *suffix,
                                     const llvm::Twine &info) {
  std::string message = messaget.str();
  static std::set< std::pair<Instruction*, std::string> > emittedErrors;
  const InstructionInfo &ii = *state.prevPC->info;
  
    std::cerr << "[" << state.getThreadName() << "] terminateStateOnError ----- state "<< state.stateId <<"@"<< ii.line <<"\n";
    
  if (EmitAllErrors ||
      emittedErrors.insert(std::make_pair(state.prevPC->inst, message)).second) {
    if (ii.file != "") {
      klee_message("ERROR: %s:%d: %s", ii.file.c_str(), ii.line, message.c_str());
    } else {
      klee_message("ERROR: %s", message.c_str());
    }
    if (!EmitAllErrors)
      klee_message("NOTE: now ignoring this error at this location");
    
    std::ostringstream msg;
    msg << "Error: " << message << "\n";
    if (ii.file != "") {
      msg << "File: " << ii.file << "\n";
      msg << "Line: " << ii.line << "\n";
    }
    msg << "Stack: \n";
    state.dumpStack(msg);

    std::string info_str = info.str();
    if (info_str != "")
      msg << "Info: \n" << info_str;
    interpreterHandler->processTestCase(state, msg.str().c_str(), suffix);
  }

  if (message.find("ASSERTION FAIL") != std::string::npos || 
          message.find("divide by zero") != std::string::npos) {
	terminateStateCLAPWithConstraints(state);
  }
}

// XXX shoot me
static const char *okExternalsList[] = { "printf", 
                                         "fprintf", 
                                         "puts",
                                         "getpid" };
static std::set<std::string> okExternals(okExternalsList,
                                         okExternalsList + 
                                         (sizeof(okExternalsList)/sizeof(okExternalsList[0])));

void Executor::callExternalFunction(ExecutionState &state,
                                    KInstruction *target,
                                    Function *function,
                                    std::vector< ref<Expr> > &arguments) {

  // check if specialFunctionHandler wants it
  if (specialFunctionHandler->handle(state, function, target, arguments)) { //std::cout << "handle!\n";
    return;
  }
  
  if (NoExternals && !okExternals.count(function->getName())) {
    std::cerr << "KLEE:ERROR: Calling not-OK external function : " 
              << function->getName().str() << "\n";
    terminateStateOnError(state, "externals disallowed", "user.err");
    return;
  }

  // normal external function handling path
  // allocate 128 bits for each argument (+return value) to support fp80's;
  // we could iterate through all the arguments first and determine the exact
  // size we need, but this is faster, and the memory usage isn't significant.
  uint64_t *args = (uint64_t*) alloca(2*sizeof(*args) * (arguments.size() + 1));
  memset(args, 0, 2 * sizeof(*args) * (arguments.size() + 1));
  unsigned wordIndex = 2;
  for (std::vector<ref<Expr> >::iterator ai = arguments.begin(), 
       ae = arguments.end(); ai!=ae; ++ai) {
    if (AllowExternalSymCalls) { // don't bother checking uniqueness
      ref<ConstantExpr> ce;
      bool success = solver->getValue(state, *ai, ce);
      assert(success && "FIXME: Unhandled solver failure");
      (void) success;
      ce->toMemory(&args[wordIndex]);
      wordIndex += (ce->getWidth()+63)/64;
    } else {
      ref<Expr> arg = toUnique(state, *ai);
      if (ConstantExpr *ce = dyn_cast<ConstantExpr>(arg)) {
        // XXX kick toMemory functions from here
        ce->toMemory(&args[wordIndex]);
        wordIndex += (ce->getWidth()+63)/64;
      } else {

    	  std::ostringstream os;
    	  os <<arg<<"\n";

    	  terminateStateOnExecError(state,
                                  "external call with symbolic argument: " + function->getName()+" -- "+os.str());



        return;
      }
    }
  }

  state.addressSpace.copyOutConcretes();

  if (!SuppressExternalWarnings) {
    std::ostringstream os;
    os << "calling external: " << function->getName().str() << "(";
    for (unsigned i=0; i<arguments.size(); i++) {
      os << arguments[i];
      if (i != arguments.size()-1)
	os << ", ";
    }
    os << ")";
    
    if (AllExternalWarnings)
      klee_warning("%s", os.str().c_str());
    else
      klee_warning_once(function, "%s", os.str().c_str());
  }
  bool success = externalDispatcher->executeCall(function, target->inst, args);
  if (!success) {
    terminateStateOnError(state, "failed external call: " + function->getName(),
                          "external.err");
    return;
  }

  state.addressSpace.copyInConcretes();

  LLVM_TYPE_Q Type *resultType = target->inst->getType();
  if (resultType != Type::getVoidTy(getGlobalContext())) {
    ref<Expr> e = ConstantExpr::fromMemory((void*) args, 
                                           getWidthForLLVMType(resultType));
    bindLocal(target, state, e, e);
  }
}

/***/

ref<Expr> Executor::replaceReadWithSymbolic(ExecutionState &state, 
                                            ref<Expr> e) {
  unsigned n = interpreterOpts.MakeConcreteSymbolic;
  if (!n || replayOut || replayPath)
    return e;

  // right now, we don't replace symbolics (is there any reason too?)
  if (!isa<ConstantExpr>(e))
    return e;

  if (n != 1 && random() %  n)
    return e;

  // create a new fresh location, assert it is equal to concrete value in e
  // and return it.
  
  static unsigned id;
  const Array *array = new Array("rrws_arr" + llvm::utostr(++id), 
                                 Expr::getMinBytesForWidth(e->getWidth()));
  ref<Expr> res = Expr::createTempRead(array, e->getWidth());
  ref<Expr> eq = NotOptimizedExpr::create(EqExpr::create(e, res));
  state.addConstraint(eq);
  return res;
}

ObjectState *Executor::bindObjectInState(ExecutionState &state, 
                                         const MemoryObject *mo,
                                         bool isLocal,
                                         const Array *array) {
  ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
  state.addressSpace.bindObject(mo, os);

  // Its possible that multiple bindings of the same mo in the state
  // will put multiple copies on this list, but it doesn't really
  // matter because all we use this list for is to unbind the object
  // on function return.
  if (isLocal)
    state.stack.back().allocas.push_back(mo);

  return os;
}

void Executor::executeAlloc(ExecutionState &state,
                            ref<Expr> size,
                            bool isLocal,
                            KInstruction *target,
                            bool zeroMemory,
                            const ObjectState *reallocFrom) {
  size = toUnique(state, size);
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(size)) {
    MemoryObject *mo = memory->allocate(CE->getZExtValue(), isLocal, !isLocal, 
                                        state.prevPC->inst); // yqp
    if (!mo) {
      bindLocal(target, state, 
                ConstantExpr::alloc(0, Context::get().getPointerWidth()),
				ConstantExpr::alloc(0, Context::get().getPointerWidth()));
    } else {
	  // make sure the malloc/calloc memory can be accessed by all threads!
	  if (target->inst->getOpcode() == Instruction::Call) { 
		  mallocAddresses.insert(mo->getBaseExpr());
		  mo->isGlobal = true;
	  }

      ObjectState *os = bindObjectInState(state, mo, isLocal);
      if (zeroMemory) {
        os->initializeToZero();
      } else {
        os->initializeToRandom();
      }
      bindLocal(target, state, mo->getBaseExpr(), mo->getBaseExpr());
      
      if (reallocFrom) {
        unsigned count = std::min(reallocFrom->size, os->size);
        for (unsigned i=0; i<count; i++)
          os->write(i, reallocFrom->read8(i));
        state.addressSpace.unbindObject(reallocFrom->getObject());
      }
    }
  } else {
    // XXX For now we just pick a size. Ideally we would support
    // symbolic sizes fully but even if we don't it would be better to
    // "smartly" pick a value, for example we could fork and pick the
    // min and max values and perhaps some intermediate (reasonable
    // value).
    // 
    // It would also be nice to recognize the case when size has
    // exactly two values and just fork (but we need to get rid of
    // return argument first). This shows up in pcre when llvm
    // collapses the size expression with a select.

    ref<ConstantExpr> example;
    bool success = solver->getValue(state, size, example);
    assert(success && "FIXME: Unhandled solver failure");
    (void) success;
    
    // Try and start with a small example.
    Expr::Width W = example->getWidth();
    while (example->Ugt(ConstantExpr::alloc(128, W))->isTrue()) {
      ref<ConstantExpr> tmp = example->LShr(ConstantExpr::alloc(1, W));
      bool res;
      bool success = solver->mayBeTrue(state, EqExpr::create(tmp, size), res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (!res)
        break;
      example = tmp;
    }

    StatePair fixedSize = fork(state, EqExpr::create(example, size), EqExpr::create(example, size), true);
    
    if (fixedSize.second) { 
      // Check for exactly two values
      ref<ConstantExpr> tmp;
      bool success = solver->getValue(*fixedSize.second, size, tmp);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      bool res;
      success = solver->mustBeTrue(*fixedSize.second, 
                                   EqExpr::create(tmp, size),
                                   res);
      assert(success && "FIXME: Unhandled solver failure");      
      (void) success;
      if (res) {
        executeAlloc(*fixedSize.second, tmp, isLocal,
                     target, zeroMemory, reallocFrom);
      } else {
        // See if a *really* big value is possible. If so assume
        // malloc will fail for it, so lets fork and return 0.
        StatePair hugeSize = 
          fork(*fixedSize.second, 
					  UltExpr::create(ConstantExpr::alloc(1<<31, W), size), 
						  UltExpr::create(ConstantExpr::alloc(1<<31, W), size), 
						  true);
        if (hugeSize.first) {
          klee_message("NOTE: found huge malloc, returning 0");
          bindLocal(target, *hugeSize.first, 
                    ConstantExpr::alloc(0, Context::get().getPointerWidth()),
					ConstantExpr::alloc(0, Context::get().getPointerWidth()));
        }
        
        if (hugeSize.second) {
          std::ostringstream info;
          ExprPPrinter::printOne(info, "  size expr", size);
          info << "  concretization : " << example << "\n";
          info << "  unbound example: " << tmp << "\n";
          terminateStateOnError(*hugeSize.second, 
                                "concretized symbolic size", 
                                "model.err", 
                                info.str());
        }
      }
    }

    if (fixedSize.first) // can be zero when fork fails
      executeAlloc(*fixedSize.first, example, isLocal, 
                   target, zeroMemory, reallocFrom);
  }
}

void Executor::executeFree(ExecutionState &state,
                           ref<Expr> address,
                           KInstruction *target) {
  StatePair zeroPointer = fork(state, Expr::createIsZero(address), Expr::createIsZero(address), true);
  if (zeroPointer.first) {
    if (target)
      bindLocal(target, *zeroPointer.first, Expr::createPointer(0), Expr::createPointer(0));
  }
  if (zeroPointer.second) { // address != 0
    ExactResolutionList rl;
    resolveExact(*zeroPointer.second, address, rl, "free");
    
    for (Executor::ExactResolutionList::iterator it = rl.begin(), 
           ie = rl.end(); it != ie; ++it) {
      const MemoryObject *mo = it->first.first;
      if (mo->isLocal) {
        terminateStateOnError(*it->second, 
                              "free of alloca", 
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else if (mo->isGlobal) {
        terminateStateOnError(*it->second, 
                              "free of global", 
                              "free.err",
                              getAddressInfo(*it->second, address));
      } else {
        it->second->addressSpace.unbindObject(mo);
        if (target)
          bindLocal(target, *it->second, Expr::createPointer(0), Expr::createPointer(0));
      }
    }
  }
}

void Executor::resolveExact(ExecutionState &state,
                            ref<Expr> p,
                            ExactResolutionList &results, 
                            const std::string &name) {
  // XXX we may want to be capping this?
  ResolutionList rl;
  state.addressSpace.resolve(state, solver, p, rl);
  
  ExecutionState *unbound = &state;
  for (ResolutionList::iterator it = rl.begin(), ie = rl.end(); 
       it != ie; ++it) {
    ref<Expr> inBounds = EqExpr::create(p, it->first->getBaseExpr());
    
    StatePair branches = fork(*unbound, inBounds, inBounds, true);
    
    if (branches.first)
      results.push_back(std::make_pair(*it, branches.first));

    unbound = branches.second;
    if (!unbound) // Fork failure
      break;
  }

  if (unbound) {
    terminateStateOnError(*unbound,
                          "memory error: invalid pointer: " + name,
                          "ptr.err",
                          getAddressInfo(*unbound, p));
  }
}

ref<Expr> Executor::getValueFrom(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */) {


	Expr::Width type;
	if(isWrite && value.isNull())
	{
		std::cerr << "\t["<<state.getThreadName()<<"] executeMemoryOperation: isWrite and value is null -> set value = 0\n";
		value = ConstantExpr::create(0, 32); //create value zero
		type = value->getWidth();
	}
	else
	{
		type = (isWrite ? value->getWidth() :
					getWidthForLLVMType(target->inst->getType()));
	}
	unsigned bytes = Expr::getMinBytesForWidth(type);

	if (SimplifySymIndices) {
		if (!isa<ConstantExpr>(address))
		  address = state.constraints.simplifyExpr(address);

		if (isWrite && !isa<ConstantExpr>(value))
		  value = state.constraints.simplifyExpr(value);
	}

	// fast path: single in-bounds resolution
	ObjectPair op;
	bool success;
	solver->setTimeout(stpTimeout);
	if (!state.addressSpace.resolveOne(state, solver, address, op, success)) {
		address = toConstant(state, address, "resolveOne failure");
		success = state.addressSpace.resolveOne(cast<ConstantExpr>(address), op);
	}
	solver->setTimeout(0);

	if (success) {
		const MemoryObject *mo = op.first;

		if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
			address = toConstant(state, address, "max-sym-array-size");
		}

		ref<Expr> offset = mo->getOffsetExpr(address);

		bool inBounds;
		solver->setTimeout(stpTimeout);
		bool success = solver->mustBeTrue(state, 
					mo->getBoundsCheckOffset(offset, bytes),
					inBounds);
		solver->setTimeout(0);
		if (!success) {
			state.pc = state.prevPC;
			terminateStateEarly(state, "query timed out");
			assert(0);
			return 0;
		}

		if (inBounds) {
			const ObjectState *os = op.second;
			if (isWrite) {
				if (os->readOnly) {
					terminateStateOnError(state,
								"memory error: object read only",
								"readonly.err");
				} else {
					ObjectState *wos = state.addressSpace.getWriteable(mo, os);
					wos->write(offset, value);
				}          
			} else {
				ref<Expr> result = os->read(offset, type);

				if (interpreterOpts.MakeConcreteSymbolic) {
					result = replaceReadWithSymbolic(state, result);
				}

				return result;
			}

			assert(0);
			return 0;
		}
	} 
	
	if (addressToValue.find(address) != addressToValue.end()) {
		ref<Expr> result = addressToValue[address].first;
		return result;
	} else if (state.addressToValue.find(address) != state.addressToValue.end()) {
		return state.addressToValue[address].first;
	}

	// we are on an error path (no resolution, multiple resolution, one
	// resolution with out of bounds)

	ResolutionList rl;  
	solver->setTimeout(stpTimeout);
	bool incomplete = state.addressSpace.resolve(state, solver, address, rl,
				0, stpTimeout);
	solver->setTimeout(0);

	// XXX there is some query wasteage here. who cares?
	ExecutionState *unbound = &state;

	for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
		const MemoryObject *mo = i->first;

		bool isCorrectMemObj = false;

		if(address==mo->getBaseExpr())
		  isCorrectMemObj = true;
		else if(address->getKind()==Expr::Add
					&&address->getKid(0)==mo->getBaseExpr())
		  isCorrectMemObj = true;

		if(isCorrectMemObj)
		{

			const ObjectState *os = i->second;

			if (isWrite) {
				if (os->readOnly) {
					terminateStateOnError(state,
								"memory error: object read only",
								"readonly.err");
				} else {
					ObjectState *wos = state.addressSpace.getWriteable(mo, os);
					wos->write(mo->getOffsetExpr(address), value);
				}
			} else {
				ref<Expr> result = os->read(mo->getOffsetExpr(address), type);
				return result;
			}

			break;
		}

		if (!unbound)
		  break;
	}
	
	terminateStateOnError(*unbound,
				"memory error: out of bound pointer",
				"ptr.err",
				getAddressInfo(*unbound, address));
	
	terminateStateCLAPWithConstraints(state);
	return 0;
}


/*
 * CAREFULLY ADDRESS THIS FUNCTION
 */
ref<Expr> lastResult;
void Executor::executeMemoryOperation(ExecutionState &state,
                                      bool isWrite,
                                      ref<Expr> address,
                                      ref<Expr> value /* undef if read */,
                                      KInstruction *target /* undef if write */) {

    Expr::Width type;
    if(isWrite && value.isNull())
    {
        std::cerr << "\t["<<state.getThreadName()<<"] executeMemoryOperation: isWrite and value is null -> set value = 0\n";
        value = ConstantExpr::create(0, 32); //create value zero
        type = value->getWidth();
    }
    else
    {
        type = (isWrite ? value->getWidth() :
                            getWidthForLLVMType(target->inst->getType()));
    }
  unsigned bytes = Expr::getMinBytesForWidth(type);

  if (SimplifySymIndices) {
    if (!isa<ConstantExpr>(address))
      address = state.constraints.simplifyExpr(address);
  
    if (isWrite && !isa<ConstantExpr>(value))
      value = state.constraints.simplifyExpr(value);
  }

  // fast path: single in-bounds resolution
  ObjectPair op;
  bool success;
  solver->setTimeout(stpTimeout);
  if (!state.addressSpace.resolveOne(state, solver, address, op, success)) {
    address = toConstant(state, address, "resolveOne failure");
    success = state.addressSpace.resolveOne(cast<ConstantExpr>(address), op);
  }
  solver->setTimeout(0);

  if (success) {
    const MemoryObject *mo = op.first;

    if (MaxSymArraySize && mo->size>=MaxSymArraySize) {
      address = toConstant(state, address, "max-sym-array-size");
    }

    ref<Expr> offset = mo->getOffsetExpr(address);

    bool inBounds;
    solver->setTimeout(stpTimeout);
    bool success = solver->mustBeTrue(state, 
                                      mo->getBoundsCheckOffset(offset, bytes),
                                      inBounds);
    solver->setTimeout(0);
    if (!success) {
      state.pc = state.prevPC;
      terminateStateEarly(state, "query timed out");
      return;
    }

    if (inBounds) {
      const ObjectState *os = op.second;
      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(state,
                                "memory error: object read only",
                                "readonly.err");
        } else {
          ObjectState *wos = state.addressSpace.getWriteable(mo, os);
          wos->write(offset, value);
		  
		  ref<Expr> result = os->read(offset, type);
		  result = wos->read(offset, type);
        }          
      } else {
        ref<Expr> result = os->read(offset, type);
        
        if (interpreterOpts.MakeConcreteSymbolic) {
			result = replaceReadWithSymbolic(state, result);
		}

		lastResult = result;
		
		if (controlStr != "") {
			int offInt = dyn_cast<ConstantExpr>(offset)->getZExtValue();

			ref<Expr> concValue = getInitValue(state, address, target, controlStr, offInt, result->getWidth());
			if (concValue.isNull() == false)
				return ;
			
		}

		if (value.isNull())
		    value = result;
		bindLocal(target, state, result, value);
      }

      return;
    }
  }

  if (!isWrite && state.addressToValue.find(address) != state.addressToValue.end()) {
	ref<Expr> result = state.addressToValue[address].first;
	ref<Expr> result1 = state.addressToValue[address].second;
	bindLocal(target, state, result, result1);
	return;
  } else if (!isWrite && addressToValue.find(address) != addressToValue.end()) {
	ref<Expr> result = addressToValue[address].first;
	ref<Expr> result1 = addressToValue[address].second;
	bindLocal(target, state, result, result1);
	return;
  }

  // we are on an error path (no resolution, multiple resolution, one
  // resolution with out of bounds)

  ResolutionList rl;  
  solver->setTimeout(stpTimeout);
  bool incomplete = state.addressSpace.resolve(state, solver, address, rl,
                                               0, stpTimeout);
  solver->setTimeout(0);
  
  // XXX there is some query wasteage here. who cares?
  ExecutionState *unbound = &state;
  
  for (ResolutionList::iterator i = rl.begin(), ie = rl.end(); i != ie; ++i) {
    const MemoryObject *mo = i->first;

    bool isCorrectMemObj = false;

	if(address==mo->getBaseExpr())
		isCorrectMemObj = true;
	else if(address->getKind()==Expr::Add
			&&address->getKid(0)==mo->getBaseExpr())
		isCorrectMemObj = true;

	if(isCorrectMemObj)
	{

    const ObjectState *os = i->second;

      if (isWrite) {
        if (os->readOnly) {
          terminateStateOnError(state,
                                "memory error: object read only",
                                "readonly.err");
        } else {
          ObjectState *wos = state.addressSpace.getWriteable(mo, os);
          wos->write(mo->getOffsetExpr(address), value);
        }
      } else {
        ref<Expr> result = os->read(mo->getOffsetExpr(address), type);
        bindLocal(target, state, result, value);
      }

    break;
    }

    if (!unbound)
      break;
  }
  
  // XXX should we distinguish out of bounds and overlapped cases?
  if (unbound) {
    if (incomplete) {
      terminateStateEarly(*unbound, "query timed out (resolve)");
    } else {
    	//Jeff: aget error (data structure in external calls)-- commented out
/*
      terminateStateOnError(*unbound,
                            "memory error: out of bound pointer",
                            "ptr.err",
                            getAddressInfo(*unbound, address));
*/
    	//Don't terminate the state, but may segfault later

//    	std::string message = "memory error: out of bound pointer";
//    	  const InstructionInfo &ii = *state.prevPC->info;
//
//    	    if (ii.file != "") {
//    	      klee_message("ERROR: %s:%d: %s", ii.file.c_str(), ii.line, message.c_str());
//    	    } else {
//    	      klee_message("ERROR: %s", message.c_str());
//    	    }

//    	    printFileLine(state, state.pc);
//    	    std::cerr << std::setw(10) << stats::instructions << " ";
//    	    llvm::errs() << *(state.pc->inst) <<"\n";
    }
  }
}

std::string Executor::getUniqueName(ExecutionState &state,
                                   const MemoryObject *mo,
                                   const std::string &name,
                                   std::string &addrstr) {

	std::string uniqueName;//objectname+threadname+index

	std::string uname = name +"_"+addrstr;
	unsigned id = state.arrayNames[uname];
	if(id>0) {
		std::stringstream ss;
		ss << id;
		uniqueName = uname+"-" +state.getThreadName()+"-"+ss.str();
	} else {
		uniqueName = uname+"-" +state.getThreadName()+"-0";
	}
	return uniqueName;
}

std::pair<std::string, ref<Expr> > Executor::executeMakeSymbolic_yqp(ExecutionState &state,
                                   const MemoryObject *mo,
                                   const std::string &name,
                                   std::string &addrstr,
								   KInstruction* target) {
	std::string name2;
	if (varaddrnamemap.find(mo->getBaseExpr()) != varaddrnamemap.end()) {
	    name2 = varaddrnamemap[mo->getBaseExpr()].first;
		if (name2 == "")
		  name2 = getContextStr(state, name);
	} else if (state.varaddrnamemap.find(mo->getBaseExpr()) != state.varaddrnamemap.end()) {
		name2 = state.varaddrnamemap[mo->getBaseExpr()].first;
		if (name2 == "")
		  name2 = getContextStr(state, name);
	} else {
		name2 = getContextStr(state, name);
	}
	
	std::string uniqueName;//objectname+threadname+index

	std::string uname = name2 + name +"_"+addrstr;

	unsigned id = state.arrayNames[uname];
	if(id>0)
	{
		std::stringstream ss;
		ss << id;
		uniqueName = uname+"-" +state.getThreadName()+"-"+ss.str();

		state.arrayNames[uname] = ++id;
	}
	else
	{
		uniqueName = uname+"-" +state.getThreadName()+"-0";
        state.arrayNames[uname]=1;

		if (mo->isGlobal || mallocAddresses.find(mo->getBaseExpr()) !=
						  mallocAddresses.end()) { 
			varaddrnamemap[mo->getBaseExpr()]=std::make_pair(name2, name);
		} else {
		  state.varaddrnamemap[mo->getBaseExpr()]=std::make_pair(name2, name);
		}
	}

	const Array *array = new Array(uniqueName, mo->size);
	
    ObjectState *os = array ? new ObjectState(mo, array) : new ObjectState(mo);
    ref<Expr> offset = mo->getOffsetExpr(mo->getBaseExpr());
	vector<int> offsets, sizes;
	
	Expr::Width type = mo->size * 8; 
	if (target->inst->getOpcode() == Instruction::Load)
	    type = getWidthForLLVMType(target->inst->getType());
	
	ref<Expr> result = os->read(offset, type);
	
	for (int i = 0; i< offsets.size(); ++i) {
		int off = offsets[i];
		off = off;// + cast<ConstantExpr>(offset)->getZExtValue();
		ref<Expr> offs = ConstantExpr::alloc(off, Expr::Int32);
		ref<Expr> result = os->read(offs, sizes[i]);
	}

	delete os;

	return std::make_pair(uniqueName, result);
}


std::string Executor::executeMakeSymbolic(ExecutionState &state,
                                   const MemoryObject *mo,
                                   const std::string &name,
                                   std::string &addrstr) {

	std::string name2;
	if (varaddrnamemap.find(mo->getBaseExpr()) != varaddrnamemap.end()) {
	    name2 = varaddrnamemap[mo->getBaseExpr()].first;
		if (name2 == "")
		  name2 = getContextStr(state, name);
	} else if (state.varaddrnamemap.find(mo->getBaseExpr()) != state.varaddrnamemap.end()) {
		name2 = state.varaddrnamemap[mo->getBaseExpr()].first;
		if (name2 == "")
		  name2 = getContextStr(state, name);
	} else {
		name2 = getContextStr(state, name);
	}


	std::string uniqueName;//objectname+threadname+index

	// Create a new object state for the memory object (instead of a copy).
  if (!replayOut) {
    // Find a unique name for this array.  First try the original name,
    // or if that fails try adding a unique identifier.

	  std::string uname = name2+name +"_"+addrstr;

	  unsigned id = state.arrayNames[uname];
	  if(id>0)
	  {
		  std::stringstream ss;
		  ss << id;
		  uniqueName = uname+"-" +state.getThreadName()+"-"+ss.str();

		  state.arrayNames[uname] = ++id;
	  }
	  else
	  {
		  uniqueName = uname+"-" +state.getThreadName()+"-0";
		  state.arrayNames[uname]=1;

		  if (mo->isGlobal || mallocAddresses.find(mo->getBaseExpr()) !=
						  mallocAddresses.end())
			varaddrnamemap[mo->getBaseExpr()]=std::make_pair(name2, name);
		  else
			state.varaddrnamemap[mo->getBaseExpr()]=std::make_pair(name2, name);
		  
	  }


    const Array *array = new Array(uniqueName, mo->size);
    bindObjectInState(state, mo, false, array);
    state.addSymbolic(mo, array);
    
    std::map< ExecutionState*, std::vector<SeedInfo> >::iterator it = 
      seedMap.find(&state);
    if (it!=seedMap.end()) { // In seed mode we need to add this as a
                             // binding.
      for (std::vector<SeedInfo>::iterator siit = it->second.begin(), 
             siie = it->second.end(); siit != siie; ++siit) {
        SeedInfo &si = *siit;
        KTestObject *obj = si.getNextInput(mo, NamedSeedMatching);

        if (!obj) {
          if (ZeroSeedExtension) {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values = std::vector<unsigned char>(mo->size, '\0');
          } else if (!AllowSeedExtension) {
            terminateStateOnError(state, 
                                  "ran out of inputs during seeding",
                                  "user.err");
            break;
          }
		} else {
			if (obj->numBytes != mo->size &&
						((!(AllowSeedExtension || ZeroSeedExtension)
						  && obj->numBytes < mo->size) ||
						 (!AllowSeedTruncation && obj->numBytes > mo->size))) {
				std::stringstream msg;
				msg << "replace size mismatch: "
					<< mo->name << "[" << mo->size << "]"
					<< " vs " << obj->name << "[" << obj->numBytes << "]"
					<< " in test\n";

				terminateStateOnError(state,
							msg.str(),
							"user.err");
            break;
          } else {
            std::vector<unsigned char> &values = si.assignment.bindings[array];
            values.insert(values.begin(), obj->bytes, 
                          obj->bytes + std::min(obj->numBytes, mo->size));
            if (ZeroSeedExtension) {
              for (unsigned i=obj->numBytes; i<mo->size; ++i)
                values.push_back('\0');
            }
          }
        }
      }
    }
  } else {
    ObjectState *os = bindObjectInState(state, mo, false);
    if (replayPosition >= replayOut->numObjects) {
      terminateStateOnError(state, "replay count mismatch", "user.err");
    } else {
      KTestObject *obj = &replayOut->objects[replayPosition++];
      if (obj->numBytes != mo->size) {
        terminateStateOnError(state, "replay size mismatch", "user.err");
      } else {
        for (unsigned i=0; i<mo->size; i++)
          os->write8(i, obj->bytes[i]);
      }
    }
  }

  return uniqueName;
}

/***/

void Executor::runFunctionAsMain(Function *f,
				 int argc,
				 char **argv,
				 char **envp) {
  std::vector<ref<Expr> > arguments;

  gettimeofday(&startday, NULL);
  // force deterministic initialization of memory objects
  srand(1);
  srandom(1);
  
  MemoryObject *argvMO = 0;

  beginTime = clock(); //Nuno: start timestampt
    
  // In order to make uclibc happy and be closer to what the system is
  // doing we lay out the environments at the end of the argv array
  // (both are terminated by a null). There is also a final terminating
  // null that uclibc seems to expect, possibly the ELF header?

  int envc;
  for (envc=0; envp[envc]; ++envc) ;

  unsigned NumPtrBytes = Context::get().getPointerWidth() / 8;
  KFunction *kf = kmodule->functionMap[f];
  assert(kf);
  Function::arg_iterator ai = f->arg_begin(), ae = f->arg_end();
  if (ai!=ae) {
    arguments.push_back(ConstantExpr::alloc(argc, Expr::Int32));

    if (++ai!=ae) {
      argvMO = memory->allocate((argc+1+envc+1+1) * NumPtrBytes, false, true,
                                f->begin()->begin());
      
      arguments.push_back(argvMO->getBaseExpr());

      if (++ai!=ae) {
        uint64_t envp_start = argvMO->address + (argc+1)*NumPtrBytes;
        arguments.push_back(Expr::createPointer(envp_start));

        if (++ai!=ae)
          klee_error("invalid main function (expect 0-3 arguments)");
      }
    }
  }

  ExecutionState *state = new ExecutionState(kmodule->functionMap[f]);
  
  if (pathWriter) 
    state->pathOS = pathWriter->open();
  if (symPathWriter) 
    state->symPathOS = symPathWriter->open();


  if (statsTracker)
    statsTracker->framePushed(*state, 0);

  assert(arguments.size() == f->arg_size() && "wrong number of arguments");
  for (unsigned i = 0, e = f->arg_size(); i != e; ++i)
    bindArgument(kf, i, *state, arguments[i]);

  if (argvMO) {
    ObjectState *argvOS = bindObjectInState(*state, argvMO, false);

    for (int i=0; i<argc+1+envc+1+1; i++) {
      MemoryObject *arg;
      
      if (i==argc || i>=argc+1+envc) {
        arg = 0;
      } else {
        char *s = i<argc ? argv[i] : envp[i-(argc+1)];
        int j, len = strlen(s);
        
        arg = memory->allocate(len+1, false, true, state->pc->inst);
        ObjectState *os = bindObjectInState(*state, arg, false);
        for (j=0; j<len+1; j++)
          os->write8(j, s[j]);
      }

      if (arg) {
        argvOS->write(i * NumPtrBytes, arg->getBaseExpr());
      } else {
        argvOS->write(i * NumPtrBytes, Expr::createPointer(0));
      }
    }
  }
  
  initializeGlobals(*state);
  
  processTree = new PTree(state);
  state->ptreeNode = processTree->root;
  run2(*state);
  
  struct timeval endday;
  gettimeofday(&endday, NULL);
  int timeuse = 1000000 * ( endday.tv_sec - startday.tv_sec ) + 
	  endday.tv_usec - startday.tv_usec;
}

unsigned Executor::getPathStreamID(const ExecutionState &state) {
  assert(pathWriter);
  return state.pathOS.getID();
}

unsigned Executor::getSymbolicPathStreamID(const ExecutionState &state) {
  assert(symPathWriter);
  return state.symPathOS.getID();
}

void Executor::getConstraintLog(const ExecutionState &state,
                                std::string &res,
                                bool asCVC) {
  if (asCVC) {
    Query query(state.constraints, ConstantExpr::alloc(0, Expr::Bool));
    char *log = solver->stpSolver->getConstraintLog(query);
    res = std::string(log);
    free(log);
  } else {
    std::ostringstream info;
    ExprPPrinter::printConstraints(info, state.constraints);
    res = info.str();    
  }
}

bool Executor::getSymbolicSolution(const ExecutionState &state,
                                   std::vector< 
                                   std::pair<std::string,
                                   std::vector<unsigned char> > >
                                   &res) {
  solver->setTimeout(stpTimeout);

  ExecutionState tmp(state);
  if (!NoPreferCex) {

	  //std::cerr << "Jeff: !NoPreferCex\n";

	  for (unsigned i = 0; i != state.symbolics.size(); ++i) {
      const MemoryObject *mo = state.symbolics[i].first;
      std::vector< ref<Expr> >::const_iterator pi = 
        mo->cexPreferences.begin(), pie = mo->cexPreferences.end();
      for (; pi != pie; ++pi) {
        bool mustBeTrue;
        bool success = solver->mustBeTrue(tmp, Expr::createIsZero(*pi), 
                                          mustBeTrue);
        if (!success) break;
        if (!mustBeTrue) tmp.addConstraint(*pi);
      }
      if (pi!=pie) break;
    }
  }

  std::vector< std::vector<unsigned char> > values;
  std::vector<const Array*> objects;
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    objects.push_back(state.symbolics[i].second);
  bool success = solver->getInitialValues(tmp, objects, values);
  solver->setTimeout(0);
  if (!success) {
    klee_warning("unable to compute initial values (invalid constraints?)!");
    ExprPPrinter::printQuery(std::cerr,
                             state.constraints, 
                             ConstantExpr::alloc(0, Expr::Bool));
    return false;
  }
  
  for (unsigned i = 0; i != state.symbolics.size(); ++i)
    res.push_back(std::make_pair(state.symbolics[i].first->name, values[i]));
  return true;
}

void Executor::getCoveredLines(const ExecutionState &state,
                               std::map<const std::string*, std::set<unsigned> > &res) {
  res = state.coveredLines;
}

void Executor::doImpliedValueConcretization(ExecutionState &state,
                                            ref<Expr> e,
                                            ref<ConstantExpr> value) {
  abort(); // FIXME: Broken until we sort out how to do the write back.

  if (DebugCheckForImpliedValues)
    ImpliedValue::checkForImpliedValues(solver->solver, e, value);

  ImpliedValueList results;
  ImpliedValue::getImpliedValues(e, value, results);
  for (ImpliedValueList::iterator it = results.begin(), ie = results.end();
       it != ie; ++it) {
    ReadExpr *re = it->first.get();
    
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(re->index)) {
      // FIXME: This is the sole remaining usage of the Array object
      // variable. Kill me.
      const MemoryObject *mo = 0; //re->updates.root->object;
      const ObjectState *os = state.addressSpace.findObject(mo);

      if (!os) {
        // object has been free'd, no need to concretize (although as
        // in other cases we would like to concretize the outstanding
        // reads, but we have no facility for that yet)
      } else {
        assert(!os->readOnly && 
               "not possible? read only object with static read?");
        ObjectState *wos = state.addressSpace.getWriteable(mo, os);
        wos->write(CE, it->second);
      }
    }
  }
}

Expr::Width Executor::getWidthForLLVMType(LLVM_TYPE_Q llvm::Type *type) const {
  return kmodule->targetData->getTypeSizeInBits(type);
}

Interpreter *Interpreter::create(const InterpreterOptions &opts,
                                 InterpreterHandler *ih) {

	return new Executor(opts, ih);
}

ref<Expr> Executor::getInitValue(ExecutionState &state, ref<Expr> base,
			KInstruction* ki, std::string name, int offInt, Expr::Width width) {

	for (std::map<string, std::map<int, int> >::iterator it2 = inputValues.begin();
				it2 != inputValues.end(); ++it2) {
		if (it2->first.find(name) != string::npos) {
			if (it2->second.find(offInt) != it2->second.end()) { 
				int vv = it2->second[offInt];
				ref<ConstantExpr> newResult;
				if (width == 8 && vv != bits64::truncateToNBits(vv, width)) { // handle char
					vv = 255;
				} 

				if (vv == -1) {
					newResult = ConstantExpr::create(4294967295, width);// Expr::Int64);
				} else {
					newResult = ConstantExpr::create(vv, width);
				}
				  
				executeMemoryOperation(state, true, base, newResult, ki);
				inputValues[it2->first].erase(it2->second.find(offInt));
				return newResult;
			}
		}
	}

	return 0;
}

void Executor::handleSymRetValue(ExecutionState &state, KInstruction* target) {

	Expr::Width type = getWidthForLLVMType(target->inst->getType());
	unsigned bytes = Expr::getMinBytesForWidth(type);

	CallSite cs(target->inst);
	Value *fp = cs.getCalledValue();
	Function *f = getTargetFunction(fp, state);
	state.stack.back().calledNum[f]++;

	MemoryObject *mo;
	mo = memory->allocate(bytes, false, true, target->inst);
	
	std::string funcName = f->getNameStr();
	std::string basevalue;
	if (ConstantExpr *CE = dyn_cast<ConstantExpr>(mo->getBaseExpr())) {
		CE->toString(basevalue);
	}

	basevalue += "*0";

	std::string name = "ret*";
	name += f->getNameStr() + llvm::utostr(state.stack.back().calledNum[f]) + "_";
	std::string uniqueName = executeMakeSymbolic(state, mo, name, basevalue);
	ref<Expr> base = mo->getBaseExpr();
	executeMemoryOperation(state, false, base, 0, target);
	ref<Expr> result = lastResult;
	const InstructionInfo *myinfo = target->info; 

	stringstream linestr;
	linestr << myinfo->line;
	std::string str = "R-" + uniqueName.substr(0, uniqueName.find("__")+1);
	str += "-" + state.getThreadName() + "-0";
	ref<Expr> concValue = getInitValue(state, mo->getBaseExpr(), target, str, 
				0, result->getWidth());
	if (concValue.isNull() ) {
        concValue = ConstantExpr::create(0, result->getWidth());
	}

    bindLocal(target, state, concValue, result);
	state.addressToValue[mo->getBaseExpr()] = std::make_pair(concValue, result);
	std::stringstream ss;
	ss << "R-" << uniqueName;

    state.tmpTrace.append("O" + stringValueOf(currentOrder++) + " " 
            + extractFileBasename(myinfo->file) + "@" + linestr.str() + ":" + ss.str() + "\n");
} 



std::string Executor::getContextStr(ExecutionState &state, const std::string &name) {
    KInstruction *ki = &(*(state.pc));
    std::string name2 = "";
    name2 = "T" + state.getThreadName() + "*";
    StackFrame *pre = &*(state.stack.begin());
    name2 += ki->inst->getParent()->getParent()->getNameStr() + "_";
    return name2;
}

