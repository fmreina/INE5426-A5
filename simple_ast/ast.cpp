#include "ast.h"

using namespace AST;

/* Print methods */
void Integer::printTree(){
    std::cout << value;
    return;
}

void BinOp::printTree(){
    left->printTree();
    switch(op){
        case plus: std::cout << " + ";
	break;
	case times: std::cout << " * ";
	break;
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
	std::cout << "Found a 'plus'" << std::endl; 
	value = lvalue + rvalue;
	break;
        case times: 
	std::cout << "Found a 'times'" << std::endl; 
	value = lvalue * rvalue;
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
