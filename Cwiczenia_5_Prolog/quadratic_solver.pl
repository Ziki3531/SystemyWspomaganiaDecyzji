% Predykat delta(A, B, C, Delta) oblicza wyróżnik równania kwadratowego.
delta(A, B, C, Delta) :-
    Delta is B*B - 4*A*C.

% Predykat kwadrat(A, B, C, X1, X2) rozwiązuje równanie kwadratowe.
% Obsługuje trzy przypadki: Delta > 0 (dwa pierwiastki rzeczywiste),
% Delta = 0 (jeden pierwiastek rzeczywisty), Delta < 0 (brak pierwiastków rzeczywistych).

% Dwa pierwiastki rzeczywiste (Delta > 0)
kwadrat(A, B, C, X1, X2) :-
    A \= 0, % Ensure it's a quadratic equation
    delta(A, B, C, Delta),
    Delta > 0,
    SqrtDelta is sqrt(Delta),
    X1 is (-B + SqrtDelta) / (2*A),
    X2 is (-B - SqrtDelta) / (2*A).

% Jeden pierwiastek rzeczywisty (Delta = 0)
kwadrat(A, B, C, X, X) :-
    A \= 0, % Ensure it's a quadratic equation
    delta(A, B, C, 0),
    X is -B / (2*A).

% Brak pierwiastków rzeczywistych (Delta < 0)
kwadrat(A, B, C, 'brak_pierwiastkow_rzeczywistych', 'brak_pierwiastkow_rzeczywistych') :-
    A \= 0, % Ensure it's a quadratic equation
    delta(A, B, C, Delta),
    Delta < 0.

% Obsługa przypadku gdy A=0 (to nie jest równanie kwadratowe)
kwadrat(0, B, C, linear_equation(X), linear_equation(X)) :-
    B \= 0,
    X is -C / B.
kwadrat(0, 0, C, infinite_solutions, infinite_solutions) :-
    C = 0.
kwadrat(0, 0, C, no_solution, no_solution) :-
    C \= 0.