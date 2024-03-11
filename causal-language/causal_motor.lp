% actual state object: as(state, time), actual event occurrence object: ao(event, time)
% GD - goal descriptor
% r_as: relation between state objects (from literal, to cnf, to dnf)

inertia(as(L, T), as(L, T + 1)) :- holds(L, T), holds(L, T + 1), literal(L). 
r_as(as(L, T), as(C, T)) :- conj(C), holds(C, T), in(C, L). 
r_as(as(C, T), as(D, T)) :- disj(D), holds(D, T), in(D, C), holds(C, T). 

%%% Direct NESS
direct_ness(ao(init(L), -1), ao(L, 0)) :- holds(L, 0), literal(L). 
direct_ness(ao(E, T), as(F, T + 1)) :- initiated(E, F, T). 
direct_ness(ao(E, T), as(neg(F), T + 1)) :- terminated(E, F, T). 
direct_ness(Event, as(L, T + 1)) :- direct_ness(Event, as(L, T)), inertia(as(L, T), as(L, T + 1)). 
direct_ness(Event, as(GD, T)) :- direct_ness(Event, as(GD_S, T)), r_as(as(GD_S, T), as(GD, T)).
% TODO: GD - bigger compound state, GD_S - sub compound state or primitive state

%%% NESS
% ness(ao(E1, T1), as(GD, T2)) :- direct_ness(ao(E1, T1), as(GD, T2)). 
% ness(ao(E1, T1), as(GD))


%%% Weight. As of now, this requires eff to be in proper disjunctive form (with disj and conj state)
weight(as(D, T), L, ratio(K, N)) :- disj(D), holds(D, T), literal(L), time(T), 
                          K = #count{C: conj(C), r_as(as(L, T), as(C, T)), r_as(as(C, T), as(D, T))}, K > 0,
                          N = #count{C: conj(C), r_as(as(C, T), as(D, T))}.

weight(as(D, T), ao(E, T1), ratio(K, N)) :- disj(D), holds(D, T), direct_ness(ao(E, T1), as(D, T)), T1 < T,
                                          K = #count{C: conj(C), r_as(as(C, T), as(D, T)), direct_ness(ao(E, T1), as(C, T))}, K > 0,
                                          N = #count{C: conj(C), r_as(as(C, T), as(D, T))}. 