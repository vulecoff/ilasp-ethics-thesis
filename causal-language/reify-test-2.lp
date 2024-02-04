#script (python)
import clingo 
F = clingo.Function
N = clingo.Number
S = clingo.String
Symb = clingo.Symbol
Type = clingo.SymbolType
parse_term = clingo.parse_term

uid = 0
VAR_EXPR = "var" # both input and output
FUNC_EXPR = "func"
def parse_helper(node, pUid, path: list):
    global uid
    uid += 1

    nodeIdx = uid # local copy for this stack
    treeNodeIdentifier = ";".join([str(v) for v in path])
    if node.type == Type.Function: 
        if node.name == VAR_EXPR: 
            assert len(node.arguments) == 1, "var expression contains exactly one string symbol"
            varSymbol = node.arguments[0]
            retSymb = F(VAR_EXPR, [varSymbol, N(pUid), S(treeNodeIdentifier), N(0), N(nodeIdx)])
            return [retSymb]
        argLen = len(node.arguments)
        symb = F(FUNC_EXPR, [F(node.name), N(pUid), S(treeNodeIdentifier), N(argLen), N(nodeIdx)])
        ls = [symb]
        if argLen == 0:
            return ls
        for i, m in enumerate(node.arguments): 
            _ls = parse_helper(m, nodeIdx, path + [i])
            ls.extend(_ls)
        return ls
    else:  
        if node.type == Type.String:
            const = node.string 
            symb = F(FUNC_EXPR, [S(const), N(pUid), S(treeNodeIdentifier), N(0), N(nodeIdx)])
            return [symb]
        elif node.type == Type.Number:
            const = node.number
            symb = F(FUNC_EXPR, [N(const), N(pUid), S(treeNodeIdentifier), N(0), N(nodeIdx)])
            return [symb]
        else:
            raise Exception("What type is this?")

def parse(node): 
    # (0, 0) signifies functions that are the proper predicate (top-most level in the normal language)

    l = parse_helper(node, 0, [0]) # TODO: make this tail recursion
    return l
#end.

% node: the most indivisible expression

m(p(a, f(var("X"), var("Y")), var("X"))). 
m(p(a, f(1, 2), 1)). 
m(p(a, var("X"), g(1, var("X")))). 

node(@parse(A)) :- m(A). 
atom(Uid) :- node(func(S, 0, "0", Arity, Uid)).
hasVar(NodeIdx) :- node(var(_, _, _, _, NodeIdx)). 
hasVar(ParIdx) :- node(var(_, ParIdx, _, _, _)).
hasVar(ParIdx) :- node(func(_, ParIdx, _, _, ChildIdx)), hasVar(ChildIdx). 

toGround(A) :- atom(A), hasVar(A). 
fact(A) :- atom(A), not hasVar(A).


reqMatch(A, F, A, F) :- atom(A), atom(F), A != F, toGround(A), fact(F).
noop :- atom(A1), atom(A2), A1 != A2, fact(A1), fact(A2). 
signatureMatched(Node1, Node2, A, F) :- node(func(S, Parent1, PosIdx, Arity, Node1)), 
                                        node(func(S, Parent2, PosIdx, Arity, Node2)), 
                                        reqMatch(Node1, Node2, A, F). 
variableMatched(VarIdx, ConstIdx, A, F) :- node(var(S1, Parent1, PosIdx, 0, VarIdx)), 
                                           node(func(S2, Parent2, PosIdx, Ar, ConstIdx)), 
                                           reqMatch(VarIdx, ConstIdx, A, F). 
reqMatch(Node1, Node2, A, F) :- signatureMatched(Parent1, Parent2, A, F), 
                                node(func(S, Parent1, PosIdx, Ar, Node1)),
                                node(func(S, Parent2, PosIdx, Ar, Node2)). 
reqMatch(Node1, Node2, A, F) :- signatureMatched(Parent1, Parent2, A, F), 
                                node(var(S1, Parent1, PosIdx, 0, Node1)), 
                                node(func(S2, Parent2, PosIdx, Ar, Node2)). 

matched(Node1, Node2, A, F) :- signatureMatched(Node1, Node2, A, F), not diffArgOrUnnecessary(Node1, Node2, A, F). 
matched(C1, C2, A, F) :- node(func(S, _, PosIdx, 0, C1)), node(func(S, _, PosIdx, 0, C2)), C1!= C2, reqMatch(C1, C2, A, F).

diffArgOrUnnecessary(Parent1, Parent2, A, F) :- node(func(S1, Parent1, PosIdx, Arity1, Node1)), 
                            node(func(S2, Parent2, PosIdx, Arity2, Node2)), 
                            not matched(Node1, Node2, A, F), reqMatch(Parent1, Parent2, A, F). 

binding(V, C, A, F) :- atom(A), atom(F), matched(A, F, A, F), variableMatched(V, C, A, F). 


#show node/1.
#show atom/1.
#show binding/4.
#show toGround/1.
#show fact/1.
% #show reqMatch/4.
% #show signatureMatched/4.
% #show variableMatched/4.

% next up: divide between ground and unground

% AS THERE ARE MORE NODES DURING EVALUATION. HOW CAN I USE THE PARSING? I THINK I'M CONFUSED BETWEEN THE GROUNDING AND SOLVING
% TODO: GROUNDING SIMPLIFICATION. 