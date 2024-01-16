#!/usr/bin/bash

bash generate.sh crate 1000 > output_level_crate.txt
bash generate.sh laser 1000 > output_level_laser.txt
bash generate.sh mirror 1000 > output_level_mirror.txt

python3 stats_crate.py
python3 stats_laser.py
python3 stats_mirror.py