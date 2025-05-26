include "alldifferent.mzn";

int: S = 3; % Rozmiar bloku
int: N = S * S; % Rozmiar planszy Sudoku (9x9)

% puzzle[i,j] = wartość w komórce (i,j), 0 oznacza pustą komórkę
array[1..N, 1..N] of int: puzzle = % Przykładowa, częściowo wypełniona plansza Sudoku [cite: 10]
  [| 5, 3, 0, 0, 7, 0, 0, 0, 0  % [cite: 10]
   | 6, 0, 0, 1, 9, 5, 0, 0, 0
   | 0, 9, 8, 0, 0, 0, 0, 6, 0
   | 8, 0, 0, 0, 6, 0, 0, 0, 3
   | 4, 0, 0, 8, 0, 3, 0, 0, 1
   | 7, 0, 0, 0, 2, 0, 0, 0, 6
   | 0, 6, 0, 0, 0, 0, 2, 8, 0
   | 0, 0, 0, 4, 1, 9, 0, 0, 5
   | 0, 0, 0, 0, 8, 0, 0, 7, 9
  |];

array[1..N, 1..N] of var 1..N: sudoku; % Zmienne reprezentujące planszę

% Ograniczenia Sudoku [cite: 9]
constraint forall(r in 1..N) ( % Każdy wiersz zawiera różne liczby
    alldifferent([sudoku[r,c] | c in 1..N])
);

constraint forall(c in 1..N) ( % Każda kolumna zawiera różne liczby
    alldifferent([sudoku[r,c] | r in 1..N])
);

constraint forall(br in 0..S-1, bc in 0..S-1) ( % Każdy blok 3x3 zawiera różne liczby
    alldifferent([sudoku[br*S + r, bc*S + c] | r,c in 1..S])
);

% Wypełnienie planszy na podstawie początkowego układu
constraint forall(r,c in 1..N where puzzle[r,c] != 0) (
    sudoku[r,c] = puzzle[r,c]
);

solve satisfy;

output ["Rozwiązane Sudoku:\n"];
output [
  show(sudoku[r,c]) ++ " " ++ (if c mod S == 0 /\ c < N then " | " else "" endif) ++
  (if c == N then "\n" else "" endif) ++
  (if c == N /\ r mod S == 0 /\ r < N then "".join(["---"| _ in 1..S]) ++ "".join(["+---"| _ in 1..S-1]) ++ "\n" else "" endif)
  | r,c in 1..N
];