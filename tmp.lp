% clipped if terminated or released
clipped(T1, F, T2) :- terminates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 
clipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 

% declipped if initiated or released
declipped(T1, F, T2) :- initiates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 
declipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2). 

% holds if initially true and not clipped
holdsAt(F, T) :- initiallyP(F), not clipped(0, F, T), time(T). 
negholdsAt(F, T) :- initiallyN(F), not declipped(0, F, T), time(T). 

% continues to hold if not interrupted
holdsAt(F, T2) :- initiates(E, F, T1), happens(E, T1), not clipped(T1, F, T2), T1 < T2, time(T1), time(T2). 
negholdsAt(F, T2) :- terminates(E, F, T1), happens(E, T1), not declipped(T1, F, T2), T1 < T2, time(T1), time(T2). 

% holding f for nonInertial fluents. nonInertial fluents can be directly derived from other fluents
holdsAt(F, 0) :- initiallyP(F), nonInertial(F). 
negholdsAt(F, 0) :- initiallyN(F), nonInertial(F). 
holdsAt(F, T) :- initiates(E, F, T), happens(E, T), nonInertial(F). 

% releases removes the fluent from the commonsense law of inertia, so in some model it can be true 
% and some can be false --> this "indeterminate" rule is to check for any such dangling fluents
% also make sure fluents must not be unexpectedly indeterminate at any time points. 
indeterminate(P, T) :- not holdsAt(P, T), not negholdsAt(P, T), time(T), fluent(P). 

% track moment where fluent changed
fluentFlipped(P, T + 1, toTrue) :- negholdsAt(P, T), holdsAt(P, T + 1). 
fluentFlipped(P, T + 1, toFalse) :- holdsAt(P, T), negholdsAt(P, T + 1). 

#show indeterminate/2. #show fluentFlipped/3.

% Required domain predicates: time, fluent, event
%% END OF EVENT CALC AXIOMS
% yale shooting problem
time(0..10). fluent(loaded; alive; dead). 
initiates(load, loaded, T) :- time(T). 
initiates(shoot, dead, T) :- holdsAt(loaded, T). 
terminates(shoot, alive, T) :- holdsAt(loaded, T).
initiallyP(alive). 
initiallyN(loaded).
initiallyN(dead). 
%happens(load, 1). happens(sneeze, 3). happens(shoot, 5). 

happens(load, 0). 
prints(F, T) :- holdsAt(F, T), negholdsAt(F, T). 

#show prints/2.