#!/bin/bash

export MATPLOTLIBRC="$HOME/.oasys/miniconda3/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc"

"$HOME/.oasys/miniconda3/bin/python" -m oasys.canvas --force-discovery >> /home/jny/oasys_debug.log 2>&1
