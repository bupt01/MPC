//===-- SpecialFunctionHandler.cpp ----------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Common.h"

#include "Memory.h"
#include "SpecialFunctionHandler.h"
#include "TimingSolver.h"

#include "klee/ClapUtil.h"

#include "klee/ExecutionState.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"

#include "Executor.h"
#include "MemoryManager.h"

#include "llvm/Module.h"
#include "llvm/User.h"          //Nuno: add
#include "llvm/Instructions.h"  //Nuno: add
#include "llvm/IntrinsicInst.h" //Nuno: add
#include "llvm/ADT/Twine.h"

#include <AvisoUtil.h> //Nuno: add
#include <errno.h>
#include <sstream>
#include <set>

//** CHANGE{
#include <unistd.h>
#include <stdlib.h>
//**CHANGE}

using namespace llvm;
using namespace klee;

/// \todo Almost all of the demands in this file should be replaced
/// with terminateState calls.

extern string Times, Index, Last, Solutions, Trace;
///

struct HandlerInfo {
  const char *name;
  SpecialFunctionHandler::Handler handler;
  bool doesNotReturn; /// Intrinsic terminates the process
  bool hasReturnValue; /// Intrinsic has a return value
  bool doNotOverride; /// Intrinsic should not be used if already defined
};

// FIXME: We are more or less committed to requiring an intrinsic
// library these days. We can move some of this stuff there,
// especially things like realloc which have complicated semantics
// w.r.t. forking. Among other things this makes delayed query
// dispatch easier to implement.
HandlerInfo handlerInfo[] = {
#define add(name, handler, ret) { name, \
                                  &SpecialFunctionHandler::handler, \
                                  false, ret, false }
#define addDNR(name, handler) { name, \
                                &SpecialFunctionHandler::handler, \
                                true, false, false }
  addDNR("__assert_rtn", handleAssertFail),
  addDNR("__assert_fail", handleAssertFail),
  addDNR("_assert", handleAssert),
  addDNR("abort", handleAbort),
  addDNR("_exit", handleExit),
  { "exit", &SpecialFunctionHandler::handleExit, true, false, true },
  addDNR("klee_abort", handleAbort),
  addDNR("klee_silent_exit", handleSilentExit),  
  addDNR("klee_report_error", handleReportError),

  add("calloc", handleCalloc, true),
  add("free", handleFree, false),
  add("klee_assume", handleAssume, false),
  add("klee_check_memory_access", handleCheckMemoryAccess, false),
  add("klee_get_valuef", handleGetValue, true),
  add("klee_get_valued", handleGetValue, true),
  add("klee_get_valuel", handleGetValue, true),
  add("klee_get_valuell", handleGetValue, true),
  add("klee_get_value_i32", handleGetValue, true),
  add("klee_get_value_i64", handleGetValue, true),
  add("klee_define_fixed_object", handleDefineFixedObject, false),
  add("klee_get_obj_size", handleGetObjSize, true),
  add("klee_get_errno", handleGetErrno, true),
  add("klee_is_symbolic", handleIsSymbolic, true),
  add("klee_make_symbolic", handleMakeSymbolic, false),
  add("klee_mark_global", handleMarkGlobal, false),
  add("klee_merge", handleMerge, false),
  add("klee_prefer_cex", handlePreferCex, false),
  add("klee_print_expr", handlePrintExpr, false),
  add("klee_print_range", handlePrintRange, false),
  add("klee_set_forking", handleSetForking, false),
  add("klee_stack_trace", handleStackTrace, false),
  add("klee_warning", handleWarning, false),
  add("klee_warning_once", handleWarningOnce, false),
  add("klee_alias_function", handleAliasFunction, false),
  add("malloc", handleMalloc, true),
  add("realloc", handleRealloc, true),

  add("exit", handleExit0, true), /////////////        
  
  //:CLAP:{
  //myBasicBlockEntry
  add("_Z17myBasicBlockEntryi", handleBasicBlockEntry,false),   //C++ calls
  add("myBasicBlockEntry", handleBasicBlockEntry,false),        //C calls
  add("myAssert", handleMyAssert,false),   //C++ calls
  add("myPThreadCreate", handleMyPThreadCreate,true),        //C calls

  add("_Z17myBeforeMutexLockP23_opaque_pthread_mutex_t",handleBeforeMutexLock,true),
  add("_Z16myAfterMutexLockP23_opaque_pthread_mutex_t",handleAfterMutexLock,true),

  //PThread related handlers
  add("pthread_create", handlePThreadCreate2, true), //** Nuno: set to true
  add("pthread_exit", handleExit, false), // yqp add
  add("pthread_join", handlePThreadJoin, true),
  add("\01_pthread_join", handlePThreadJoin2, false),

  //fork,join,lock,unlock,wait,timedwait,signal,broadcast
  add("pthread_mutex_lock", handlePThreadLock, true),   // changed by yqp
  add("pthread_mutex_unlock", handlePThreadUnlock, true),
  add("pthread_cond_wait", handlePThreadWait, true),            //** Nuno: set to true
  add("pthread_cond_timedwait", handlePThreadTimedwait, true),  //** Nuno: set to true
  add("\01_pthread_cond_timedwait", handlePThreadTimedwait, false),

  add("pthread_cond_signal", handlePThreadSignal, true),        //** Nuno: set to true
  add("pthread_cond_broadcast", handlePThreadBroadcast, false),

  add("pthread_mutex_init", handlePThreadMutexInit, true),
  add("pthread_mutex_destroy", handlePThreadMutexDestroy, true),

  add("pthread_cond_init", handlePThreadCondInit, true),
  add("pthread_cond_destroy", handlePThreadCondDestroy, true),

  add("pthread_attr_init", handlePThreadAttrInit, true),
  add("pthread_attr_destroy", handlePThreadAttrDestroy, true),

  add("pthread_attr_setscope", handlePThreadAttrSetScope, true),
  //:CLAP:}

  // operator delete[](void*)
  add("_ZdaPv", handleDeleteArray, false),
  // operator delete(void*)
  add("_ZdlPv", handleDelete, false),

  // operator new[](unsigned int)
  add("_Znaj", handleNewArray, true),
  // operator new(unsigned int)
  add("_Znwj", handleNew, true),

  // FIXME-64: This is wrong for 64-bit long...

  // operator new[](unsigned long)
  add("_Znam", handleNewArray, true),
  // operator new(unsigned long)
  add("_Znwm", handleNew, true),

#undef addDNR
#undef add  
};

SpecialFunctionHandler::SpecialFunctionHandler(Executor &_executor) 
  : executor(_executor) {}


void SpecialFunctionHandler::prepare() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    // No need to create if the function doesn't exist, since it cannot
    // be called in that case.
  
    if (f && (!hi.doNotOverride || f->isDeclaration())) {
      // Make sure NoReturn attribute is set, for optimization and
      // coverage counting.
      if (hi.doesNotReturn)
        f->addFnAttr(Attribute::NoReturn);

      // Change to a declaration since we handle internally (simplifies
      // module and allows deleting dead code).
      if (!f->isDeclaration())
        f->deleteBody();
    }
  }
}

void SpecialFunctionHandler::bind() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    if (f && (!hi.doNotOverride || f->isDeclaration()))
      handlers[f] = std::make_pair(hi.handler, hi.hasReturnValue);
  }
}


bool SpecialFunctionHandler::handle(ExecutionState &state, 
                                    Function *f,
                                    KInstruction *target,
                                    std::vector< ref<Expr> > &arguments) {
  handlers_ty::iterator it = handlers.find(f);
  if (it != handlers.end()) {    
    Handler h = it->second.first;
    bool hasReturnValue = it->second.second;
     // FIXME: Check this... add test?
    if (!hasReturnValue && !target->inst->use_empty()) {
      executor.terminateStateOnExecError(state, 
                                         "expected return value from void special function");
    } else {
      (this->*h)(state, target, arguments);
    }
    return true;
  } else {
    return false;
  }
}

// reads a concrete string from memory
std::string 
SpecialFunctionHandler::readStringAtAddress(ExecutionState &state, 
                                            ref<Expr> addressExpr) {
  ObjectPair op;
  addressExpr = executor.toUnique(state, addressExpr);
  ref<ConstantExpr> address = cast<ConstantExpr>(addressExpr);
  if (!state.addressSpace.resolveOne(address, op))
    assert(0 && "XXX out of bounds / multiple resolution unhandled");
  bool res;
  assert(executor.solver->mustBeTrue(state, 
                                     EqExpr::create(address, 
                                                    op.first->getBaseExpr()),
                                     res) &&
         res &&
         "XXX interior pointer unhandled");
  const MemoryObject *mo = op.first;
  const ObjectState *os = op.second;

  char *buf = new char[mo->size];

  unsigned i;
  for (i = 0; i < mo->size - 1; i++) {
    ref<Expr> cur = os->read8(i);
    cur = executor.toUnique(state, cur);
    assert(isa<ConstantExpr>(cur) && 
           "hit symbolic char while reading concrete string");
    buf[i] = cast<ConstantExpr>(cur)->getZExtValue(8);
  }
  buf[i] = 0;
  
  std::string result(buf);
  delete[] buf;
  return result;
}

/****/

void SpecialFunctionHandler::handleAbort(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==0 && "invalid number of arguments to abort");

  //XXX:DRE:TAINT
  if(state.underConstrained) {
    std::cerr << "TAINT: skipping abort fail\n";
    executor.terminateState(state);
  } else {
    executor.terminateStateOnError(state, "abort failure", "abort.err");
  }
}

void SpecialFunctionHandler::handleExit(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateStateOnExit(state);
}

void SpecialFunctionHandler::handleSilentExit(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateState(state);
}

void SpecialFunctionHandler::handleAliasFunction(ExecutionState &state,
						 KInstruction *target,
						 std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 && 
         "invalid number of arguments to klee_alias_function");
  std::string old_fn = readStringAtAddress(state, arguments[0]);
  std::string new_fn = readStringAtAddress(state, arguments[1]);
  if (old_fn == new_fn)
    state.removeFnAlias(old_fn);
  else state.addFnAlias(old_fn, new_fn);
}

void SpecialFunctionHandler::handleAssert(ExecutionState &state,
                                          KInstruction *target,
                                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==3 && "invalid number of arguments to _assert");  
  
  //XXX:DRE:TAINT
  if(state.underConstrained) {
    std::cerr << "TAINT: skipping assertion:" 
               << readStringAtAddress(state, arguments[0]) << "\n";
    executor.terminateState(state);
  } else {
    executor.terminateStateOnError(state, 
                                   "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
                                   "assert.err");
  }
}

void SpecialFunctionHandler::handleAssertFail(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to __assert_fail");
  
  //XXX:DRE:TAINT
  if(state.underConstrained) {
    std::cerr << "TAINT: skipping assertion:" 
               << readStringAtAddress(state, arguments[0]) << "\n";
    executor.terminateState(state);
  } else {
    executor.terminateStateOnError(state, 
                                   "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
                                   "assert.err");
  }
}

void SpecialFunctionHandler::handleReportError(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to klee_report_error");
  
  //XXX:DRE:TAINT
  if(state.underConstrained) {
    std::cerr << "TAINT: skipping klee_report_error:"
               << readStringAtAddress(state, arguments[2]) << ":"
               << readStringAtAddress(state, arguments[3]) << "\n";
    executor.terminateState(state);
  } else
    executor.terminateStateOnError(state, 
                                   readStringAtAddress(state, arguments[2]),
                                   readStringAtAddress(state, arguments[3]).c_str());
}

void SpecialFunctionHandler::handleMerge(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  // nop
}

void SpecialFunctionHandler::handleNew(ExecutionState &state,
                         KInstruction *target,
                         std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new");

  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDelete(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // FIXME: Should check proper pairing with allocation type (malloc/free,
  // new/delete, new[]/delete[]).

  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleNewArray(ExecutionState &state,
                              KInstruction *target,
                              std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new[]");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDeleteArray(ExecutionState &state,
                                 KInstruction *target,
                                 std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete[]");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleMalloc(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to malloc");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleAssume(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_assume");
  
  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success = executor.solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    executor.terminateStateOnError(state, 
                                   "invalid klee_assume call (provably false)",
                                   "user.err");
  } else {
    executor.addConstraint(state, e);
  }
}

void SpecialFunctionHandler::handleIsSymbolic(ExecutionState &state,
                                KInstruction *target,
                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_is_symbolic");

  executor.bindLocal(target, state, 
                     ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
                                          Expr::Int32), 
					 ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
                                          Expr::Int32));
}

void SpecialFunctionHandler::handlePreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_prefex_cex");

  ref<Expr> cond = arguments[1];
  if (cond->getWidth() != Expr::Bool)
    cond = NeExpr::create(cond, ConstantExpr::alloc(0, cond->getWidth()));

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "prefex_cex");
  
  assert(rl.size() == 1 &&
         "prefer_cex target must resolve to precisely one object");

  rl[0].first.first->cexPreferences.push_back(cond);
}

void SpecialFunctionHandler::handlePrintExpr(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_expr");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
}

void SpecialFunctionHandler::handleSetForking(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_set_forking");
  ref<Expr> value = executor.toUnique(state, arguments[0]);
  
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(value)) {
    state.forkDisabled = CE->isZero();
  } else {
    executor.terminateStateOnError(state, 
                                   "klee_set_forking requires a constant arg",
                                   "user.err");
  }
}

void SpecialFunctionHandler::handleStackTrace(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  state.dumpStack(std::cout);
}

void SpecialFunctionHandler::handleWarning(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_warning");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  klee_warning("%s: %s", state.stack.back().kf->function->getName().data(), 
               msg_str.c_str());
}

void SpecialFunctionHandler::handleWarningOnce(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_warning_once");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  klee_warning_once(0, "%s: %s", state.stack.back().kf->function->getName().data(),
                    msg_str.c_str());
}

void SpecialFunctionHandler::handlePrintRange(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_range");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  if (!isa<ConstantExpr>(arguments[1])) {
    // FIXME: Pull into a unique value method?
    ref<ConstantExpr> value;
    bool success = executor.solver->getValue(state, arguments[1], value);
    assert(success && "FIXME: Unhandled solver failure");
    bool res;
    success = executor.solver->mustBeTrue(state, 
                                          EqExpr::create(arguments[1], value), 
                                          res);
    assert(success && "FIXME: Unhandled solver failure");
    if (res) {
      std::cerr << " == " << value;
    } else { 
      std::cerr << " ~= " << value;
      std::pair< ref<Expr>, ref<Expr> > res =
        executor.solver->getRange(state, arguments[1]);
      std::cerr << " (in [" << res.first << ", " << res.second <<"])";
    }
  }
  std::cerr << "\n";
}

void SpecialFunctionHandler::handleGetObjSize(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_obj_size");
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "klee_get_obj_size");
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    executor.bindLocal(target, *it->second, 
                       ConstantExpr::create(it->first.first->size, Expr::Int32),
					   ConstantExpr::create(it->first.first->size, Expr::Int32));
  }
}

void SpecialFunctionHandler::handleGetErrno(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==0 &&
         "invalid number of arguments to klee_get_errno");
  executor.bindLocal(target, state,
                     ConstantExpr::create(errno, Expr::Int32), 
					 ConstantExpr::create(errno, Expr::Int32));
}

void SpecialFunctionHandler::handleCalloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to calloc");

  ref<Expr> size = MulExpr::create(arguments[0],
                                   arguments[1]);
  executor.executeAlloc(state, size, false, target, true);
}

void SpecialFunctionHandler::handleRealloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to realloc");
  ref<Expr> address = arguments[0];
  ref<Expr> size = arguments[1];

  Executor::StatePair zeroSize = executor.fork(state, 
                                               Expr::createIsZero(size), 
											   Expr::createIsZero(size),
                                               true);
  
  if (zeroSize.first) { // size == 0
    executor.executeFree(*zeroSize.first, address, target);   
  }
  if (zeroSize.second) { // size != 0
    Executor::StatePair zeroPointer = executor.fork(*zeroSize.second, 
                                                    Expr::createIsZero(address), 
													Expr::createIsZero(address),
                                                    true);
    
    if (zeroPointer.first) { // address == 0
      executor.executeAlloc(*zeroPointer.first, size, false, target);
    } 
    if (zeroPointer.second) { // address != 0
      Executor::ExactResolutionList rl;
      executor.resolveExact(*zeroPointer.second, address, rl, "realloc");
      
      for (Executor::ExactResolutionList::iterator it = rl.begin(), 
             ie = rl.end(); it != ie; ++it) {
        executor.executeAlloc(*it->second, size, false, target, false, 
                              it->first.second);
      }
    }
  }
}

void SpecialFunctionHandler::handleFree(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to free");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleCheckMemoryAccess(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > 
                                                       &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_check_memory_access");

  ref<Expr> address = executor.toUnique(state, arguments[0]);
  ref<Expr> size = executor.toUnique(state, arguments[1]);
  if (!isa<ConstantExpr>(address) || !isa<ConstantExpr>(size)) {
    executor.terminateStateOnError(state, 
                                   "check_memory_access requires constant args",
                                   "user.err");
  } else {
    ObjectPair op;

    if (!state.addressSpace.resolveOne(cast<ConstantExpr>(address), op)) {
      executor.terminateStateOnError(state,
                                     "check_memory_access: memory error",
                                     "ptr.err",
                                     executor.getAddressInfo(state, address));
    } else {
      ref<Expr> chk = 
        op.first->getBoundsCheckPointer(address, 
                                        cast<ConstantExpr>(size)->getZExtValue());
      if (!chk->isTrue()) {
        executor.terminateStateOnError(state,
                                       "check_memory_access: memory error",
                                       "ptr.err",
                                       executor.getAddressInfo(state, address));
      }
    }
  }
}

void SpecialFunctionHandler::handleGetValue(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_value");

  executor.executeGetValue(state, arguments[0], target);
}

void SpecialFunctionHandler::handleDefineFixedObject(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[0]) &&
         "expect constant address argument to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[1]) &&
         "expect constant size argument to klee_define_fixed_object");
  
  uint64_t address = cast<ConstantExpr>(arguments[0])->getZExtValue();
  uint64_t size = cast<ConstantExpr>(arguments[1])->getZExtValue();
  MemoryObject *mo = executor.memory->allocateFixed(address, size, state.prevPC->inst);
  executor.bindObjectInState(state, mo, false);
  mo->isUserSpecified = true; // XXX hack;
}

void SpecialFunctionHandler::handleMakeSymbolic(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  std::string name;

  // FIXME: For backwards compatibility, we should eventually enforce the
  // correct arguments.
  if (arguments.size() == 2) {
    name = "unnamed";
  } else {
    // FIXME: Should be a user.err, not an assert.
    assert(arguments.size()==3 &&
           "invalid number of arguments to klee_make_symbolic");  
    name = readStringAtAddress(state, arguments[2]);
  }

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "make_symbolic");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    mo->setName(name);
    
    const ObjectState *old = it->first.second;
    ExecutionState *s = it->second;
    
    if (old->readOnly) {
      executor.terminateStateOnError(*s, 
				  "cannot make readonly object symbolic", 
				  "user.err");
	  return;
	} 

	// FIXME: Type coercion should be done consistently somewhere.
	bool res;
	bool success =
		executor.solver->mustBeTrue(*s, 
					EqExpr::create(ZExtExpr::create(arguments[1],
							Context::get().getPointerWidth()),
						mo->getSizeExpr()),
					res);
	assert(success && "FIXME: Unhandled solver failure");

	if (res) {
		std::string basevalue;
		if (ConstantExpr *CE = dyn_cast<ConstantExpr>(mo->getBaseExpr())) {
			CE->toString(basevalue);
		}

		basevalue += "*0";
		executor.executeMakeSymbolic_yqp(*s, mo, name,basevalue, target);
	} else {
		executor.terminateStateOnError(*s,
					"wrong size given to klee_make_symbolic",
					"user.err");
    }
  }
}

void SpecialFunctionHandler::handleMarkGlobal(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_mark_global");  

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "mark_global");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    assert(!mo->isLocal);
    mo->isGlobal = true;
  }

}


//:yqp:
void SpecialFunctionHandler::handlePThreadCreate2(ExecutionState &state,
                                                 KInstruction *target,
                                                 std::vector<ref<Expr> > &arguments)
{
	ExecutionState* newState = new ExecutionState(state);
	executor.bindLocal(target, state,
				ConstantExpr::create(0, Expr::Int32), 
				ConstantExpr::create(0, Expr::Int32));

    executor.handleSymRetValue(state, target); 
	executor.runNewThread2(state,target,arguments);
}



//:CLAP:
void SpecialFunctionHandler::handlePThreadCreate(ExecutionState &state,
                                                 KInstruction *target,
                                                 std::vector<ref<Expr> > &arguments)
{
    //fork a new process
    pid_t PID = fork();
    std::string childName;
    std::stringstream ssTid;   //stream to obtain the executor thread id

    //define the name of the child process
    ssTid << executor.tid;
    if(getThreadName()=="0"){
        childName = ssTid.str();
    }
    else{
        childName = getThreadName()+"_"+ssTid.str();
    }
    
    //get the source code line
    std::stringstream line;
    line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
    
    if (PID == 0){
        // CHILD PROCESS
        setThreadName(childName);
        executor.tid=1;
        
		cout << "runNewThread: " << executor.tid << "\n";
        executor.runNewThread(state,target,arguments);

        //terminate
        exit(-1);
    }
    else{
        //PARENT PROCESS
        executor.tid++;
        executor.printSyncTrace(("fork_"+childName),line.str(),state);
    }
}

//:CLAP:
void SpecialFunctionHandler::handlePThreadJoin(ExecutionState &state,
                                               KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "join";
	  std::stringstream line;
	  // yqp
	  if (executor.tidMap.find(state.pc->info->line) != executor.tidMap.end()) {
		  stringstream ss;

		  int line = state.pc->info->line;
		  int id = executor.tidMap[state.pc->info->line];
		  if (executor.occurTimes.find(line) != executor.occurTimes.end()) {
			  id += executor.occurTimes[line];
			  executor.occurTimes[line]++;
		  } else
			  executor.occurTimes[line] = 1;
			  
		  ss << id;
		  str += "_" + ss.str();
	  } else {
		  std::cerr << "Please set the join point: " << state.pc->info->line << "\n";
		  assert(0);
	  }

	  line <<  extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
	  executor.printSyncTrace(str,line.str(),state);
	  
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadJoin2(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "join";
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" <<  state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadLock(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "lock_";
      executor.handleSymRetValue(state, target); 

	  //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          //expr->print(ref);
          ref<<expr;
      }

	  string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
	  str.append(ref.str());
	  str.append(target->inst->getOperand(0)->getNameStr());

      //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << (state.pc->info->line - 1); //** apparently KLEE always stores the line + 1 w.r.t the original one
      executor.printSyncTrace(str,line.str(),state);
	  

	  //FIXME: changed by yqp: assume all lock success!
	  //executor.locks.insert(arguments[0]);
	  executor.locks[arguments[0]] = state.getThreadName();
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));

 }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadUnlock(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "unlock_";
      
	  ref<Expr> lock = arguments[0];
	  //FIXME: changed by yqp: assume all unlock success!
	  //executor.locks.erase(lock);
	  executor.locks.erase(lock);

      //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          expr->print(ref);
      }
      string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
	  str.append(ref.str());
	  str.append(target->inst->getOperand(0)->getNameStr());
      
	  //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
	  
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));

 }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadWait(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "wait_";
      
      //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          expr->print(ref);
      }
      string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
      str.append(obj.str());
      
      //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
      
	  //FIXME: changed by yqp: assume all inits success!
	  //arguments[0]->dump(), arguments[1]->dump();
	  //assert(executor.locks.find(arguments[1]) != executor.locks.end());
	  //executor.locks.erase(arguments[1]);
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
      
}
//:CLAP:
  void SpecialFunctionHandler::handlePThreadTimedwait(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "timedwait_";
      
      //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          expr->print(ref);
      }
      string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
      str.append(obj.str());
      
      //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
 }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadSignal(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "signal_";
      
      //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          expr->print(ref);
      }
      string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
      str.append(obj.str());
      
      //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
	  
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));

  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadBroadcast(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  std::string str = "signalall_";
	  
      //stream to get the obj reference
      std::stringstream obj, ref;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          expr->print(ref);
      }
      string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
      str.append(obj.str());
      
      //get the src line
	  std::stringstream line;
      line << extractFileBasename(state.pc->info->file) << "@" << state.pc->info->line;
      executor.printSyncTrace(str,line.str(),state);
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadMutexInit(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
      executor.handleSymRetValue(state, target); 
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));

  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadMutexDestroy(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadCondInit(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all operations success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));

  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadCondDestroy(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadAttrInit(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadAttrDestroy(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing	
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handlePThreadAttrSetScope(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handleBeforeMutexLock(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handleAfterMutexLock(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:CLAP:
  void SpecialFunctionHandler::handleBasicBlockEntry(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  executor.newBasicBlockEntry(state, arguments);
  }

// yqp
  void SpecialFunctionHandler::handleMyAssert(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	 return;
  }


//:Symbiosis:
  void SpecialFunctionHandler::handleMyPThreadCreate(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  //do nothing
	  //FIXME: changed by yqp: assume all inits success!
	  executor.bindLocal(target, state,
				  ConstantExpr::create(0, Expr::Int32), 
				  ConstantExpr::create(0, Expr::Int32));
  }

//:yqp:
   void SpecialFunctionHandler::handleExit0(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  assert(state.goalsReached == executor.threadbbiidsmap[getThreadName()].size());
	  executor.terminateStateCLAPWithConstraints(state);
  }

 void SpecialFunctionHandler::handleAtoi(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleConnect(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleSend(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleRecv(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleStrstr(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleFread(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleFclose(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleUnlink(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleSetcanceltype(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleSnprintf(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleStat(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleFopen(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleFgets(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleCBL(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleGetopt(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleStrncmp(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleStrlen(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleGethostbyname(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleStrtok(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleOpen(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handlePThreadcancel(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleGetuid(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
{
    executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleGetpwuid(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleFwrite(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }
 
  void SpecialFunctionHandler::handleWrite(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleLseek(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
      executor.handleSymRetValue(state, target); 
  }

  void SpecialFunctionHandler::handleSigwait(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	  makeSymArgument(state, target, arguments[1]);
  }

  void SpecialFunctionHandler::handleTime(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	  makeSymArgument(state, target, arguments[0]);
  }

  void SpecialFunctionHandler::makeSymArgument(ExecutionState &state,
			KInstruction *target, ref<Expr> argument) {
	
	CallSite cs(target->inst);
	Value *fp = cs.getCalledValue();
	Function *f = executor.getTargetFunction(fp, state);

	Executor::ExactResolutionList rl;
	executor.resolveExact(state, argument, rl, "make_symbolic");

	for (Executor::ExactResolutionList::iterator it = rl.begin(), 
				ie = rl.end(); it != ie; ++it) {
		const MemoryObject *mo = it->first.first;
		mo->setName(f->getNameStr());

		const ObjectState *old = it->first.second;
		ExecutionState *s = it->second;

		if (old->readOnly) {
			executor.terminateStateOnError(*s, 
						"cannot make readonly object symbolic", 
						"user.err");
			return;
		} 
		
		Expr::Width type = executor.getWidthForLLVMType(target->inst->getType());
		unsigned bytes = Expr::getMinBytesForWidth(type);
		ref<Expr> size = ConstantExpr::alloc(bytes, Expr::Int32);

		// FIXME: Type coercion should be done consistently somewhere.
		bool res;
		bool success =
			executor.solver->mustBeTrue(*s, 
						EqExpr::create(ZExtExpr::create(size,
								Context::get().getPointerWidth()),
							mo->getSizeExpr()),
						res);
		assert(success && "FIXME: Unhandled solver failure");

		if (res) {
			//:CLAP:{
			std::string basevalue;
			if (ConstantExpr *CE = dyn_cast<ConstantExpr>(mo->getBaseExpr())) {
				CE->toString(basevalue);
			}
			basevalue += "*0";
			//:CLAP:}
			std::string name = f->getNameStr() + llvm::utostr(state.stack.back().calledNum[f]);
			state.stack.back().calledNum[f]++;

			executor.executeMakeSymbolic(*s, mo, name, basevalue);
		} else {
			//TODO: commented by Jeff //:CLAP:
			executor.terminateStateOnError(*s,
						"wrong size given to klee_make_symbolic",
						"user.err");
		}

	}
  }
