#!/usr/bin/bash

CLINGO="$(which clingo)"

for ((i=0;i<$2;i++))
do
    "${CLINGO}" -n 1 --rand-freq=1 --seed="${RANDOM}" generator_"${1}".lp --stats | python3 parser.py
done