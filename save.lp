end(A) :- action(A), patient(P), goalOf(A, G), #sum {1: intention(G, P, pos)} > 0, -intention(G, P, neg).

