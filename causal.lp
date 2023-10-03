% ends -rule
end(A, P) :- action(A), patient(P), goalOf(A, G), #sum {G, P, pos: intention(G, P, pos)} > 0, not intention(G, P, neg). % close world for intention here


% F-rule framework 
% actualized/C :- BF(actualized/A, actualized/C), dependsOn/C[...], 

% every consequence C has an actualization rule
actualized(C), -actualized(C) :- consequence(C). 

% rule against co-dependence
dependsOn(C, Y) :- dependsOn(C, X), dependsOn(X, Y). % transitive dependence. X, Y is A & C
:- dependsOn(C1, C2), dependsOn(C2, C1). % no co-dependence



%% butFor condition. Needs more test cases. 
node(1..9). 
edge(1, 2). edge(2, 3). edge(3, (4; 7)). 
edge(3, 4). edge(4, 5). edge(5, 6). 
edge(3, 7). edge(7, 8). edge(6, 9). edge(8, 9). 

{butFor(1..8, 9)} = 0. 

% encoding
reaches(A, B) :- edge(A, B). 
reaches(A, B) :- reaches(A, C), reaches(C, B). 
-reaches(A, B) :- node(A), node(B), not reaches(A, B). 

% default: each node is necessary for itself
butFor(A, A) :- node(A). 

% reconstruct graph without the node V. Is there any issue with self-loop?
reachesWithRemoval(A, B, V) :- node(A), node(B), node(V), edge(A, B), V != A, V != B. 
reachesWithRemoval(A, B, V) :- node(A), node(B), node(V), reachesWithRemoval(A, C, V), reachesWithRemoval(C, B, V), C != V. 
butFor(A, B) :- reaches(A, B), not reachesWithRemoval(_, B, A), node(A), node(B). 
-butFor(A, B) :- node(A), node(B), not butFor(A, B). % close world
%-butFor(A, B) :- -reaches(A, B). 
%-butFor(A, B) :- reaches(A, B), reachesWithRemoval(_, B, A), node(A), node(B). 

#show -butFor/2.
#show butFor/2.
