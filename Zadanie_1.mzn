% Zadanie 2: Problem zakupów z wykorzystaniem tablic

% Liczba dostępnych posiłków
int: n = 6;

% Tablice: ceny posiłków oraz ich nazwy
array[1..n] of int: prices = [215, 275, 335, 355, 420, 580];
array[1..n] of string: names = ["Owoce", "Frytki", "Sałatka", "Skrzydełka", "Paluszki", "Zestaw próbny"];

% Zmienna: liczba zamawianych porcji dla każdego posiłku
array[1..n] of var 0..100: order;

% Ograniczenie: łączna suma cen posiłków musi wynosić 1505
constraint sum(i in 1..n)(prices[i] * order[i]) = 1505;

solve satisfy;

% Użycie funkcji fix()
output [
  if fix(order[i]) > 0 then 
    names[i] ++ ": " ++ show(fix(order[i])) ++ "\n" 
  else 
    ""
  endif | i in 1..n
];
