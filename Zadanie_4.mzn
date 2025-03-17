% Zadanie 4: Optymalizacja wyboru posiłków według kryterium smaku

int: n = 6;
int: budget = 1505;

% Tablice: ceny posiłków, ich nazwy oraz "yumyum factor"
array[1..n] of int: prices = [215, 275, 335, 355, 420, 580];
array[1..n] of string: names = ["Owoce", "Frytki", "Sałatka", "Skrzydełka", "Paluszki", "Zestaw próbny"];
array[1..n] of int: yummy = [0, 0, 1, 1, 2, 3];

% Zmienna: liczba zamawianych porcji dla każdego posiłku.
array[1..n] of var 0..(budget div min(prices)): order;

% Ograniczenie budżetowe: suma kosztów posiłków nie może przekroczyć budżetu.
constraint sum(i in 1..n)(prices[i] * order[i]) <= budget;

% Funkcja celu: maksymalizacja łącznego "yumyum factor".
var int: total_yum = sum(i in 1..n)(yummy[i] * order[i]);

solve maximize total_yum;

% Wyjście: dla każdego posiłku, jeżeli liczba zamówień > 0, wyświetlamy szczegóły.
output [
  if fix(order[i]) > 0 then 
    names[i] ++ ": " ++ show(fix(order[i])) ++ " (koszt: " ++ show(prices[i] * fix(order[i])) ++ ", yum: " ++ show(yummy[i] * fix(order[i])) ++ ")\\n"
  else 
    ""
  endif | i in 1..n
] ++ [
  "Łączny koszt: " ++ show(sum(i in 1..n)(prices[i] * fix(order[i]))) ++ "\\n",
  "Łączny yumyum: " ++ show(total_yum)
];
