%% START OF TROLLEY PROBLEM ENCODING
% define domain, finite predicates-dataset
time(0..12).
fluent(crashed; switched). %TODO: how to capture the on fluents
maxTracks(7). 

initiallyN(switched). 
initiallyP(on(group(1), sideTrack, 3); on(group(5), mainTrack, 4)). 
initiallyP(alive(group(1)); alive(group(5))). 
initiallyN(crashed). 
initiallyP(on(train, mainTrack, 0)).  nonInertial(on(train, mainTrack, 0)). % how can I say nonInertial(on(train, Var, Var))

% events/actions: run(track, trackNo), switch, crash

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), -holdsAt(switched, 0), T = 1. 
T = 1 :- happens(switch, T). % enforce that we can only switch at time 1
% GOAL: to initiate --> on either track? What if not switched? 
% the difference in DECIDES to switch, or not SWITCH. action omission? effect of NOT-DOING it

% what is the best way to model action --> action semantics? Instantenous action? 
% or fluent -> fluent semantics. can only be achieved by introducing a triggered event by the original fluent
happens(run(sideTrack, 1), T) :- happens(switch, T).
holdsAt(on(train, sideTrack, 1), T) :- happens(switch, T).
happens(run(mainTrack, 1), T) :- not happens(switch, T), time(T), T = 1. 
holdsAt(on(train, mainTrack, 1), T) :- not happens(switch, T), time(T), T = 1. 

% INTERESTING: Does decision of switch matter? It would kill the people right away. But 
% if not I couldve prevented that, --> moral

happens(run(Trk, TrkNo), T) :- T >= 2, holdsAt(on(train, Trk, TrkNo), T), -holdsAt(crashed, T), maxTracks(Q), TrkNo < Q.

nonInertial(on(train, Trk, TrkNo + 1)) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T), TrkNo >= 1. 
initiates(run(Trk, TrkNo), on(train, Trk, TrkNo + 1), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T), TrkNo >= 1. 
initiates(run(Trk, TrkNo), crashed, T) :- -holdsAt(crashed, T), time(T), holdsAt(on(group(X), Trk, TrkNo), T). 
terminates(run(Trk, TrkNo), alive(group(G)), T)  :- time(T), holdsAt(on(group(G), Trk, TrkNo), T).

happens(switch, 1). 

%prints(initiates(run(mainTrack, P), on(P1, P2, P3),  K)) :- initiates(run(mainTrack, P), on(P1,P2,P3), Y,  K). 
%prints(holdsAt(on(train, Trk, TrkNo), T)) :- holdsAt(on(train, Trk, TrkNo), T). 
%prints(nonInertial(X)) :- nonInertial(X).
%prints(holdsAt(crashed, T)) :- holdsAt(crashed, T). 
prints(dead(Q)) :- -holdsAt(alive(Q), T).
#show prints/1.

% what is the formal way to "trigger" action, or non-inertial fluents? 