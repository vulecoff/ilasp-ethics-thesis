maxTime(2). 
fluent(a_voted; b_voted; c_voted; d_voted; e_voted).
initiallyN(a_voted; b_voted; c_voted; d_voted; e_voted). 

disj(p_elected). in(p_elected, (c1; c2; c3; c4)). 
conj(c1). in(c1, in(a_voted; b_voted; c_voted)). 
conj(c2). in(c2, in(a_voted; b_voted; d_voted)). 
conj(c3). in(c3, in(a_voted; c_voted; d_voted)).
conj(c4). in(c4, in(b_voted; c_voted; d_voted)).
conj(c5). in(c5, in(a_voted;))

action(a, true, a_voted). 
action(b, true, b_voted). 
action(c, true, c_voted). 
action(d, true, d_voted). 
action(e, true, e_voted). 

performs(a, 0). performs(b, 0). performs(c, 0). performs(d, 0). 