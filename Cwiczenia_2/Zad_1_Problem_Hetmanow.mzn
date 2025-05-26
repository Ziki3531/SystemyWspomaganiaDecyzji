include "alldifferent.mzn";

int: N = 8; % Rozmiar szachownicy i liczba hetmanów [cite: 1]

% q[i] = kolumna, w której znajduje się hetman w wierszu i
array[1..N] of var 1..N: q;

% Ograniczenia:
% 1. Każdy hetman w osobnej kolumnie [cite: 2]
constraint alldifferent(q);

% 2. Brak ataków po przekątnych [cite: 2]
constraint forall(i in 1..N, j in i+1..N) (
    q[i] - q[j] != i - j % Różne różnice dla przekątnych \
);
constraint forall(i in 1..N, j in i+1..N) (
    q[i] - q[j] != -(i - j) % Różne sumy dla przekątnych / (równoważne q[i] + i != q[j] + j)
);

solve satisfy;

output ["Rozmieszczenie hetmanów (wiersz: kolumna):\n"];
output ["  " ++ show(i) ++ ": " ++ show(q[i]) ++ "\n" | i in 1..N];
output ["\nSzachownica:\n"];
output [
    if fix(q[i]) == j then " H " else " . " endif ++
    if j == N then "\n" else "" endif
    | i,j in 1..N
];