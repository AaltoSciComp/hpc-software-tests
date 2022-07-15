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

if [[ -z "$COMPILER" ]]; then
    COMPILER=$(command -v icc || command -v gcc)
fi

echo 'Compiling with '$COMPILER

CODE=ddot.c
EXECUTABLE=${CODE%.c}

echo 'Compilation command:'
echo $COMPILER -o $EXECUTABLE $CODE -Wl,-rpath,$LD_LIBRARY_PATH  $BLAS_FLAGS
$COMPILER -o $EXECUTABLE $CODE -Wl,-rpath,$LD_LIBRARY_PATH  $BLAS_FLAGS

srun $EXECUTABLE && echo $EXECUTABLE' ran successfully'
