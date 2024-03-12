% dead = poisoned + headshot

% TODO: reuse compound state
maxTime(5).

fluent(poisoned). fluent(headshot). 
initiallyN(poisoned). initiallyN(headshot). 
disj(dead). in(dead, (deadC1; deadC2)). conj(deadC1; deadC2).
in(deadC1, poisoned). in(deadC2, headshot). 

action(poison, true, poisoned). delayedEff(poison, poisoned, 3). 
action(shoot, true, headshot). 

performs(poison, 0). 
performs(shoot, 1). 
