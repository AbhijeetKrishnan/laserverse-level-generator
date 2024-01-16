#!/usr/bin/bash

CLINGO="$(which clingo)"

if [ -z "$2" ]
then
    echo "Usage: ./generate.sh <crate|laser|mirror|master> <number of instances>"
    exit 1
fi

for (( i=0; i<$2; i++ ))
do
    "${CLINGO}" -n 1 --rand-freq=1 --seed="${RANDOM}" generator_"${1}".lp --stats | python3 parser.py
done
