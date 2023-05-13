//===-- SpecialFunctionHandler.cpp ----------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "SpecialFunctionHandler.h"

#include "Executor.h"
#include "Memory.h"
#include "MemoryManager.h"
#include "Searcher.h"
#include "TimingSolver.h"
#include "klee/ClapUtil.h"

#include "klee/ExecutionState.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/Debug.h"
#include "klee/Internal/Support/ErrorHandling.h"
#include "klee/MergeHandler.h"
#include "klee/OptionCategories.h"
#include "klee/Solver/SolverCmdLine.h"

#include "llvm/ADT/Twine.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/CallSite.h"


#include <errno.h>
#include <sstream>

using namespace llvm;
using namespace klee;
extern std::string Times, Index, Last, Solutions, Trace;

namespace {
cl::opt<bool>
    ReadablePosix("readable-posix-inputs", cl::init(false),
                  cl::desc("Prefer creation of POSIX inputs (command-line "
                           "arguments, files, etc.) with human readable bytes. "
                           "Note: option is expensive when creating lots of "
                           "tests (default=false)"),
                  cl::cat(TestGenCat));

cl::opt<bool>
    SilentKleeAssume("silent-klee-assume", cl::init(false),
                     cl::desc("Silently terminate paths with an infeasible "
                              "condition given to klee_assume() rather than "
                              "emitting an error (default=false)"),
                     cl::cat(TerminationCat));
} // namespace

/// \todo Almost all of the demands in this file should be replaced
/// with terminateState calls.

///

// FIXME: We are more or less committed to requiring an intrinsic
// library these days. We can move some of this stuff there,
// especially things like realloc which have complicated semantics
// w.r.t. forking. Among other things this makes delayed query
// dispatch easier to implement.
static SpecialFunctionHandler::HandlerInfo handlerInfo[] = {
#define add(name, handler, ret) { name, \
                                  &SpecialFunctionHandler::handler, \
                                  false, ret, false }
#define addDNR(name, handler) { name, \
                                &SpecialFunctionHandler::handler, \
                                true, false, false }
  addDNR("__assert_rtn", handleAssertFail),
  addDNR("__assert_fail", handleAssertFail),
  addDNR("__assert", handleAssertFail),
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
#ifndef __APPLE__
  add("__errno_location", handleErrnoLocation, true),
#else
  add("__error", handleErrnoLocation, true),
#endif
  add("klee_is_symbolic", handleIsSymbolic, true),
  add("klee_make_symbolic", handleMakeSymbolic, false),
  add("klee_mark_global", handleMarkGlobal, false),
  add("klee_open_merge", handleOpenMerge, false),
  add("klee_close_merge", handleCloseMerge, false),
  add("klee_prefer_cex", handlePreferCex, false),
  add("klee_posix_prefer_cex", handlePosixPreferCex, false),
  add("klee_print_expr", handlePrintExpr, false),
  add("klee_print_range", handlePrintRange, false),
  add("klee_set_forking", handleSetForking, false),
  add("klee_stack_trace", handleStackTrace, false),
  add("klee_warning", handleWarning, false),
  add("klee_warning_once", handleWarningOnce, false),
  add("malloc", handleMalloc, true),
  add("memalign", handleMemalign, true),
  add("realloc", handleRealloc, true),


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

  // Run clang with -fsanitize=signed-integer-overflow and/or
  // -fsanitize=unsigned-integer-overflow
  add("__ubsan_handle_add_overflow", handleAddOverflow, false),
  add("__ubsan_handle_sub_overflow", handleSubOverflow, false),
  add("__ubsan_handle_mul_overflow", handleMulOverflow, false),
  add("__ubsan_handle_divrem_overflow", handleDivRemOverflow, false),
  add("exit", handleExit0, true), /////////////        

#undef addDNR
#undef add
};

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::begin() {
  return SpecialFunctionHandler::const_iterator(handlerInfo);
}

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::end() {
  // NULL pointer is sentinel
  return SpecialFunctionHandler::const_iterator(0);
}

SpecialFunctionHandler::const_iterator& SpecialFunctionHandler::const_iterator::operator++() {
  ++index;
  if ( index >= SpecialFunctionHandler::size())
  {
    // Out of range, return .end()
    base=0; // Sentinel
    index=0;
  }

  return *this;
}

int SpecialFunctionHandler::size() {
	return sizeof(handlerInfo)/sizeof(handlerInfo[0]);
}

SpecialFunctionHandler::SpecialFunctionHandler(Executor &_executor) 
  : executor(_executor) {}

void SpecialFunctionHandler::prepare(
    std::vector<const char *> &preservedFunctions) {
  unsigned N = size();

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);

    // No need to create if the function doesn't exist, since it cannot
    // be called in that case.
    if (f && (!hi.doNotOverride || f->isDeclaration())) {
      preservedFunctions.push_back(hi.name);
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

/****/

// reads a concrete string from memory
std::string 
SpecialFunctionHandler::readStringAtAddress(ExecutionState &state, 
                                            ref<Expr> addressExpr) {
  ObjectPair op;
  addressExpr = executor.toUnique(state, addressExpr);
  if (!isa<ConstantExpr>(addressExpr)) {
    executor.terminateStateOnError(
        state, "Symbolic string pointer passed to one of the klee_ functions",
        Executor::TerminateReason::User);
    return "";
  }
  ref<ConstantExpr> address = cast<ConstantExpr>(addressExpr);
  if (!state.addressSpace.resolveOne(address, op)) {
    executor.terminateStateOnError(
        state, "Invalid string pointer passed to one of the klee_ functions",
        Executor::TerminateReason::User);
    return "";
  }
  bool res __attribute__ ((unused));
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
  executor.terminateStateOnError(state, "abort failure", Executor::Abort);
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

void SpecialFunctionHandler::handleAssert(ExecutionState &state,
                                          KInstruction *target,
                                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==3 && "invalid number of arguments to _assert");  
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 Executor::Assert);
}

void SpecialFunctionHandler::handleAssertFail(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to __assert_fail");
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 Executor::Assert);
}

void SpecialFunctionHandler::handleReportError(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to klee_report_error");
  
  // arguments[0], arguments[1] are file, line
  executor.terminateStateOnError(state,
				 readStringAtAddress(state, arguments[2]),
				 Executor::ReportError,
				 readStringAtAddress(state, arguments[3]).c_str());
}

void SpecialFunctionHandler::handleOpenMerge(ExecutionState &state,
    KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  if (!UseMerge) {
    klee_warning_once(0, "klee_open_merge ignored, use '-use-merge'");
    return;
  }

  state.openMergeStack.push_back(
      ref<MergeHandler>(new MergeHandler(&executor, &state)));

  if (DebugLogMerge)
    llvm::errs() << "open merge: " << &state << "\n";
}

void SpecialFunctionHandler::handleCloseMerge(ExecutionState &state,
    KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  if (!UseMerge) {
    klee_warning_once(0, "klee_close_merge ignored, use '-use-merge'");
    return;
  }
  Instruction *i = target->inst;

  if (DebugLogMerge)
    llvm::errs() << "close merge: " << &state << " at [" << *i << "]\n";

  if (state.openMergeStack.empty()) {
    std::ostringstream warning;
    warning << &state << " ran into a close at " << i << " without a preceding open";
    klee_warning("%s", warning.str().c_str());
  } else {
    assert(executor.mergingSearcher->inCloseMerge.find(&state) ==
               executor.mergingSearcher->inCloseMerge.end() &&
           "State cannot run into close_merge while being closed");
    executor.mergingSearcher->inCloseMerge.insert(&state);
    state.openMergeStack.back()->addClosedState(&state, i);
    state.openMergeStack.pop_back();
  }
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

void SpecialFunctionHandler::handleMemalign(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr>> &arguments) {
  if (arguments.size() != 2) {
    executor.terminateStateOnError(state,
      "Incorrect number of arguments to memalign(size_t alignment, size_t size)",
      Executor::User);
    return;
  }

  std::pair<ref<Expr>, ref<Expr>> alignmentRangeExpr =
      executor.solver->getRange(state, arguments[0]);
  ref<Expr> alignmentExpr = alignmentRangeExpr.first;
  auto alignmentConstExpr = dyn_cast<ConstantExpr>(alignmentExpr);

  if (!alignmentConstExpr) {
    executor.terminateStateOnError(state,
      "Could not determine size of symbolic alignment",
      Executor::User);
    return;
  }

  uint64_t alignment = alignmentConstExpr->getZExtValue();

  // Warn, if the expression has more than one solution
  if (alignmentRangeExpr.first != alignmentRangeExpr.second) {
    klee_warning_once(
        0, "Symbolic alignment for memalign. Choosing smallest alignment");
  }

  executor.executeAlloc(state, arguments[1], false, target, false, 0,
                        alignment);
}

void SpecialFunctionHandler::handleAssume(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_assume");
  
  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success __attribute__ ((unused)) = executor.solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    if (SilentKleeAssume) {
      executor.terminateState(state);
    } else {
      executor.terminateStateOnError(state,
                                     "invalid klee_assume call (provably false)",
                                     Executor::User);
    }
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
                                          Expr::Int32),ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
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

void SpecialFunctionHandler::handlePosixPreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  if (ReadablePosix)
    return handlePreferCex(state, target, arguments);
}

void SpecialFunctionHandler::handlePrintExpr(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_expr");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  llvm::errs() << msg_str << ":" << arguments[1] << "\n";
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
                                   Executor::User);
  }
}

void SpecialFunctionHandler::handleStackTrace(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  state.dumpStack(outs());
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
  llvm::errs() << msg_str << ":" << arguments[1];
  if (!isa<ConstantExpr>(arguments[1])) {
    // FIXME: Pull into a unique value method?
    ref<ConstantExpr> value;
    bool success __attribute__ ((unused)) = executor.solver->getValue(state, arguments[1], value);
    assert(success && "FIXME: Unhandled solver failure");
    bool res;
    success = executor.solver->mustBeTrue(state, 
                                          EqExpr::create(arguments[1], value), 
                                          res);
    assert(success && "FIXME: Unhandled solver failure");
    if (res) {
      llvm::errs() << " == " << value;
    } else { 
      llvm::errs() << " ~= " << value;
      std::pair< ref<Expr>, ref<Expr> > res =
        executor.solver->getRange(state, arguments[1]);
      llvm::errs() << " (in [" << res.first << ", " << res.second <<"])";
    }
  }
  llvm::errs() << "\n";
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
    executor.bindLocal(
        target, *it->second,
        ConstantExpr::create(it->first.first->size,
                             executor.kmodule->targetData->getTypeSizeInBits(
                                 target->inst->getType())),ConstantExpr::create(it->first.first->size,
                             executor.kmodule->targetData->getTypeSizeInBits(
                                 target->inst->getType())));
  }
}

void SpecialFunctionHandler::handleGetErrno(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==0 &&
         "invalid number of arguments to klee_get_errno");
#ifndef WINDOWS
  int *errno_addr = executor.getErrnoLocation(state);
#else
  int *errno_addr = nullptr;
#endif

  // Retrieve the memory object of the errno variable
  ObjectPair result;
  bool resolved = state.addressSpace.resolveOne(
      ConstantExpr::create((uint64_t)errno_addr, Expr::Int64), result);
  if (!resolved)
    executor.terminateStateOnError(state, "Could not resolve address for errno",
                                   Executor::User);
  executor.bindLocal(target, state, result.second->read(0, Expr::Int32),result.second->read(0, Expr::Int32));
}

void SpecialFunctionHandler::handleErrnoLocation(
    ExecutionState &state, KInstruction *target,
    std::vector<ref<Expr> > &arguments) {
  // Returns the address of the errno variable
  assert(arguments.size() == 0 &&
         "invalid number of arguments to __errno_location/__error");

#ifndef WINDOWS
  int *errno_addr = executor.getErrnoLocation(state);
#else
  int *errno_addr = nullptr;
#endif

  executor.bindLocal(
      target, state,
      ConstantExpr::create((uint64_t)errno_addr,
                           executor.kmodule->targetData->getTypeSizeInBits(
                               target->inst->getType())),
      ConstantExpr::create((uint64_t)errno_addr,
                           executor.kmodule->targetData->getTypeSizeInBits(
                               target->inst->getType())) );
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
                                               Expr::createIsZero(size), Expr::createIsZero(size),
                                               true);
  
  if (zeroSize.first) { // size == 0
    executor.executeFree(*zeroSize.first, address, target);   
  }
  if (zeroSize.second) { // size != 0
    Executor::StatePair zeroPointer = executor.fork(*zeroSize.second, 
                                                    Expr::createIsZero(address), Expr::createIsZero(address),
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
				   Executor::User);
  } else {
    ObjectPair op;

    if (!state.addressSpace.resolveOne(cast<ConstantExpr>(address), op)) {
      executor.terminateStateOnError(state,
                                     "check_memory_access: memory error",
				     Executor::Ptr, NULL,
                                     executor.getAddressInfo(state, address));
    } else {
      ref<Expr> chk = 
        op.first->getBoundsCheckPointer(address, 
                                        cast<ConstantExpr>(size)->getZExtValue());
      if (!chk->isTrue()) {
        executor.terminateStateOnError(state,
                                       "check_memory_access: memory error",
				       Executor::Ptr, NULL,
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

  if (arguments.size() != 3) {
    executor.terminateStateOnError(state, "Incorrect number of arguments to klee_make_symbolic(void*, size_t, char*)", Executor::User);
    return;
  }

  name = arguments[2]->isZero() ? "" : readStringAtAddress(state, arguments[2]);

  if (name.length() == 0) {
    name = "unnamed";
    klee_warning("klee_make_symbolic: renamed empty name to \"unnamed\"");
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
      executor.terminateStateOnError(*s, "cannot make readonly object symbolic",
                                     Executor::User);
      return;
    } 

    // FIXME: Type coercion should be done consistently somewhere.
    bool res;
    bool success __attribute__ ((unused)) =
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
                                     "wrong size given to klee_make_symbolic[_name]", 
                                     Executor::User);
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

void SpecialFunctionHandler::handleAddOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on addition",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleSubOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on subtraction",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleMulOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on multiplication",
                                 Executor::Overflow);
}

void SpecialFunctionHandler::handleDivRemOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state, "overflow on division or remainder",
                                 Executor::Overflow);
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
//:yqp:
void SpecialFunctionHandler::handlePThreadCreate2(ExecutionState &state,
                                                 KInstruction *target,
                                                 std::vector<ref<Expr> > &arguments)
{
  std::cout<<"create thread"<<std::endl;
	ExecutionState* newState = new ExecutionState(state);
	executor.bindLocal(target, state,
				ConstantExpr::create(0, Expr::Int32), 
				ConstantExpr::create(0, Expr::Int32));

    executor.handleSymRetValue(state, target); 
	executor.runNewThread2(state,target,arguments);
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
		  std::stringstream ss;

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
      std::stringstream ref,obj;
      if(Expr *expr = dyn_cast<Expr>(arguments[0])){
          ref<<expr;
      }

	  std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
	  str.append(ref.str());
	  str.append(target->inst->getOperand(0)->getName().str());

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
          ref<<expr;
      }
      std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
      obj << generateHash(shortRef,shortRef.size());            //generate a hash of the obj ref
	  str.append(ref.str());
	  str.append(target->inst->getOperand(0)->getName().str());
      
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
          ref<<expr;
      }
      std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
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
          ref<<expr;
      }
      std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
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
          ref<<expr;
      }
      std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
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
          ref<<expr;
      }
      std::string shortRef = ref.str().substr(0,ref.str().size()-5); //to guarantee that the hash is correct, we need to remove the thread id
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
    void SpecialFunctionHandler::handlePThreadcancel(ExecutionState &state,
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
    void SpecialFunctionHandler::handleOpen(ExecutionState &state,
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
    void SpecialFunctionHandler::handleStrtok(ExecutionState &state,
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
    void SpecialFunctionHandler::handleSigwait(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	  makeSymArgument(state, target, arguments[1]);
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
    void SpecialFunctionHandler::handleTime(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	  makeSymArgument(state, target, arguments[0]);
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
  //:yqp:
   void SpecialFunctionHandler::handleExit0(ExecutionState &state,
          KInstruction *target,
          std::vector<ref<Expr> > &arguments)
  {
	  assert(state.goalsReached == executor.threadbbiidsmap[getThreadName()].size());
	  executor.terminateStateCLAPWithConstraints(state);
  }
  void SpecialFunctionHandler::makeSymArgument(ExecutionState &state,
			KInstruction *target, ref<Expr> argument) {
	
	llvm::CallSite cs(target->inst);
	Value *fp = cs.getCalledValue();
	Function *f = executor.getTargetFunction(fp, state);

	Executor::ExactResolutionList rl;
	executor.resolveExact(state, argument, rl, "make_symbolic");

	for (Executor::ExactResolutionList::iterator it = rl.begin(), 
				ie = rl.end(); it != ie; ++it) {
		const MemoryObject *mo = it->first.first;
		mo->setName(f->getName().str());

		const ObjectState *old = it->first.second;
		ExecutionState *s = it->second;

		if (old->readOnly) {
			executor.terminateStateOnError(*s, 
						"cannot make readonly object symbolic", 
						klee::Executor::TerminateReason::User);
			return;
		} 
        }	
  }