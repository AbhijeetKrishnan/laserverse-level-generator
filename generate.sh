#!/usr/bin/bash

for ((i=0;i<$2;i++))
do
    /cygdrive/c/Users/Admin/Downloads/clingo-5.3.0-win64/clingo.exe -n 1 --rand-freq=1 --seed=`echo $RANDOM` generator_$1.lp --stats | python3 parser.py
done