% ends -rule
end(A) :- action(A), patient(P), goalOf(A, G), #sum {1: intention(G, P, pos)} > 0, -intention(G, P, neg).


% F-rule framework 
% actualized/C :- BF(actualized/A, actualized/C), dependsOn/C[...], 

% every consequence C has an actualization rule
actualized(C), -actualized(C) :- consequence(C). 

% rule against co-dependence
dependsOn(C, Y) :- dependsOn(C, X), dependsOn(X, Y). % transitive dependence. X, Y is A & C
:- dependsOn(C1, C2), dependsOn(C2, C1). % no co-dependence
