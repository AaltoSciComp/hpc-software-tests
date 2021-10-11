#!/bin/bash -l
#SBATCH --mem=1G
#SBATCH --ntasks-per-node=2
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

EXECUTABLE=hello-world

if [[ $SLURM_PROCID -eq 0 ]]; then

    mpicc -o $EXECUTABLE hello-world.c

fi

srun $EXECUTABLE | grep 'Hello world launched with '$SLURM_NTASKS' processors.'

