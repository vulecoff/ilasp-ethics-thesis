% fly(X) :- bird(X), not -fly(X).
% -fly(X) :- bird(X), not fly(X). 
% -fly(X) :- penguin(X). 
% bird(tux). penguin(tux). 
% bird(tweety). chicken(tweety). 

rule(1). head(fly(X))

hold(H) :- head(H, R), rule(R), 
           #count {N: nbl(N, R), hold(N)} = 0, 
           #count {P: pbl(P, R)} = C1,  #count{P: pbl(P, R), hold(P)} = C2, C1 = C2.

:- hold(X), hold(Y), compl(X, Y). 
:- hold(null). 

#show hold/1.