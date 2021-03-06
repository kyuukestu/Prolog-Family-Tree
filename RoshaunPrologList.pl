%Rewrite your family database, but this time use PROLOG's lists ([H|T]) to represent the basic facts of 
%your family. Save it as an ordinary text file named familylists.pl.
%Your program should implement the following facts for your immediate family, grandparents, and 
%great-grandparents.
%family([mom,dad],[[daughter1, daughter2],[son1,son2]]).
%In other words, each "nuclear" family is comprised of two lists:
%family(ParentList, ChildrenList). 
%The ParentList is formatted with the name of the mother, followed by the name of the father. 
%The ChildrenList consists of two sublists, the first giving the names of the daughters, in 
%chronological order, and the second giving the names of the sons, in chronological order.



family([anbal,leigh], [[kay], [roshaun]]).
family([anbal,west], [[tash], []]).
family([caroline,glan],[[anbal],[]]).
family([jean,hodgson],[[],[leigh]]).
family([catherine,cgee],[[],[west]]).
family([cynthia,smug],[[jean],[]]).
family([ruth,james],[[],[glan]]).

%Parent Predicates
%Determines parent based on position of parent in parent's list 
%and child's presents on child list
father_of(D, C) :- family([_, D],[Ds, Ss]),(member(C, Ds);member(C, Ss)).
mother_of(M, C) :- family([M, _],[Ds, Ss]),(member(C,Ds);member(C, Ss)).

%Determine parents based on father and mother predicates. 
parent_of(P,C) :- father_of(P,C).
parent_of(P,C) :- mother_of(P,C).

%Determines grandparent, greatgrandparent,and ancestor.
grandparent_of(M,MC):-parent_of(M,P), parent_of(P,MC).
greatgrandparent_of(MM,MMC):- parent_of(MM,M), grandparent_of(M,MMC).
ancestor_of(L, D):- parent_of(L, D).
ancestor_of(L,D):- ancestor_of(L, M),parent_of(M, D).



%Gender Predicates

%Determines gender based on position in parent list or son/daughter's 
%list. 
male(M) :- family([_,M],_).
male(M) :- family(_,[_,Ss]), member(M,Ss).
female(F) :- family([F, _], _).
female(F) :- family([_], [Ds, _]), member(F, Ds).

%Children Predicate

%Determines son or daughter based on verified parent
%and presence in son or daughter list
son_of(S, P) :- parent_of(P, S), family(_, [_, Ss]), member(S, Ss).
daughter_of(D, P) :- parent_of(P, D), family(_, [Ds,_]), member(D, Ds).

%Determines eldest if person is at top of list in children with particular gender. 
oldest_son_of(Y, P) :- parent_of(P, Y), family(_, [_, [H|_]]), Y = H.
oldest_daughter_of(W, P) :- parent_of(P, W), family(_, [[H|_], _]), W = H.

%Sibling Predicate

%Determines Sibling if its the same parent.
sibling_of(E,F):- parent_of(P,E), parent_of(P,F).

%Determines type of sibling based on gender predicate and
%sibling predicate. 
brother_of(E,F):-sibling_of(E,F), family(_,[_,Ss]), member(F,Ss).
sister_of(E,F):-sibling_of(E,F), family(_, [Ds, _]), member(F, Ds).


