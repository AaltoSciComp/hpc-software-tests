#!/bin/bash -l
#SBATCH --mem=2G
#SBATCH --time=00:15:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

EXAMPLE_CODE=cholmod_simple.c
EXAMPLE_BIN=${EXAMPLE_CODE/.c/.o}

EXAMPLE_MATRIX=c.mtx

if [ ! -e ${EXAMPLE_CODE} ] ; then
    echo 'Downloading source code for cholmod_simple ...'
    curl -L -o $EXAMPLE_CODE https://raw.githubusercontent.com/DrTimothyAldenDavis/SuiteSparse/master/CHOLMOD/Demo/$EXAMPLE_CODE
fi

if [ ! -e ${EXAMPLE_MATRIX} ] ; then
    echo 'Downloading example matrix ...'
    curl -L -o $EXAMPLE_MATRIX https://raw.githubusercontent.com/DrTimothyAldenDavis/SuiteSparse/master/CHOLMOD/Demo/Matrix/$EXAMPLE_MATRIX
fi

echo 'Compiling cholmod_simple ...'
gcc -lcholmod -lamd -lcolamd -lsuitesparseconfig -lopenblas -o $EXAMPLE_BIN $EXAMPLE_CODE

echo 'Running cholmod_simple ...'
./$EXAMPLE_BIN < $EXAMPLE_MATRIX
