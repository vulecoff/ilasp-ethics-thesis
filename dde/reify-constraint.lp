atom(1..7). 

fact(1).
to_ground(1..6).

fact(A) :- atom(A), atom(B), fact(B), to_ground(A). 
