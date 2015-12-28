% generate jigsaw pieces
piece(['74', [[1,1,0,0,1,0], [0,1,0,1,0,0], [0,1,0,0,1,0], [0,1,0,0,1,1]]]).
piece(['65', [[1,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,1,0,1]]]).
piece(['13', [[0,1,0,1,0,1], [1,1,0,1,0,1], [1,1,0,0,1,1], [1,1,0,0,1,0]]]).
piece(['Cc', [[0,0,1,1,0,0], [0,0,1,1,0,0], [0,1,0,0,1,0], [0,0,1,1,0,0]]]).
piece(['98', [[1,1,0,0,1,0], [0,1,0,0,1,0], [0,0,1,1,0,0], [0,0,1,1,0,1]]]).
piece(['02', [[0,0,1,1,0,0], [0,1,0,0,1,1], [1,0,1,1,0,0], [0,0,1,1,0,0]]]).

% rotate(+A, +N, ?B) is true iff list B is the list A rotated left by N elements
rotate(A, 0, A).
rotate([H|T], N, B) :- N > 0, append(T, [H], R), M is N - 1, rotate(R, M, B).
/*
?- rotate([1,2,3], 2, [3,1,2]).
true 
false.

?- rotate([1,2,3], 1, [2,3,1]).
true 
false.

?- rotate([1,2,3], 2, [2,3,1]).
false.
*/

% reverse(?A, ?B) is true iff elements in list A are in reverse order when compared to elements in list B
reverse([], []).
reverse([H|T], B) :- reverse(T, RT), append(RT, [H], B).

% xor(?A, ?B) is true iff A xor B
xor(1, 0).
xor(0, 1).

% xorlist(?A, ?B) is true iff all the pairwise elements of lists A and B are true under the xor predicate defined above
xorlist([], []).
xorlist([H1|T1], [H2|T2]) :- xor(H1, H2), xorlist(T1, T2).

% range(+Min, +Max, -Val) unifies Val with Min on the first evaluation and then all values up to Max - 1 on backtracking
range(Min, Max, Min) :- Max > Min.
range(Min, Max, Val) :- N is Min + 1, Max > N, range(N, Max, Val).

% flipped(+P, ?FP) is true iff piece FP is piece P flipped
flipped([P, [S0, S1, S2, S3]], [P, [FS0, FS1, FS2, FS3]]) :-
	piece([P, [S0, S1, S2, S3]]),
	reverse(S0, FS0),
	reverse(S1, FS3),
	reverse(S2, FS2),
	reverse(S3, FS1).
% flipped checks if P is a valid piece and then unifies the top and bottom sides of FP with the reverse (mirror) of the same sides in P and unifies the left and right sides of FP with the reverse of the opposing sides in P.

% orientation(+P, ?O, -OP) is true iff OP is piece P in orientation O
orientation(P, O, OP) :- piece(P), rotations(P, O, OP).
orientation(P, O, OP) :- piece(P), flipped(P, FP), rotations(FP, O, OP).

rotations([P, [S0, S1, S2, S3]], O, [P, [OS0, OS1, OS2, OS3]]) :-
	range(0, 4, O),
	rotate([S0, S1, S2, S3], O, [OS0, OS1, OS2, OS3]).

% compatible(+P1, +Side1, +P2, +Side2) is true iff Side1 of piece P1 can be plugged into Side2 of P2
compatible([_, Sides1], Side1, [_, Sides2], Side2) :-
	nth0(Side1, Sides1, [_, F1, F2, F3, F4, _]),
	nth0(Side2, Sides2, [_, F5, F6, F7, F8, _]),
	xorlist([F4, F3, F2, F1], [F5, F6, F7, F8]).
