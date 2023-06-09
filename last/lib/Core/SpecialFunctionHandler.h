//===-- SpecialFunctionHandler.h --------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_SPECIALFUNCTIONHANDLER_H
#define KLEE_SPECIALFUNCTIONHANDLER_H

#include <map>
#include <vector>
#include <string>

namespace llvm {
  class Function;
}

namespace klee {
  class Executor;
  class Expr;
  class ExecutionState;
  struct KInstruction;
  template<typename T> class ref;
  
  class SpecialFunctionHandler {
  public:
    typedef void (SpecialFunctionHandler::*Handler)(ExecutionState &state,
                                                    KInstruction *target, 
                                                    std::vector<ref<Expr> > 
                                                      &arguments);
    typedef std::map<const llvm::Function*, 
                     std::pair<Handler,bool> > handlers_ty;

    handlers_ty handlers;
    class Executor &executor;

  public:
    SpecialFunctionHandler(Executor &_executor);

    /// Perform any modifications on the LLVM module before it is
    /// prepared for execution. At the moment this involves deleting
    /// unused function bodies and marking intrinsics with appropriate
    /// flags for use in optimizations.
    void prepare();

    /// Initialize the internal handler map after the module has been
    /// prepared for execution.
    void bind();

    bool handle(ExecutionState &state, 
                llvm::Function *f,
                KInstruction *target,
                std::vector< ref<Expr> > &arguments);

    /* Convenience routines */

    std::string readStringAtAddress(ExecutionState &state, ref<Expr> address);
    
	void makeSymArgument(ExecutionState &state,	KInstruction *target, ref<Expr> argument);
    /* Handlers */

#define HANDLER(name) void name(ExecutionState &state, \
                                KInstruction *target, \
                                std::vector< ref<Expr> > &arguments)
    HANDLER(handleAbort);
    HANDLER(handleAssert);
    HANDLER(handleAssertFail);
    HANDLER(handleAssume);
    HANDLER(handleCalloc);
    HANDLER(handleCheckMemoryAccess);
    HANDLER(handleDefineFixedObject);
    HANDLER(handleDelete);    
    HANDLER(handleDeleteArray);
    HANDLER(handleExit);
    HANDLER(handleAliasFunction);
    HANDLER(handleFree);
    HANDLER(handleGetErrno);
    HANDLER(handleGetObjSize);
    HANDLER(handleGetValue);
    HANDLER(handleIsSymbolic);
    HANDLER(handleMakeSymbolic);
    HANDLER(handleMalloc);
    HANDLER(handleMarkGlobal);
    HANDLER(handleMerge);
    HANDLER(handleNew);
    HANDLER(handleNewArray);
    HANDLER(handlePreferCex);
    HANDLER(handlePrintExpr);
    HANDLER(handlePrintRange);
    HANDLER(handleRange);
    HANDLER(handleRealloc);
    HANDLER(handleReportError);
    HANDLER(handleRevirtObjects);
    HANDLER(handleSetForking);
    HANDLER(handleSilentExit);
    HANDLER(handleStackTrace);
    HANDLER(handleUnderConstrained);
    HANDLER(handleWarning);
    HANDLER(handleWarningOnce);

    //myBasicBlockEntryi
    HANDLER(handleBasicBlockEntry);
    HANDLER(handleMyAssert);
    HANDLER(handleMyPThreadCreate);

    HANDLER(handleBeforeMutexLock);
    HANDLER(handleAfterMutexLock);

    //PThread related handlers
    HANDLER(handlePThreadCreate);
    HANDLER(handlePThreadCreate2); //yqp
    HANDLER(handlePThreadJoin);
    HANDLER(handlePThreadJoin2);

    HANDLER(handlePThreadLock);
    HANDLER(handlePThreadUnlock);
    HANDLER(handlePThreadWait);
    HANDLER(handlePThreadTimedwait);
    HANDLER(handlePThreadSignal);
    HANDLER(handlePThreadBroadcast);
    HANDLER(handlePThreadMutexInit);
    HANDLER(handlePThreadMutexDestroy);
    HANDLER(handlePThreadCondInit);
    HANDLER(handlePThreadCondDestroy);
    HANDLER(handlePThreadAttrInit);
    HANDLER(handlePThreadAttrDestroy);
    HANDLER(handlePThreadAttrSetScope);
	
	HANDLER(handleAtoi); //yqp
    HANDLER(handleConnect); //yqp
    HANDLER(handleSend); //yqp
    HANDLER(handleRecv); //yqp
    HANDLER(handleStrstr); //yqp
    HANDLER(handleFread); //yqp
    HANDLER(handleFclose); //yqp
    HANDLER(handleUnlink); //yqp
    HANDLER(handlePThreadcancel); //yqp
    HANDLER(handleSetcanceltype); //yqp
    HANDLER(handleSnprintf); //yqp
    HANDLER(handleStat); //yqp
    HANDLER(handleFopen); //yqp
    HANDLER(handleOpen); //yqp
    HANDLER(handleFgets); //yqp
    HANDLER(handleCBL); //yqp
    HANDLER(handleGetopt); //yqp
    HANDLER(handleStrncmp); //yqp
    HANDLER(handleStrlen); //yqp
    HANDLER(handleStrtok); //yqp
    HANDLER(handleGethostbyname); //yqp
    HANDLER(handleSigwait); //yqp
    HANDLER(handleGetuid); //yqp
    HANDLER(handleGetpwuid); //yqp
    HANDLER(handleTime); //yqp
    HANDLER(handleFwrite); //yqp
    HANDLER(handleWrite); //yqp
    HANDLER(handleLseek); //yqp
    HANDLER(handleExit0); //yqp


#undef HANDLER
  };
} // End klee namespace

#endif
