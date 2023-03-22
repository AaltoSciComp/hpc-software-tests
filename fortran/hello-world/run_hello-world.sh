#!/bin/bash -l
#SBATCH --mem=100M
#SBATCH --time=00:05:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

EXECUTABLE=hello-world

if [[ -z "$COMPILER" ]]; then
    COMPILER=$(command -v ifort || command -v gfortran)
fi

echo 'Compiling with '$COMPILER
$COMPILER -o $EXECUTABLE hello-world.f90

./$EXECUTABLE | grep 'Hello world.'
