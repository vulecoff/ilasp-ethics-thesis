%% START OF TROLLEY PROBLEM ENCODING
% define domain, finite predicates-dataset
time(0..12).
fluent(crashed; switched). %TODO: how to capture the on fluents
maxTracks(7). 
track(mainTrack; sideTrack). 
trackNo(0..X) :- maxTracks(X). 
switchTrack(from(mainTrack, 1), to(sideTrack, 1)). 

initiallyN(switched). 
initiallyP(on(group(1), sideTrack, 4); on(group(5), mainTrack, 5)). 
initiallyP(alive(group(1)); alive(group(5))). 
initiallyN(crashed). 
initiallyP(on(train, mainTrack, 0)).  

% events/actions: run(track, trackNo), switch, crash

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), -holdsAt(switched, 0), T = 1. 
T = 1 :- happens(switch, T). % enforce that we can only switch at time 1

% triggered event: keeps running if currently on this track and not crashed
happens(run(Trk, TrkNo + 1), T) :- T >= 1, not switchTrack(from(Trk, TrkNo), _), holdsAt(on(train, Trk, TrkNo), T), 
                                    -holdsAt(crashed, T), maxTracks(Q), TrkNo < Q. % if not switchable track, keep going to the next track
happens(run(ToTrk, ToTrkNo), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(on(train, FromTrk, FromTrkNo), T), holdsAt(switched, T).  % if on switchable track, and decides to switch
happens(run(FromTrk, FromTrkNo+1), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(on(train, FromTrk, FromTrkNo), T), -holdsAt(switched, T). % if not on switchable track, and decides to not switch



% effects of running. If currently running on this track --> go onto the next track
% should initiates --> terminates. Or should it all be on the left handside of the original conditions.
initiates(run(Trk, TrkNo + 1), on(train, Trk, TrkNo + 1), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).
terminates(run(Trk, TrkNo + 1), on(train, Trk, TrkNo), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).

initiates(run(ToTrk, ToTrkNo), on(train, ToTrk, ToTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a bridge track
                                                                    -holdsAt(crashed, T), time(T), holdsAt(on(train, FromTrk, FromTrkNo), T). 
terminates(run(ToTrk, ToTrkNo), on(train, FromTrk, FromTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a bridge track
                                                                    -holdsAt(crashed, T), time(T), holdsAt(on(train, FromTrk, FromTrkNo), T). 

initiates(run(Trk, TrkNo), crashed, T) :- -holdsAt(crashed, T), time(T), holdsAt(on(group(X), Trk, TrkNo), T). 
terminates(run(Trk, TrkNo), alive(group(G)), T)  :- time(T), holdsAt(on(group(G), Trk, TrkNo), T).

%happens(switch, 1). 

%prints(initiates(run(sideTrack, P), on(P1, P2, P3),  K)) :- initiates(run(sideTrack, P), on(P1,P2,P3),  K). 
prints(holdsAt(on(train, Trk, TrkNo), T)) :- holdsAt(on(train, Trk, TrkNo), T), testTime(T). 
prints(-holdsAt(on(train, Trk, TrkNo), T)) :- -holdsAt(on(train, Trk, TrkNo), T), testTime(T). 
prints(happens(E, T)) :- happens(E, T), testTime(T). 
prints(holdsAt(switched, T)) :- holdsAt(switched, T), testTime(T).
prints(-holdsAt(switched, T)) :- -holdsAt(switched, T), testTime(T). 
%prints(flipped(on(train, Trk, TrkNo), T + 1, toTrue)) :- -holdsAt(on(train, Trk, TrkNo), T), holdsAt(on(train, Trk, TrkNo), T+1).
%prints(flipped(on(train, Trk, TrkNo), T + 1, toFalse)) :- holdsAt(on(train, Trk, TrkNo), T), -holdsAt(on(train, Trk, TrkNo), T+1).
%prints(nonInertial(X)) :- nonInertial(X).
%prints(holdsAt(crashed, T)) :- holdsAt(crashed, T). 
%prints(happens(X, Y)) :- happens(X, Y). 
%prints(holdsAt(switched, T+ 1)) :- -holdsAt(switched, T), holdsAt(switched, T + 1). 
prints(dead(Q)) :- -holdsAt(alive(Q), T).
%testTime(2). 
#show prints/1.

