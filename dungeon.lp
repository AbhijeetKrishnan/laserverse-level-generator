% dungeon.lp
% clingo -n 1 --rand-freq=1 --seed=`echo $RANDOM` dungeon.lp --stats
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

#const minMirrors = 1.
#const maxMirrors = 1.

#const minSplitters = 0.
#const maxSplitters = 0.

#const minCrates = 0.
#const maxCrates = 0.

#const minDoors = 1.
#const maxDoors = 1.

#const minAndGates = 0.
#const maxAndGates = 0.

#const minButtons = 0.
#const maxButtons = 0.

dimX(0..n-1).
dimY(0..m-1).

step(0,-1 ;; 0,1 ;; 1,0 ;; -1,0).

%------------------%
% Tile definitions %
%------------------%

tile(background).
tile(wall).
tile(player).
%tile(crate).
tile(exit).
%tile(glass).

%tile(laserU).
%tile(laserD).
%tile(laserL).
%tile(laserR).

%tile(laserOnU).
%tile(laserOnD).
%tile(laserOnL).
%tile(laserOnR)

%tile(laserOffU).
%tile(laserOffD).
%tile(laserOffL).
%tile(laserOffR).

tile(laserUrot).
tile(laserDrot).
tile(laserLrot).
tile(laserRrot).

%tile(laserUtran).
%tile(laserDtran).
%tile(laserLtran).
%tile(laserRtran).

%tile(laserOffUrot).
%tile(laserOffDrot).
%tile(laserOffLrot).
%tile(laserOffRrot).

%tile(mirrorUL).
%tile(mirrorUR).
%tile(mirrorDR).
%tile(mirrorDL).

%tile(mirrorULtran).
%tile(mirrorURtran).
%tile(mirrorDRtran).
%tile(mirrorDLtran).

tile(mirrorULrot).
tile(mirrorURrot).
tile(mirrorDRrot).
tile(mirrorDLrot).

%tile(splitter1).
%tile(splitter2).
%tile(splitter1tran).
%tile(splitter2tran).
%tile(splitter1rot).
%tile(splitter2rot).

%tile(goalOffguardDLR).
%tile(goalOffguardULR).
%tile(goalOffguardUDR).
%tile(goalOffguardUDL).
tile(goalOff).

tile(wireOff).
tile(wireWallOff).
%tile(buttonOff).
tile(doorClosed).
%tile(antiDoorOpen).
%tile(gate0). %AND gate

%------------------------------%
% Action-button-related groups %
%------------------------------%

rotator(laserUrot;laserDrot;laserLrot;laserRrot).
rotator(laserOffUrot;laserOffDrot;laserOffLrot;laserOffRrot).
rotator(mirrorULrot;mirrorURrot;mirrorDRrot;mirrorDLrot).
rotator(splitter1rot;splitter2rot).

translator(laserUtran;laserDtran;laserLtran;laserRtran).
translator(laserOffUtran;laserOffDtran;laserOffLtran;laserOffRtran).
translator(mirrorULtran;mirrorURtran;mirrorDRtran;mirrorDLtran).
translator(splitter1tran;splitter2tran).

%----------------------%
% Laser-related groups %
%----------------------%

laserConstant(laserU;laserD;laserL;laserR).
laserOn(laserOnU;laserOnD;laserOnL;laserOnR).
laserOff(laserOffU;laserOffD;laserOffL;laserOffR).
laserRot(laserUrot;laserDrot;laserLrot;laserRrot).
laser(X) :- laserConstant(X), tile(X).
laser(X) :- laserOn(X), tile(X).
laser(X) :- laserOff(X), tile(X).
laser(X) :- laserRot(X), tile(X).

mirrorConstant(mirrorUL;mirrorUR;mirrorDR;mirrorDL).
mirrorRot(mirrorULrot;mirrorURrot;mirrorDRrot;mirrorDLrot).
mirrorTran(mirrorULtran;mirrorURtran;mirrorDRtran;mirrorDLtran).
mirror(X) :- mirrorConstant(X), tile(X).
mirror(X) :- mirrorRot(X), tile(X).
mirror(X) :- mirrorTran(X), tile(X).

splitterConstant(splitter1;splitter2).
splitterRot(splitter1rot;splitter2rot).
splitterTran(splitter1tran;splitter2tran).
splitter(X) :- splitterConstant(X), tile(X).
splitter(X) :- splitterRot(X), tile(X).
splitter(X) :- splitterTran(X), tile(X).

goal(goalOff).
%goal(goalOffguardDLR;goalOffguardUDL;goalOffguardUDR;goalOffguardULR).

door(doorClosed).
%door(antiDoorOpen).

%-------------------------%
% Movement-related groups %
%-------------------------%

movable(X) :- mirror(X).
movable(crate).
movable(X) :- splitter(X).
movable(X) :- laserConstant(X).

solid(X) :- movable(X).
solid(X) :- goal(X).
solid(X) :- laser(X).
solid(wall).
solid(wireWallOff).
solid(doorClosed).
% incorrect assumption that you cannot move into guarded goal from single
% non-guarded side. Not sure how to resolve it
solid(goalOffguardDLR;goalOffguardUDL;goalOffguardUDR;goalOffguardULR).
solid(glass).

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
minMirrors { at(0..n-1, 0..m-1, T) :mirror(T) } maxMirrors.
minSplitters { at(0..n-1, 0..m-1, T) :splitter(T) } maxSplitters.
minCrates { at(0..n-1, 0..m-1, crate) } maxCrates.
minAndGates { at(0..n-1, 0..m-1, gate0) } maxAndGates.
minButtons { at(0..n-1, 0..m-1, buttonOff) } maxButtons.

%------------------------------------------%
% There must be a path from player to exit %
%------------------------------------------%
pathExists(X, Y, X, Y) :- dimX(X), dimY(Y).
pathExists(X1, Y1, X2, Y2) :-
	dimX(X1), dimY(Y1),
	step(DX, DY),
    NX = X1 + DX,
    NY = Y1 + DY,
	at(NX, NY, T), not solid(T),
	pathExists(NX, NY, X2, Y2).
    
adjacent(X,Y,X+1,Y):- dimX(X), dimY(Y).
adjacent(X,Y,X-1,Y):- dimX(X), dimY(Y).
adjacent(X,Y,X,Y-1):- dimX(X), dimY(Y).
adjacent(X,Y,X,Y+1):- dimX(X), dimY(Y).

%:- at(PlayerX, PlayerY, player), at(ExitX, ExitY, exit),
%	not pathExists(PlayerX, PlayerY, ExitX, ExitY).

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

%% set constants appropriately

%-------------------------------------------------%
% door must be connected to button by single wire %
%-------------------------------------------------%
wirePathExists(X, Y, X, Y) :- dimX(X), dimY(Y).
wirePathExists(X1, Y1, X2, Y2) :-
	dimX(X1), dimY(Y1),
	adjacent(X1, Y1, NX, NY),
	at(NX, NY, T), wire(T),
	wirePathExists(NX, NY, X2, Y2).
    
%:- at(ButtonX, ButtonY, buttonOff), at(DoorX, DoorY, doorClosed),
%    adjacent(DoorX, DoorY, NX, NY),
%    not wirePathExists(DoorX, DoorY, NX, NY).

%-------------------------%
% crate must be reachable %
%-------------------------%
%:- at(CrateX, CrateY, crate), at(PlayerX, PlayerY, player), step(DX, DY),
%    not pathExists(PlayerX, PlayerY, CrateX + DX, CrateY + DY).

%--------------------------------------%  
% path must exist from crate to button %
%--------------------------------------%
%:- at(CrateX, CrateY, crate), at(ButtonX, ButtonY, buttonOff), step(DX, DY),
%    not pathExists(CrateX, CrateY, ButtonX + DX, ButtonY + DY).

%-------------------------------------%
% path must exist from button to door %
%-------------------------------------%
%:- at(ButtonX, ButtonY, buttonOff), at(DoorX, DoorY, doorClosed), step(DX, DY),
%    not pathExists(ButtonX, ButtonY, DoorX + DX, DoorY + DY).

%-----------------------------------%
%----------- LEVEL TYPE ------------%
% one rot laser, one goal, one door %
%-----------------------------------%

%% rot laser must be reachable
%
%% door must be reachable from rot laser
%
%% rot laser must be in line with goal
%:- at(X, Y, T), laser(T), at(0..X-1, 0..Y-1, S), goal(S).
%:- at(X, Y, T), laser(T), at(0..X-1, Y+1..m-1, S), goal(S).
%:- at(X, Y, T), laser(T), at(X+1..n-1, 0..Y-1, S), goal(S).
%:- at(X, Y, T), laser(T), at(X+1..n-1, Y+1..m-1, S), goal(S).
%
%% laser beam must propagate to goal
%laserReachableUp(X, Y) :-
%    at(X, Y, T), not solid(T),
%    laserReachableUp(X + 1, Y).
%laserReachableUp(X, Y) :-
%    at(X + 1, Y, T), laser(T).
%laserReachableDown(X, Y) :-
%    at(X, Y, T), not solid(T),
%    laserReachableDown(X - 1, Y).
%laserReachableDown(X, Y) :-
%    at(X - 1, Y, T), laser(T).
%laserReachableLeft(X, Y) :-
%    at(X, Y, T), not solid(T),
%    laserReachableLeft(X, Y + 1).
%laserReachableLeft(X, Y) :-
%    at(X, Y + 1, T), laser(T).
%laserReachableRight(X, Y) :-
%    at(X, Y, T), not solid(T),
%    laserReachableRight(X, Y - 1).
%laserReachableRight(X, Y) :-
%    at(X, Y - 1, T), laser(T).
%
%goalReachableByLaser :-
%    at(GoalX, GoalY, G), goal(G),
%    laserReachableUp(GoalX, GoalY).
%goalReachableByLaser :-
%    at(GoalX, GoalY, G), goal(G),
%    laserReachableDown(GoalX, GoalY).
%goalReachableByLaser :-
%    at(GoalX, GoalY, G), goal(G),
%    laserReachableLeft(GoalX, GoalY).
%goalReachableByLaser :-
%    at(GoalX, GoalY, G), goal(G),
%    laserReachableRight(GoalX, GoalY).
%    
%:- not goalReachableByLaser.
%
%% rot laser must not be initially pointed to goal
%:- at(X, Y, laserUrot), at(X, 0..Y-1, S), goal(S).
%:- at(X, Y, laserDrot), at(X, Y+1..m-1, S), goal(S).
%:- at(X, Y, laserRrot), at(X+1..n-1, Y, S), goal(S).
%:- at(X, Y, laserLrot), at(0..X-1, Y, S), goal(S).

%---------------------------------------------------%
%------------------- LEVEL TYPE --------------------%
% one rot laser, one rot mirror, one goal, one door %
%---------------------------------------------------%

% rot laser must be reachable

% door must be reachable from rot laser

% rot laser must be in line with mirror
:- at(X, Y, T), laser(T), at(0..X-1, 0..Y-1, S), mirror(S).
:- at(X, Y, T), laser(T), at(0..X-1, Y+1..m-1, S), mirror(S).
:- at(X, Y, T), laser(T), at(X+1..n-1, 0..Y-1, S), mirror(S).
:- at(X, Y, T), laser(T), at(X+1..n-1, Y+1..m-1, S), mirror(S).

% laser beam must propagate to mirror
laserOrMirror(T) :- laser(T).
laserOrMirror(T) :- mirror(T).

laserReachableUp(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableUp(X + 1, Y).
laserReachableUp(X, Y) :-
    at(X + 1, Y, T), laserOrMirror(T).
laserReachableDown(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableDown(X - 1, Y).
laserReachableDown(X, Y) :-
    at(X - 1, Y, T), laserOrMirror(T).
laserReachableLeft(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableLeft(X, Y + 1).
laserReachableLeft(X, Y) :-
    at(X, Y + 1, T), laserOrMirror(T).
laserReachableRight(X, Y) :-
    at(X, Y, T), not solid(T),
    laserReachableRight(X, Y - 1).
laserReachableRight(X, Y) :-
    at(X, Y - 1, T), laserOrMirror(T).

mirrorReachableByLaser :-
    at(GoalX, GoalY, G), mirror(G),
    laserReachableUp(GoalX, GoalY).
mirrorReachableByLaser :-
    at(GoalX, GoalY, G), mirror(G),
    laserReachableDown(GoalX, GoalY).
mirrorReachableByLaser :-
    at(GoalX, GoalY, G), mirror(G),
    laserReachableLeft(GoalX, GoalY).
mirrorReachableByLaser :-
    at(GoalX, GoalY, G), mirror(G),
    laserReachableRight(GoalX, GoalY).
    
:- not mirrorReachableByLaser.

% laser beam must propagate to goal
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

% rot laser must not be initially pointed to mirror
:- at(X, Y, laserUrot), at(X, 0..Y-1, S), mirror(S).
:- at(X, Y, laserDrot), at(X, Y+1..m-1, S), mirror(S).
:- at(X, Y, laserRrot), at(X+1..n-1, Y, S), mirror(S).
:- at(X, Y, laserLrot), at(0..X-1, Y, S), mirror(S).

% mirror must be in line with goal
:- at(X, Y, T), mirror(T), at(0..X-1, 0..Y-1, S), goal(S).
:- at(X, Y, T), mirror(T), at(0..X-1, Y+1..m-1, S), goal(S).
:- at(X, Y, T), mirror(T), at(X+1..n-1, 0..Y-1, S), goal(S).
:- at(X, Y, T), mirror(T), at(X+1..n-1, Y+1..m-1, S), goal(S).

#show at/3.