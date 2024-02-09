% Event Calculus with Possible Worlds


% clipped if terminated or released. Exclusive at two ends
clipped(W, T1, F, T2) :- terminates(W, E, F, T), happens(W, E, T), T1 < T, T < T2, time(T1), time(T2). 
clipped(W, T1, F, T2) :- releases(W, E, F, T), happens(W, E, T), T1 < T, T < T2, time(T1), time(T2). 

% declipped if initiated or released. Exclusive at two ends.
declipped(W, T1, F, T2) :- initiates(W, E, F, T), happens(W, E, T), T1 < T, T < T2, time(T1), time(T2). 
declipped(W, T1, F, T2) :- releases(W, E, F, T), happens(W, E, T), T1 < T, T < T2, time(T1), time(T2). 

% holds if initially true and not clipped in between
holdsAt(W, F, T) :- initiallyP(W, F), not clipped(W, 0, F, T), time(T). 
-holdsAt(W, F, T) :- initiallyN(W, F), not declipped(W, 0, F, T), time(T). 

% continues to hold if not interrupted
holdsAt(W, F, T2) :- initiates(W, E, F, T1), happens(W, E, T1), not clipped(W, T1, F, T2), T1 < T2, time(T1), time(T2). 
-holdsAt(W, F, T2) :- terminates(W, E, F, T1), happens(W, E, T1), not declipped(W, T1, F, T2), T1 < T2, time(T1), time(T2). 

% track moment where fluent changed
fluentFlipped(W, P, T + 1, toTrue) :- not holdsAt(W, P, T), holdsAt(W, P, T + 1), time(T). % fluents initiated at time > 0
fluentFlipped(W, P, T + 1, toTrue) :- -holdsAt(W, P, T), holdsAt(W, P, T + 1). 
fluentFlipped(W, P, T + 1, toFalse) :- holdsAt(W, P, T), -holdsAt(W, P, T + 1). 

% enforce that all event happening must occur time point 0. 
T > 0 :- happens(W, E, T).

% domain predicates for events, fluents, timepoint