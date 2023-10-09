% consequence of events --> fluents
consequence(E, pres(F)) :- initiates(E, F, T), happens(E, T), holdsAt(F, T + 1). 
consequence(E, abs(F)) :- terminates(E, F, T), happens(E, T), -holdsAt(F, T + 1).

% consequence of runtime fluents --> events
% how do I render these rules in preconditions semantics
% how do we ascribe transitive causal power, given that
% there are also background conditions that are still true
% there are multiple events that contribute to the condition