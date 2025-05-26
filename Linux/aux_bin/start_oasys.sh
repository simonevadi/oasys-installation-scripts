#!/bin/bash

echo "Running start_oasys.sh" >> /home/jny/oasys_debug.log
echo "DISPLAY=$DISPLAY" >> /home/jny/oasys_debug.log

export MATPLOTLIBRC="$HOME/.oasys/miniconda3/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc"

"$HOME/.oasys/miniconda3/bin/python" -m oasys.canvas --force-discovery >> /home/jny/oasys_debug.log 2>&1
