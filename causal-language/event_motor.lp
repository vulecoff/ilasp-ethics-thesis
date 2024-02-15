% Axioms for relations between events - fluents

%%% TODO: what are the allowed predicates to use for users %%%

%%% Docs %%%
% Ontologies: event[name, predStates, effState] - {action, auto}. 

%%% Event and Actions %%%
event(A, GD, Eff) :- action(A, GD, Eff). 
event(U, GD, Eff) :- auto(U, GD, Eff). 
event(E) :- event(E, GD, Eff).


%%% Time points %%%
time(0..T) :- maxTime(T).

%%% Triggering of events axioms %%%

% Removed priority of concurrent events: this should not be a means of resolving conflict
triggered(A, GD, T) :- action(A, GD, Eff), performs(A, T), holds(GD, T).  % for action, predStates hold + agent performs
triggered(U, GD, T) :- auto(U, GD, Eff), holds(GD, T).  % for autoEvent, predStates hold is enough
happens(E, GD, T) :- triggered(E, GD, T).


%%% Effect of events axioms %%%

apply(E, Eff, T) :- happens(E, GD, T), event(E, GD, Eff). 

% Relation between event and atomic fluent
% initiated/terminated = actually happened
initiated(E, F, T) :- apply(E, Eff, T), in(Eff, F), holds(neg(F), T), fluent(F).  % <experimental>
terminated(E, F, T) :- apply(E, Eff, T), in(Eff, neg(F)), holds(F, T), fluent(F). % <experimental>

% influence of events on fluents

holds(F, 0) :- initiallyP(F), fluent(F). 
holds(neg(F), 0) :- initiallyN(F), fluent(F). 
holds(F, T + 1) :- initiated(E, F, T), fluent(F). 
holds(neg(F), T + 1) :- terminated(E, F, T), fluent(F). 

% Inertia of fluents. Compound states do not have inertia

holds(F, T + 1) :- holds(F, T), fluent(F), time(T), maxTime(T2), T < T2 , not terminated(E, F, T): event(E). 
holds(neg(F), T + 1) :- holds(neg(F), T), fluent(F), time(T), maxTime(T2), T < T2, not initiated(E, F, T): event(E). 

% Constraints. For now, print error. 

% :- holds(F, T), holds(neg(F), T), time(T). 
error("Opposite fluents hold at same time", info(F, T)) :- holds(F, T), holds(neg(F), T), time(T). 
error("Indeterminate fluent", info(F, T)) :- fluent(F), time(T), not holds(F, T), not holds(neg(F), T). 

%%% Compound states. DNF forms. 

holds(true, T) :- time(T).  
% single out compound as in action's effect. A little bit clunky in logic here. <TODO>. 
% Note: F here is literal: F, neg(F): TODO: what is the use of literal in their programs
holds(C, T) :- conj(C), time(T), holds(F, T):in(C, F);  not event(_, _, C).  
holds(D, T) :- disj(D), holds(F, T), time(T), in(D, F), not event(_, _, D). 

#show error/2.
#show holds/2.
#show happens/3. 

