#!/bin/bash -l
#SBATCH --mem=6G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    echo "Loading modules: "$MODULES
    MODULES=${@:1}
    module purge
    module load $MODULES
    module list
fi

[[ -d build ]] && rm -r build

cp -r $GUROBI_HOME/examples/build build

cd build

sed -i "s:TWOUP    = ..:TWOUP    = $GUROBI_HOME/examples:g" Makefile

make run_c
