% ElectrocuteCond = (l1 * l3) + (l2 * l4)
% Event Eff: e12 --> l1, l2  e3 --> l3  e4 --> l4

maxTime(2).

fluent(l1; l2; l3; l4). 
initiallyN(l1; l2; l3; l4).  
disj(electrocuteCond). in(electrocuteCond, (electrocuteCond1; electrocuteCond2; electrocuteCond3)). 
conj(electrocuteCond1). in(electrocuteCond1, l1). in(electrocuteCond1, l3).
conj(electrocuteCond2). in(electrocuteCond2, l2). in(electrocuteCond2, l4). 

action(e12, true, e12Eff). conj(e12Eff). in(e12Eff, l1). in(e12Eff, l2). 
action(e3, true, l3). 
action(e4, true, l4). 
auto(electrocute, electrocuteCond, true).


performs(e12, 0).
performs(e3, 1). performs(e4, 1). 