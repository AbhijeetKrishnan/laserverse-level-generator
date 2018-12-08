#!/usr/bin/bash

for ((i=0;i<$1;i++))
do
    /cygdrive/c/Users/Admin/Downloads/clingo-5.3.0-win64/clingo.exe -n 1 --rand-freq=1 --seed=`echo $RANDOM` dungeon.lp --stats | python3 parser.py
done