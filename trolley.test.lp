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

% events/actions: run(track, trackNo), switch, crash

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), -holdsAt(switched, 0), T = 1. 
T = 1 :- happens(switch, T). % enforce that we can only switch at time 1
happens(run(sideTrack, 0)) :- holdsAt(switched, T). % triggered events. Sufficient condition? 

%TODO: distinguish the semantics of trigger condition for happens vs intitiates
happens(run(Trk, TrkNo + 1), T) :- holdsAt(on(train, Trk, TrkNo), T), -holdsAt(crashed, T). 

initiates(run(Trk, TrkNo), on(train, Trk, TrkNo + 1), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).
initiates(run(Trk, TrkNo), crashed, T) :- -holdsAt(crashed, T), time(T), holdsAt(on(group(_), Trk, TrkNo), T). 
terminates(run(Trk, TrkNo), alive(group(G)), T)  :- time(T), holdsAt(on(group(G), Trk, TrkNo), T).

happens(switch, 1). 


prints(holdsAt(on(train, Trk, TrkNo), T)) :- holdsAt(on(train, Trk, TrkNo), T). 
prints(nonInertial(X)) :- nonInertial(X).

#show prints/1.
