% peng.
% bird.
% -fly :- not fly, peng. 
% fly :- not -fly, bird. 
% :- peng.

rule(1). head(peng, 1). 
rule(2). head(bird, 2). 
rule(3). head(-fly, 3). pbl(peng, 3). nbl(fly, 3). 
rule(4). head(fly, 4). pbl(bird, 4). nbl(-fly, 4). 
% rule(5). head(null, 5). pbl(peng, 5).

compl(fly, -fly). 

hold(H) :- head(H, R), rule(R), 
           #count {N: nbl(N, R), hold(N)} = 0, 
           #count {P: pbl(P, R)} = C1,  #count{P: pbl(P, R), hold(P)} = C2, C1 = C2.

:- hold(X), hold(Y), compl(X, Y). 
:- hold(null). 
#show hold/1.