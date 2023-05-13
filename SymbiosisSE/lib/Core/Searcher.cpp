//===-- Searcher.cpp ------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Searcher.h"

#include "CoreStats.h"
#include "Executor.h"
#include "PTree.h"
#include "StatsTracker.h"

#include "klee/ExecutionState.h"
#include "klee/MergeHandler.h"
#include "klee/Statistics.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/ADT/DiscretePDF.h"
#include "klee/Internal/ADT/RNG.h"
#include "klee/Internal/Support/ModuleUtil.h"
#include "klee/Internal/System/Time.h"
#include "klee/Internal/Support/ErrorHandling.h"

#include "klee/ClapUtil.h" //CLAP
//#include "FindCallGraph.h" //symbiosis

#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/CFG.h"
#include "llvm/Support/CommandLine.h"

//** Nuno: added for BugRedux
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Dominators.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/Analysis/CallGraph.h"


#include <cassert>
#include <climits>
#include <cmath>
#include <fstream>

using namespace klee;
using namespace llvm;


namespace klee {
  extern RNG theRNG;
}

Searcher::~Searcher() {
}

///

ExecutionState &DFSSearcher::selectState() {
  return *states.back();
}

void DFSSearcher::update(ExecutionState *current,
                         const std::vector<ExecutionState *> &addedStates,
                         const std::vector<ExecutionState *> &removedStates) {
  states.insert(states.end(),
                addedStates.begin(),
                addedStates.end());
  for (std::vector<ExecutionState *>::const_iterator it = removedStates.begin(),
                                                     ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    if (es == states.back()) {
      states.pop_back();
    } else {
      bool ok = false;

      for (std::vector<ExecutionState*>::iterator it = states.begin(),
             ie = states.end(); it != ie; ++it) {
        if (es==*it) {
          states.erase(it);
          ok = true;
          break;
        }
      }

      (void) ok;
      assert(ok && "invalid state removed");
    }
  }
}

///

ExecutionState &BFSSearcher::selectState() {
  return *states.front();
}

void BFSSearcher::update(ExecutionState *current,
                         const std::vector<ExecutionState *> &addedStates,
                         const std::vector<ExecutionState *> &removedStates) {
  // Assumption: If new states were added KLEE forked, therefore states evolved.
  // constraints were added to the current state, it evolved.
  if (!addedStates.empty() && current &&
      std::find(removedStates.begin(), removedStates.end(), current) ==
          removedStates.end()) {
    auto pos = std::find(states.begin(), states.end(), current);
    assert(pos != states.end());
    states.erase(pos);
    states.push_back(current);
  }

  states.insert(states.end(),
                addedStates.begin(),
                addedStates.end());
  for (std::vector<ExecutionState *>::const_iterator it = removedStates.begin(),
                                                     ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    if (es == states.front()) {
      states.pop_front();
    } else {
      bool ok = false;

      for (std::deque<ExecutionState*>::iterator it = states.begin(),
             ie = states.end(); it != ie; ++it) {
        if (es==*it) {
          states.erase(it);
          ok = true;
          break;
        }
      }

      (void) ok;
      assert(ok && "invalid state removed");
    }
  }
}

///

ExecutionState &RandomSearcher::selectState() {
  return *states[theRNG.getInt32()%states.size()];
}

void
RandomSearcher::update(ExecutionState *current,
                       const std::vector<ExecutionState *> &addedStates,
                       const std::vector<ExecutionState *> &removedStates) {
  states.insert(states.end(),
                addedStates.begin(),
                addedStates.end());
  for (std::vector<ExecutionState *>::const_iterator it = removedStates.begin(),
                                                     ie = removedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    __attribute__((unused))
    bool ok = false;

    for (std::vector<ExecutionState*>::iterator it = states.begin(),
           ie = states.end(); it != ie; ++it) {
      if (es==*it) {
        states.erase(it);
        ok = true;
        break;
      }
    }
    
    assert(ok && "invalid state removed");
  }
}

///

WeightedRandomSearcher::WeightedRandomSearcher(WeightType _type)
  : states(new DiscretePDF<ExecutionState*>()),
    type(_type) {
  switch(type) {
  case Depth:
  case RP:
    updateWeights = false;
    break;
  case InstCount:
  case CPInstCount:
  case QueryCost:
  case MinDistToUncovered:
  case CoveringNew:
    updateWeights = true;
    break;
  default:
    assert(0 && "invalid weight type");
  }
}

WeightedRandomSearcher::~WeightedRandomSearcher() {
  delete states;
}

ExecutionState &WeightedRandomSearcher::selectState() {
  return *states->choose(theRNG.getDoubleL());
}

double WeightedRandomSearcher::getWeight(ExecutionState *es) {
  switch(type) {
  default:
  case Depth:
    return es->depth;
  case RP:
    return std::pow(0.5, es->depth);
  case InstCount: {
    uint64_t count = theStatisticManager->getIndexedValue(stats::instructions,
                                                          es->pc->info->id);
    double inv = 1. / std::max((uint64_t) 1, count);
    return inv * inv;
  }
  case CPInstCount: {
    StackFrame &sf = es->stack.back();
    uint64_t count = sf.callPathNode->statistics.getValue(stats::instructions);
    double inv = 1. / std::max((uint64_t) 1, count);
    return inv;
  }
  case QueryCost:
    return (es->queryCost.toSeconds() < .1) ? 1. : 1./ es->queryCost.toSeconds();
  case CoveringNew:
  case MinDistToUncovered: {
    uint64_t md2u = computeMinDistToUncovered(es->pc,
                                              es->stack.back().minDistToUncoveredOnReturn);

    double invMD2U = 1. / (md2u ? md2u : 10000);
    if (type==CoveringNew) {
      double invCovNew = 0.;
      if (es->instsSinceCovNew)
        invCovNew = 1. / std::max(1, (int) es->instsSinceCovNew - 1000);
      return (invCovNew * invCovNew + invMD2U * invMD2U);
    } else {
      return invMD2U * invMD2U;
    }
  }
  }
}

void WeightedRandomSearcher::update(
    ExecutionState *current, const std::vector<ExecutionState *> &addedStates,
    const std::vector<ExecutionState *> &removedStates) {
  if (current && updateWeights &&
      std::find(removedStates.begin(), removedStates.end(), current) ==
          removedStates.end())
    states->update(current, getWeight(current));

  for (std::vector<ExecutionState *>::const_iterator it = addedStates.begin(),
                                                     ie = addedStates.end();
       it != ie; ++it) {
    ExecutionState *es = *it;
    states->insert(es, getWeight(es));
  }

  for (std::vector<ExecutionState *>::const_iterator it = removedStates.begin(),
                                                     ie = removedStates.end();
       it != ie; ++it) {
    states->remove(*it);
  }
}

bool WeightedRandomSearcher::empty() { 
  return states->empty(); 
}

///
RandomPathSearcher::RandomPathSearcher(Executor &_executor)
  : executor(_executor) {
}

RandomPathSearcher::~RandomPathSearcher() {
}

ExecutionState &RandomPathSearcher::selectState() {
  unsigned flips=0, bits=0;
  PTreeNode *n = executor.processTree->root.get();
  while (!n->state) {
    if (!n->left) {
      n = n->right.get();
    } else if (!n->right) {
      n = n->left.get();
    } else {
      if (bits==0) {
        flips = theRNG.getInt32();
        bits = 32;
      }
      --bits;
      n = (flips&(1<<bits)) ? n->left.get() : n->right.get();
    }
  }

  return *n->state;
}

void
RandomPathSearcher::update(ExecutionState *current,
                           const std::vector<ExecutionState *> &addedStates,
                           const std::vector<ExecutionState *> &removedStates) {
}

bool RandomPathSearcher::empty() { 
  return executor.states.empty(); 
}

///

MergingSearcher::MergingSearcher(Searcher *_baseSearcher)
  : baseSearcher(_baseSearcher){}

MergingSearcher::~MergingSearcher() {
  delete baseSearcher;
}

ExecutionState& MergingSearcher::selectState() {
  assert(!baseSearcher->empty() && "base searcher is empty");

  if (!UseIncompleteMerge)
    return baseSearcher->selectState();

  // Iterate through all MergeHandlers
  for (auto cur_mergehandler: mergeGroups) {
    // Find one that has states that could be released
    if (!cur_mergehandler->hasMergedStates()) {
      continue;
    }
    // Find a state that can be prioritized
    ExecutionState *es = cur_mergehandler->getPrioritizeState();
    if (es) {
      return *es;
    } else {
      if (DebugLogIncompleteMerge){
        llvm::errs() << "Preemptively releasing states\n";
      }
      // If no state can be prioritized, they all exceeded the amount of time we
      // are willing to wait for them. Release the states that already arrived at close_merge.
      cur_mergehandler->releaseStates();
    }
  }
  // If we were not able to prioritize a merging state, just return some state
  return baseSearcher->selectState();
}

///

BatchingSearcher::BatchingSearcher(Searcher *_baseSearcher,
                                   time::Span _timeBudget,
                                   unsigned _instructionBudget) 
  : baseSearcher(_baseSearcher),
    timeBudget(_timeBudget),
    instructionBudget(_instructionBudget),
    lastState(0) {
  
}

BatchingSearcher::~BatchingSearcher() {
  delete baseSearcher;
}

ExecutionState &BatchingSearcher::selectState() {
  if (!lastState ||
      (((timeBudget.toSeconds() > 0) &&
        (time::getWallTime() - lastStartTime) > timeBudget)) ||
      ((instructionBudget > 0) &&
       (stats::instructions - lastStartInstructions) > instructionBudget)) {
    if (lastState) {
      time::Span delta = time::getWallTime() - lastStartTime;
      auto t = timeBudget;
      t *= 1.1;
      if (delta > t) {
        klee_message("increased time budget from %f to %f\n", timeBudget.toSeconds(), delta.toSeconds());
        timeBudget = delta;
      }
    }
    lastState = &baseSearcher->selectState();
    lastStartTime = time::getWallTime();
    lastStartInstructions = stats::instructions;
    return *lastState;
  } else {
    return *lastState;
  }
}

void
BatchingSearcher::update(ExecutionState *current,
                         const std::vector<ExecutionState *> &addedStates,
                         const std::vector<ExecutionState *> &removedStates) {
  if (std::find(removedStates.begin(), removedStates.end(), lastState) !=
      removedStates.end())
    lastState = 0;
  baseSearcher->update(current, addedStates, removedStates);
}

/***/

IterativeDeepeningTimeSearcher::IterativeDeepeningTimeSearcher(Searcher *_baseSearcher)
  : baseSearcher(_baseSearcher),
    time(time::seconds(1)) {
}

IterativeDeepeningTimeSearcher::~IterativeDeepeningTimeSearcher() {
  delete baseSearcher;
}

ExecutionState &IterativeDeepeningTimeSearcher::selectState() {
  ExecutionState &res = baseSearcher->selectState();
  startTime = time::getWallTime();
  return res;
}

void IterativeDeepeningTimeSearcher::update(
    ExecutionState *current, const std::vector<ExecutionState *> &addedStates,
    const std::vector<ExecutionState *> &removedStates) {

  const auto elapsed = time::getWallTime() - startTime;

  if (!removedStates.empty()) {
    std::vector<ExecutionState *> alt = removedStates;
    for (std::vector<ExecutionState *>::const_iterator
             it = removedStates.begin(),
             ie = removedStates.end();
         it != ie; ++it) {
      ExecutionState *es = *it;
      std::set<ExecutionState*>::const_iterator it2 = pausedStates.find(es);
      if (it2 != pausedStates.end()) {
        pausedStates.erase(it2);
        alt.erase(std::remove(alt.begin(), alt.end(), es), alt.end());
      }
    }    
    baseSearcher->update(current, addedStates, alt);
  } else {
    baseSearcher->update(current, addedStates, removedStates);
  }

  if (current &&
      std::find(removedStates.begin(), removedStates.end(), current) ==
          removedStates.end() &&
      elapsed > time) {
    pausedStates.insert(current);
    baseSearcher->removeState(current);
  }

  if (baseSearcher->empty()) {
    time *= 2U;
    klee_message("increased time budget to %f\n", time.toSeconds());
    std::vector<ExecutionState *> ps(pausedStates.begin(), pausedStates.end());
    baseSearcher->update(0, ps, std::vector<ExecutionState *>());
    pausedStates.clear();
  }
}

/***/

InterleavedSearcher::InterleavedSearcher(const std::vector<Searcher*> &_searchers)
  : searchers(_searchers),
    index(1) {
}

InterleavedSearcher::~InterleavedSearcher() {
  for (std::vector<Searcher*>::const_iterator it = searchers.begin(),
         ie = searchers.end(); it != ie; ++it)
    delete *it;
}

ExecutionState &InterleavedSearcher::selectState() {
  Searcher *s = searchers[--index];
  if (index==0) index = searchers.size();
  return s->selectState();
}

void InterleavedSearcher::update(
    ExecutionState *current, const std::vector<ExecutionState *> &addedStates,
    const std::vector<ExecutionState *> &removedStates) {
  for (std::vector<Searcher*>::const_iterator it = searchers.begin(),
         ie = searchers.end(); it != ie; ++it)
    (*it)->update(current, addedStates, removedStates);
}

// //** Nuno: added from bugredux { #######################

// //** GeneralReplayerSearcher ****************************************
// KInstruction* GeneralReplaySearcher::findInstFromSourceLine(std::string sourceline) {
// 	KInstruction* retInst = NULL;
	
//     for (unsigned i=0;i<functions.size();i++)
//     {
// 		KFunction* kf = functions[i];
// 		int numInst = kf->numInstructions;
		      
//         for (int j=0;j<numInst;j++)
//         {
// 			KInstruction* ki = kf->instructions[j];
			
//             std::string filename = (ki->info->file);
//             char * filename_c = new char[filename.size() + 1];
//             std::copy(filename.begin(), filename.end(), filename_c);
//             filename_c[filename.size()] = '\0'; // don't forget the terminating 0
            
//             std::ostringstream osstream;
//             osstream << extractFileBasename(filename_c) <<":" << ki->info->line;
// 			//std::cerr << "\t" << osstream.str() << " ? ";
			
//             if (osstream.str().compare(sourceline)==0) {
//     			return ki;
// 			}
//     	}
// 	}
// 	return retInst;
// }



// GeneralReplaySearcher::GeneralReplaySearcher(Executor &_executor) : executor(_executor), functions(executor.kmodule->functions){
// 	for (unsigned i=0;i<functions.size();i++)
//     {
// 		KFunction * kf = functions[i];
// 		if (kf->function!=NULL)
//         {
// 			funcShortMap[kf->function] = 1;
// 		}
// 		llvm::Function* curFunc = kf->function;
// 		if (curFunc->getBasicBlockList().size()==0)
// 			continue;
// 	}
    
// }

// void GeneralReplaySearcher::generateFuncShort() {
    
// 	int infinity = 10000000;
// 	std::set<Function*> exitfuncs;
// 	for (unsigned i=0;i<functions.size();i++) {
// 		KFunction * kf = functions[i];
// 		if (kf->function->getName().str().compare("main")==0) //** Nuno: changed __user_main to main
// 			continue;
// 		for (unsigned j=0;j<kf->numInstructions;j++) {
// 			KInstruction* ki = kf->instructions[j];
// 			if (isa<CallInst>(ki->inst)) {
// 				CallInst* callI = (CallInst*)(ki->inst);
// 				if (callI->getCalledFunction()!=NULL&&callI->getCalledFunction()->getName().str().compare("exit")==0) {
// 					exitfuncs.insert(kf->function);
// 					break;
// 				}
// 			}
            
// 		}
// 		llvm::Function* curFunc = kf->function;
// 	}
    
// 	// run 5 times to get approximate short dis for func
//     for (int j=0;j<5;j++) {
//         curDistanceMap.clear();
        
// 		for (unsigned i=0;i<functions.size();i++) {
// 			KFunction * kf = functions[i];
// 			llvm::Function* curFunc = kf->function;
// 			std::set<Instruction*> q;
// 			if (curFunc->getBasicBlockList().size()==0)
// 				continue;
//       for (BasicBlock &BB : *curFunc){
// 			//for (Function::iterator I=curFunc->begin(), E=curFunc->end();I!=E;I++) {
// 				//BasicBlock *BB = dynamic_cast<BasicBlock>(I);
//                 for (Instruction &BI : BB){
//                 //for (BasicBlock::iterator BI=BB->begin(),BE=BB->end();BI!=BE;BI++) {
//                     Instruction* inst = &BI;
//                     if (isa<ReturnInst>(inst)) {
//                         curDistanceMap[inst] = 1;
//                     } else if (isa<CallInst>(inst)){
//                         CallInst* callI = (CallInst*)inst;
//                         if (callI->getCalledFunction()!=NULL&&callI->getCalledFunction()->getName().str().compare("exit")==0)
//                             curDistanceMap[inst] = 1;
//                         else if (callI->getCalledFunction()!=NULL&&exitfuncs.find(callI->getCalledFunction())!=exitfuncs.end())
//                             curDistanceMap[inst] = 1;
//                         else
//                             curDistanceMap[inst] = infinity;
//                     }
//                     else {
//                         curDistanceMap[inst] = infinity;
//                     }
//                     if (inst->isTerminator()||isa<CallInst>(inst))
//                         q.insert(inst);
//                 }
// 			}
            
// 			while (q.size()>0) {
//                 std::set<Instruction*>::iterator it;
//                 Instruction* minInst = NULL;
//                 int minval = infinity;
//                 for (it = q.begin();it!=q.end();it++) {
//                     Instruction* ci = *it;
                    
//                     if (curDistanceMap[ci]<minval) {
//                         minval = curDistanceMap[ci];
//                         minInst = ci;
//                     }
//                 }
//                 if (minval==infinity) {
//                     q.clear();
//                     break;
//                 }
//                 q.erase(minInst);
                
//                 std::vector<Instruction*> instvec;
//                 for (Instruction &BI : *(minInst->getParent())){
//                 //for (BasicBlock::iterator BI = minInst->getParent()->begin(),BE = minInst->getParent()->end();BI!=BE;BI++) {
//                     Instruction* binst = &BI;
//                     if (binst==minInst)
//                         break;
//                     instvec.push_back(binst);
//                 }
//                 int newDis = infinity;
                
//                 Instruction* cminInst = minInst;
//                 while(instvec.size()>0){
//                     Instruction* backInst = instvec.back();
//                     if (isa<CallInst>(backInst)) {
                        
                        
// 						Function* calledFunc = ((CallInst*)backInst)->getCalledFunction();
// 						if (calledFunc==NULL) {
// 						  	newDis = curDistanceMap[cminInst]+1;
// 						} else {
// 							if (unvisitedFunc.find(calledFunc)==unvisitedFunc.end()) {
//                                 if (funcShortMap.find(calledFunc)!=funcShortMap.end())
//                                     newDis = curDistanceMap[cminInst]+1+funcShortMap[calledFunc];
//                                 else
//                                     newDis = curDistanceMap[cminInst]+1;
// 							} else
// 								newDis = infinity;
//                         }
//                         if (curDistanceMap[backInst]>newDis) {
//                             curDistanceMap[backInst] = newDis;
//                         }
//                     }
//                     else {
//                         //simple case direct pred
//                         newDis = curDistanceMap[cminInst]+1;
//                         if (curDistanceMap[backInst] > newDis) {
//                             curDistanceMap[backInst] = newDis;
//                         }
                        
                        
//                     }
//                     instvec.pop_back();
//                     cminInst=backInst;
//                     q.erase(backInst);
//                 }
                
//                 //means minInst is the beginning of program
//                 pred_iterator PI = pred_begin(cminInst->getParent()), PE = pred_end(cminInst->getParent());
//                 while(PI!=PE) {
//                     BasicBlock* predBB = (BasicBlock*)(*PI);
//                     if (prunedBBSet.find(predBB)==prunedBBSet.end()) {
//                         Instruction * predterm = predBB->getTerminator();
//                         newDis = curDistanceMap[cminInst]+1;
//                         if (curDistanceMap[predterm]>newDis) {
//                             curDistanceMap[predterm] = newDis;
//                         }
//                     }
//                     PI++;
//                 }
                
                
//             }
// 			if (curDistanceMap[&*(curFunc->getEntryBlock().begin())]<infinity) {
// 				funcShortMap[curFunc] = curDistanceMap[&*(curFunc->getEntryBlock().begin())];
// 			}
// 		}
//     }//end outer for
    
// }

// void GeneralReplaySearcher::generateNewShortDistance() {
// }

// void GeneralReplaySearcher::findNextTarget() {
// 	lastChoice = NULL;
// 	lastChoiceNumber = -1;
    
//     //	if (eventPtr==targetInstList.size()) {
//     //		this->curInsideFuncDisMap.clear();
//     //		return;
//     //	}
    
// 	generateNewShortDistance();
    
// 	return;
    
// }

// GeneralReplaySearcher::~GeneralReplaySearcher() {
// }


// ExecutionState &GeneralReplaySearcher::selectState() {
//     return *states.back();
// }


// void GeneralReplaySearcher::update(ExecutionState *current,
//                                    const std::set<ExecutionState*> &addedStates,
//                                    const std::set<ExecutionState*> &removedStates) {
//     states.insert(states.end(),
//                   addedStates.begin(),
//                   addedStates.end());
//     for (std::set<ExecutionState*>::const_iterator it = removedStates.begin(),
//          ie = removedStates.end(); it != ie; ++it) {
//         ExecutionState *es = *it;
//         if (es == states.back()) {
//             states.pop_back();
//         } else {
//             bool ok = false;
            
//             for (std::vector<ExecutionState*>::iterator ait = states.begin(),
//                  aie = states.end(); ait != aie; ++ait) {
//                 if (es==*ait) {
//                     states.erase(ait);
//                     ok = true;
//                     break;
//                 }
//             }
            
//             assert(ok && "invalid state removed");
//         }
//     }
// }


// //** AvisoReplaySearcher *********************************************
// AvisoReplaySearcher::AvisoReplaySearcher(Executor &_executor)
// :GeneralReplaySearcher(_executor) {
	
//     //** Nuno: load aviso events
//     //load target goals
//     if(atrace.empty())
//     {
//         atrace = loadAvisoTrace();
//         printAvisoTrace();
        
//         //** initalize map threadHasFinished
//         for(AvisoTrace::iterator iter = atrace.begin(); iter != atrace.end(); ++iter )
//         {
//             std::string tid = (*iter).first;
//             threadHasFinished[tid] = false;
//             //std::cerr << "*** threadHasFinished["<<tid<<"] = "<< threadHasFinished[tid]<< "\n";
//         }
//         //**
//     }
    
//     eventPtr = 0;
// 	getTarget = false;
    
//     if(!atrace.empty())
//     {
//         //** Here we build the targetInstList, which contains an ordered sequence of events
//         //** that should be reached during the symbolic execution
        
//         std::map<std::string,KInstruction*> foundset;   //cache for the events whose instruction was already found
//         std::map<std::string,KInstruction*> unfoundset; //cache for the events whose instruction couldn't be found
        
//         std::cerr << "############ THREAD " << getThreadName() << "\n";
        
//         AvisoEventVector vec = atrace[getThreadName()];
//         for(AvisoEventVector::iterator vecit = vec.begin(); vecit!=vec.end(); ++vecit)
//         {
//             AvisoEvent ae = *vecit;
//             std::ostringstream osstream;
// 			osstream << ae.filename <<":"<< ae.loc;
            
//             if (foundset.find(osstream.str())!=foundset.end()) //we've already seen this event before
//             {
//                 //std::cerr << "event " << osstream.str() << " already on cache\n";
//                 targetInstList.push_back(foundset[osstream.str()]);
//                 continue;
//             }
//             else if (unfoundset.find(osstream.str())!=unfoundset.end())
//             {
//                 //std::cerr << "event "<< osstream.str() << " not found, already on cache\n";
//                 continue;
//             }
//             else
//             {
//                 //std::cerr << "event " << osstream.str() << " == ";
//                 KInstruction* inst = this->findInstFromSourceLine(osstream.str());
//                 if(inst!=NULL)
//                 {
//                     foundset[osstream.str()] = inst;
//                     targetInstList.push_back(inst);
//                     visitedFuncs.insert(inst->inst->getParent()->getParent());
//                 }
//                 else
//                 {
//                     std::cerr << "[" << getThreadName () << "] Cannot find target "<< osstream.str() << "\n";
//                     unfoundset[osstream.str()] = NULL;
//                 }
                    
//             }
//         }
//     }
    
//     lastChoiceNumber = -1;
// 	lastChoice = NULL;
// 	this->getToUserMain = false;
// }

// //** complete the aviso trace with events referring to the function call seq
// void AvisoReplaySearcher::expandTraceFile()
// {
//     //** run pass to find the callers for each function
//     llvm::PassManager pmcfg;
//     FindCallGraph* fcg = new FindCallGraph();
//     PassRegistry &Registry = *PassRegistry::getPassRegistry();
//     initializeIPA(Registry);
//     pmcfg.add((llvm::Pass*)fcg);
//     pmcfg.run(*executor.kmodule->module);
 
//     std::vector<ExecutionState*>::iterator it = states.begin();
//     ExecutionState *es = *it;
//     Function* mainFunc = es->pc->inst->getParent()->getParent(); //thread's main function, i.e., the first function that it executes
    
//     //** iterate over all events and add extra events for each function in the call seq
//     for(std::vector<KInstruction*>::iterator it = targetInstList.begin(); it != targetInstList.end(); it++)
//     {
//         Function* eventfunc = (*it)->inst->getParent()->getParent(); //** function where the event is
//         std::stack<Function*> stack;
        
//         //** DFS to find path from eventFunc to mainFunc
//         vector<Function*> path; //to store path from mainFunc to eventFunc
//         stack.push(eventfunc);
//         while(!stack.empty())
//         {
//             Function* tmpFunc = stack.top();
//             stack.pop();
//             if(tmpFunc == mainFunc)
//             {
//                 path.insert(path.begin(),tmpFunc);
//                 break;
//             }
//             else if(visitedFuncs.find(tmpFunc)!=visitedFuncs.end())
//             {
//                 path.insert(path.begin(),tmpFunc);
//                 for(std::set<llvm::Function *>::iterator itc = fcg->callersOf[tmpFunc].begin(); itc!=fcg->callersOf[tmpFunc].end(); ++itc)
//                 {
//                     stack.push((*itc));
//                 }
//             }
//         }
        
//         std::cerr << "### callseq for event " << (*it)->info->line << ": ";
//         for(std::vector<Function*>::iterator pit = path.begin(); pit!=path.end(); ++pit)
//         {
//                 std::cerr << (*pit)->getName().str() << " -> ";
//         }
//         std::cerr << "\n";
//     }
    
    
    
//   /*  for(std::map< llvm::Function *, std::set<llvm::Function *> >::iterator it = fcg->callersOf.begin(); it!=fcg->callersOf.end(); ++it)
//     {
//         llvm::Function* func = it->first;
//         if(visitedFuncs.find(func)!=visitedFuncs.end())
//         {
//             std::set<llvm::Function *> setCallers = it->second;
//             std::cerr << func->getNameStr() << " : ";
//             for(std::set<llvm::Function *>::iterator itc = setCallers.begin(); itc!=setCallers.end(); ++itc)
//             {
//                 llvm::Function* func = (*itc);
//                 std::cerr << func->getNameStr() << "; ";
//             }
//             std::cerr << "\n";
//         }
//     }//*/
//     //CALLGRAPH ----------------
// }
