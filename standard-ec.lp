% clipped if terminated or released
clipped(T1, F, T2) :- terminates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 
clipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 

% declipped if initiated or released
declipped(T1, F, T2) :- initiates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 
declipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 

% holds if initially true and not clipped
holdsAt(F, T) :- initiallyP(F), not clipped(0, F, T), time(T), not nonInertial(F). 
-holdsAt(F, T) :- initiallyN(F), not declipped(0, F, T), time(T), not nonInertial(F). 

% continues to hold if not interrupted
holdsAt(F, T2) :- initiates(E, F, T1), happens(E, T1), not clipped(T1, F, T2), T1 < T2, time(T1), time(T2), not nonInertial(F). 
-holdsAt(F, T2) :- terminates(E, F, T1), happens(E, T1), not declipped(T1, F, T2), T1 < T2, time(T1), time(T2), not nonInertial(F). 

% holding f for nonInertial fluents. nonInertial fluents can be directly derived from other fluents
holdsAt(F, 0) :- initiallyP(F), nonInertial(F). 
-holdsAt(F, 0) :- initiallyN(F), nonInertial(F). 
holdsAt(F, T) :- initiates(E, F, T), happens(E, T), nonInertial(F). 

% releases removes the fluent from the commonsense law of inertia, so in some model it can be true 
% and some can be false --> this "indeterminate" rule is to check for any such dangling fluents
% also make sure fluents must not be unexpectedly indeterminate at any time points. 
indeterminate(P, T) :- not holdsAt(P, T), not -holdsAt(P, T), time(T), fluent(P), not nonInertial(P). 

% track moment where fluent changed
fluentFlipped(P, T + 1, toTrue) :- -holdsAt(P, T), holdsAt(P, T + 1). 
fluentFlipped(P, T + 1, toFalse) :- holdsAt(P, T), -holdsAt(P, T + 1). 

%#show indeterminate/2. #show fluentFlipped/3.

% Required domain predicates: time, fluent, event
%% END OF EVENT CALC AXIOMS

% define domain, finite predicates-dataset
time(0..10).
fluent(trainRunning; trainCrashed; switched). %TODO: how to capture the on fluents
maxTracks(7). 

initiallyN(switched). 
initiallyP(on(group1, sideTrack, 3); on(group5, mainTrack, 4)). 
initiallyP(alive(group1); alive(group5)). 
initiallyP(trainRunning). initiallyN(trainCrashed). 
initiallyP(on(train, mainTrack, 0)).  nonInertial(on(train, mainTrack, 0)). % how can I say nonInertial(on(train, Var, Var))


% new nonInertial fluent generated. If keeps running, train moves to a new fluent-state. 
holdsAt(on(train, Trk, TrkNo + 1), T + 1) :- holdsAt(on(train, Trk, TrkNo), T), holdsAt(trainRunning, T), maxTracks(V), TrkNo < V. 
nonInertial(on(train, Trk, TrkNo + 1)) :- holdsAt(on(train, Trk, TrkNo), T), holdsAt(trainRunning, T), maxTracks(V), TrkNo < V. 

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), -holdsAt(switched, 0), T = 0. 
T = 0 :- happens(switch, T). % enforce that we can only switch at time 01
holdsAt(on(train, sideTrack, 1), T + 1) :- holdsAt(switched, T), T = 0, holdsAt(on(train, mainTrack, 0), T). 
nonInertial(on(train, sideTrack, 1)) :- holdsAt(switched, T), T = 0, holdsAt(on(train, mainTrack, 0), T). 



% prints
prints(holdsAt(on(train, Trk, TrkNo), T)) :- holdsAt(on(train, Trk, TrkNo), T). 
prints(nonInertial(X)) :- nonInertial(X).

#show prints/1.

