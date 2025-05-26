

int: len = 4; 

array[0..len-1] of var 0..len: s;


constraint forall(i in 0..len-1) (
    s[i] = count([s[j] | j in 0..len-1], i)
);


constraint sum(i in 0..len-1)(s[i]) = len;


constraint sum(i in 0..len-1)(s[i] * i) = len;

solve satisfy;

output [
    "Magiczna seria dla len = ", show(len), ":\n",
    show(s)
];
