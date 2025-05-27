
color(red).
color(green).
color(blue).


koloruj(P1, P2, P3, P4, P5) :-
    color(P1), % Assign a color to P1
    color(P2), % Assign a color to P2
    color(P3), % Assign a color to P3
    color(P4), % Assign a color to P4
    color(P5), % Assign a color to P5

   
    P1 \= P2,  % P1 and P2 are neighbors
    P2 \= P3,  % P2 and P3 are neighbors
    P3 \= P4,  % P3 and P4 are neighbors
    P4 \= P5.  % P4 and P5 are neighbors