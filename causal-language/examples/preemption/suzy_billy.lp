maxTime(4).

fluent(broken). 
initiallyN(broken). 
disj(breakS). conj(breakSC). in(breakS, breakSC). in(breakSC, broken).
action(suzyThrows, true, broken). 
action(billyThrows, true, broken). 
% delayedEff(billyThrows, broken, 2).
disj(throwPred). in(throwPred, neg(broken)). 
performs(suzyThrows, 0). performs(billyThrows, 1). 


% fluent(s_thrown; b_thrown). 
% initiallyN(s_thrown; b_thrown).
% disj(broken). conj(b1; b2). in(broken, (b1; b2)).
% in(b1, s_thrown). in(b2, b_thrown). 

% action(sThrows, true, s_thrown). 
% action(bThrows, true, b_thrown). 
% performs(sThrows, 0). performs(bThrows, 0).