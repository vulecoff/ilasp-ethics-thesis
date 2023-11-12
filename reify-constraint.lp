set(1; 2; 3). 
element(1, (0..2)). 
element(2, (0..1)). 
element(3, (0..3)). 

% crossProduct(0, nil). 
% crossProduct(N + 1, cons(V, Cons))   :- element(N + 1, V), crossProduct(N, Cons).

% ans(L) :- crossProduct(3, L). 
% count(Q) :- #count{L: ans(L)} = Q. 

% #show count/1.

coefficient(1, 1). 
coefficient(S + 1, V * N)   :- coefficient(S, V), set(S + 1), #count{ El: element(S, El), set(S)} = N. 

indexedCartesianProduct(0, 0). 
indexedCartesianProduct(S + 1, Cum + V * C)   :- set(S + 1), element(S + 1, V), indexedCartesianProduct(S, Cum), coefficient(S + 1, C).

belongsHelper(el(S, El), 0, 0) :- element(S, El), set(S). 
belongsHelper(el(S0, El0), S + 1, Cum + V * C)   :- element(S + 1, V), set(S + 1), coefficient(S + 1, C), belongsHelper(el(S0, El0), S, Cum), S0 != S + 1. 
belongsHelper(el(S0, El0), S + 1, Cum + El0 * C) :- element(S + 1, V), set(S + 1), coefficient(S + 1, C), belongsHelper(el(S0, El0), S, Cum), S0 = S + 1. 

% indexed n-ary Cartesian product tuple and generate all tuples such that an element belong to
belongs(el(S0, El0), Uid) :- belongsHelper(el(S0, El0), Cadinality, Uid), #count{S: set(S)} = Cadinality. 
output(Uid) :- belongs(el(3, 0), Uid).
% #show indexedCartesianProduct/2.
#show output/1.