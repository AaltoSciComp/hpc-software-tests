#!/bin/bash -l
#SBATCH --time=00:05:00

set -e

if [[ "$#" -eq 1 ]]; then
    echo "Running on: "$(hostname)
    echo "Loading module: "$1
    module purge
    module load $1
fi


srun hostname
