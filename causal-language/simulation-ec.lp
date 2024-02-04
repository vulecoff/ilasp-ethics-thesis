% clipped if terminated or released. Exclusive at two ends
clipped(U, T1, F, T2) :- terminates(U, E, F, T), happens(U, E, T), T1 < T, T < T2, time(T1), time(T2). 
clipped(U, T1, F, T2) :- releases(U, E, F, T), happens(U, E, T), T1 < T, T < T2, time(T1), time(T2). 

% declipped if initiated or released. Exclusive at two ends.
declipped(U, T1, F, T2) :- initiates(U, E, F, T), happens(U, E, T), T1 < T, T < T2, time(T1), time(T2). 
declipped(U, T1, F, T2) :- releases(U, E, F, T), happens(U, E, T), T1 < T, T < T2, time(T1), time(T2). 

% holds if initially true and not clipped
holdsAt(U, F, T) :- initiallyP(U, F), not clipped(U, 0, F, T), time(T). 
-holdsAt(U, F, T) :- initiallyN(U, F), not declipped(U, 0, F, T), time(T). 

% continues to hold if not interrupted
holdsAt(U, F, T2) :- initiates(U, E, F, T1), happens(U, E, T1), not clipped(U, T1, F, T2), T1 < T2, time(T1), time(T2). 
-holdsAt(U, F, T2) :- terminates(U, E, F, T1), happens(U, E, T1), not declipped(U, T1, F, T2), T1 < T2, time(T1), time(T2). 

% track moment where fluent changed
fluentFlipped(U, P, T + 1, toTrue) :- not holdsAt(U, P, T), holdsAt(U, P, T + 1), time(T). % fluents initiated at time > 0
fluentFlipped(U, P, T + 1, toTrue) :- -holdsAt(U, P, T), holdsAt(U, P, T + 1). 
fluentFlipped(U, P, T + 1, toFalse) :- holdsAt(U, P, T), -holdsAt(U, P, T + 1). 

% enforces that all happens must occur after the initial time. 
T > 0 :- happens(U, E, T). 

%%% Problem encoding
maxTime(12). 
time(0..T) :- maxTime(T). 
universe(base). 
maxTracks(7). track(mainTrack; sideTrack). trackNo(0..X) :- maxTracks(X). 
patients(group(1); group(5); fatman).
externalActions(push; switch). % keep note of this

switchTrack(from(mainTrack, 1), to(sideTrack, 1)). 
bridgeOnTop(mainTrack, 2). 

initiallyN(U, switched) :- universe(U). 
initiallyP(U, (on(group(1), sideTrack, 4); on(group(5), mainTrack, 5))) :- universe(U). 
initiallyN(U, crashed) :- universe(U). 
initiallyP(U, on(train, mainTrack, 0)) :- universe(U). 
initiallyP(U, alive(P)) :- patients(P), not removedFromUniverse(U, P), universe(U). 

ethicallyCharged(alive(X)) :- patients(X). % implicitly assumed that postive fluents are ethically desirable, the converse goes for negative fluents (absence). 
% TODO: how to automatically extract agents involved in a ethically-charged agents? 

initiates(U, switch, switched, T) :- time(T), -holdsAt(U, switched, 0), T = 1, universe(U). 
T = 1 :- happens(U, switch, T). 

initiates(U, push, on(fatman, Trk, TrkNo), T) :- time(T), T = 1, bridgeOnTop(Trk, TrkNo), track(Trk), trackNo(TrkNo), not removedFromUniverse(U, fatman), universe(U). 
terminates(U, push, alive(fatman), T) :- time(T), T = 1, not removedFromUniverse(U, fatman), universe(U). 

%%
happens(U, run(Trk, TrkNo + 1), T) :- T >= 1, not switchTrack(from(Trk, TrkNo), _), holdsAt(U, on(train, Trk, TrkNo), T), 
                                    -holdsAt(U, crashed, T), maxTracks(Q), TrkNo < Q. 
happens(U, run(ToTrk, ToTrkNo), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(U, on(train, FromTrk, FromTrkNo), T), holdsAt(U, switched, T).  
happens(U, run(FromTrk, FromTrkNo+1), T) :- T >= 1, switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), 
                                    holdsAt(U, on(train, FromTrk, FromTrkNo), T), -holdsAt(U, switched, T). 
happens(U, crash, T) :- holdsAt(U, on(train, Trk, TrkNo), T), holdsAt(U, on(P, Trk, TrkNo), T), patients(P), not removedFromUniverse(U, P), universe(U). 

%%
initiates(U, run(Trk, TrkNo + 1), on(train, Trk, TrkNo + 1), T) :- -holdsAt(U, crashed, T), time(T), holdsAt(U, on(train, Trk, TrkNo), T).
terminates(U, run(Trk, TrkNo + 1), on(train, Trk, TrkNo), T) :- -holdsAt(U, crashed, T), time(T), holdsAt(U, on(train, Trk, TrkNo), T).
initiates(U, run(ToTrk, ToTrkNo), on(train, ToTrk, ToTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a connecting track
                                                                    -holdsAt(U, crashed, T), time(T), holdsAt(U, on(train, FromTrk, FromTrkNo), T). 
terminates(U, run(ToTrk, ToTrkNo), on(train, FromTrk, FromTrkNo), T) :- switchTrack(from(FromTrk, FromTrkNo), to(ToTrk, ToTrkNo)), % if there is a connecting track
                                                                    -holdsAt(U, crashed, T), time(T), holdsAt(U, on(train, FromTrk, FromTrkNo), T). 

initiates(U, crash, crashed, T) :- time(T), -holdsAt(U, crashed, T). 
terminates(U, run(Trk, TrkNo), alive(P), T)  :- time(T), holdsAt(U, on(P, Trk, TrkNo), T), patients(P), not removedFromUniverse(U, P), universe(U). 


removedFromUniverse(without(P), P) :- patients(P), universe(without(P)). 
happens(U, A, T) :- happens(base, A, T), externalActions(A), universe(U), U != base. 

universe(without(P1)) :- -holdsAt(base, alive(P1), T1), holdsAt(base, alive(P2), T2), 
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

% external action
0 {happens(base, switch, 1); happens(base, push, 1)} 1. 

% Printing out
prints(holdsAt(U, alive(G), T)) :- holdsAt(U, alive(G), T), patients(G), maxTime(T). 
prints(-holdsAt(U, alive(G), T)) :- -holdsAt(U, alive(G), T), patients(G), maxTime(T). 
prints(happens(base, A, T)) :- externalActions(A), time(T), happens(base, A, T). 
#show prints/1.
#show treatedAsAMeansFor/2. #show sideEffectFor/2.


debug(holdsAt(U, on(O, Trk, TrkNo), T)) :- holdsAt(U, on(O, Trk, TrkNo), T), testTime(T). 
debug(-holdsAt(U, on(O, Trk, TrkNo), T)) :- -holdsAt(U, on(O, Trk, TrkNo), T), testTime(T). 
debug(happens(U, E, T)) :- happens(U, E, T), testTime(T). 
debug(holdsAt(U, switched, T)) :- holdsAt(U, switched, T), testTime(T).
debug(-holdsAt(U, switched, T)) :- -holdsAt(U, switched, T), testTime(T). 
debug(holdsAt(U, crashed, T)) :- holdsAt(U, crashed, T), testTime(T).
testTime(3). 
%#show debug/1.

% NEXT STEP: 