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
% what is the point of precondition???