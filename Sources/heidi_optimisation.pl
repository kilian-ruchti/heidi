%%-----------------------------------------------------------------------------
%% Optimisation
%%-----------------------------------------------------------------------------
%% De Heidi

%% De Heidi
% List of orders.

h_order('deponer').
h_order('dretg').
h_order('sanester').
h_order('davent').
h_order('davos').
h_order('plaun').
h_order('returnar').
h_order('sa_fermar').


% To see if an order is known.
heidi_order(X) :-
    h_order(X).


% To see if a sequence of orders is known.(various cases)
heidi_sequence(X) :-
    heidi_order(X).

heidi_sequence([H|T]) :-
    heidi_order(H),
    T = [].

heidi_sequence([H|T]) :-
    heidi_order(H),
    heidi_sequence(T).

/*
<examples of tests>

?- h_order(davent).
?- h_order(X).

?- heidi_sequence(deponer).
?- heidi_sequence([deponer,davent]).
?- heidi_sequence([dretg,davos,sa_fermar]).
*/

%%-----------------------------------------------------------------------------
%% De Tita

t_whistle(wheet).
t_whistle(wheeo).
t_whistle(hee).
t_pause(pause).


% To see if a whistle is known.
tita_whistle(X) :-
    t_whistle(X).


% To see if a sequence of whistles is known.(various cases)
tita_sequence(X) :-
    tita_whistle(X).

tita_sequence([H|T]) :-
    tita_whistle(H),
    T = [].

tita_sequence([H|T]) :-
    tita_whistle(H),
    tita_sequence(T).


% To see if a sequence in work time (sequence of whistles with pauses) is known.
work_sequence(X) :-
    tita_sequence(X).

work_sequence(X) :-
    append(Whistle_head, Whistle_tail, X),
    tita_sequence(Whistle_head),
    Whistle_tail = [Y|Tail],
    t_pause(Y),
    work_sequence(Tail).

/*
<examples of tests>

?- t_whistle(hee).
?- tita_sequence(X).
?- seance_travail([hee, wheet, pause, hee, wheet, pause, wheeo]).
*/

%%-----------------------------------------------------------------------------
%% De Heidi a Tita
% New translations from Romanche to wistles.

translation('deponer', [wheeo, hee, wheet]).
translation('dretg', [hee, wheet]).
translation('sanester', [wheet, wheeo]).
translation('davent', [wheet, hee, wheet]).
translation('davos', [wheet, wheeo, wheet]).
translation('plaun', [wheet, wheeo, wheeo]).
translation('returnar', [wheeo, wheet]).
translation('sa_fermar', [wheeo, wheeo]).

% To translate an order to tita
heidi_to_tita(Ord, Whis) :-
    translation(Ord, Whis).

heidi_to_tita(Ord, Whis) :-
    Ord = [X],
    translation(X, Whis).

heidi_to_tita(Ord, Whis) :-
    Ord = [Orders_head|Orders_tail],
    append(Whistle_head, Whistle_tail, Whis),
    translation(Orders_head, Whistle_head),
    Whistle_tail = [A|B],
    t_pause(A),
    heidi_to_tita(Orders_tail, B).

/*
<examples of tests>

?- heidi_to_tita('plaun', [wheet, wheeo, wheeo, pause]).
?- heidi_to_tita([dretg, davos], [hee, wheet, pause, wheet, wheeo, wheet]).
?- heidi_to_tita(X, [wheet, wheeo, wheeo, pause, hee, wheet]).
?- heidi_to_tita(X,Y).
*/

%%-----------------------------------------------------------------------------
%% De Tita a Heidi

tita_to_heidi(Whis, Ord) :-
    heidi_to_tita(Ord, Whis).

/*
<examples of tests>

?- tita_to_heidi([wheeo, hee, wheet, pause, wheet, wheeo, wheeo], [deponer, plaun]).
?- tita_to_heidi([wheeo, wheeo, pause, wheet, wheeo, wheet], [sa_fermar, davos]).
?- tita_to_heidi(X,Y).
*/

%%-----------------------------------------------------------------------------
heidi_to_tita_to_heidi(Orders) :-
    heidi_to_tita(Orders, X),
    tita_to_heidi(X, Y),
    Orders == Y,
    !.

/*
<examples of tests>
?- heidi_to_tita_to_heidi([deponer, dretg, davos, plaun, sa_fermar]).
?- heidi_to_tita_to_heidi(X).
*/
