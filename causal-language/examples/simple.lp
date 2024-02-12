% specify time points
% specify all fluents
% specify actions & their relation to states

% initial states (fluents)
% action/observation

time(0..3). 
fluent(loaded). fluent(dead; alive).
action(load, true, loadEff). 
auto(shoot, shootPred, shootEff). 
conj(shootPred). in(shootPred, loaded). 
conj(shootEff). in(shootEff, dead). in(shootEff, neg(alive)). 
conj(loadEff). in(loadEff, loaded).

initiallyN(loaded). initiallyP(alive). initiallyN(dead). 
performs(load, 0). 