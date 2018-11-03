% dungeon.lp

#const n=9.

dim(0..n-1). % everything in this range is a valid dimension

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
%%ile(goalOff).

tile(wireOff)
tile(wireWallOff).
%tile(buttonOff).
tile(doorClosed).
%tile(antiDoorOpen).
%tile(gate0).

transparent(background;player;exit).
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
{ at(X, Y, T) :tile(T) } = 1 :- dim(X), dim(Y).

%% Test

% level boundaries must be wall/player/exit
boundary(wall;player;exit).

:- at(0, 0..n-1, T), not boundary(T).
:- at(n-1, 0..n-1, T), not boundary(T).
:- at(0..n-1, 0, T), not boundary(T).
:- at(0..n-1, n-1, T), not boundary(T).

% There must be exactly one instance of player
{ at(X, Y, player) :dim(X), dim(Y) } = 1.

% There must be exactly one instance of player
{ at(X, Y, exit) :dim(X), dim(Y) } = 1.

% Player must be on boundary
:- at(X, Y, player), X > 0, X < n - 1, Y > 0, Y < n - 1.

% Exit must be on boundary
:- at(X, Y, exit), X > 0, X < n - 1, Y > 0, Y < n - 1.

% There must be a closed door adjacent to exit (on inside edge)
:- at(X, 0, exit), not at(X, 1, doorClosed).
:- at(X, n-1, exit), not at(X, n-2, doorClosed).
:- at(0, Y, exit), not at(1, Y, doorClosed).
:- at(n-1, Y, exit), not at(n-2, Y, doorClosed).

% There must be a path from player to exit of length > 1
%:- at(PlayerX, PlayerY, player), at(ExitX, ExitY, exit), path(PlayerX, PlayerY, ExitX, ExitY, L), L <= 1.

% There must be exactly one laser
laser(laserUrot1;laserDrot1;laserLrot1;laserRrot1).
{ at(X, Y, T) :dim(X), dim(Y) } = 1 :- laser(T).

% There must be exactly one closed door
{ at(X, Y, doorClosed) :dim(X), dim(Y) } = 1.

% There must be exactly one sensor
sensor(goalOff).
{ at(X, Y, T) :dim(X), dim(Y) } = 1 :- sensor(T).

% Wires must connect closed door to sensor

% Laser must not be pointing at goal initially

#show at/3.