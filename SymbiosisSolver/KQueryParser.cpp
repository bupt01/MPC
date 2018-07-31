//
//  KQueryParser.cpp
//  symbiosisSolver
//
//  Created by Nuno Machado on 06/01/14.
//  Copyright (c) 2014 Nuno Machado. All rights reserved.
//

#include "KQueryParser.h"
#include "Util.h"
#include <stdlib.h>
#include <unistd.h>
#include <string>

using namespace std;

void kqueryparser::parseLeftRightExpr(string expr, string &l, string &r)
{
    string left, right;
    std::size_t init = 0;
    std::size_t end = 0;
    
    if(expr[init]!='(')
    {
        end = expr.find_first_of(' ',init);
        left = expr.substr(init, end-init);   //get the left operand value
        init = end+1;
    }
    else
    {
        end = expr.find_first_of(')',init);
        left = expr.substr(init, end-init+1); //get the left operand expression (we want the last ')')
        while(!util::isClosedExpression(left))
        {
            end = expr.find_first_of(')',end+1);
            left = expr.substr(init, end-init+1);
        }
        init = end+1;
    }
   
    init = expr.find_first_not_of(" )",init);
    if(expr[init]!='(')
    {
        if(expr.find_first_of(' ',init)!=string::npos)
        {
            end = expr.find_first_of(' ',init);
        }
        else if(expr.find_first_of(')',init)!=string::npos)
        {
            end = expr.find_first_of(')',init);
        }
        right = expr.substr(init, end-init);   //get the right operand value
        init = end+1;
    }
    else
    {
        end = expr.find_first_of(')',init);
        right = expr.substr(init, end-init+1); //get the right operand expression (we want the last ')')
        while(!util::isClosedExpression(right))
        {
            end = expr.find_first_of(')',end+1);
            right = expr.substr(init, end-init+1);
        }
        init = end+1;
    }
    
    l.append(left);
    r.append(right);
}


string kqueryparser::translateExprToZ3(std::string expr, bool& bitvec){

    bitvec = false;
    //in case its a number, there is no need to parse
    if(expr.front()!='(') {
        return expr;
    }
    
    string expOperator = expr.substr(1,expr.find_first_of(' ')-1);                  //expression operator
    
    //check if operator is an arithmetic operation
    if(!expOperator.compare("Add") || !expOperator.compare("Sub") || !expOperator.compare("Mul") || !expOperator.compare("UDiv")
       || !expOperator.compare("SDiv") || !expOperator.compare("URem") || !expOperator.compare("SRem"))
    {
        std::size_t pos = expr.find_first_of('w');
        string type = expr.substr(pos,expr.find_first_of(' ',pos)-pos); //type of form w[0-9]+
        pos = expr.find(type) + type.size() + 1;
        string left,right;
        string tmp = expr.substr(pos);
        parseLeftRightExpr(tmp, left, right);
        
        if(!expOperator.compare("Add"))
        {
            //handle cases where klee does subtractions using overflow tricks
            if(left.find("4294967295")!=string::npos || right.find("4294967295")!=string::npos)
            {
                string changeexpr;
                bool temp;
                if(left.find("4294967295")!=string::npos){
                    changeexpr = ("(- "+translateExprToZ3(right, temp)+" "+translateExprToZ3("1", temp)+")");
                }
                else{
                    changeexpr = ("(- "+translateExprToZ3(left, temp)+" "+translateExprToZ3("1", temp)+")");
                }
                return changeexpr;
            }

			if(left.find("4294967")!=string::npos || right.find("4294967")!=string::npos)
            {
                string changeexpr;
                bool temp;
                if(left.find("4294967")!=string::npos){
					std::string str = left.substr(7);
					int i1 = stoi(str);
					i1 = 296 - i1;
                    changeexpr = ("(- "+translateExprToZ3(right, temp)+" "+translateExprToZ3(to_string(i1), temp)+")");
                } else{
					std::string str = right.substr(7);
					int i1 = stoi(str);
					i1 = 296 - i1;
                    changeexpr = ("(- "+translateExprToZ3(left, temp)+" "+translateExprToZ3(to_string(i1), temp)+")");
                }
                return changeexpr;
            }

            bool temp;
            return ("(+ "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        else if(!expOperator.compare("Sub"))
        {
            bool temp;
            return ("(- "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        else if(!expOperator.compare("Mul"))
        {
            bool temp;
            return ("(* "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        else if(!expOperator.compare("UDiv") || !expOperator.compare("SDiv"))
        {
            bool temp;
			translateExprToZ3(left, temp);
			translateExprToZ3(right, temp);
            return ("(div "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        else if(!expOperator.compare("URem") || !expOperator.compare("SRem"))
        {
            bool temp;
            return ("(mod "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
    }
        //check whether the operator is a macro expression
    else if (!expOperator.compare("ReadLSB") || !expOperator.compare("ReadMSB") 
				|| !expOperator.compare("Read")) // added by yqp
    {
        std::size_t pos = expr.find_first_of('w');
        
        string type = expr.substr(pos,expr.find_first_of(' ',pos)-pos); //type of form w[0-9]+
        pos = pos + type.size() + 1;
        string index = expr.substr(pos,expr.find_first_of(' ',pos)-pos); //index of form [0-9]+
        pos = pos + index.size() + 1;
        string var = expr.substr(pos,expr.find_first_of(')',pos)-pos); //variable reference
		if (var.at(0) != 'w')
		  return ("R-"+var);
		else {
			var = var.substr(var.find_first_of(' ')+1); //variable reference
			var = var.substr(var.find_first_of(' ')+1); //variable reference
			
			std::string str = "";
			for (unsigned i=0; i<var.size(); ++i) 
			  if (var.at(i) == '(')
				str += ")";
			var += str;

            bool temp;
			var = translateExprToZ3(var, temp);
			return var;
		}

    }
        //check whether the operator is a comparison
    else if (!expOperator.compare("Eq") || !expOperator.compare("Ne") || !expOperator.compare("Ult") || !expOperator.compare("Ule")
             || !expOperator.compare("Ugt") || !expOperator.compare("Uge") || !expOperator.compare("Slt")
             || !expOperator.compare("Sgt") || !expOperator.compare("Sle") || !expOperator.compare("Sge")

			 || !expOperator.compare("And") ) // added by yqp
    {
        std::size_t pos = expr.find_first_not_of(' ',expOperator.size()+1);
        
        string left,right;
        string tmp = expr.substr(pos);
		if (tmp.at(0) == 'w') {
			tmp = tmp.substr(tmp.find_first_of(' ')+1);	
		}
        parseLeftRightExpr(tmp, left, right);
		
        
        if(!expOperator.compare("Eq"))
        {
            bool temp1, temp2;
            left = translateExprToZ3(left, temp1);
            right = translateExprToZ3(right, temp2);
            if (temp1 != temp2) {
                if (temp1 == true)
                    right = "((_ int2bv 32) " + right + ")";
                else
                    left = "((_ int2bv 32) " + left + ")";
            }
            return ("(= "+left+" "+right+")");
        }
        if(!expOperator.compare("Ne"))
        {
            bool temp;
            return ("(not (= "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+"))");
        }
        if(!expOperator.compare("Ult") || !expOperator.compare("Slt"))
        {
            bool temp;
            return ("(< "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        if(!expOperator.compare("Ule") || !expOperator.compare("Sle"))
        {
            bool temp;
            return ("(<= "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        if(!expOperator.compare("Ugt") || !expOperator.compare("Sgt"))
        {
            bool temp;
            return ("(> "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
        if(!expOperator.compare("Uge") || !expOperator.compare("Sge"))
        {
            bool temp;
            return ("(>= "+translateExprToZ3(left, temp)+" "+translateExprToZ3(right, temp)+")");
        }
		if (!expOperator.compare("And"))
		{
            bool temp1, temp2;
            left = translateExprToZ3(left, temp1);
            right = translateExprToZ3(right, temp2);
            if (left.front() != '(' && left.front() != 'R')
                left = "((_ int2bv 32) " + left + ")";
            if (right.front() != '(' && right.front() != 'R')
                right = "((_ int2bv 32) " + right + ")";

            bitvec = true;
			return ("(bvand "+left+" "+right+")");
		}
        
    }
    //check whether the operator is a bit vector -> we're not handling these...
    else if(!expOperator.compare("SExt") ||
				!expOperator.compare("ZExt")) // added by yqp
    {
        std::size_t pos = expr.find_first_of('w');
        
        string type = expr.substr(pos,expr.find_first_of(' ',pos)-pos); //type of form w[0-9]+
        pos = pos + type.size() + 1;
        
        //get the input expression
        pos = expr.find_first_not_of(' ',pos);
        
        string inputexpr;
        if(expr[pos]!='(')
        {
            inputexpr = expr.substr(pos, expr.find_first_of(')',pos)-pos);   //yqp: get the left operand value
        }
        else
        {
            inputexpr = expr.substr(pos, expr.find_first_of(')',pos)-pos +1 ); //yqp: get the left operand expression (we want the last ')')
			pos = expr.find_first_of(')', pos)+1;
			std::size_t p = 1;
			while (inputexpr.find_first_of('(', p) != std::string::npos) {
				p = inputexpr.find_first_of('(', p) + 1;
				inputexpr += expr.substr(pos, expr.find_first_of(')', pos)-pos+1);
				pos = expr.find_first_of(')', pos)+1;
			}
        }
       
        bool temp;
		std::string ss = translateExprToZ3(inputexpr, temp);
		return ss;
    }
   
    
    return expr;
}
