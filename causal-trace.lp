% consequence of events --> fluents
% caution: fluent is already true/false before initiating? 
eventEffect(T, E, pres(F)) :- initiates(E, F, T), happens(E, T), fluentFlipped(F, T + 1, toTrue). 
eventEffect(T, E, abs(F)) :- terminates(E, F, T), happens(E, T), fluentFlipped(F, T + 1, toFalse).

% make sure that the happening of events is in Virtue of this specific effect
fluentEffect(T, abs(F), E) :- -holdsAt(F, T), happens(E, T), precondition(abs(F), E).
fluentEffect(T, pres(F), E) :- holdsAt(F, T), happens(E, T), precondition(pres(F), E).

cause(E1, E2) :- eventEffect(T1, E1, F), fluentEffect(T2, F, E2), T1 < T2. 
% consequence of runtime fluents --> events
% how do I render these rules in preconditions semantics
% how do we ascribe transitive causal power, given that
% there are also background conditions that are still true
% there are multiple events that contribute to the condition
% perhaps one solution is to use atomic event. multiple conditions can give rise to event. But event 
% can just be characterized one happening. 

% right now focus on the change-able fluent. These are the conditions-fluent that the event depends on
precondition(pres(on(train, Trk, TrkNo)), run(Trk, TrkNo + 1)) :- track(Trk), trackNo(TrkNo). 
precondition(abs(crashed), run(Trk, TrkNo + 1)) :- track(Trk), trackNo(TrkNo). 
precondition(pres(switched), run(Trk, TrkNo)) :- track(Trk), trackNo(TrkNo). 
precondition(abs(switched), run(Trk, TrkNo)) :- track(Trk), trackNo(TrkNo).
% condition of running on the main track 
% we know that both conditions and events hold, how do we know that 
% this is the "contributing" factor? 

precondition(pres(on(train, Trk, TrkNo)), crash) :- track(Trk), trackNo(TrkNo). 
precondition(pres(on(P, Trk, TrkNo)), crash) :- track(Trk), trackNo(TrkNo), patients(P). 

precondition(abs(alive(X)), deathOf(X)) :- patients(X). 

#show cause/2.
#show eventEffect/3. #show fluentEffect/3.