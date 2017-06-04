%% Abstract syntax
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
%%  De Tita
% List of whistles.

t_whistle(court).
t_whistle(whee).
t_whistle(wheet).
t_whistle(wheeo).
t_whistle(who).
t_whistle(hee).
t_whistle(long).
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

?- t_whistle(whee).
?- t_whistle(X).

?- tita_sequence([hee]).
?- tita_sequence([wheeo, hee, long]).

?- seance_travail([court, whee]).
?- seance_travail([court, whee, pause]).
?- seance_travail([wheeo, hee, pause, long, court, pause, who]).
*/

%%-----------------------------------------------------------------------------
%% Sémantique
%% De Heidi a Tita
% Translations from Romanche to wistles.

translation('deponer', [court,court]).
translation('dretg', [whee, who]).
translation('sanester', [wheet, wheeo]).
translation('davent', [wheet, wheeo, wheet, wheet]).
translation('davos', [who, hee, who]).
translation('plaun', [hee, hee, hee, hee]).
translation('returnar', [whee, whee, wheet]).
translation('sa_fermar', [long]).


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

?- heidi_to_tita('plaun', [hee, hee, hee, hee]).
?- heidi_to_tita([dretg, davos], [whee, who, pause, who, hee, who]).
?- heidi_to_tita(X, [whee, who, pause, long]).
?- heidi_to_tita(X,Y).
*/

%%-----------------------------------------------------------------------------
%% De Tita a Heidi

tita_to_heidi(Whis, Ord) :-
    heidi_to_tita(Ord, Whis).

/*
<examples of tests>

?- tita_to_heidi([court, court, pause, hee, hee, hee, hee], [deponer, plaun]).
?- tita_to_heidi([long, pause, who, hee, who], [sa_fermar, davos]).
?- tita_to_heidi(X,Y).
*/
