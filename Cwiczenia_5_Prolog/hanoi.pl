% hanoi.pl
move(1, From, To, _) :-
    write('Move top disk from '), write(From), write(' to '), write(To), nl.
move(N, From, To, Aux) :-
    N > 1,
    N1 is N - 1,
    move(N1, From, Aux, To),
    move(1, From, To, _),
    move(N1, Aux, To, From).