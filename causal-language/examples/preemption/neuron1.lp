maxTime(4).
% TODO: non-inertial fluents
% Currently: non-inertial fluents are modeled using delayedEff - 1 timepoint after effect it will be reverted.

fluent(fA; fB; fC; fD; fE). 
initiallyN(fA; fB; fC; fD; fE).

action(a, true, fA). action(a, true, neg(fA)). delayedEff(a, neg(fA), 2).
action(c, true, fC). action(c, true, neg(fC)). delayedEff(c, neg(fC), 2).
auto(d, preD, fD). auto(d, preD, neg(fD)). delayedEff(d, neg(fD), 2).
disj(preD). in(preD, conjD). conj(conjD). in(conjD, fC). 

auto(b, preB, fB). auto(b, preB, neg(fB)). delayedEff(b, neg(fB), 2).
disj(preB). in(preB, conjB). conj(conjB). in(conjB, fA). in(conjB, neg(fC)). 

auto(e, preE, fE). auto(e, preE, neg(fE)). delayedEff(e, neg(fE), 2).
disj(preE). in(preE, (conjE1; conjE2)). conj(conjE1; conjE2). in(conjE1, fD). in(conjE2, fB).

performs(a, 0). performs(c, 0).