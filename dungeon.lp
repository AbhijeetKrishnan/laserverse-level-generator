% dungeon.lp

#const n=15.

dim(0..n-1). % everything in this range is a valid dimension

tile(background).
tile(wall).
tile(player).
%tile(crate).
tile(exit).
%tile(glass).

tile(laserU). %transparent
tile(laserD). %transparent
tile(laserL). %transparent
tile(laserR). %transparent

%tile(laserOffU).
%tile(laserOffD).
%tile(laserOffL).
%tile(laserOffR).

%tile(laserUrot1).
%tile(laserDrot1).
%tile(laserLrot1).
%tile(laserRrot1).

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

%tile(wireOff)
%tile(wireWallOff).
%tile(buttonOff).
tile(doorClosed).
%tile(antiDoorOpen).
%tile(gate0).

%path(X1, Y1, X3, Y3) :- at(X1, Y1, floor), at(X1, Y1 - 1, floor), path(X1, Y1 - 1, X3, Y3), dim(X1), dim(X2), dim(Y1), dim(Y2), dim(X3), dim(Y3).
%path(X1, Y1, X3, Y3) :- at(X1, Y1, floor), at(X1, Y1 + 1, floor), path(X1, Y1 + 1, X3, Y3), dim(X1), dim(X2), dim(Y1), dim(Y2), dim(X3), dim(Y3).
%path(X1, Y1, X3, Y3) :- at(X1, Y1, floor), at(X1 - 1, Y1, floor), path(X1 - 1, Y1, X3, Y3), dim(X1), dim(X2), dim(Y1), dim(Y2), dim(X3), dim(Y3).
%path(X1, Y1, X3, Y3) :- at(X1, Y1, floor), at(X1 + 1, Y1, floor), path(X1 + 1, Y1, X3, Y3), dim(X1), dim(X2), dim(Y1), dim(Y2), dim(X3), dim(Y3).

%% Generate
1 { at(X, Y, T) : tile(T) } 1 :- dim(X), dim(Y).

%% Test

% level boundaries must be wall
:- X = 0, Y = 0..n-1, not at(X, Y, wall) ; not at(X, Y, player) ; not at(X, Y, exit).
:- X = n-1, Y = 0..n-1, not at(X, Y, wall) ; not at(X, Y, player) ; not at(X, Y, exit).
:- X = 0..n-1, Y = 0, not at(X, Y, wall) ; not at(X, Y, player) ; not at(X, Y, exit).
:- X = 0..n-1, Y = n-1, not at(X, Y, wall) ; not at(X, Y, player) ; not at(X, Y, exit).

% There must be exactly one instance of player
:- 0 { at(X, Y, player) } 0.
:- 2 { at(X, Y, player) }.

% There must be exactly one instance of exit
:- 0 { at(X, Y, exit) } 0.
:- 2 { at(X, Y, exit) }.

#show at/3.