% clipped if terminated or released. Exclusive at two ends
clipped(T1, F, T2) :- terminates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 
clipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 

% declipped if initiated or released. Exclusive at two ends.
declipped(T1, F, T2) :- initiates(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 
declipped(T1, F, T2) :- releases(E, F, T), happens(E, T), T1 < T, T < T2, time(T1), time(T2), not nonInertial(F). 

% holds if initially true and not clipped
holdsAt(F, T) :- initiallyP(F), not clipped(0, F, T), time(T), not nonInertial(F). 
negholdsAt(F, T) :- initiallyN(F), not declipped(0, F, T), time(T), not nonInertial(F). 

% continues to hold if not interrupted
holdsAt(F, T2) :- initiates(E, F, T1), happens(E, T1), not clipped(T1, F, T2), T1 < T2, time(T1), time(T2), not nonInertial(F). 
negholdsAt(F, T2) :- terminates(E, F, T1), happens(E, T1), not declipped(T1, F, T2), T1 < T2, time(T1), time(T2), not nonInertial(F). 

% holding f for nonInertial fluents. nonInertial fluents can be directly derived from other fluents
holdsAt(F, 0) :- initiallyP(F), nonInertial(F). 
negholdsAt(F, 0) :- initiallyN(F), nonInertial(F). 
holdsAt(F, T) :- initiates(E, F, T), happens(E, T), nonInertial(F). 

% releases removes the fluent from the commonsense law of inertia, so in some model it can be true 
% and some can be false --> this "indeterminate" rule is to check for any such dangling fluents
% also make sure fluents must not be unexpectedly indeterminate at any time points. 
indeterminate(P, T) :- not holdsAt(P, T), not negholdsAt(P, T), time(T), fluent(P), not nonInertial(P). 

% track moment where fluent changed
fluentFlipped(P, T + 1, toTrue) :- negholdsAt(P, T), holdsAt(P, T + 1). 
fluentFlipped(P, T + 1, toFalse) :- holdsAt(P, T), negholdsAt(P, T + 1). 

% enforces that all happens must occur after the initial time. 
T > 0 :- happens(E, T). 

%#show indeterminate/2. #show fluentFlipped/3.

% Required domain predicates: time, fluent, event
%% END OF EVENT CALC AXIOMS

%% START OF TROLLEY PROBLEM ENCODING
% define domain, finite predicates-dataset
time(0..10).
fluent(crashed; switched). %TODO: how to capture the on fluents
maxTracks(7). 

initiallyN(switched). 
initiallyP(on(group(1), sideTrack, 3); on(group(5), mainTrack, 4)). 
initiallyP(alive(group(1)); alive(group(5))). 
initiallyN(crashed). 
initiallyP(on(train, mainTrack, 0)).  nonInertial(on(train, mainTrack, 0)). % how can I say nonInertial(on(train, Var, Var))

%:- negholdsAt(P, T), holdsAt(P, T). 
% events/actions: run(track, trackNo), switch, crash

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), negholdsAt(switched, 0), T = 1. 
T = 1 :- happens(switch, T). % enforce that we can only switch at time 1
happens(run(sideTrack, 0), T) :- holdsAt(switched, T), T = 2. % triggered events. Sufficient condition? 

%TODO: distinguish the semantics of trigger condition for happens vs intitiates
happens(run(Trk, TrkNo), T) :- holdsAt(on(train, Trk, TrkNo), T), negholdsAt(crashed, T), maxTracks(Q), TrkNo < Q, T > 0.

nonInertial(on(train, Trk, TrkNo + 1)) :- negholdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).
initiates(run(Trk, TrkNo), on(train, Trk, TrkNo + 1), T) :- negholdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).
initiates(run(Trk, TrkNo), crashed, T) :- negholdsAt(crashed, T), time(T), holdsAt(on(group(_), Trk, TrkNo), T). 
terminates(run(Trk, TrkNo), alive(group(G)), T)  :- time(T), holdsAt(on(group(G), Trk, TrkNo), T).

%happens(switch, 1). 

#show happens/2.
prints(holdsAt(on(train, Trk, TrkNo), T)) :- holdsAt(on(train, Trk, TrkNo), T). 
prints(nonInertial(X)) :- nonInertial(X).

#show prints/1.
