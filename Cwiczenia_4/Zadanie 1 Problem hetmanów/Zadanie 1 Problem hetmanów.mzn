include "alldifferent.mzn";

int: N = 16;
array[1..N] of var 1..N: rows;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in 1..N]);
constraint alldifferent([rows[i] - i | i in 1..N]);



constraint rows[1] = 1;


constraint rows[8] != 8;


constraint sum([bool2int(rows[i] <= 8) | i in 1..N]) >= 4;

solve satisfy;
