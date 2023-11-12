% index starts at zero
% each atom has multiple matchings. An n-ary matching of all atoms in a rule is called an assignment.
rule(r0).
orderedAtom(r0, 0). orderedAtom(r0, 1). 
orderedBinding(r0, cell(0, 0), "X", 1).
orderedBinding(r0, cell(0, 0), "Y", 2). 
orderedBinding(r0, cell(0, 1), "X", 1). 
orderedBinding(r0, cell(0, 1), "Y", 3). 
orderedBinding(r0, cell(1, 0), "Y", 2). 
orderedBinding(r0, cell(1, 0), "Z", 7). 
orderedBinding(r0, cell(1, 1), "Y", 3). 
orderedBinding(r0, cell(1, 1), "Z", 8). 

cartesianProdCoefficient(R, 0, 1) :- rule(R). 
cartesianProdCoefficient(R, Aidx + 1, Coef * N) :- orderedAtom(R, Aidx + 1), cartesianProdCoefficient(R, Aidx, Coef), #count{M: orderedBinding(R, cell(Aidx, M), _, _)} = N. 

% orderedAtom ~ index of set. orderedBinding ~ <index of set, index of el in set> 
% this computes the index of n-ary cartesian product along with alll cell<A, M> belonging to which idx
inAssignmentHelper(R, cell(Aidx0, Midx0), 0, 0) :- orderedAtom(R, Aidx0), orderedBinding(R, cell(Aidx0, Midx0), _, _).
inAssignmentHelper(R, cell(Aidx0, Midx0), Aidx + 1, Cum + Midx * Coef)  :- orderedAtom(R, Aidx), orderedBinding(R, cell(Aidx, Midx), _, _), 
                                                                            inAssignmentHelper(R, cell(Aidx0, Midx0), Aidx, Cum), Aidx0 != Aidx, 
                                                                            cartesianProdCoefficient(R, Aidx, Coef). 
inAssignmentHelper(R, cell(Aidx0, Midx0), Aidx + 1, Cum + Midx0 * Coef)  :- orderedAtom(R, Aidx), orderedBinding(R, cell(Aidx, Midx), _, _), 
                                                                            inAssignmentHelper(R, cell(Aidx0, Midx0), Aidx, Cum), Aidx0 = Aidx, 
                                                                            cartesianProdCoefficient(R, Aidx, Coef). 
inAssignment(R, cell(Aidx, Midx), AssignId) :- inAssignmentHelper(R, cell(Aidx, Midx), Size, AssignId), #count {S: orderedAtom(R, S)} = Size. 

% invalid assignment rule
invalidAssignment(R, AssignId) :- orderedAtom(R, A1), orderedAtom(R, A2), A1 != A2, 
                                    orderedBinding(R, cell(A1, M1), Symb1, Val1), orderedBinding(R, cell(A2, M2), Symb2, Val2), 
                                    inAssignment(R, cell(A1, M1), AssignId), inAssignment(R, cell(A2, M2), AssignId), 
                                    Symb1 = Symb2, Val1 != Val2. 

validAssignment(R, AssignId, Symb, Val)   :- inAssignment(R, cell(A, M), AssignId), orderedBinding(R, cell(A, M), Symb, Val), not invalidAssignment(R, AssignId).

#show validAssignment/4.

