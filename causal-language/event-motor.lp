% Axioms for relations between events - fluents

%%% TODO: what are the allowed predicates to use for users %%%

%%% Docs %%%
% Ontologies: event[name, predStates, effState] - {action, auto}. 

event(A, GD, Eff) :- action(A, GD, Eff). 
event(U, GD, Eff) :- auto(U, GD, Eff). 

%%% Triggering of events axioms %%%

% Removed priority of concurrent events: this should not be a means of resolving conflict
triggered(A, GD, T) :- action(A, GD, Eff), performs(A, T), holds(GD, T).  % for action, predStates hold + agent performs
triggered(U, GD, T) :- auto(U, GD, Eff), holds(GD, T).  % for autoEvent, predStates hold is enough
happens(E, GD, T) :- triggered(E, GD, T).


%%% Effect of events axioms %%%

apply(E, Eff, T) :- happens(E, GD, T), event(E, GD, Eff). 

% Relation between event and atomic fluent




