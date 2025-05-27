
int: items_n; 
int: knapsacks_n; 
int: capacity; 
array[1..items_n] of int: values; 
array[1..items_n] of int: weights; 


array[1..knapsacks_n, 1..items_n] of var 0..1: taken;
var int: total_value; 


constraint forall(j in 1..items_n)(
    sum(i in 1..knapsacks_n)(taken[i,j]) <= 1
);


constraint forall(i in 1..knapsacks_n)(
    sum(j in 1..items_n)(taken[i,j] * weights[j]) <= capacity
);


constraint total_value = sum(i in 1..knapsacks_n, j in 1..items_n)(
    taken[i,j] * values[j]
);


constraint forall(i in 1..knapsacks_n-1)(
    lex_lesseq(row(taken, i), row(taken, i+1)) 
);


solve maximize total_value;


output [
    "Total value: ", show(total_value), "\n",
    "Items in knapsacks:\n"
] ++ [
   
    "  Knapsack " ++ show(i) ++ ": " ++
    show({j | j in 1..items_n where taken[i,j] = 1}) ++ 
    " (Weight: " ++ show(sum(j in 1..items_n)(taken[i,j] * weights[j])) ++ ")\n"
    | i in 1..knapsacks_n
];