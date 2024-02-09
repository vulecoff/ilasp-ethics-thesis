% yale shooting problem
time(0..10). fluent(loaded; alive; dead). 
initiates(load, loaded, T) :- time(T). 
initiates(shoot, dead, T) :- holdsAt(loaded, T). 
terminates(shoot, alive, T) :- holdsAt(loaded, T).
initiallyP(alive). 
initiallyN(loaded).
initiallyN(dead). 
happens(load, 1). happens(sneeze, 3). happens(shoot, 5). 

#show fluentFlipped/3.