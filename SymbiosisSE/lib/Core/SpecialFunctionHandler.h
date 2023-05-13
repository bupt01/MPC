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

#include <iterator>
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

    struct HandlerInfo {
      const char *name;
      SpecialFunctionHandler::Handler handler;
      bool doesNotReturn; /// Intrinsic terminates the process
      bool hasReturnValue; /// Intrinsic has a return value
      bool doNotOverride; /// Intrinsic should not be used if already defined
    };

    // const_iterator to iterate over stored HandlerInfo
    // FIXME: Implement >, >=, <=, < operators
    class const_iterator : public std::iterator<std::random_access_iterator_tag, HandlerInfo>
    {
      private:
        value_type* base;
        int index;
      public:
      const_iterator(value_type* hi) : base(hi), index(0) {};
      const_iterator& operator++();  // pre-fix
      const_iterator operator++(int); // post-fix
      const value_type& operator*() { return base[index];}
      const value_type* operator->() { return &(base[index]);}
      const value_type& operator[](int i) { return base[i];}
      bool operator==(const_iterator& rhs) { return (rhs.base + rhs.index) == (this->base + this->index);}
      bool operator!=(const_iterator& rhs) { return !(*this == rhs);}
    };

    static const_iterator begin();
    static const_iterator end();
    static int size();



  public:
    SpecialFunctionHandler(Executor &_executor);

    /// Perform any modifications on the LLVM module before it is
    /// prepared for execution. At the moment this involves deleting
    /// unused function bodies and marking intrinsics with appropriate
    /// flags for use in optimizations.
    ///
    /// @param preservedFunctions contains all the function names which should
    /// be preserved during optimization
    void prepare(std::vector<const char *> &preservedFunctions);

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
    HANDLER(handleErrnoLocation);
    HANDLER(handleFree);
    HANDLER(handleGetErrno);
    HANDLER(handleGetObjSize);
    HANDLER(handleGetValue);
    HANDLER(handleIsSymbolic);
    HANDLER(handleMakeSymbolic);
    HANDLER(handleMalloc);
    HANDLER(handleMemalign);
    HANDLER(handleMarkGlobal);
    HANDLER(handleOpenMerge);
    HANDLER(handleCloseMerge);
    HANDLER(handleNew);
    HANDLER(handleNewArray);
    HANDLER(handlePreferCex);
    HANDLER(handlePosixPreferCex);
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
    HANDLER(handleAddOverflow);
    HANDLER(handleMulOverflow);
    HANDLER(handleSubOverflow);
    HANDLER(handleDivRemOverflow);

    HANDLER(handleBasicBlockEntry);
    HANDLER(handleMyAssert);
    HANDLER(handleMyPThreadCreate);
    HANDLER(handleBeforeMutexLock);
    HANDLER(handleAfterMutexLock);

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

#endif /* KLEE_SPECIALFUNCTIONHANDLER_H */
