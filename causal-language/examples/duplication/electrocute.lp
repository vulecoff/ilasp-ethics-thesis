% electrocuted = (l1 * l4) + (l2 * l4) + (l3 * l4)

maxTime(2).

fluent(l1; l2; l3; l4). 
initiallyN(l2; l3; l4). initiallyP(l1). 
disj(electrocuteCond). in(electrocuteCond, (electrocuteCond1; electrocuteCond2; electrocuteCond3)). 
conj(electrocuteCond1). in(electrocuteCond1, l1). in(electrocuteCond1, l4).
conj(electrocuteCond2). in(electrocuteCond2, l2). in(electrocuteCond2, l4). 
conj(electrocuteCond3). in(electrocuteCond3, l3). in(electrocuteCond3, l4).

action(e1, true, neg(l1)). 
action(e2, true, l2).
action(e3, true, l3). 
action(e4, true, l4). 
auto(electrocute, electrocuteCond, true). % TODO: what is an appropriate NULL effect? 
% TODO: repeated happenings. Or interesting: how do I express logic that: stops after some duration. e.g dead after being electrocuted for 5 seconds (change back to 2)
% TODO: warning conditions surpasses maximum time. 

performs(e1, 0). performs(e2, 0). 
performs(e3, 1). performs(e4, 1). 