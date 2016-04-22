#include "ast.h"
#include "st.h"

using namespace AST;

extern ST::SymbolTable symtab;

/* Print methods */
void Integer::printTree(){
    std::cout << value;
    return;
}

void BinOp::printTree(){
    left->printTree();
    switch(op){
        case plus: std::cout << " + "; break;
        case times: std::cout << " * "; break;
        case assign: std::cout << " = "; break;
    }
    right->printTree();
    return;
}

void Block::printTree(){
    for (Node* line: lines) {
        line->printTree();
        std::cout << std::endl;
    }
}

void Variable::printTree(){
    if (next != NULL){
        next->printTree();
        std::cout << ", ";
    }
    std::cout << id;
}
/* Compute methods */
int Integer::computeTree(){
    return value;
}

int BinOp::computeTree(){
    int value, lvalue, rvalue;
    lvalue = left->computeTree();
    rvalue = right->computeTree();
    switch(op){
        case plus: 
		//std::cout << "Found a 'plus'" << std::endl; 
		value = lvalue + rvalue;
		break;
        case times: 
		//std::cout << "Found a 'times'" << std::endl; 
		value = lvalue * rvalue;
		break;
	case assign:
            	//assignments require data from the symbol table
            	Variable* leftvar = dynamic_cast<Variable*>(left);
            	symtab.entryList[leftvar->id].value = rvalue;
           	 value = rvalue;
		break;
    }
    return value;
}

int Block::computeTree(){
    int value;
    for (Node* line: lines) {
        value = line->computeTree();
         std::cout << "Computed " << value << std::endl;
    }
    return 0;
}

int Variable::computeTree(){
	// the variable value is stored in the symbol table
	return symtab.entryList[id].value;
}
