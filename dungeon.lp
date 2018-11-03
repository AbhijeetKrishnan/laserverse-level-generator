% dungeon.lp
% clingo -n 1 --rand-freq=1 --seed=`echo $RANDOM` dungeon.lp --stats
% https://www.puzzlescript.net/editor.html?hack=e559af178f5d63b65989cbef2e5fe663

#const n = 5.
#const m = 9.
#const numLasers = 1.
#const numSensors = 1.

dimX(0..n-1). % everything in this range is a valid dimension
dimY(0..m-1).

tile(background).
tile(wall).
tile(player).
%tile(crate).
tile(exit).
%tile(glass).

%tile(laserU). %transparent
%tile(laserD). %transparent
%tile(laserL). %transparent
%tile(laserR). %transparent

%tile(laserOffU).
%tile(laserOffD).
%tile(laserOffL).
%tile(laserOffR).

tile(laserUrot1).
tile(laserDrot1).
tile(laserLrot1).
tile(laserRrot1).

%tile(laserUtran1).
%tile(laserDtran1).
%tile(laserLtran1).
%tile(laserRtran1).

%tile(laserOffUrot1).
%tile(laserOffDrot1).
%tile(laserOffLrot1).
%tile(laserOffRrot1).

%tile(mirrorUL).
%tile(mirrorUR).
%tile(mirrorDR).
%tile(mirrorDL).

%tile(mirrorULtran1).
%tile(mirrorURtran1).
%tile(mirrorDRtran1).
%tile(mirrorDLtran1).

%tile(mirrorULrot1).
%tile(mirrorURrot1).
%tile(mirrorDRrot1).
%tile(mirrorDLrot1).

%tile(splitter1).
%tile(splitter2).
%tile(splitter1tran1).
%tile(splitter2tran1).
%tile(splitter1rot1).
%tile(splitter2rot1).

%tile(goalOffguardDLR).
%tile(goalOffguardULR).
%tile(goalOffguardUDR).
%tile(goalOffguardUDL).
tile(goalOff).

tile(wireOff).
%tile(wireWallOff).
%tile(buttonOff).
tile(doorClosed).
%tile(antiDoorOpen).
%tile(gate0).

%transparent(background;player;exit;goalOff;wireOff; doorClosed).
%transparent(L) :- laser(L).
step(0,-1 ;; 0,1 ;; 1,0 ;; -1,0).
%path(X, Y, X, Y, 0) :- at(X, Y, T), transparent(T).
%path(X1, Y1, X2, Y2, L) :-
%    at(X1, Y1, T), transparent(T),
%    step(DX, DY),
%    NX = X1 + DX,
%    NY = Y1 + DY,
%    at(NX, NY, T2), transparent(T2),
%    path(NX, NY, X2, Y2, L-1).

%% Generate
{ at(X, Y, T) :tile(T) } = 1 :- dimX(X), dimY(Y).

%% Test

% level boundaries must be wall/player/exit
boundary(wall;player;exit).

:- at(0, 0..m-1, T), not boundary(T).
:- at(n-1, 0..m-1, T), not boundary(T).
:- at(0..n-1, 0, T), not boundary(T).
:- at(0..n-1, m-1, T), not boundary(T).

% There must be exactly one instance of player
{ at(0..n-1, 0..m-1, player) } = 1.

% There must be exactly one instance of exit
{ at(0..n-1, 0..m-1, exit) } = 1.

% Player must be on boundary
:- at(X, Y, player), X > 0, X < n - 1, Y > 0, Y < m - 1.

% Exit must be on boundary
:- at(X, Y, exit), X > 0, X < n - 1, Y > 0, Y < m - 1.

% Player must not be on corner
:- at(X, Y, player), X = 0, Y = 0.
:- at(X, Y, player), X = 0, Y = m-1.
:- at(X, Y, player), X = 0, Y = 0.
:- at(X, Y, player), X = n-1, Y = m-1.

% Exit must not be on corner
:- at(X, Y, exit), X = 0, Y = 0.
:- at(X, Y, exit), X = 0, Y = m-1.
:- at(X, Y, exit), X = 0, Y = 0.
:- at(X, Y, exit), X = n-1, Y = m-1.

% There must be a path from player to exit
%:- at(PlayerX, PlayerY, player), at(ExitX, ExitY, exit), path(PlayerX, PlayerY, ExitX, ExitY, L).

%% One rotatable laser, one goal, laser is in line with goal but not in same direction
%% + wires connect goal to single door

% There must be a closed door adjacent to exit (on inside edge)
:- at(X, 0, exit), not at(X, 1, doorClosed).
:- at(X, m-1, exit), not at(X, m-2, doorClosed).
:- at(0, Y, exit), not at(1, Y, doorClosed).
:- at(n-1, Y, exit), not at(n-2, Y, doorClosed).

% There must be exactly one laser
laser(laserUrot1;laserDrot1;laserLrot1;laserRrot1).
{ at(0..n-1, 0..m-1, T) :laser(T) } = numLasers.

% There must be exactly one closed door
{ at(0..n-1, 0..m-1, doorClosed) } = 1.

% There must be exactly one sensor
{ at(0..n-1, 0..m-1, goalOff) } = numSensors.

% Wires must connect closed door to sensor
good(wireOff;goalOff;doorClosed).
doorSensorPath(X, Y, X, Y) :-
    dimX(X), dimY(Y),
    at(X, Y, T), good(T).
doorSensorPath(X1, Y1, X2, Y2) :-
    dimX(X1), dimY(Y1), dimX(X2), dimY(Y2),
    at(X1, Y1, T), good(T),
    step(DX, DY),
    NX = X1 + DX,
    NY = Y1 + DY,
    at(NX, NY, T2), good(T2),
    doorSensorPath(NX, NY, X2, Y2).

{ doorSensorPath(SensorX, SensorY, DoorX, DoorY) } = 1 :- at(SensorX, SensorY, goalOff), at(DoorX, DoorY, doorClosed).
%:- at(SensorX, SensorY, goalOff), at(DoorX, DoorY, doorClosed), not doorSensorPath(SensorX, SensorY, DoorX, DoorY).

% Number of wireOff tiles = Manhattan distance between goal and door
%1 { at(X, Y, wireOff) } = |SourceX - DoorX| + |SourceY - DoorY| - 1 :- dimX(X), dimY(Y), at(SourceX, SourceY, goalOff), at(DoorX, DoorY, doorClosed). 

%wirePath(X, Y, X, Y) :-
%    dimX(X), dimY(Y),
%    at(X, Y, wireOff).
%wirePath(X1, Y1, X2, Y2) :-
%    dimX(X1), dimY(Y1), dimX(X2), dimY(Y2),
%    at(X1, Y1, wireOff),
%    step(DX, DY),
%    NX = X1 + DX,
%    NY = Y1 + DY,
%    wirePath(NX, NY, X2, Y2).

%doorToSensor(X1, Y1, X2, Y2) :-
%    dimX(X1), dimY(Y1), dimX(X2), dimY(Y2),
%    at(X1, Y1, doorClosed),
%    at(X2, Y2, goalOff).
%doorToSensor(X1, Y1, X2, Y2) :-
%    dimX(X1), dimY(Y1), dimX(X2), dimY(Y2),
%    at(X1, Y1, doorClosed),
%    step(DX, DY),
%    NX = X1 + DX,
%    NY = Y1 + DY,
%    at(NX, NY, wireOff),
%    wirePath(NX, NY, X3, Y3),
%    step(DX2, DY2),
%    NX2 = NX + DX2,
%    NY2 = NY + DY2,
%    at(NX2, NY2, goalOff).

% Laser must be in line with goal
:- at(X, Y, T), laser(T), at(0..X-1, 0..Y-1, goalOff).
:- at(X, Y, T), laser(T), at(0..X-1, Y+1..m-1, goalOff).
:- at(X, Y, T), laser(T), at(X+1..n-1, 0..Y-1, goalOff).
:- at(X, Y, T), laser(T), at(X+1..n-1, Y+1..m-1, goalOff).

% Laser must not be pointing at goal initially
:- at(X, Y, laserDrot1), at(X, 0..Y-1, goalOff).
:- at(X, Y, laserUrot1), at(X, Y+1..m-1, goalOff).
:- at(X, Y, laserLrot1), at(X+1..n-1, Y, goalOff).
:- at(X, Y, laserRrot1), at(0..X-1, Y, goalOff).

#show at/3.