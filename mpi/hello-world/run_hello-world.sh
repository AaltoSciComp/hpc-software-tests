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

rm -f $EXECUTABLE

if [[ $SLURM_PROCID -eq 0 ]]; then

    echo 'Compiling '$EXECUTABLE' with '$(which mpicc)
    mpicc -o $EXECUTABLE hello-world.c
else
    sleep 5
fi

if [[ $(command -v srun) ]]; then
    echo 'Launching with srun'
    srun $EXECUTABLE | grep 'Hello world launched with '$SLURM_NTASKS' processors.'
    exit $?
elif [[ $(command -v mpirun) ]]; then
    echo 'Launching with mpirun'
    mpirun -np 4 $EXECUTABLE | grep 'Hello world launched with 4 processors.'
    exit $?
else
    echo 'Could not find srun/mpirun to run the example!'
    exit 1
fi
