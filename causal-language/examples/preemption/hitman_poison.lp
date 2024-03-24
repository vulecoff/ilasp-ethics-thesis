% dead = poisoned + headshot

% TODO: reuse compound state
maxTime(5).

fluent(poisoned). fluent(headshot). fluent(dead).
initiallyN(poisoned). initiallyN(headshot). initiallyN(dead).
disj(deadD). in(deadD, (deadC1; deadC2)). conj(deadC1; deadC2).
in(deadC1, poisoned). in(deadC2, headshot). 

action(poison, neg(dead), poisoned). delayedEff(poison, poisoned, 4). 
action(shoot, neg(dead), headshot). 
auto(die, deadD, dead).

performs(poison, 0). 
performs(shoot, 1). 
