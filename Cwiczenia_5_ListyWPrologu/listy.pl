%---------------------------------------------------
% LAB: Praca z listami w Prologu
% Pełne rozwiązania wszystkich zadań
%---------------------------------------------------

% 1. Notacja list
% Definicje predykatów do manipulacji konkretnymi elementami listy.
trzeci([_A, _B, C | _Rest], C).
porownaj([_E1, _E2, X, X | _Rest]).
zamien([A, B, C, D | Rest], [A, B, D, C | Rest]).

%---------------------------------------------------
% 2. Przynależność do listy
% Rekurencyjna definicja predykatu sprawdzającego, czy element należy do listy.
nalezy(X, [X | _]).
nalezy(X, [_ | Yogon]) :-
    nalezy(X, Yogon).

%---------------------------------------------------
% 3. Liczenie elementów
% Rekurencyjna definicja predykatu do obliczania długości listy.
dlugosc([], 0).
dlugosc([_ | Ogon], Dlug) :-
    dlugosc(Ogon, X),
    Dlug is X + 1.

%---------------------------------------------------
% 4. Rekurencyjna analiza list
% Predykat transformujący elementy listy rekurencyjnie.
a2b([], []).
a2b([a | Ta], [b | Tb]) :-
    a2b(Ta, Tb).

%---------------------------------------------------
% 5. Sklejanie list
% Podstawowy predykat do konkatenacji list oraz jego zastosowania.
sklej([], X, X).
sklej([X | L1], L2, [X | L3]) :-
    sklej(L1, L2, L3).
nalezy1(X, L) :- sklej(_, [X | _], L).
ostatni_sklej(Element, Lista) :- sklej(_, [Element], Lista).
ostatni(Element, [Element]).
ostatni(Element, [_ | T]) :- ostatni(Element, T).

%---------------------------------------------------
% 6. Dodawanie elementów
% Predykat dodający element na początek listy.
dodaj(X, L, [X | L]).

%---------------------------------------------------
% 7. Usuwanie elementów
% Predykat usuwający elementy z listy i jego zastosowania.
usun(X, [X | Reszta], Reszta).
usun(X, [Y | Ogon], [Y | Reszta]) :-
    X \== Y,
    usun(X, Ogon, Reszta).
wstaw(X, L, Duza) :- usun(X, Duza, L).
nalezy2(X, L) :- usun(X, L, _).

%---------------------------------------------------
% 8. Zawieranie list
% Predykat sprawdzający, czy jedna lista jest podlistą innej.
zawiera(S, L) :-
    sklej(_, L2, L),
    sklej(S, _, L2).

%---------------------------------------------------
% 9. Permutacje list
% Dwie metody generowania permutacji listy.
permutacja([], []).
permutacja([X | L], P) :-
    permutacja(L, L1),
    wstaw(X, L1, P).
permutacja2([], []).
permutacja2(L, [X | P]) :-
    usun(X, L, L1),
    permutacja2(L1, P).

%---------------------------------------------------
% 10. Odwracanie list
% Dwie metody odwracania kolejności elementów w liście (jedna efektywniejsza).
odwroc([], []).
odwroc([H | T], L) :-
    odwroc(T, R),
    sklej(R, [H], L).
odwroc2(L, R) :- odwr2(L, [], R).
odwr2([], A, A).
odwr2([H | T], A, R) :- odwr2(T, [H | A], R).

%---------------------------------------------------
% 11. Listy a napisy
% Predykaty do obsługi list znaków i prostych transformacji tekstowych.
wypisz([]).
wypisz([H | T]) :- put(H), wypisz(T).
plural(Noun, Plural) :-
    name(Noun, NounChars),
    name(s, SCharList),
    append(NounChars, SCharList, PluralChars),
    name(Plural, PluralChars).

%---------------------------------------------------
% 14. Problemy do samodzielnego rozwiązania
% Różnorodne zadania na listach, takie jak usuwanie elementów, sprawdzanie
% długości, palindromy, rotacje, konwersje danych, podzbiory, dzielenie i spłaszczanie list,
% oraz rozmienianie pieniędzy.
usun_3_ostatnich(L, L1) :- sklej(L1, [_, _, _], L).
usun_3_pierwszych(L, L1) :- sklej([_, _, _], L1, L).
usun_3_pierwszych_i_ostatnich(L, L2) :- sklej([_, _, _], Temp, L), sklej(L2, [_, _, _], Temp).
parzysta([]).
parzysta([_, _ | T]) :- parzysta(T).
nieparzysta([_]).
nieparzysta([_, _, _ | T]) :- nieparzysta(T).
palindrom(L) :- odwroc(L, L).
przesun([H | T], L2) :- sklej(T, [H], L2).
znaczy(0, zero).
znaczy(1, jeden).
znaczy(2, dwa).
znaczy(3, trzy).
znaczy(4, cztery).
znaczy(5, piec).
znaczy(6, szesc).
znaczy(7, siedem).
znaczy(8, osiem).
znaczy(9, dziewiec).
przeloz([], []).
przeloz([H1 | T1], [H2 | T2]) :- ( (integer(H1), znaczy(H1, H2)) ; (atom(H1), znaczy(H2, H1)) ), przeloz(T1, T2).
podzbior([], []).
podzbior([H | T], Z) :- podzbior(T, Z).
podzbior([H | T], [H | Z]) :- podzbior(T, Z).
podziel([], [], []).
podziel([X], [X], []).
podziel([X, Y | T], [X | L1], [Y | L2]) :- podziel(T, L1, L2).
splaszcz(X, [X]) :- \+ is_list(X).
splaszcz([], []).
splaszcz([H | T], L) :- splaszcz(H, H_flat), splaszcz(T, T_flat), sklej(H_flat, T_flat, L).
moneta(1).
moneta(2).
moneta(5).
moneta(10).
moneta(20).
moneta(50).
rozmien(0, []).
rozmien(Kwota, [Nominal | Reszta]) :- moneta(Nominal), Kwota >= Nominal, NowaKwota is Kwota - Nominal, rozmien(NowaKwota, Reszta).

%---------------------------------------------------
% 15. Przechwytywanie wyników
% Omówienie użycia bagof/3, setof/3, findall/3 do zbierania rozwiązań.
% Wymaga załadowania pliku rodzina1.pl.
% (Kod rodzina1.pl nie jest tutaj, ale zakłada się jego obecność)

%---------------------------------------------------
% 16. Labirynt
% Analiza programu maze.pl, definicja połączeń labiryntu i modyfikacje.
% Wymaga załadowania pliku maze.pl.
% Predykat `connected_to/2` zapewnia dwukierunkowe przejścia w labiryncie.
connect(start, 2).
connect(start, 1).
connect(1, 7). connect(2, 3). connect(2, 8). connect(3, 4). connect(4, 5). connect(4, 10).
connect(5, 6). connect(5, 11). connect(6, 12). connect(7, 13). connect(8, 9). connect(9, 10).
connect(10, 16). connect(11, 17). connect(12, 18). connect(13, 19). connect(14, 8).
connect(14, 15). connect(15, 9). connect(15, 16). connect(15, 21). connect(16, 22).
connect(17, 23). connect(18, 24). connect(19, 25). connect(20, 14). connect(20, 21).
connect(21, 27). connect(22, 28). connect(23, 29). connect(24, 30). connect(25, 31).
connect(26, 20). connect(26, 27). connect(27, 33). connect(28, 34). connect(29, 35).
connect(30, 29). connect(31, finish). connect(32, 31). connect(32, 26). connect(33, 34).
connect(34, finish). connect(35, finish). connect(36, 30). connect(36, 35).
% Dodatkowe połączenia dla wielu dróg (zmodyfikowany labirynt).
connect(2, 15).
connect(28, finish).

%---------------------------------------------------
% 17. Zagadka (Piramidek)
% Rozwiązania piramidek przy użyciu Constraint Logic Programming (CLP(FD)).
% Definiowanie zmiennych, ich domen, reguł sum/różnic oraz reguł dotyczących
% powtórzeń cyfr w rzędach.
:- use_module(library(clpfd)).
has_repetition(List) :- list_to_set(List, Set), length(List, LLen), length(Set, SLen), LLen #> SLen.

solve_pyramid1(P) :-
    P = [[A], [B, C], [D, E, F], [G, H, I, J], [K, L, M, N, O]],
    ListNums = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O],
    fd_domain(ListNums, 1, 9),
    A = 2, L = 1, N = 6, D = 5, F = 4, H = 8,
    fd_all_distinct([A]), fd_all_distinct([B, C]), fd_all_distinct([K, L, M, N, O]),
    (A #= B + C ; A #= abs(B - C)), (B #= D + E ; B #= abs(D - E)), (C #= E + F ; C #= abs(E - F)),
    (D #= G + H ; D #= abs(G - H)), (E #= H + I ; E #= abs(H - I)), (F #= I + J ; F #= abs(I - J)),
    (G #= K + L ; G #= abs(K - L)), (H #= L + M ; H #= abs(L - M)), (I #= M + N ; I #= abs(M - N)),
    (J #= N + O ; J #= abs(N - O)),
    fd_labeling(ListNums),
    has_repetition([D, E, F]), has_repetition([G, H, I, J]).

solve_pyramid2(P) :-
    P = [[A], [B, C], [D, E, F], [G, H, I, J], [K, L, M, N, O]],
    ListNums = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O],
    fd_domain(ListNums, 1, 9),
    A = 7, B = 2, D = 1, F = 5, H = 8, K = 4, M = 9, O = 3,
    fd_all_distinct([B, C]), fd_all_distinct([G, H, I, J]),
    (A #= B + C ; A #= abs(B - C)), (B #= D + E ; B #= abs(D - E)), (C #= E + F ; C #= abs(E - F)),
    (D #= G + H ; D #= abs(G - H)), (E #= H + I ; E #= abs(H - I)), (F #= I + J ; F #= abs(I - J)),
    (G #= K + L ; G #= abs(K - L)), (H #= L + M ; H #= abs(L - M)), (I #= M + N ; I #= abs(M - N)),
    (J #= N + O ; J #= abs(N - O)),
    fd_labeling(ListNums).