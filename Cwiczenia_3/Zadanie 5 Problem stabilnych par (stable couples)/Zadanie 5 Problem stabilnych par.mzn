include "globals.mzn"; 


int: n; 



array[1..n] of string: m_names;
array[1..n] of string: w_names;


array[1..n, 1..n] of int: m_ranks;


array[1..n, 1..n] of int: w_ranks;



array[1..n] of var 1..n: wives;


array[1..n] of var 1..n: husbands;


predicate prefers_over(array[1..n, 1..n] of int: ranks, int: s, var int: p1, var int: p2) =
    ranks[p1, s] < ranks[p2, s];

predicate man_prefers_over(int: m, var int: w1, var int: w2) =
    prefers_over(m_ranks, m, w1, w2);

predicate woman_prefers_over(int: w, var int: m1, var int: m2) =
    prefers_over(w_ranks, w, m1, m2);




constraint forall(m in 1..n)(
    husbands[wives[m]] = m
);
constraint forall(w in 1..n)(
    wives[husbands[w]] = w
);


constraint forall(m in 1..n, w in 1..n where w != wives[m])(
    (man_prefers_over(m, w, wives[m])) -> (woman_prefers_over(w, husbands[w], m))
);


constraint alldifferent(wives);
constraint alldifferent(husbands);



solve satisfy;


output [
    "Stable marriages (Man -> Woman):\n"
] ++ [
    
    "  Man " ++ show(m) ++ " -> Woman " ++ show(wives[m]) ++ "\n"
    | m in 1..n
] ++ [
    "Stable marriages (Woman -> Man):\n"
] ++ [
    
    "  Woman " ++ show(w) ++ " -> Man " ++ show(husbands[w]) ++ "\n"
    | w in 1..n
];