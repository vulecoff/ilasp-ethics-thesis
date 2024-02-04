% Problem encoding of the trolley variations Switch versus Push-The-Fatman

%%% Domain predicates
maxTime(11). time(0..T) :- maxTime(T).  
maxTracks(7). track(mainTrack; sideTrack). trackNo(0..X) :- maxTracks(X). 
patients(group(1); group(5); fatman). 
externalActions(push; switch). 

world(base). 
switchTrack(from(mainTrack, 1), to(sideTrack, 1)). 
bridgeOnTop(mainTrack, 2). 

%%% Initial state
initiallyN(W, switched) :- world(W). 
initiallyP(W, (on(group(1), sideTrack, 4); on(group(5), mainTrack, 5))) :- world(W). 
initiallyN(W, crashed) :- world(W). 
initiallyP(W, on(trolley, mainTrack, 0)) :- world(W). 
initiallyP(W, alive(P)) :- patients(P), not removedFromWorld(W, P), world(W). % initially all people are alive. 


%%% Effect of external actions
% enforce that all external actions must occur at time 1
T = 1 :- happens(W, A, T), time(T), world(W), externalActions(A). 

initiates(W, switch, switched, T) :- time(T), T = 1, world(W). 
initiates(W, push, on(fatman, Trk, TrkNo), T) :- time(T), T = 1, bridgeOnTop(Trk, TrkNo), not removedFromWorld(W, fatman), world(W). 
% terminates(W, push, alive(fatman), T) :- time(T), T = 1, not removedFromWorld(W, fatman), world(W). 

%%% Automatic happenings of the running trolley
% keeps running to **next** track if not currently on the switchable track
% run() = **starts* to run on the next track
happens(W, run(Trk, TrkNo + 1), T) :- T >= 1, not switchTrack(from(Trk, TrkNo), _), holdsAt(W, on(trolley, Trk, TrkNo), T), 
                                    -holdsAt(W, crashed, T), maxTracks(Q), TrkNo < Q, 
                                    #count {P: holdsAt(W, on(P, Trk, TrkNo), T), patients(P)} = 0. % make sure no other patient is on this track
% run to the ToTrk if switched and on the switchable track
happens(W, run(ToTrk, ToTrkNo), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(W, on(trolley, FromTrk, FromTrkNo), T), holdsAt(W, switched, T), 
                                    #count {P: holdsAt(W, on(P, FromTrk, FromTrkNo), T), patients(P)} = 0. 
% keeps running if not switched
happens(W, run(FromTrk, FromTrkNo + 1), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), _), 
                                            holdsAt(W, on(trolley, FromTrk, FromTrkNo), T), -holdsAt(W, switched, T), 
                                            #count {P: holdsAt(W, on(P, FromTrk, FromTrkNo), T), patients(P)} = 0. 
% crash if trolley and people on the same location
happens(W, crash(Trk, TrkNo), T) :- T >= 1, holdsAt(W, on(trolley, Trk, TrkNo), T), holdsAt(W, on(P, Trk, TrkNo), T), 
                                    patients(P), not removedFromWorld(W, P), world(W). 

%%% Effect of trolley's actions
% run on a new trackNo
initiates(W, run(Trk, TrkNo + 1), on(trolley, Trk, TrkNo + 1), T) :- -holdsAt(W, crashed, T), time(T), holdsAt(W, on(trolley, Trk, TrkNo), T).
% no longer on the previous track --> terminates past fluent
terminates(W, run(Trk, TrkNo + 1), on(trolley, Trk, TrkNo), T) :- -holdsAt(W, crashed, T), time(T), holdsAt(W, on(trolley, Trk, TrkNo), T).
% if there is a connecting track
initiates(W, run(ToTrk, ToTrkNo), on(trolley, ToTrk, ToTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                                                    -holdsAt(W, crashed, T), time(T), holdsAt(W, on(trolley, FromTrk, FromTrkNo), T). 
terminates(W, run(ToTrk, ToTrkNo), on(trolley, FromTrk, FromTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                                                    -holdsAt(W, crashed, T), time(T), holdsAt(W, on(trolley, FromTrk, FromTrkNo), T). 

initiates(W, crash(Trk, TrkNo), crashed, T) :- time(T), -holdsAt(W, crashed, T), track(Trk), trackNo(TrkNo). 
terminates(W, crash(Trk, TrkNo), alive(P), T)  :- time(T), holdsAt(W, on(P, Trk, TrkNo), T), patients(P), not removedFromWorld(W, P), world(W). 

%%% Means - Side effect distinction
removedFromWorld(without(P), P) :- patients(P), world(without(P)). 
happens(W, A, T) :- happens(base, A, T), externalActions(A), world(W), W != base. 

world(without(P1)) :- -holdsAt(base, alive(P1), T1), holdsAt(base, alive(P2), T2), 
                        T1 <= T2, time(T1), time(T2),
                        patients(P1), patients(P2), P1 != P2. 
treatedAsAMeansFor(P1, P2) :- -holdsAt(base, alive(P1), T1), holdsAt(base, alive(P2), T2), 
                        T1 <= T2, time(T1), time(T2),
                        patients(P1), patients(P2), P1 != P2, 
                        -holdsAt(without(P1), alive(P2), T3), time(T3). 
sideEffectFor(P1, P2) :- -holdsAt(base, alive(P1), T1), holdsAt(base, alive(P2), T2), 
                        T1 <= T2, time(T1), time(T2),
                        patients(P1), patients(P2), P1 != P2, 
                        #count{ T3: -holdsAt(without(P1), alive(P2), T3), time(T3), patients(P2) } = 0. 

%%% External actions
% note that we are "joining" two trolley problems together into one single scenario. 
0 {happens(base, switch, 1); happens(base, push, 1)} 1. 


%%% Outputs
prints(holdsAt(W, alive(G), T)) :- holdsAt(W, alive(G), T), patients(G), maxTime(T). 
prints(-holdsAt(W, alive(G), T)) :- -holdsAt(W, alive(G), T), patients(G), maxTime(T). 
prints(holdsAt(W, on(trolley, Trk, TrkNo), T)) :- holdsAt(W, on(trolley, Trk, TrkNo), T), maxTime(T). 
prints(happens(base, A, T)) :- externalActions(A), time(T), happens(base, A, T). 
#show prints/1.
#show treatedAsAMeansFor/2. #show sideEffectFor/2.
% #show removedFromWorld/2.
% % #show fluentFlipped/4.


% Debug by time
debug(case(A)) :- happens(W, A, 1), externalActions(A). 
debug(holdsAt(W, on(O, Trk, TrkNo), T)) :- holdsAt(W, on(O, Trk, TrkNo), T), testTime(T), O = trolley.
debug(-holdsAt(W, on(O, Trk, TrkNo), T)) :- -holdsAt(W, on(O, Trk, TrkNo), T), testTime(T), O = trolley.
debug(holdsAt(W, alive(P), T)) :- holdsAt(W, alive(P), T), testTime(T). 
debug(-holdsAt(W, alive(P), T)) :- -holdsAt(W, alive(P), T), testTime(T). 
debug(happens(W, E, T)) :- happens(W, E, T), testTime(T). 
debug(holdsAt(W, switched, T)) :- holdsAt(W, switched, T), testTime(T).
debug(-holdsAt(W, switched, T)) :- -holdsAt(W, switched, T), testTime(T). 
debug(holdsAt(W, crashed, T)) :- holdsAt(W, crashed, T), testTime(T).

debug(testTime(T)) :- testTime(T). 
testTime(3). 
% #show debug/1.