#!/bin/bash -l
#SBATCH --mem=1G
#SBATCH --ntasks-per-node=1
#SBATCH --nodes=2-2
#SBATCH --time=00:05:00

set -e

if [[ "$#" -gt 0 ]]; then
    MODULES=${@:1}
    echo "Running on: "$(hostname)
    echo "Loading modules: "$MODULES
    module purge
    module load $MODULES
fi

EXECUTABLE="python numpy-example.py"

if [[ $(command -v srun) ]]; then
    echo 'Launching with srun'
    srun $EXECUTABLE
    exit $?
elif [[ $(command -v mpirun) ]]; then
    echo 'Launching with mpirun'
    mpirun -np 4 $EXECUTABLE
    exit $?
else
    echo 'Could not find srun/mpirun to run the example!'
    exit 1
fi
