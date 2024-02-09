% clipped if terminated or released. Exclusive at two ends
clipped(T1, F, T2) :- terminates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 
clipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 

% declipped if initiated or released. Exclusive at two ends.
declipped(T1, F, T2) :- initiates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 
declipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 

% holds if initially true and not clipped
holdsAt(F, T) :- initiallyP(F), not clipped(0, F, T), time(T). 
-holdsAt(F, T) :- initiallyN(F), not declipped(0, F, T), time(T). 

% continues to hold if not interrupted
holdsAt(F, T2) :- initiates(E, F, T1), happens(E, T1), not clipped(T1, F, T2), T1 < T2, time(T1), time(T2). 
-holdsAt(F, T2) :- terminates(E, F, T1), happens(E, T1), not declipped(T1, F, T2), T1 < T2, time(T1), time(T2). 

% holding f for nonInertial fluents. nonInertial fluents can be directly derived from other fluents
% nonInertial can be simulated by immediately terminates-ing after initiated. Effect constraint (to terminate old fluents) or triggered events to automatically trigger the terminationHappening

% releases removes the fluent from the commonsense law of inertia, so in some model it can be true 
% and some can be false --> this "indeterminate" rule is to check for any such dangling fluents
% also make sure fluents must not be unexpectedly indeterminate at any time points. 
indeterminate(P, T) :- not holdsAt(P, T), not -holdsAt(P, T), time(T), fluent(P). 

% track moment where fluent changed
fluentFlipped(P, T + 1, toTrue) :- not holdsAt(P, T), holdsAt(P, T + 1), time(T). % fluents initiated at time > 0
fluentFlipped(P, T + 1, toTrue) :- -holdsAt(P, T), holdsAt(P, T + 1). 
fluentFlipped(P, T + 1, toFalse) :- holdsAt(P, T), -holdsAt(P, T + 1). 

% enforces that all happens must occur after the initial time. 
T > 0 :- happens(E, T). 

%#show indeterminate/2. #show fluentFlipped/3.

%TODO: next. Happens at zero
% Required domain predicates: time, fluent, event
%% END OF EVENT CALC AXIOMS

