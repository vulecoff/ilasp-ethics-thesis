% specify time points: maxTime
% specify all fluents
% specify actions & their relation to states

% initial states (fluents)
% action/observation

maxTime(3). 
fluent(loaded). fluent(dead; alive).
action(load, true, loadEff). 
auto(shoot, shootPred, shootEff). % automatically shoot right after loading
conj(shootPred). in(shootPred, loaded). 
conj(shootEff). in(shootEff, dead). in(shootEff, neg(alive)). in(shootEff, neg(loaded)).
conj(loadEff). in(loadEff, loaded).

initiallyN(loaded). initiallyP(alive). initiallyN(dead). 
performs(load, 0). 