% generator_laser.lp
% clingo -n 1 --rand-freq=1 --seed=`echo $RANDOM` generator_laser.lp --stats
% https://www.puzzlescript.net/editor.html?hack=e559af178f5d63b65989cbef2e5fe663

%-----------%
% Constants %
%-----------%

#const n = 6. % height
#const m = 6. % width

#const minLasers = 1.
#const maxLasers = 1.

#const minGoals = 1.
#const maxGoals = 1.

#const minDoors = 1.
#const maxDoors = 1.

dimX(0..n-1).
dimY(0..m-1).

%------------------%
% Tile definitions %
%------------------%

tile(background).
tile(wall).
tile(player).
tile(exit).

tile(laserUrot).
tile(laserDrot).
tile(laserLrot).
tile(laserRrot).

tile(mirrorULrot).
tile(mirrorURrot).
tile(mirrorDRrot).
tile(mirrorDLrot).
tile(goalOff).

tile(wireOff).
tile(wireWallOff).
tile(doorClosed).

%----------------------%
% Laser-related groups %
%----------------------%

laserRot(laserUrot;laserDrot;laserLrot;laserRrot).
laser(X) :- laserRot(X), tile(X).

goal(goalOff).
door(doorClosed).

%-------------------------%
% Movement-related groups %
%-------------------------%

solid(X) :- goal(X).
solid(X) :- laser(X).
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
minLasers { at(0..n-1, 0..m-1, T) :laser(T) } maxLasers.
minDoors { at(0..n-1, 0..m-1, T) :door(T) } maxDoors.
minGoals { at(0..n-1, 0..m-1, T) :goal(T) } maxGoals.
    
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

%-----------------------------------%
%----------- LEVEL TYPE ------------%
% one rot laser, one goal, one door %
%-----------------------------------%

%-------------------------------------%
% rot laser must be in line with goal %
%-------------------------------------%
:- at(X, Y, T), laser(T), at(0..X-1, 0..Y-1, S), goal(S).
:- at(X, Y, T), laser(T), at(0..X-1, Y+1..m-1, S), goal(S).
:- at(X, Y, T), laser(T), at(X+1..n-1, 0..Y-1, S), goal(S).
:- at(X, Y, T), laser(T), at(X+1..n-1, Y+1..m-1, S), goal(S).

%-----------------------------------%
% laser beam must propagate to goal %
%-----------------------------------%
laserReachableUp(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableUp(X + 1, Y).
laserReachableUp(X, Y) :-
    at(X + 1, Y, T), laser(T).
laserReachableDown(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableDown(X - 1, Y).
laserReachableDown(X, Y) :-
    at(X - 1, Y, T), laser(T).
laserReachableLeft(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableLeft(X, Y + 1).
laserReachableLeft(X, Y) :-
    at(X, Y + 1, T), laser(T).
laserReachableRight(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableRight(X, Y - 1).
laserReachableRight(X, Y) :-
    at(X, Y - 1, T), laser(T).

goalReachableByLaser :-
    at(GoalX, GoalY, G), goal(G),
    laserReachableUp(GoalX, GoalY).
goalReachableByLaser :-
    at(GoalX, GoalY, G), goal(G),
    laserReachableDown(GoalX, GoalY).
goalReachableByLaser :-
    at(GoalX, GoalY, G), goal(G),
    laserReachableLeft(GoalX, GoalY).
goalReachableByLaser :-
    at(GoalX, GoalY, G), goal(G),
    laserReachableRight(GoalX, GoalY).
    
:- not goalReachableByLaser.

%-------------------------------------------------%
% rot laser must not be initially pointed to goal %
%-------------------------------------------------%
:- at(X, Y, laserUrot), at(X, 0..Y-1, S), goal(S).
:- at(X, Y, laserDrot), at(X, Y+1..m-1, S), goal(S).
:- at(X, Y, laserRrot), at(X+1..n-1, Y, S), goal(S).
:- at(X, Y, laserLrot), at(0..X-1, Y, S), goal(S).

#show at/3.