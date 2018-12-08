% generator_crate.lp
% clingo -n 1 --rand-freq=1 --seed=`echo $RANDOM` generator_crate.lp --stats
% https://www.puzzlescript.net/editor.html?hack=e559af178f5d63b65989cbef2e5fe663

%-----------%
% Constants %
%-----------%

#const n = 6. % height
#const m = 6. % width

#const minCrates = 0.
#const maxCrates = 0.

#const minDoors = 1.
#const maxDoors = 1.

#const minButtons = 1.
#const maxButtons = 1.

dimX(0..n-1).
dimY(0..m-1).

%------------------%
% Tile definitions %
%------------------%

tile(background).
tile(wall).
tile(player).
tile(crate).
tile(exit).

tile(goalOff).

tile(wireOff).
tile(wireWallOff).
tile(buttonOff).
tile(doorClosed).

goal(goalOff).
door(doorClosed).

%-------------------------%
% Movement-related groups %
%-------------------------%

movable(crate).

solid(X) :- movable(X).
solid(X) :- goal(X).
solid(wall).
solid(wireWallOff).
solid(doorClosed).
wire(wireOff;wireWallOff).

%----------%
% Generate %
%----------%

{ at(X, Y, T) :tile(T) } = 1 :- dimX(X), dimY(Y).

%------%
% Test %
%------%

%----------------------------------------------%
% There must be exactly one instance of player %
%----------------------------------------------%
{ at(0..n-1, 0..m-1, player) } = 1.

%--------------------------------------------%
% There must be exactly one instance of exit %
%--------------------------------------------%
{ at(0..n-1, 0..m-1, exit) } = 1.

%----------------------------------%
% Cardinality constraints on tiles %
%----------------------------------%
minDoors { at(0..n-1, 0..m-1, T) :door(T) } maxDoors.
minCrates { at(0..n-1, 0..m-1, crate) } maxCrates.
minButtons { at(0..n-1, 0..m-1, buttonOff) } maxButtons.

adjacent(X,Y,X+1,Y):- dimX(X), dimY(Y).
adjacent(X,Y,X-1,Y):- dimX(X), dimY(Y).
adjacent(X,Y,X,Y-1):- dimX(X), dimY(Y).
adjacent(X,Y,X,Y+1):- dimX(X), dimY(Y).

%--------------------------------------------------------------------------%
% --------------------- LEVEL BOUNDARY CONDITIONS -------------------------%
% to enforce similarity between authored level layout and generated levels %
%--------------------------------------------------------------------------%

%-------------------------------------------%
% level boundaries must be wall/player/exit %
%-------------------------------------------%
boundary(wall;player;exit).

:- at(0, 0..m-1, T), not boundary(T).
:- at(n-1, 0..m-1, T), not boundary(T).
:- at(0..n-1, 0, T), not boundary(T).
:- at(0..n-1, m-1, T), not boundary(T).

%----------------------------%
% Player must be on boundary %
%----------------------------%
:- at(X, Y, player), X > 0, X < n - 1, Y > 0, Y < m - 1.

%--------------------------%
% Exit must be on boundary %
%--------------------------%
:- at(X, Y, exit), X > 0, X < n - 1, Y > 0, Y < m - 1.

%------------------------------%
% Player must not be on corner %
%------------------------------%
:- at(0, 0, player).
:- at(0, m-1, player).
:- at(n-1, 0, player).
:- at(n-1, m-1, player).

%----------------------------%
% Exit must not be on corner %
%----------------------------%
:- at(0, 0, exit).
:- at(0, m-1, exit).
:- at(n-1, 0, exit).
:- at(n-1, m-1, exit).

%---------------------------------------------%
% door must be adjacent to exit on inner side %
%---------------------------------------------%
:- at(ExitX, ExitY, exit), at(DoorX, DoorY, doorClosed), 
    not adjacent(ExitX, ExitY, DoorX, DoorY).

%-------------------------------------%
% exit must not be adjacent to player %
%-------------------------------------%
:- at(ExitX, ExitY, exit), at(PlayerX, PlayerY, player), 
    adjacent(ExitX, ExitY, PlayerX, PlayerY).

%---------------------------------%
%---------- LEVEL TYPE -----------%
% one crate, one button, one door %
%---------------------------------%

#show at/3.