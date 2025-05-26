#!/bin/bash

export MATPLOTLIBRC="$HOME/.oasys/miniconda3/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc"

"$HOME/.oasys/miniconda3/bin/python" -m oasys.canvas --force-discovery
