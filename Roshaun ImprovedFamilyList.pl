%We have considered two representations for the family database:
% One which represents a family in terms of three basic predicates: parent_of(), 
%male() and female(), plus a bunch of rules. 
%A second representation which represents a family in terms of a list with the form
%family(ParentList, ChildrenLists). For example,
%family([mom,dad],[[daughter1, daughter2],[son1,son2,son3]]).
%One shortcoming of this list representation is that it doesn't represent the chronological order of all the 
%children. You can tell who is the oldest son and who is the oldest daughter but not who is the oldest 
%child.
$So we now want to rewrite our database using the following representation scheme:
%family([mom,dad],[[child1,female],[child2,male],[child3,male]]).



family([anbal,leigh],[[kay,female],[roshaun,male]]).
family([anbal,west], [[tash,female]]).
family([caroline,glan],[[anbal,female]]).
family([jean,hodgson],[[leigh,male]]).
family([catherine,cgee],[[west,male]]).
family([cynthia,smug],[[jean,female]]).
family([ruth,james],[[],[glan,male]]).

on(Item, [Item|_]).
size([], 0).
size([_|T], N) :- size(T, N1), N is N1 + 1.

%Determines gender based on name,gender format of the child list. 
male(M) :- family(_, Cs), member([M, male], Cs). 
female(F) :- family(_,Cs), member([F, female], Cs).

%Predicates for Gender
%CHecks for gender based on position in parent list
male(M) :- family(_,  Cs), member([M,  male], Cs).
female(F) :- family(_,Cs), member([F, female], Cs).


%Parent Predicates
 %Determines parentage based on rank of parent in the 
 %parent list and presece of the child in the child list., 
father_of(F, C) :- family([_, F], Cs), member([C|_], Cs).
mother_of(M, C) :- family([M, _], Cs),  member([C|_], Cs).

%Determines parent based on mother and father predicates. 
parent_of(P, C) :- father_of(P, C) ; mother_of(P, C).

%Determine ancestor in terms of parent predicates and defined
%recursively to the nth degree. 
ancestor_of(L, D):- parent_of(L, D).
ancestor_of(L,D):- ancestor_of(L, M),parent_of(M, D).

%Sibling Predicates
%Provides sibling if parent is shared. 
sibling_of(S1, S2) :- parent_of(P, S1), parent_of(P, S2).

%Determines sibling type based on sibling predicate and 
%gender predicate.
brother_of(B, S) :- sibling_of(B, S),male(B).
sister_of(S, ST) :- sibling_of(S, ST), female(ST).

%Determine daughter and son based on daughter and 
%son predicates.
daughter_of(D, P) :- parent_of(P, D), female(D).
son_of(S, P) :- parent_of(P, S), male(S).


%Children Predicates
%Check of primacy by removing first child of a particular gender from list
%and compare to new and old list.
oldest_son_of(SO,P):- (family([_, P], Cs) ; family([P,_], Cs)), member([SO,_], Cs), selectchk([_, male], Cs, R), selectchk([SO, male], Cs, R).
oldest_daughter_of(D,P):- (family([_, P], Cs) ; family([P,_], Cs)), member([D,_], Cs), selectchk([_, female], Cs, R), selectchk([D, female], Cs, R).

%Checks for oldest child through head of child list.
oldest_child_of(C,P):-parent_of(P, C), family(_, Cs), on([C|_], Cs).

%Checks size of children list
number_of_children(P, N) :- (family([_, P], Cs) ; family([P, _], Cs)), size(Cs, N).

%Checks for size of parent list in terms of daughters and sons.
number_of_daughters(P, N) :- aggregate(count, daughter_of(_X, P), Y), N is Y.
number_of_sons(P, N) :- aggregate(count, son_of(_X, P),Y), N is Y.

