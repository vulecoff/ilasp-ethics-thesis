maxTime(4).

fluent(alive; poisoned).
initiallyP(alive). initiallyN(poisoned).
action(poison, true, neg(alive)).
delayedEff(poison, neg(alive), 3).
action(poison, true, poisoned).
performs(poison, 1).