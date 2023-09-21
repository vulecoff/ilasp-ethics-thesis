% Logic of event: initiates, terminates: (event, fluent, time)
% Logic of fluent: holds(fluent), nonInertial(F), automatic(E), clipped(fluent, time)
% Basic facts: effect(event, fluent), precondition(f, e), occurs(event, time)


initiates(E, P, T) :- effect(E, P), occurs(E, T). 
terminates(E, P, T) :- effect(E, -P), occurs(E, T). 
clipped(P, T) :- terminates(E, P, T). 

holds(P, T + 1) :- initiates(E, P, T). 
holds(P, 0) :- initially(P). 
holds(P, T + 1) :- holds(P, T), not clipped(P, T), not nonInertial(P). 
holds(-S, T) :- not holds(S, T), _fluent(S), _time(T). 

missingPrecondition(F, E, T) :- precondition(F, E), not holds(F, T). 
% precondition, fluent F is needed for event V. 
% for automatic event? 
incomplete(E, T) :- missingPrecondition(F, E, T). 
possible(E, T) :- not incomplete(E, T). 
% any event is possible. For spontaneous/automatic event
overtaken(E1, T) :- possible(E1, T), possible(E2, T), priority(E2, E1), E1 != E2. % get the best
occurs(E, T) :- possible(E, T), not overtaken(E, T), automatic(E). 
:- occurs(E, T), not possible(E, T). 

% confusion between notions of necessary/sufficent causality
consequence(E, F) :- effect(E, F), occurs(E, T), holds(F, T + 1). 
consequence(F, E) :- precondition(F, E), holds(F, T), occurs(E, T). 
consequence(C1, C3) :- consequence(C1, C2), consequence(C2, C3). 
% what's the point of this? 
consequence(C, C) :- holds(C, T). 
consequence(C, C) :- occurs(C, T). 

% Suzy & Billy test??
