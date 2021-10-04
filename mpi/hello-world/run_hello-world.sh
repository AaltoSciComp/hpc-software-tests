#!/bin/bash -l
#SBATCH --time=00:05:00
#SBATCH --ntasks-per-node=2
#SBATCH --nodes=2-2

set -e

if [[ "$#" -eq 1 ]]; then
    echo "Running on: "$(hostname)
    echo "Loading module: "$1
    module purge
    module load $1
    EXECUTABLE=hello-world_${1//\//_}
else
    EXECUTABLE=hello-world
fi

if [[ $SLURM_PROCID -eq 0 ]]; then

    mpicc -o $EXECUTABLE hello-world.c

fi

srun $EXECUTABLE | grep 'Hello world launched with '$SLURM_NTASKS' processors.'

