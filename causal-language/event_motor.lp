% Axioms for relations between events - fluents

%%% TODO: what are the allowed predicates to use for users %%%

%%% Docs %%%
% Ontologies: event[name, predStates, effState] - {action, auto}. 
% GD: goal descriptor, states relevant to the triggering of events, anything that can be "holds()", disjuctive + conjuctive
% Eff: conjunctive only, holds by the effect of event

%%% Event and Actions %%%
event(A, GD, Eff) :- action(A, GD, Eff). 
event(U, GD, Eff) :- auto(U, GD, Eff). 
event(E) :- event(E, GD, Eff).


%%% Time points %%%
time(0..T) :- maxTime(T).

%%% Triggering of events axioms %%%

% TODO: Replace priority feature 
triggered(A, GD, T) :- action(A, GD, Eff), performs(A, T), holds(GD, T).  % for action, predStates hold + agent performs
triggered(U, GD, T) :- auto(U, GD, Eff), holds(GD, T).  % for autoEvent, predStates hold is enough
overtaken(E1,T) :- triggered(E1, _, T), happens(E2, _, T), priority(E2, E1), E2!=E1.
happens(E,GD,T) :- triggered(E, GD, T), not overtaken(E, T).


%%% Effect of events axioms %%%

apply(E, Eff, T) :- happens(E, GD, T), event(E, GD, Eff), not delayedEff(E, Eff, TD): time(TD).
% T + TD is the time that the effect will takes effect.
apply(E, Eff, T + TD - 1) :- happens(E, GD, T), event(E, GD, Eff), delayedEff(E, Eff, TD),
                            time(TD), maxTime(M), T + TD <= M, TD > 0.

% TODO: here is more of a warning than error
error("Delayed effect time exceeds maxtime", info(delayedEff(E, Eff, TD), happens(E, T))) 
    :- happens(E, GD, T), event(E, GD, Eff), delayedEff(E, Eff, TD), maxTime(M), TD + T > M. 

% Relation between event and atomic fluent
% initiated/terminated = actually happened
initiated(E, F, T) :- apply(E, Eff, T), in(Eff, F), holds(neg(F), T), fluent(F).  % <experimental> 
terminated(E, F, T) :- apply(E, Eff, T), in(Eff, neg(F)), holds(F, T), fluent(F). % <experimental>
% TODO: potential shortcoming - if already dead, that action will not be recorded, only actions that affect a change in state are recorded


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

%%% States and fluents. DNF forms. 
% Primitive fluents: literal are either F, or -F
literal(neg(F)) :- fluent(F). 
literal(F) :- fluent(F). 
in(L, L) :- literal(L).

% Compound states
holds(true, T) :- time(T).  
% single out compound as in action's effect, not part of ANY events' effect (use of anon var)
% Note: F here is literal: F, neg(F)
% TODO: may be clunky logic, test this? How. 
holds(C, T) :- conj(C), time(T), holds(F, T):in(C, F);  not event(_, _, C).  
holds(D, T) :- disj(D), holds(F, T), time(T), in(D, F), not event(_, _, D). 

#show error/2.
#show holds/2.
#show happens/3. 

