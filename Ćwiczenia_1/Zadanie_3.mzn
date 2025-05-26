% Zadanie 3: Problem zakupów z danymi na zewnątrz


int: n;
array[1..n] of string: names;
array[1..n] of int: prices;
int: budget;

% Zmienna: liczba zamawianych porcji dla każdego posiłku
array[1..n] of var 0..(budget div min(prices)): order;

% Ograniczenie: łączna suma kosztów = budżetowi
constraint sum(i in 1..n)(prices[i] * order[i]) = budget;

solve satisfy;

% Wyjście:zamówione posiłki oraz całkowity koszt
output [
  if fix(order[i]) > 0 then 
    names[i] ++ ": " ++ show(fix(order[i])) ++ " (koszt: " ++ show(prices[i] * fix(order[i])) ++ ")\\n" 
  else 
    "" 
  endif | i in 1..n
] ++ ["Łączny koszt: " ++ show(sum(i in 1..n)(prices[i] * fix(order[i])))];
