%% START OF TROLLEY PROBLEM ENCODING
% define domain, finite predicates-dataset
time(0..12).
fluent(crashed; switched). %TODO: how to capture the on fluents
maxTracks(7). 
track(mainTrack; sideTrack). 
trackNo(0..X) :- maxTracks(X). 
patients(group(1); group(5); bystander). 

switchTrack(from(mainTrack, 1), to(sideTrack, 1)). % connecting track from [] to []
bridgeOnTop(mainTrack, 2). % initially (implicitly), bystander and I are on the bridge

initiallyN(switched). 
initiallyP(on(group(1), sideTrack, 4); on(group(5), mainTrack, 5)). 
initiallyP(alive(group(1)); alive(group(5)); alive(bystander)). 
initiallyN(crashed). 
initiallyP(on(train, mainTrack, 0)).  

% events/actions: run(track, trackNo), switch, crash

% causal effect 
% switches only occur at first time point
initiates(switch, switched, T) :- time(T), -holdsAt(switched, 0), T = 1. 
T = 1 :- happens(switch, T). % enforce that we can only switch at time 1

% effects of pushing
initiates(push, on(bystander, Trk, TrkNo), T) :- time(T), T = 1, bridgeOnTop(Trk, TrkNo), track(Trk), trackNo(TrkNo). 
terminates(push, alive(bystander), T) :- time(T), T = 1. 

% triggered event: keeps running if currently on this track and not crashed
% if on the switchable(decision) track and switched or not switched? 
happens(run(Trk, TrkNo + 1), T) :- T >= 1, not switchTrack(from(Trk, TrkNo), _), holdsAt(on(train, Trk, TrkNo), T), 
                                    -holdsAt(crashed, T), maxTracks(Q), TrkNo < Q. % if not switchable track, keep going to the next track
happens(run(ToTrk, ToTrkNo), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(on(train, FromTrk, FromTrkNo), T), holdsAt(switched, T).  % if on switchable track, and decides to switch
happens(run(FromTrk, FromTrkNo+1), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(on(train, FromTrk, FromTrkNo), T), -holdsAt(switched, T). % if not on switchable track, and decides to not switch
happens(crash, T) :- holdsAt(on(train, Trk, TrkNo), T), holdsAt(on(P, Trk, TrkNo), T), patients(P). 

% eventify the dead conditions
happens(deathOf(X), T) :- -holdsAt(alive(X), T), patients(X), time(T). 

% effects of training running. If currently running on this track --> go onto the next track
% should initiates --> terminates. Or should it all be on the left handside of the original conditions.
% [happens --> but doesn't have any effect]
initiates(run(Trk, TrkNo + 1), on(train, Trk, TrkNo + 1), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).
terminates(run(Trk, TrkNo + 1), on(train, Trk, TrkNo), T) :- -holdsAt(crashed, T), time(T), holdsAt(on(train, Trk, TrkNo), T).

initiates(run(ToTrk, ToTrkNo), on(train, ToTrk, ToTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a connecting track
                                                                    -holdsAt(crashed, T), time(T), holdsAt(on(train, FromTrk, FromTrkNo), T). 
terminates(run(ToTrk, ToTrkNo), on(train, FromTrk, FromTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a connecting track
                                                                    -holdsAt(crashed, T), time(T), holdsAt(on(train, FromTrk, FromTrkNo), T). 

% effects of crashing. !IMPORTANT Semantically speaking: does the train running cause the crash?
%initiates(run(Trk, TrkNo), crashed, T) :- -holdsAt(crashed, T), time(T), holdsAt(on(P, Trk, TrkNo), T), patients(P). 
initiates(crash, crashed, T) :- time(T), -holdsAt(crashed, T). 
terminates(run(Trk, TrkNo), alive(P), T)  :- time(T), holdsAt(on(P, Trk, TrkNo), T), patients(P).



% to switch or to not switch
0 {happens(switch, 1); happens(push, 1)} 1.


%debug(initiates(run(sideTrack, P), on(P1, P2, P3),  K)) :- initiates(run(sideTrack, P), on(P1,P2,P3),  K). 
debug(holdsAt(on(O, Trk, TrkNo), T)) :- holdsAt(on(O, Trk, TrkNo), T), testTime(T). 
debug(-holdsAt(on(O, Trk, TrkNo), T)) :- -holdsAt(on(O, Trk, TrkNo), T), testTime(T). 
debug(happens(E, T)) :- happens(E, T), testTime(T). 
debug(holdsAt(switched, T)) :- holdsAt(switched, T), testTime(T).
debug(-holdsAt(switched, T)) :- -holdsAt(switched, T), testTime(T). 
debug(holdsAt(crashed, T)) :- holdsAt(crashed, T), testTime(T).
testTime(4). 
%prints(flipped(on(train, Trk, TrkNo), T + 1, toTrue)) :- -holdsAt(on(train, Trk, TrkNo), T), holdsAt(on(train, Trk, TrkNo), T+1).
%prints(flipped(on(train, Trk, TrkNo), T + 1, toFalse)) :- holdsAt(on(train, Trk, TrkNo), T), -holdsAt(on(train, Trk, TrkNo), T+1).
%prints(nonInertial(X)) :- nonInertial(X).
%prints(holdsAt(crashed, T)) :- holdsAt(crashed, T). 
%prints(happens(X, Y)) :- happens(X, Y). 
%prints(holdsAt(switched, T+ 1)) :- -holdsAt(switched, T), holdsAt(switched, T + 1). 
prints(dead(Q)) :- -holdsAt(alive(Q), T).
prints(switch_happened) :- happens(switch, T). 
prints(push_happened) :- happens(push, T). 
prints(switch_not_happened) :- #count {T: happens(switch, T)} = 0. 
prints(push_not_happened) :- #count {T: happens(push, T)} = 0. 

#show prints/1.
%#show debug/1.

